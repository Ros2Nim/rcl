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
  rmw/types, rcutils/logging, rcutils/types/rcutils_ret,
  rcutils/visibility_control, rcutils/visibility_control_macros,
  rcutils/error_handling, rcutils/snprintf, rcutils/testing/fault_injection,
  rcutils/time, rcutils/types/array_list, rcutils/types/char_array,
  rcutils/types/hash_map, rcutils/types/string_array, rcutils/qsort,
  rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/visibility_control,
  rmw/events_statuses/liveliness_changed, rmw/events_statuses/liveliness_lost,
  rmw/events_statuses/message_lost, rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/macros, rmw/ret_types, rmw/security_options,
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time

const
  RCL_RET_ALREADY_INIT* = 100 ##  rcl specific ret codes start at 100
                              ##  rcl_init() already called return code.
  RCL_RET_NOT_INIT* = 101    ##  rcl_init() not yet called return code.
  RCL_RET_MISMATCHED_RMW_ID* = 102 ##  Mismatched rmw identifier return code.
  RCL_RET_TOPIC_NAME_INVALID* = 103 ##  Topic name does not pass validation.
  RCL_RET_SERVICE_NAME_INVALID* = 104 ##  Service name (same as topic name) does not pass validation.
  RCL_RET_UNKNOWN_SUBSTITUTION* = 105 ##  Topic name substitution is unknown.
  RCL_RET_ALREADY_SHUTDOWN* = 106 ##  rcl_shutdown() already called return code.
  RCL_RET_NODE_INVALID* = 200 ##  rcl node specific ret codes in 2XX
                              ##  Invalid rcl_node_t given return code.
  RCL_RET_NODE_INVALID_NAME* = 201 ##  Invalid node name return code.
  RCL_RET_NODE_INVALID_NAMESPACE* = 202 ##  Invalid node namespace return code.
  RCL_RET_NODE_NAME_NON_EXISTENT* = 203 ##  Failed to find node name
  RCL_RET_PUBLISHER_INVALID* = 300 ##  rcl publisher specific ret codes in 3XX
                                   ##  Invalid rcl_publisher_t given return code.
  RCL_RET_SUBSCRIPTION_INVALID* = 400 ##  rcl subscription specific ret codes in 4XX
                                      ##  Invalid rcl_subscription_t given return code.
  RCL_RET_SUBSCRIPTION_TAKE_FAILED* = 401 ##  Failed to take a message from the subscription return code.
  RCL_RET_CLIENT_INVALID* = 500 ##  rcl service client specific ret codes in 5XX
                                ##  Invalid rcl_client_t given return code.
  RCL_RET_CLIENT_TAKE_FAILED* = 501 ##  Failed to take a response from the client return code.
  RCL_RET_SERVICE_INVALID* = 600 ##  rcl service server specific ret codes in 6XX
                                 ##  Invalid rcl_service_t given return code.
  RCL_RET_SERVICE_TAKE_FAILED* = 601 ##  Failed to take a request from the service return code.
  RCL_RET_TIMER_INVALID* = 800 ##  rcl guard condition specific ret codes in 7XX
                               ##  rcl timer specific ret codes in 8XX
                               ##  Invalid rcl_timer_t given return code.
  RCL_RET_TIMER_CANCELED* = 801 ##  Given timer was canceled return code.
  RCL_RET_WAIT_SET_INVALID* = 900 ##  rcl wait and wait set specific ret codes in 9XX
                                  ##  Invalid rcl_wait_set_t given return code.
  RCL_RET_WAIT_SET_EMPTY* = 901 ##  Given rcl_wait_set_t is empty return code.
  RCL_RET_WAIT_SET_FULL* = 902 ##  Given rcl_wait_set_t is full return code.
  RCL_RET_INVALID_REMAP_RULE* = 1001 ##  rcl argument parsing specific ret codes in 1XXX
                                     ##  Argument is not a valid remap rule
  RCL_RET_WRONG_LEXEME* = 1002 ##  Expected one type of lexeme but got another
  RCL_RET_INVALID_ROS_ARGS* = 1003 ##  Found invalid ros argument while parsing
  RCL_RET_INVALID_PARAM_RULE* = 1010 ##  Argument is not a valid parameter rule
  RCL_RET_INVALID_LOG_LEVEL_RULE* = 1020 ##  Argument is not a valid log level rule
  RCL_RET_EVENT_INVALID* = 2000 ##  rcl event specific ret codes in 20XX
                                ##  Invalid rcl_event_t given return code.
  RCL_RET_EVENT_TAKE_FAILED* = 2001 ##  Failed to take an event from the event handle
  RCL_RET_LIFECYCLE_STATE_REGISTERED* = 3000 ##  rcl_lifecycle state register ret codes in 30XX
                                             ##  rcl_lifecycle state registered
  RCL_RET_LIFECYCLE_STATE_NOT_REGISTERED* = 3001 ##  rcl_lifecycle state not registered

type

  rcl_ret_t* = rmw_ret_t     ##  The type that holds an rcl return code.

  rcl_serialized_message_t* = rmw_serialized_message_t ##
                              ##  typedef for rmw_serialized_message_t;

const
  RCL_RET_OK* = RMW_RET_OK   ##  Success return code.
  RCL_RET_ERROR* = RMW_RET_ERROR ##  Unspecified error return code.
  RCL_RET_TIMEOUT* = RMW_RET_TIMEOUT ##  Timeout occurred return code.
  RCL_RET_BAD_ALLOC* = RMW_RET_BAD_ALLOC ##  Failed to allocate memory return code.
  RCL_RET_INVALID_ARGUMENT* = RMW_RET_INVALID_ARGUMENT ##
                              ##  Invalid argument return code.
  RCL_RET_UNSUPPORTED* = RMW_RET_UNSUPPORTED ##  Unsupported return code.
