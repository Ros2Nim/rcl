##  Copyright 2020 Ericsson AB
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

import
  rmw/network_flow_endpoint, rmw/types, rmw/types, rmw/types, rmw/types,
  rcutils/logging, rcutils/logging, rcutils/logging, rcutils/allocator,
  rcutils/allocator, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, rcutils/macros, rcutils/allocator, rcutils/types/rcutils_ret,
  rcutils/allocator, rcutils/visibility_control,
  rcutils/visibility_control_macros, rcutils/visibility_control_macros,
  rcutils/visibility_control, rcutils/allocator, rcutils/logging,
  rcutils/error_handling, rcutils/error_handling, rcutils/error_handling,
  rcutils/error_handling, rcutils/error_handling, rcutils/error_handling,
  rcutils/snprintf, rcutils/snprintf, rcutils/error_handling,
  rcutils/testing/fault_injection, rcutils/testing/fault_injection,
  rcutils/testing/fault_injection, rcutils/error_handling,
  rcutils/error_handling, rcutils/error_handling, rcutils/error_handling,
  rcutils/logging, rcutils/time, rcutils/time, rcutils/types,
  rcutils/types/array_list, rcutils/types/array_list, rcutils/types,
  rcutils/types/char_array, rcutils/types/char_array, rcutils/types,
  rcutils/types/hash_map, rcutils/types/hash_map, rcutils/types,
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
  rmw/types, rmw/network_flow_endpoint, rmw/network_flow_endpoint_array,
  rmw/network_flow_endpoint_array, ./allocator, ./arguments, ./log_level,
  ./macros, ./log_level, ./types, ./log_level, ./visibility_control,
  ./visibility_control, ./log_level, ./arguments, rcl_yaml_param_parser/types,
  ./arguments, ./context, ./context, ./init_options, ./init_options, ./context,
  ./context, ./publisher, rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/visibility_control, rosidl_runtime_c/visibility_control,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_typesupport_interface/macros,
  rosidl_runtime_c/message_type_support_struct, ./publisher, ./node, ./node,
  ./guard_condition, ./guard_condition, ./node, ./node_options, ./node_options,
  ./domain_id, ./domain_id, ./node_options, ./node, ./publisher, ./time, ./time,
  ./publisher, ./subscription, ./event_callback, rmw/event_callback_type,
  rmw/event_callback_type, ./event_callback, ./subscription,
  rmw/message_sequence, rmw/message_sequence, rmw/message_sequence,
  ./subscription

type

  rcl_network_flow_endpoint_t* = rmw_network_flow_endpoint_t

  rcl_network_flow_endpoint_array_t* = rmw_network_flow_endpoint_array_t

  rcl_transport_protocol_t* = rmw_transport_protocol_t

  rcl_internet_protocol_t* = rmw_internet_protocol_t

const
  rcl_get_zero_initialized_network_flow_endpoint_array* = rmw_get_zero_initialized_network_flow_endpoint_array
  rcl_network_flow_endpoint_array_fini* = rmw_network_flow_endpoint_array_fini
  rcl_network_flow_endpoint_get_transport_protocol_string* = rmw_network_flow_endpoint_get_transport_protocol_string
  rcl_network_flow_endpoint_get_internet_protocol_string* = rmw_network_flow_endpoint_get_internet_protocol_string


proc rcl_publisher_get_network_flow_endpoints*(publisher: ptr rcl_publisher_t;
    allocator: ptr rcutils_allocator_t;
    network_flow_endpoint_array: ptr rcl_network_flow_endpoint_array_t): rcl_ret_t {.
    importc: "rcl_publisher_get_network_flow_endpoints",
    header: "rcl/network_flow_endpoints.h".}
  ##  Get network flow endpoints of a publisher
                                            ##
                                            ##  Query the underlying middleware for a given publisher's network flow endpoints
                                            ##
                                            ##  The `publisher` argument must point to a valid publisher.
                                            ##
                                            ##  The `allocator` argument must be a valid allocator.
                                            ##
                                            ##  The `network_flow_endpoint_array` argument must be allocated and zero-initialized.
                                            ##  The function returns network flow endpoints in the `network_flow_endpoint_array` argument,
                                            ##  using the allocator to allocate memory for the `network_flow_endpoint_array`
                                            ##  argument's internal data structures whenever required. The caller is
                                            ##  reponsible for memory deallocation by passing the `network_flow_endpoint_array`
                                            ##  argument to `rcl_network_flow_endpoint_array_fini` function.
                                            ##
                                            ##  <hr>
                                            ##  Attribute          | Adherence
                                            ##  ------------------ | -------------
                                            ##  Allocates Memory   | Yes
                                            ##  Thread-Safe        | No
                                            ##  Uses Atomics       | No
                                            ##  Lock-Free          | Maybe [1]
                                            ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                                            ##
                                            ##  \param[in] publisher the publisher instance to inspect
                                            ##  \param[in] allocator allocator to be used when allocating space for network_flow_endpoint_array_t
                                            ##  \param[out] network_flow_endpoint_array the network flow endpoints
                                            ##  \return `RCL_RET_OK` if successful, or
                                            ##  \return `RCL_RET_INVALID_ARGUMENT` if any argument is null, or
                                            ##  \return `RCL_RET_BAD_ALLOC` if memory allocation fails, or
                                            ##  \return `RCL_RET_UNSUPPORTED` if not supported, or
                                            ##  \return `RCL_RET_ERROR` if an unexpected error occurs.
                                            ##

proc rcl_subscription_get_network_flow_endpoints*(
    subscription: ptr rcl_subscription_t; allocator: ptr rcutils_allocator_t;
    network_flow_endpoint_array: ptr rcl_network_flow_endpoint_array_t): rcl_ret_t {.
    importc: "rcl_subscription_get_network_flow_endpoints",
    header: "rcl/network_flow_endpoints.h".}
  ##  Get network flow endpoints of a subscription
                                            ##
                                            ##  Query the underlying middleware for a given subscription's network flow endpoints
                                            ##
                                            ##  The `subscription` argument must point to a valid subscription.
                                            ##
                                            ##  The `allocator` argument must be a valid allocator.
                                            ##
                                            ##  The `network_flow_endpoint_array` argument must be allocated and zero-initialized.
                                            ##  The function returns network flow endpoints in the `network_flow_endpoint_array` argument,
                                            ##  using the allocator to allocate memory for the `network_flow_endpoint_array`
                                            ##  argument's internal data structures whenever required. The caller is
                                            ##  reponsible for memory deallocation by passing the `network_flow_endpoint_array`
                                            ##  argument to `rcl_network_flow_endpoint_array_fini` function.
                                            ##
                                            ##  <hr>
                                            ##  Attribute          | Adherence
                                            ##  ------------------ | -------------
                                            ##  Allocates Memory   | Yes
                                            ##  Thread-Safe        | No
                                            ##  Uses Atomics       | No
                                            ##  Lock-Free          | Maybe [1]
                                            ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                                            ##
                                            ##  \param[in] subscription the subscription instance to inspect
                                            ##  \param[in] allocator allocator to be used when allocating space for network_flow_endpoint_array_t
                                            ##  \param[out] network_flow_endpoint_array the network flow endpoints
                                            ##  \return `RCL_RET_OK` if successful, or
                                            ##  \return `RCL_RET_INVALID_ARGUMENT` if any argument is null, or
                                            ##  \return `RCL_RET_BAD_ALLOC` if memory allocation fails, or
                                            ##  \return `RCL_RET_UNSUPPORTED` if not supported, or
                                            ##  \return `RCL_RET_ERROR` if an unexpected error occurs.
                                            ## 