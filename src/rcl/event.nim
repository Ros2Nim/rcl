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
  rmw/event, rmw/event, rcutils/allocator, rcutils/allocator, rcutils/allocator,
  rcutils/macros, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, rcutils/allocator, rcutils/types/rcutils_ret,
  rcutils/allocator, rcutils/visibility_control,
  rcutils/visibility_control_macros, rcutils/visibility_control_macros,
  rcutils/visibility_control, rcutils/allocator, rmw/event, rmw/macros,
  rmw/event, rmw/types, rmw/types, rcutils/logging, rcutils/logging,
  rcutils/logging, rcutils/error_handling, rcutils/error_handling,
  rcutils/error_handling, rcutils/error_handling, rcutils/error_handling,
  rcutils/error_handling, rcutils/snprintf, rcutils/snprintf,
  rcutils/error_handling, rcutils/testing/fault_injection,
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
  rmw/init_options, rmw/ret_types, rmw/init_options, rmw/security_options,
  rmw/security_options, rmw/init_options, rmw/init, rmw/types,
  rmw/serialized_message, rmw/types, rmw/subscription_content_filter_options,
  rmw/subscription_content_filter_options, rmw/types, rmw/time, rmw/time,
  rmw/types, rmw/event, ./client, rosidl_runtime_c/service_type_support_struct,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/visibility_control, rosidl_runtime_c/visibility_control,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_typesupport_interface/macros,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/service_type_support_struct,
  rosidl_runtime_c/service_type_support_struct, ./client, ./event_callback,
  rmw/event_callback_type, rmw/event_callback_type, ./event_callback, ./client,
  ./macros, ./client, ./node, ./allocator, ./node, ./arguments, ./log_level,
  ./types, ./log_level, ./visibility_control, ./visibility_control, ./log_level,
  ./arguments, rcl_yaml_param_parser/types, ./arguments, ./node, ./context,
  ./context, ./init_options, ./init_options, ./context, ./context, ./node,
  ./guard_condition, ./guard_condition, ./node, ./node_options, ./node_options,
  ./domain_id, ./domain_id, ./node_options, ./node, ./client, ./publisher,
  ./publisher, ./time, ./time, ./publisher, ./service, ./service,
  ./subscription, ./subscription, rmw/message_sequence, rmw/message_sequence,
  rmw/message_sequence, ./subscription

type

  rcl_publisher_event_type_t* {.size: sizeof(cint).} = enum ##
                              ##  Enumeration of all of the publisher events that may fire.
    RCL_PUBLISHER_OFFERED_DEADLINE_MISSED, RCL_PUBLISHER_LIVELINESS_LOST,
    RCL_PUBLISHER_OFFERED_INCOMPATIBLE_QOS


type

  rcl_subscription_event_type_t* {.size: sizeof(cint).} = enum ##
                              ##  Enumeration of all of the subscription events that may fire.
    RCL_SUBSCRIPTION_REQUESTED_DEADLINE_MISSED,
    RCL_SUBSCRIPTION_LIVELINESS_CHANGED,
    RCL_SUBSCRIPTION_REQUESTED_INCOMPATIBLE_QOS, RCL_SUBSCRIPTION_MESSAGE_LOST


type

  rcl_event_impl_t* = rcl_event_impl_s ##  Internal rcl implementation struct.

  rcl_event_t* {.importc: "rcl_event_t", header: "event.h", bycopy.} = object ##
                              ##  Structure which encapsulates a ROS QoS event handle.
    impl* {.importc: "impl".}: ptr rcl_event_impl_t ##
                              ##  Pointer to the event implementation



proc rcl_get_zero_initialized_event*(): rcl_event_t {.
    importc: "rcl_get_zero_initialized_event", header: "event.h".}
  ##
                              ##  Return a rcl_event_t struct with members set to `NULL`.
                              ##
                              ##  Should be called to get a null rcl_event_t before passing to
                              ##  rcl_event_init().
                              ##
                              ##  \return Zero initialized rcl_event_t.
                              ##

