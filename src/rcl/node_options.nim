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
  ./allocator, rcutils/allocator, rcutils/allocator, rcutils/allocator,
  rcutils/macros, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, rcutils/allocator, rcutils/types/rcutils_ret,
  rcutils/allocator, rcutils/visibility_control,
  rcutils/visibility_control_macros, rcutils/visibility_control_macros,
  rcutils/visibility_control, rcutils/allocator, ./allocator, ./arguments,
  ./log_level, ./macros, ./log_level, ./types, rmw/types, rmw/types, rmw/types,
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
  rmw/visibility_control, rmw/visibility_control, rmw/qos_policy_kind,
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
  rmw/events_statuses/events_statuses, rmw/types, rmw/init, rmw/init_options,
  rmw/init_options, rmw/domain_id, rmw/init_options, rmw/localhost,
  rmw/init_options, rmw/macros, rmw/init_options, rmw/ret_types,
  rmw/init_options, rmw/security_options, rmw/security_options,
  rmw/init_options, rmw/init, rmw/types, rmw/serialized_message, rmw/types,
  rmw/subscription_content_filter_options,
  rmw/subscription_content_filter_options, rmw/types, rmw/time, rmw/time,
  rmw/types, ./types, ./log_level, ./visibility_control, ./visibility_control,
  ./log_level, ./arguments, rcl_yaml_param_parser/types, ./arguments,
  ./domain_id, ./domain_id

const
  RCL_NODE_OPTIONS_DEFAULT_DOMAIN_ID* = RCL_DEFAULT_DOMAIN_ID ##
                              ##  Constant which indicates that the default domain id should be used.

type

  rcl_node_options_t* {.importc: "rcl_node_options_t", header: "node_options.h",
                        bycopy.} = object ##  Structure which encapsulates the options for creating a rcl_node_t.
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



proc rcl_node_get_default_options*(): rcl_node_options_t {.
    importc: "rcl_node_get_default_options", header: "node_options.h".}
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
    importc: "rcl_node_options_copy", header: "node_options.h".}
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
    importc: "rcl_node_options_fini", header: "node_options.h".}
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