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
  ./log_level, ./arguments, rcl_yaml_param_parser/types, ./arguments

type

  rcl_logging_output_handler_t* = rcutils_logging_output_handler_t ##
                              ##  The function signature to log messages.


proc rcl_logging_configure*(global_args: ptr rcl_arguments_t;
                            allocator: ptr rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_logging_configure", header: "logging.h".}
  ##
                              ##  Configure the logging system.
                              ##
                              ##  This function should be called during the ROS initialization process.
                              ##  It will add the enabled log output appenders to the root logger.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] global_args The global arguments for the system
                              ##  \param[in] allocator Used to allocate memory used by the logging system
                              ##  \return #RCL_RET_OK if successful, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if a general error occurs
                              ##

proc rcl_logging_configure_with_output_handler*(
    global_args: ptr rcl_arguments_t; allocator: ptr rcl_allocator_t;
    output_handler: rcl_logging_output_handler_t): rcl_ret_t {.
    importc: "rcl_logging_configure_with_output_handler", header: "logging.h".}
  ##
                              ##  Configure the logging system with the provided output handler.
                              ##
                              ##  Similar to rcl_logging_configure, but it uses the provided output handler.
                              ##  \sa rcl_logging_configure
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] global_args The global arguments for the system
                              ##  \param[in] allocator Used to allocate memory used by the logging system
                              ##  \param[in] output_handler Output handler to be installed
                              ##  \return #RCL_RET_OK if successful, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if a general error occurs
                              ##

proc rcl_logging_fini*(): rcl_ret_t {.importc: "rcl_logging_fini",
                                      header: "logging.h".}
  ##
                              ##
                              ##  This function should be called to tear down the logging setup by the configure function.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \return #RCL_RET_OK if successful.
                              ##  \return #RCL_RET_ERROR if a general error occurs
                              ##

proc rcl_logging_rosout_enabled*(): _Bool {.
    importc: "rcl_logging_rosout_enabled", header: "logging.h".}
  ##
                              ##  See if logging rosout is enabled.
                              ##
                              ##  This function is meant to be used to check if logging rosout is enabled.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \return `TRUE` if logging rosout is enabled, or
                              ##  \return `FALSE` if logging rosout is disabled.
                              ##

proc rcl_logging_multiple_output_handler*(location: ptr rcutils_log_location_t;
    severity: cint; name: cstring; timestamp: rcutils_time_point_value_t;
    format: cstring; args: ptr va_list) {.
    importc: "rcl_logging_multiple_output_handler", header: "logging.h".}
  ##
                              ##  Default output handler used by rcl.
                              ##
                              ##  This function can be wrapped in a language specific client library,
                              ##  adding the necessary mutual exclusion protection there, and then use
                              ##  rcl_logging_configure_with_output_handler() instead of
                              ##  rcl_logging_configure().
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] location The pointer to the location struct or NULL
                              ##  \param[in] severity The severity level
                              ##  \param[in] name The name of the logger, must be null terminated c string
                              ##  \param[in] timestamp The timestamp for when the log message was made
                              ##  \param[in] format The list of arguments to insert into the formatted log message
                              ##  \param[in] args argument for the string format
                              ## 