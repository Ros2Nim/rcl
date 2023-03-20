import rcutils/allocator as rcutils_allocator
import rcutils/time as rcutils_time
import rmw/types as rmw_types
import ../rcl_yaml_param_parser/types

##  Copyright 2018 Open Source Robotics Foundation, Inc.
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
##  @file

import
  ./allocator, rcutils/types/rcutils_ret, rcutils/visibility_control_macros,
  ./log_level, ./macros, ./types, rcutils/logging,
  rcutils/error_handling as rcutils_error_handling, rcutils/snprintf,
  rcutils/testing/fault_injection, rcutils/types/array_list,
  rcutils/types/char_array, rcutils/types/hash_map, rcutils/types/string_array,
  rcutils/qsort, rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/events_statuses/liveliness_changed,
  rmw/events_statuses/liveliness_lost, rmw/events_statuses/message_lost,
  rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init as rmw_init,
  rmw/init as rmw_init_options, rmw/domain_id as rmw_domain_id, rmw/localhost,
  rmw/ret_types, rmw/security_options, rmw/serialized_message,
  rmw/subscription_content_filter_options, rmw/time as rmw_time,
  ./visibility_control

const
  RCL_ROS_ARGS_FLAG* = "--ros-args" ##  The command-line flag that delineates the start of ROS arguments.
  RCL_ROS_ARGS_EXPLICIT_END_TOKEN* = "--" ##  The token that delineates the explicit end of ROS arguments.
  RCL_PARAM_FLAG* = "--param" ##  The ROS flag that precedes the setting of a ROS parameter.
  RCL_SHORT_PARAM_FLAG* = "-p" ##  The short version of the ROS flag that precedes the setting of a ROS parameter.
  RCL_PARAM_FILE_FLAG* = "--params-file" ##  The ROS flag that precedes a path to a file containing ROS parameters.
  RCL_REMAP_FLAG* = "--remap" ##  The ROS flag that precedes a ROS remapping rule.
  RCL_SHORT_REMAP_FLAG* = "-r" ##  The short version of the ROS flag that precedes a ROS remapping rule.
  RCL_ENCLAVE_FLAG* = "--enclave" ##  The ROS flag that precedes the name of a ROS security enclave.
  RCL_SHORT_ENCLAVE_FLAG* = "-e" ##  The short version of the ROS flag that precedes the name of a ROS security enclave.
  RCL_LOG_LEVEL_FLAG* = "--log-level" ##  The ROS flag that precedes the ROS logging level to set.
  RCL_EXTERNAL_LOG_CONFIG_FLAG* = "--log-config-file" ##
                              ##  The ROS flag that precedes the name of a configuration file to configure logging.
  RCL_LOG_STDOUT_FLAG_SUFFIX* = "stdout-logs" ##  The suffix of the ROS flag to enable or disable stdout
                                              ##  logging (must be preceded with --enable- or --disable-).
  RCL_LOG_ROSOUT_FLAG_SUFFIX* = "rosout-logs" ##  The suffix of the ROS flag to enable or disable rosout
                                              ##  logging (must be preceded with --enable- or --disable-).
  RCL_LOG_EXT_LIB_FLAG_SUFFIX* = "external-lib-logs" ##
                              ##  The suffix of the ROS flag to enable or disable external library
                              ##  logging (must be preceded with --enable- or --disable-).

type

  rcl_arguments_impl_t* {.importc: "rcl_arguments_impl_t",
                          header: "rcl/arguments.h", bycopy.} = object


  rcl_arguments_t* {.importc: "rcl_arguments_t", header: "rcl/arguments.h",
                     bycopy.} = object ##  Hold output of parsing command line arguments.
    impl* {.importc: "impl".}: ptr rcl_arguments_impl_t ##
                              ##  Private implementation pointer.




proc rcl_get_zero_initialized_arguments*(): rcl_arguments_t {.
    importc: "rcl_get_zero_initialized_arguments", header: "rcl/arguments.h".}
  ##
                              ##  Return a rcl_arguments_t struct with members initialized to `NULL`.