proc rcl_publisher_event_init*(event: ptr rcl_event_t;
                               publisher: ptr rcl_publisher_t;
                               event_type: rcl_publisher_event_type_t): rcl_ret_t {.
    importc: "rcl_publisher_event_init", header: "event.h".}
  ##
                              ##  Initialize an rcl_event_t with a publisher.
                              ##
                              ##  Fill the rcl_event_t with the publisher and desired event_type.
                              ##
                              ##  \param[in,out] event pointer to fill
                              ##  \param[in] publisher to get events from
                              ##  \param[in] event_type to listen for
                              ##  \return #RCL_RET_OK if the rcl_event_t is filled, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory fails, or
                              ##  \return #RCL_RET_UNSUPPORTED if event_type is not supported, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_subscription_event_init*(event: ptr rcl_event_t;
                                  subscription: ptr rcl_subscription_t;
                                  event_type: rcl_subscription_event_type_t): rcl_ret_t {.
    importc: "rcl_subscription_event_init", header: "event.h".}
  ##
                              ##  Initialize an rcl_event_t with a subscription.
                              ##
                              ##  Fill the rcl_event_t with the subscription and desired event_type.
                              ##
                              ##  \param[in,out] event pointer to fill
                              ##  \param[in] subscription to get events from
                              ##  \param[in] event_type to listen for
                              ##  \return #RCL_RET_OK if the rcl_event_t is filled, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory fails, or
                              ##  \return #RCL_RET_UNSUPPORTED if event_type is not supported, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_take_event*(event: ptr rcl_event_t; event_info: pointer): rcl_ret_t {.
    importc: "rcl_take_event", header: "event.h".}
  ##  Take event using the event handle.
                                                  ##
                                                  ##  Take an event from the event handle.
                                                  ##
                                                  ##  \param[in] event event object to take from
                                                  ##  \param[in, out] event_info event info object to write taken data into
                                                  ##  \return #RCL_RET_OK if successful, or
                                                  ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                                                  ##  \return #RCL_RET_BAD_ALLOC if memory allocation failed, or
                                                  ##  \return #RCL_RET_EVENT_TAKE_FAILED if the take event failed, or
                                                  ##  \return #RCL_RET_ERROR if an unexpected error occurs.
                                                  ##

proc rcl_event_fini*(event: ptr rcl_event_t): rcl_ret_t {.
    importc: "rcl_event_fini", header: "event.h".}
  ##  Finalize an event.
                                                  ##
                                                  ##  Finalize an event.
                                                  ##
                                                  ##  \param[in] event to finalize
                                                  ##  \return #RCL_RET_OK if successful, or
                                                  ##  \return #RCL_RET_EVENT_INVALID if event is null, or
                                                  ##  \return #RCL_RET_ERROR if an unexpected error occurs.
                                                  ##

proc rcl_event_get_rmw_handle*(event: ptr rcl_event_t): ptr rmw_event_t {.
    importc: "rcl_event_get_rmw_handle", header: "event.h".}
  ##
                              ##  Return the rmw event handle.
                              ##
                              ##  The handle returned is a pointer to the internally held rmw handle.
                              ##  This function can fail, and therefore return `NULL`, if the:
                              ##    - event is `NULL`
                              ##    - event is invalid (never called init, called fini, or invalid node)
                              ##
                              ##  The returned handle is made invalid if the event is finalized or if
                              ##  rcl_shutdown() is called.
                              ##  The returned handle is not guaranteed to be valid for the life time of the
                              ##  event as it may be finalized and recreated itself.
                              ##  Therefore it is recommended to get the handle from the event using
                              ##  this function each time it is needed and avoid use of the handle
                              ##  concurrently with functions that might change it.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] event pointer to the rcl event
                              ##  \return rmw event handle if successful, otherwise `NULL`
                              ##

proc rcl_event_is_valid*(event: ptr rcl_event_t): _Bool {.
    importc: "rcl_event_is_valid", header: "event.h".}
  ##
                              ##  Check that the event is valid.
                              ##
                              ##  The bool returned is `false` if `event` is invalid.
                              ##  The bool returned is `true` otherwise.
                              ##  In the case where `false` is to be returned, an error message is set.
                              ##  This function cannot fail.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] event pointer to the rcl event
                              ##  \return `true` if `event` is valid, otherwise `false`
                              ##

proc rcl_event_set_callback*(event: ptr rcl_event_t;
                             callback: rcl_event_callback_t; user_data: pointer): rcl_ret_t {.
    importc: "rcl_event_set_callback", header: "event.h".}
  ##
                              ##  Set the callback function for the event.
                              ##
                              ##  This API sets the callback function to be called whenever the
                              ##  event is notified about a new instance of the event.
                              ##
                              ##  \sa rmw_event_set_callback for more details about this function.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Maybe [1]
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] rmw implementation defined</i>
                              ##
                              ##  \param[in] event The event on which to set the callback
                              ##  \param[in] callback The callback to be called when new events occur, may be NULL
                              ##  \param[in] user_data Given to the callback when called later, may be NULL
                              ##  \return `RCL_RET_OK` if callback was set to the listener, or
                              ##  \return `RCL_RET_INVALID_ARGUMENT` if `event` is NULL, or
                              ##  \return `RCL_RET_UNSUPPORTED` if the API is not implemented in the dds implementation
                              ## 