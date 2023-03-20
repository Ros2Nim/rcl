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
  ./init, ./allocator, rcutils/types/rcutils_ret,
  rcutils/visibility_control_macros, ./context, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/ret_types, rmw/security_options,
  ./arguments, ./log_level, ./macros, ./types, rcutils/logging,
  rcutils/error_handling, rcutils/snprintf, rcutils/testing/fault_injection,
  rcutils/types/array_list, rcutils/types/char_array, rcutils/types/hash_map,
  rcutils/types/string_array, rcutils/qsort, rcutils/types/string_map,
  rcutils/types/uint8_array, rmw/events_statuses/events_statuses,
  rmw/events_statuses/incompatible_qos, rmw/qos_policy_kind,
  rmw/events_statuses/liveliness_changed, rmw/events_statuses/liveliness_lost,
  rmw/events_statuses/message_lost, rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/serialized_message,
  rmw/subscription_content_filter_options, rmw/time, ./visibility_control,
  ./init_options, ./node, ./guard_condition, ./node_options, ./domain_id,
  ./publisher, rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/visibility_control, rosidl_typesupport_interface/macros,
  ./time, ./subscription, ./event_callback, rmw/event_callback_type,
  rmw/message_sequence, ./wait, ./client,
  rosidl_runtime_c/service_type_support_struct, ./service, ./timer, rmw/rmw,
  rosidl_runtime_c/sequence_bound, rmw/event, rmw/publisher_options,
  rmw/qos_profiles, rmw/subscription_options, ./event
