##  Copyright 2017 Open Source Robotics Foundation, Inc.
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
  ./macros, rcutils/macros, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, ./macros, ./types, rmw/types, rmw/types, rmw/types, rmw/types,
  rcutils/logging, rcutils/logging, rcutils/logging, rcutils/allocator,
  rcutils/allocator, rcutils/types/rcutils_ret, rcutils/allocator,
  rcutils/visibility_control, rcutils/visibility_control_macros,
  rcutils/visibility_control_macros, rcutils/visibility_control,
  rcutils/allocator, rcutils/logging, rcutils/error_handling,
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
  rmw/types, ./types, ./visibility_control, ./visibility_control

const
  RCL_TOPIC_NAME_VALID* = 0  ##  The topic name is valid.
  RCL_TOPIC_NAME_INVALID_IS_EMPTY_STRING* = 1 ##  The topic name is invalid because it is an empty string.
  RCL_TOPIC_NAME_INVALID_ENDS_WITH_FORWARD_SLASH* = 2 ##
                              ##  The topic name is invalid because it ends with a forward slash.
  RCL_TOPIC_NAME_INVALID_CONTAINS_UNALLOWED_CHARACTERS* = 3 ##
                              ##  The topic name is invalid because it has characters that are not allowed.
  RCL_TOPIC_NAME_INVALID_NAME_TOKEN_STARTS_WITH_NUMBER* = 4 ##
                              ##  The topic name is invalid because one of the tokens starts with a number.
  RCL_TOPIC_NAME_INVALID_UNMATCHED_CURLY_BRACE* = 5 ##
                              ##  The topic name is invalid because it has an unmatched curly brace.
  RCL_TOPIC_NAME_INVALID_MISPLACED_TILDE* = 6 ##  The topic name is invalid because it has a misplaced tilde in it.
  RCL_TOPIC_NAME_INVALID_TILDE_NOT_FOLLOWED_BY_FORWARD_SLASH* = 7 ##
                              ##  The topic name is invalid because a tilde is not directly followed by a forward slash.
  RCL_TOPIC_NAME_INVALID_SUBSTITUTION_CONTAINS_UNALLOWED_CHARACTERS* = 8 ##
                              ##  The topic name is invalid because one of the substitutions has characters that are not allowed.
  RCL_TOPIC_NAME_INVALID_SUBSTITUTION_STARTS_WITH_NUMBER* = 9 ##
                              ##  The topic name is invalid because one of the substitutions starts with a number.


proc rcl_validate_topic_name*(topic_name: cstring; validation_result: ptr cint;
                              invalid_index: ptr csize_t): rcl_ret_t {.
    importc: "rcl_validate_topic_name", header: "rcl/validate_topic_name.h".}
  ##
                              ##  Validate a given topic name.
                              ##
                              ##  The topic name does not need to be a full qualified name, but it should
                              ##  follow some of the rules in this document:
                              ##
                              ##    http://design.ros2.org/articles/topic_and_service_names.html
                              ##
                              ##  Note that this function expects any URL suffixes as described in the above
                              ##  document to have already been removed.
                              ##
                              ##  If the input topic is valid, RCL_TOPIC_NAME_VALID will be stored
                              ##  into validation_result.
                              ##  If the input topic violates any of the rules then one of these values will
                              ##  be stored into validation_result:
                              ##
                              ##  - RCL_TOPIC_NAME_INVALID_IS_EMPTY_STRING
                              ##  - RCL_TOPIC_NAME_INVALID_ENDS_WITH_FORWARD_SLASH
                              ##  - RCL_TOPIC_NAME_INVALID_CONTAINS_UNALLOWED_CHARACTERS
                              ##  - RCL_TOPIC_NAME_INVALID_NAME_TOKEN_STARTS_WITH_NUMBER
                              ##  - RCL_TOPIC_NAME_INVALID_UNMATCHED_CURLY_BRACE
                              ##  - RCL_TOPIC_NAME_INVALID_MISPLACED_TILDE
                              ##  - RCL_TOPIC_NAME_INVALID_TILDE_NOT_FOLLOWED_BY_FORWARD_SLASH
                              ##  - RCL_TOPIC_NAME_INVALID_SUBSTITUTION_CONTAINS_UNALLOWED_CHARACTERS
                              ##  - RCL_TOPIC_NAME_INVALID_SUBSTITUTION_STARTS_WITH_NUMBER
                              ##
                              ##  Some checks, like the check for illegal repeated forward slashes, are not
                              ##  checked in this function because they would need to be checked again after
                              ##  expansion anyways.
                              ##  The purpose of this subset of checks is to try to catch issues with content
                              ##  that will be expanded in some way by rcl_expand_topic_name(), like `~` or
                              ##  substitutions inside of `{}`, or with other issues that would obviously
                              ##  prevent expansion, like RCL_TOPIC_NAME_INVALID_IS_EMPTY_STRING.
                              ##
                              ##  This function does not check that the substitutions are known substitutions,
                              ##  only that the contents of the `{}` follow the rules outline in the document
                              ##  which was linked to above.
                              ##
                              ##  Stricter validation can be done with rmw_validate_full_topic_name() after using
                              ##  rcl_expand_topic_name().
                              ##
                              ##  Additionally, if the invalid_index argument is not NULL, then it will be
                              ##  assigned the index in the topic_name string where the violation occurs.
                              ##  The invalid_index is not set if the validation passes.
                              ##
                              ##  \param[in] topic_name the topic name to be validated, must be null terminated
                              ##  \param[out] validation_result the reason for validation failure, if any
                              ##  \param[out] invalid_index index of violation if the input topic is invalid
                              ##  \return #RCL_RET_OK if the topic name was expanded successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_validate_topic_name_with_size*(topic_name: cstring;
                                        topic_name_length: csize_t;
                                        validation_result: ptr cint;
                                        invalid_index: ptr csize_t): rcl_ret_t {.
    importc: "rcl_validate_topic_name_with_size",
    header: "rcl/validate_topic_name.h".}
  ##  Validate a given topic name.
                                         ##
                                         ##  This is an overload with an extra parameter for the length of topic_name.
                                         ##  \param[in] topic_name the topic name to be validated, must be null terminated
                                         ##  \param[in] topic_name_length The number of characters in topic_name.
                                         ##  \param[out] validation_result the reason for validation failure, if any
                                         ##  \param[out] invalid_index index of violation if the input topic is invalid
                                         ##  \return #RCL_RET_OK if the topic name was expanded successfully, or
                                         ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                                         ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                                         ##
                                         ##  \sa rcl_validate_topic_name()
                                         ##

proc rcl_topic_name_validation_result_string*(validation_result: cint): cstring {.
    importc: "rcl_topic_name_validation_result_string",
    header: "rcl/validate_topic_name.h".}
  ##  Return a validation result description, or NULL if unknown or RCL_TOPIC_NAME_VALID.
                                         ##
                                         ##  \param[in] validation_result The validation result to get the string for
                                         ##  \return A string description of the validation result if successful, or
                                         ##  \return NULL if the validation result is invalid.
                                         ## 