proc rcl_parse_arguments*(argc: cint; argv: cstringArray;
                          allocator: rcl_allocator_t;
                          args_output: ptr rcl_arguments_t): rcl_ret_t {.
    importc: "rcl_parse_arguments", header: "rcl/arguments.h".}
  ##
                              ##  Parse command line arguments into a structure usable by code.
                              ##
                              ##  \sa rcl_get_zero_initialized_arguments()
                              ##
                              ##  ROS arguments are expected to be scoped by a leading `--ros-args` flag and a trailing double
                              ##  dash token `--` which may be elided if no non-ROS arguments follow after the last `--ros-args`.
                              ##
                              ##  Remap rule parsing is supported via `-r/--remap` flags e.g. `--remap from:=to` or `-r from:=to`.
                              ##  Successfully parsed remap rules are stored in the order they were given in `argv`.
                              ##  If given arguments `{"__ns:=/foo", "__ns:=/bar"}` then the namespace used by nodes in this
                              ##  process will be `/foo` and not `/bar`.
                              ##
                              ##  \sa rcl_remap_topic_name()
                              ##  \sa rcl_remap_service_name()
                              ##  \sa rcl_remap_node_name()
                              ##  \sa rcl_remap_node_namespace()
                              ##
                              ##  Parameter override rule parsing is supported via `-p/--param` flags e.g. `--param name:=value`
                              ##  or `-p name:=value`.
                              ##
                              ##  The default log level will be parsed as `--log-level level` and logger levels will be parsed as
                              ##  multiple `--log-level name:=level`, where `level` is a name representing one of the log levels
                              ##  in the `RCUTILS_LOG_SEVERITY` enum, e.g. `info`, `debug`, `warn`, not case sensitive.
                              ##  If multiple of these rules are found, the last one parsed will be used.
                              ##
                              ##  If an argument does not appear to be a valid ROS argument e.g. a `-r/--remap` flag followed by
                              ##  anything but a valid remap rule, parsing will fail immediately.
                              ##
                              ##  If an argument does not appear to be a known ROS argument, then it is skipped and left unparsed.
                              ##
                              ##  \sa rcl_arguments_get_count_unparsed_ros()
                              ##  \sa rcl_arguments_get_unparsed_ros()
                              ##
                              ##  All arguments found outside a `--ros-args ... --` scope are skipped and left unparsed.
                              ##
                              ##  \sa rcl_arguments_get_count_unparsed()
                              ##  \sa rcl_arguments_get_unparsed()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] argc The number of arguments in argv.
                              ##  \param[in] argv The values of the arguments.
                              ##  \param[in] allocator A valid allocator.
                              ##  \param[out] args_output A structure that will contain the result of parsing.
                              ##    Must be zero initialized before use.
                              ##  \return #RCL_RET_OK if the arguments were parsed successfully, or
                              ##  \return #RCL_RET_INVALID_ROS_ARGS if an invalid ROS argument is found, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_arguments_get_count_unparsed*(args: ptr rcl_arguments_t): cint {.
    importc: "rcl_arguments_get_count_unparsed", header: "rcl/arguments.h".}
  ##
                              ##  Return the number of arguments that were not ROS specific arguments.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] args An arguments structure that has been parsed.
                              ##  \return number of unparsed arguments, or
                              ##  \return -1 if args is `NULL` or zero initialized.
                              ##

proc rcl_arguments_get_unparsed*(args: ptr rcl_arguments_t;
                                 allocator: rcl_allocator_t;
                                 output_unparsed_indices: ptr ptr cint): rcl_ret_t {.
    importc: "rcl_arguments_get_unparsed", header: "rcl/arguments.h".}
  ##
                              ##  Return a list of indices to non ROS specific arguments.
                              ##
                              ##  Non ROS specific arguments may have been provided i.e. arguments outside a '--ros-args' scope.
                              ##  This function populates an array of indices to these arguments in the original argv array.
                              ##  Since the first argument is always assumed to be a process name, the list will always contain
                              ##  the index 0.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] args An arguments structure that has been parsed.
                              ##  \param[in] allocator A valid allocator.
                              ##  \param[out] output_unparsed_indices An allocated array of indices into the original argv array.
                              ##    This array must be deallocated by the caller using the given allocator.
                              ##    If there are no unparsed args then the output will be set to NULL.
                              ##  \return #RCL_RET_OK if everything goes correctly, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_arguments_get_count_unparsed_ros*(args: ptr rcl_arguments_t): cint {.
    importc: "rcl_arguments_get_count_unparsed_ros", header: "rcl/arguments.h".}
  ##
                              ##  Return the number of ROS specific arguments that were not successfully parsed.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] args An arguments structure that has been parsed.
                              ##  \return number of unparsed ROS specific arguments, or
                              ##  \return -1 if args is `NULL` or zero initialized.
                              ##

proc rcl_arguments_get_unparsed_ros*(args: ptr rcl_arguments_t;
                                     allocator: rcl_allocator_t;
                                     output_unparsed_ros_indices: ptr ptr cint): rcl_ret_t {.
    importc: "rcl_arguments_get_unparsed_ros", header: "rcl/arguments.h".}
  ##
                              ##  Return a list of indices to unknown ROS specific arguments that were left unparsed.
                              ##
                              ##  Some ROS specific arguments may not have been recognized, or were not intended to be
                              ##  parsed by rcl.
                              ##  This function populates an array of indices to these arguments in the original argv array.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] args An arguments structure that has been parsed.
                              ##  \param[in] allocator A valid allocator.
                              ##  \param[out] output_unparsed_ros_indices An allocated array of indices into the original argv array.
                              ##    This array must be deallocated by the caller using the given allocator.
                              ##    If there are no unparsed ROS specific arguments then the output will be set to NULL.
                              ##  \return #RCL_RET_OK if everything goes correctly, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_arguments_get_param_files_count*(args: ptr rcl_arguments_t): cint {.
    importc: "rcl_arguments_get_param_files_count", header: "rcl/arguments.h".}
  ##
                              ##  Return the number of parameter yaml files given in the arguments.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] args An arguments structure that has been parsed.
                              ##  \return number of yaml files, or
                              ##  \return -1 if args is `NULL` or zero initialized.
                              ##

