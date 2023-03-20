##  Copyright 2019 Open Source Robotics Foundation, Inc.
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
  ./allocator, rcutils/types/rcutils_ret, rcutils/visibility_control,
  rcutils/visibility_control_macros, ./arguments, ./log_level, ./macros,
  ./types, rmw/types, rcutils/logging, rcutils/error_handling, rcutils/snprintf,
  rcutils/testing/fault_injection, rcutils/time, rcutils/types/array_list,
  rcutils/types/char_array, rcutils/types/hash_map, rcutils/types/string_array,
  rcutils/qsort, rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/visibility_control,
  rmw/events_statuses/liveliness_changed, rmw/events_statuses/liveliness_lost,
  rmw/events_statuses/message_lost, rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/macros, rmw/ret_types, rmw/security_options,
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time,
  ./visibility_control, rcl_yaml_param_parser/types, ./domain_id


type

  rcl_node_options_t* {.importc: "rcl_node_options_t",
                        header: "rcl/node_options.h", bycopy.} = object ##
                              ##  Structure which encapsulates the options for creating a rcl_node_t.
    allocator* {.importc: "allocator".}: rcl_allocator_t ##
                              ##  bool anonymous_name;
                              ##  rmw_qos_profile_t parameter_qos;
                              ##  If true, no parameter infrastructure will be setup.
                              ##  bool no_parameters;
                              ##  Custom allocator used for internal allocations.
    use_global_arguments* {.importc: "use_global_arguments".}: _Bool ##
                              ##  If false then only use arguments in this struct, otherwise use global arguments also.
    arguments* {.importc: "arguments".}: rcl_arguments_t ##
                              ##  Command line arguments that apply only to this node.
    enable_rosout* {.importc: "enable_rosout".}: _Bool ##
                              ##  Flag to enable rosout for this node
    rosout_qos* {.importc: "rosout_qos".}: rmw_qos_profile_t ##
                              ##  Middleware quality of service settings for /rosout.


const
  RCL_NODE_OPTIONS_DEFAULT_DOMAIN_ID* = RCL_DEFAULT_DOMAIN_ID ##
                              ##  Constant which indicates that the default domain id should be used.


proc rcl_node_get_default_options*(): rcl_node_options_t {.
    importc: "rcl_node_get_default_options", header: "rcl/node_options.h".}
  ##
                              ##  Return the default node options in a rcl_node_options_t.
                              ##
                              ##  The default values are:
                              ##
                              ##  - allocator = rcl_get_default_allocator()
                              ##  - use_global_arguments = true
                              ##  - enable_rosout = true
                              ##  - arguments = rcl_get_zero_initialized_arguments()
                              ##  - rosout_qos = rcl_qos_profile_rosout_default
                              ##
                              ##  \return A structure with the default node options.
                              ##

proc rcl_node_options_copy*(options: ptr rcl_node_options_t;
                            options_out: ptr rcl_node_options_t): rcl_ret_t {.
    importc: "rcl_node_options_copy", header: "rcl/node_options.h".}
  ##
                              ##  Copy one options structure into another.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] options The structure to be copied.
                              ##    Its allocator is used to copy memory into the new structure.
                              ##  \param[out] options_out An options structure containing default values.
                              ##  \return #RCL_RET_OK if the structure was copied successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_node_options_fini*(options: ptr rcl_node_options_t): rcl_ret_t {.
    importc: "rcl_node_options_fini", header: "rcl/node_options.h".}
  ##
                              ##  Finalize the given node_options.
                              ##
                              ##  The given node_options must be non-`NULL` and valid, i.e. had
                              ##  rcl_node_get_default_options() called on it but not this function yet.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[inout] options object to be finalized
                              ##  \return #RCL_RET_OK if setup is successful, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ## 