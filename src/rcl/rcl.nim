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
##  \mainpage rcl: Common functionality for other ROS Client Libraries
##
##  `rcl` consists of functions and structs (pure C) organized into ROS concepts:
##
##  - Nodes
##    - rcl/node.h
##  - Publisher
##    - rcl/publisher.h
##  - Subscription
##    - rcl/subscription.h
##  - Service Client
##    - rcl/client.h
##  - Service Server
##    - rcl/service.h
##  - Timer
##    - rcl/timer.h
##
##  There are some functions for working with "Topics" and "Services":
##
##  - A function to validate a topic or service name (not necessarily fully qualified):
##    - rcl_validate_topic_name()
##    - rcl/validate_topic_name.h
##  - A function to expand a topic or service name to a fully qualified name:
##    - rcl_expand_topic_name()
##    - rcl/expand_topic_name.h
##
##  It also has some machinery that is necessary to wait on and act on these concepts:
##
##  - Initialization and shutdown management
##    - rcl/init.h
##  - Wait sets for waiting on messages/service requests and responses/timers to be ready
##    - rcl/wait.h
##  - Guard conditions for waking up wait sets asynchronously
##    - rcl/guard_condition.h
##  - Functions for introspecting and getting notified of changes of the ROS graph
##    - rcl/graph.h
##
##  Further still there are some useful abstractions and utilities:
##
##  - Allocator concept, which can be used to control allocation in `rcl_*` functions
##    - rcl/allocator.h
##  - Concept of ROS Time and access to steady and system wall time
##    - rcl/time.h
##  - Error handling functionality (C style)
##    - rcl/error_handling.h
##  - Macros
##    - rcl/macros.h
##  - Return code types
##    - rcl/types.h
##  - Macros for controlling symbol visibility on the library
##    - rcl/visibility_control.h
##

import
  ./init, ./allocator, rcutils/allocator, rcutils/allocator, rcutils/allocator,
  rcutils/macros, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, rcutils/allocator, rcutils/types/rcutils_ret,
  rcutils/allocator, rcutils/visibility_control,
  rcutils/visibility_control_macros, rcutils/visibility_control_macros,
  rcutils/visibility_control, rcutils/allocator, ./allocator, ./init, ./context,
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
  ./init_options, ./init_options, ./context, ./context, ./init, ./node, ./node,
  ./guard_condition, ./guard_condition, ./node, ./node_options, ./node_options,
  ./domain_id, ./domain_id, ./node_options, ./node, ./publisher,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/visibility_control, rosidl_runtime_c/visibility_control,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_typesupport_interface/macros,
  rosidl_runtime_c/message_type_support_struct, ./publisher, ./time, ./time,
  ./publisher, ./subscription, ./event_callback, rmw/event_callback_type,
  rmw/event_callback_type, ./event_callback, ./subscription,
  rmw/message_sequence, rmw/message_sequence, rmw/message_sequence,
  ./subscription, ./wait, ./wait, ./client,
  rosidl_runtime_c/service_type_support_struct,
  rosidl_runtime_c/service_type_support_struct, ./client, ./wait, ./service,
  ./service, ./wait, ./timer, ./timer, rmw/rmw, rmw/rmw,
  rosidl_runtime_c/sequence_bound, rosidl_runtime_c/sequence_bound, rmw/rmw,
  rmw/event, rmw/event, rmw/rmw, rmw/publisher_options, rmw/rmw,
  rmw/qos_profiles, rmw/rmw, rmw/subscription_options, rmw/rmw, ./timer, ./wait,
  ./event, ./event, ./wait
