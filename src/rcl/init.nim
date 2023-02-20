##  Copyright 2014 Open Source Robotics Foundation, Inc.
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
  ./allocator, rcutils/allocator, rcutils/allocator, rcutils/allocator,
  rcutils/macros, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, rcutils/allocator, rcutils/types/rcutils_ret,
  rcutils/allocator, rcutils/visibility_control,
  rcutils/visibility_control_macros, rcutils/visibility_control_macros,
  rcutils/visibility_control, rcutils/allocator, ./allocator, ./context,
  rmw/init, rmw/init, rmw/init_options, rmw/init_options, rmw/domain_id,
  rmw/init_options, rmw/localhost, rmw/visibility_control,
  rmw/visibility_control, rmw/localhost, rmw/init_options, rmw/macros,
  rmw/init_options, rmw/ret_types, rmw/init_options, rmw/security_options,
  rmw/security_options, rmw/init_options, rmw/init, ./context, ./arguments,
  ./log_level, ./macros, ./log_level, ./types, rmw/types, rmw/types,
  rcutils/logging, rcutils/logging, rcutils/logging, rcutils/error_handling,
  rcutils/error_handling, rcutils/error_handling, rcutils/error_handling,
  rcutils/error_handling, rcutils/error_handling, rcutils/snprintf,
  rcutils/snprintf, rcutils/error_handling, rcutils/testing/fault_injection,
  rcutils/testing/fault_injection, rcutils/testing/fault_injection,
  rcutils/error_handling, rcutils/error_handling, rcutils/error_handling,
  rcutils/error_handling, rcutils/logging, rcutils/time, rcutils/time,
  rcutils/types, rcutils/types/array_list, rcutils/types/array_list,
  rcutils/types, rcutils/types/char_array, rcutils/types/char_array,
  rcutils/types, rcutils/types/hash_map, rcutils/types/hash_map, rcutils/types,
  rcutils/types/string_array, rcutils/types/string_array, rcutils/qsort,
  rcutils/qsort, rcutils/types/string_array, rcutils/types,
  rcutils/types/string_map, rcutils/types/string_map, rcutils/types,
  rcutils/types/uint8_array, rcutils/types/uint8_array, rcutils/types,
  rcutils/time, rcutils/logging, rmw/types, rmw/events_statuses/events_statuses,
  rmw/events_statuses/incompatible_qos, rmw/qos_policy_kind,
  rmw/events_statuses/incompatible_qos, rmw/events_statuses/events_statuses,
  rmw/events_statuses/liveliness_changed,
  rmw/events_statuses/liveliness_changed, rmw/events_statuses/events_statuses,
  rmw/events_statuses/liveliness_lost, rmw/events_statuses/liveliness_lost,
  rmw/events_statuses/events_statuses, rmw/events_statuses/message_lost,
  rmw/events_statuses/message_lost, rmw/events_statuses/events_statuses,
  rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/events_statuses,
  rmw/events_statuses/requested_deadline_missed,
  rmw/events_statuses/requested_deadline_missed,
  rmw/events_statuses/events_statuses, rmw/types, rmw/serialized_message,
  rmw/types, rmw/subscription_content_filter_options,
  rmw/subscription_content_filter_options, rmw/types, rmw/time, rmw/time,
  rmw/types, ./types, ./log_level, ./visibility_control, ./visibility_control,
  ./log_level, ./arguments, rcl_yaml_param_parser/types, ./arguments, ./context,
  ./init_options, ./init_options, ./context, ./context


proc rcl_init*(argc: cint; argv: cstringArray; options: ptr rcl_init_options_t;
               context: ptr rcl_context_t): rcl_ret_t {.importc: "rcl_init",
    header: "init.h".}
  ##  Initialization of rcl.
                      ##
                      ##  This function can be run any number of times, so long as the given context
                      ##  has been properly prepared.
                      ##
                      ##  The given rcl_context_t must be zero initialized with the function
                      ##  rcl_get_zero_initialized_context() and must not be already initialized
                      ##  by this function.
                      ##  If the context is already initialized this function will fail and return the
                      ##  #RCL_RET_ALREADY_INIT error code.
                      ##  A context may be initialized again after it has been finalized with the
                      ##  rcl_shutdown() function and zero initialized again with
                      ##  rcl_get_zero_initialized_context().
                      ##
                      ##  The `argc` and `argv` parameters may contain command line arguments for the
                      ##  program.
                      ##  rcl specific arguments will be parsed, but not removed.
                      ##  If `argc` is `0` and `argv` is `NULL` no parameters will be parsed.
                      ##
                      ##  The `options` argument must be non-`NULL` and must have been initialized
                      ##  with rcl_init_options_init().
                      ##  It is unmodified by this function, and the ownership is not transfered to
                      ##  the context, but instead a copy is made into the context for later reference.
                      ##  Therefore, the given options need to be cleaned up with
                      ##  rcl_init_options_fini() after this function returns.
                      ##
                      ##  <hr>
                      ##  Attribute          | Adherence
                      ##  ------------------ | -------------
                      ##  Allocates Memory   | Yes
                      ##  Thread-Safe        | No
                      ##  Uses Atomics       | Yes
                      ##  Lock-Free          | Yes [1]
                      ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_uint_least64_t`</i>
                      ##
                      ##  \param[in] argc number of strings in argv
                      ##  \param[in] argv command line arguments; rcl specific arguments are removed
                      ##  \param[in] options options used during initialization
                      ##  \param[out] context resulting context object that represents this init
                      ##  \return #RCL_RET_OK if initialization is successful, or
                      ##  \return #RCL_RET_ALREADY_INIT if rcl_init has already been called, or
                      ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                      ##  \return #RCL_RET_INVALID_ROS_ARGS if an invalid ROS argument is found, or
                      ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                      ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                      ##

proc rcl_shutdown*(context: ptr rcl_context_t): rcl_ret_t {.
    importc: "rcl_shutdown", header: "init.h".}
  ##  Shutdown a given rcl context.
                                               ##
                                               ##  The given context must have been initialized with rcl_init().
                                               ##  If not, this function will fail with #RCL_RET_ALREADY_SHUTDOWN.
                                               ##
                                               ##  When this function is called:
                                               ##   - Any rcl objects created using this context are invalidated.
                                               ##   - Functions called on invalid objects may or may not fail.
                                               ##   - Calls to rcl_context_is_initialized() will return `false`.
                                               ##
                                               ##  <hr>
                                               ##  Attribute          | Adherence
                                               ##  ------------------ | -------------
                                               ##  Allocates Memory   | Yes
                                               ##  Thread-Safe        | Yes
                                               ##  Uses Atomics       | Yes
                                               ##  Lock-Free          | Yes [1]
                                               ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_uint_least64_t`</i>
                                               ##
                                               ##  \param[inout] context object to shutdown
                                               ##  \return #RCL_RET_OK if the shutdown was completed successfully, or
                                               ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                                               ##  \return #RCL_RET_ALREADY_SHUTDOWN if the context is not currently valid, or
                                               ##  \return #RCL_RET_ERROR if an unspecified error occur.
                                               ## 