proc rcl_arguments_get_param_files*(arguments: ptr rcl_arguments_t;
                                    allocator: rcl_allocator_t;
                                    parameter_files: ptr cstringArray): rcl_ret_t {.
    importc: "rcl_arguments_get_param_files", header: "rcl/arguments.h".}
  ##
                              ##  Return a list of yaml parameter file paths specified on the command line.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] arguments An arguments structure that has been parsed.
                              ##  \param[in] allocator A valid allocator.
                              ##  \param[out] parameter_files An allocated array of paramter file names.
                              ##    This array must be deallocated by the caller using the given allocator.
                              ##    The output is NULL if there were no paramter files.
                              ##  \return #RCL_RET_OK if everything goes correctly, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_arguments_get_param_overrides*(arguments: ptr rcl_arguments_t;
    parameter_overrides: ptr ptr rcl_params_t): rcl_ret_t {.
    importc: "rcl_arguments_get_param_overrides", header: "rcl/arguments.h".}
  ##
                              ##  Return all parameter overrides parsed from the command line.
                              ##
                              ##  Parameter overrides are parsed directly from command line arguments and
                              ##  parameter files provided in the command line.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] arguments An arguments structure that has been parsed.
                              ##  \param[out] parameter_overrides Parameter overrides as parsed from command line arguments.
                              ##    This structure must be finalized by the caller.
                              ##    The output is NULL if no parameter overrides were parsed.
                              ##  \return #RCL_RET_OK if everything goes correctly, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_remove_ros_arguments*(argv: cstringArray; args: ptr rcl_arguments_t;
                               allocator: rcl_allocator_t;
                               nonros_argc: ptr cint;
                               nonros_argv: ptr cstringArray): rcl_ret_t {.
    importc: "rcl_remove_ros_arguments", header: "rcl/arguments.h".}
  ##
                              ##  Return a list of arguments with ROS-specific arguments removed.
                              ##
                              ##  Some arguments may not have been intended as ROS arguments.
                              ##  This function populates an array of the aruments in a new argv array.
                              ##  Since the first argument is always assumed to be a process name, the list
                              ##  will always contain the first value from the argument vector.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] argv The argument vector
                              ##  \param[in] args An arguments structure that has been parsed.
                              ##  \param[in] allocator A valid allocator.
                              ##  \param[out] nonros_argc The count of arguments that aren't ROS-specific
                              ##  \param[out] nonros_argv An allocated array of arguments that aren't ROS-specific
                              ##    This array must be deallocated by the caller using the given allocator.
                              ##    If there are no non-ROS args, then the output will be set to NULL.
                              ##  \return #RCL_RET_OK if everything goes correctly, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_arguments_get_log_levels*(arguments: ptr rcl_arguments_t;
                                   log_levels: ptr rcl_log_levels_t): rcl_ret_t {.
    importc: "rcl_arguments_get_log_levels", header: "rcl/arguments.h".}
  ##
                              ##  Return log levels parsed from the command line.
                              ##
                              ##  Log levels are parsed directly from command line arguments.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] arguments An arguments structure that has been parsed.
                              ##  \param[out] log_levels Log levels as parsed from command line arguments.
                              ##    The output must be finished by the caller if the function successes.
                              ##  \return #RCL_RET_OK if everything goes correctly, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed.
                              ##

proc rcl_arguments_copy*(args: ptr rcl_arguments_t;
                         args_out: ptr rcl_arguments_t): rcl_ret_t {.
    importc: "rcl_arguments_copy", header: "rcl/arguments.h".}
  ##
                              ##  Copy one arguments structure into another.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] args The structure to be copied.
                              ##   Its allocator is used to copy memory into the new structure.
                              ##  \param[out] args_out A zero-initialized arguments structure to be copied into.
                              ##  \return #RCL_RET_OK if the structure was copied successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_arguments_fini*(args: ptr rcl_arguments_t): rcl_ret_t {.
    importc: "rcl_arguments_fini", header: "rcl/arguments.h".}
  ##
                              ##  Reclaim resources held inside rcl_arguments_t structure.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] args The structure to be deallocated.
                              ##  \return #RCL_RET_OK if the memory was successfully freed, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ## 