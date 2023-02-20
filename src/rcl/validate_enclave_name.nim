##  Copyright 2020 Open Source Robotics Foundation, Inc.
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
  rmw/validate_namespace, rmw/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, rcutils/macros, rcutils/macros, rmw/macros,
  rmw/validate_namespace, rmw/types, rmw/types, rmw/types, rmw/types,
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
  rmw/init_options, rmw/ret_types, rmw/init_options, rmw/security_options,
  rmw/security_options, rmw/init_options, rmw/init, rmw/types,
  rmw/serialized_message, rmw/types, rmw/subscription_content_filter_options,
  rmw/subscription_content_filter_options, rmw/types, rmw/time, rmw/time,
  rmw/types, rmw/validate_namespace, rmw/validate_full_topic_name,
  rmw/validate_full_topic_name, rmw/validate_namespace, rmw/validate_node_name,
  rmw/validate_node_name, ./macros, ./types, ./visibility_control,
  ./visibility_control

const
  RCL_ENCLAVE_NAME_VALID* = RMW_NAMESPACE_VALID ##  The enclave name is valid.
  RCL_ENCLAVE_NAME_INVALID_IS_EMPTY_STRING* = RMW_NAMESPACE_INVALID_IS_EMPTY_STRING ##
                              ##  The enclave name is invalid because it is an empty string.
  RCL_ENCLAVE_NAME_INVALID_NOT_ABSOLUTE* = RMW_NAMESPACE_INVALID_NOT_ABSOLUTE ##
                              ##  The enclave name is invalid because it is not absolute.
  RCL_ENCLAVE_NAME_INVALID_ENDS_WITH_FORWARD_SLASH* = RMW_NAMESPACE_INVALID_ENDS_WITH_FORWARD_SLASH ##
                              ##  The enclave name is invalid because it ends with a forward slash.
  RCL_ENCLAVE_NAME_INVALID_CONTAINS_UNALLOWED_CHARACTERS* = RMW_NAMESPACE_INVALID_CONTAINS_UNALLOWED_CHARACTERS ##
                              ##  The enclave name is invalid because it has characters that are not allowed.
  RCL_ENCLAVE_NAME_INVALID_CONTAINS_REPEATED_FORWARD_SLASH* = RMW_NAMESPACE_INVALID_CONTAINS_REPEATED_FORWARD_SLASH ##
                              ##  The enclave name is invalid because it contains repeated forward slashes.
  RCL_ENCLAVE_NAME_INVALID_NAME_TOKEN_STARTS_WITH_NUMBER* = RMW_NAMESPACE_INVALID_NAME_TOKEN_STARTS_WITH_NUMBER ##
                              ##  The enclave name is invalid because one of the tokens starts with a number.
  RCL_ENCLAVE_NAME_INVALID_TOO_LONG* = RMW_NAMESPACE_INVALID_TOO_LONG ##
                              ##  The enclave name is invalid because the name is too long.
  RCL_ENCLAVE_NAME_MAX_LENGTH* = RMW_NODE_NAME_MAX_NAME_LENGTH ##
                              ##  The maximum length of an enclave name.


proc rcl_validate_enclave_name*(enclave: cstring; validation_result: ptr cint;
                                invalid_index: ptr csize_t): rcl_ret_t {.
    importc: "rcl_validate_enclave_name", header: "validate_enclave_name.h".}
  ##
                              ##  Determine if a given enclave name is valid.
                              ##
                              ##  The same rules as rmw_validate_namespace() are used.
                              ##  The only difference is in the maximum allowed length, which can be up to 255 characters.
                              ##
                              ##  \param[in] enclave enclave to be validated
                              ##  \param[out] validation_result int in which the result of the check is stored
                              ##  \param[out] invalid_index index of the input string where an error occurred
                              ##  \return #RCL_RET_OK on successfully running the check, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT on invalid parameters, or
                              ##  \return #RCL_RET_ERROR when an unspecified error occurs.
                              ##

proc rcl_validate_enclave_name_with_size*(enclave: cstring;
    enclave_length: csize_t; validation_result: ptr cint;
    invalid_index: ptr csize_t): rcl_ret_t {.
    importc: "rcl_validate_enclave_name_with_size",
    header: "validate_enclave_name.h".}
  ##  Deterimine if a given enclave name is valid.
                                       ##
                                       ##  This is an overload of rcl_validate_enclave_name() with an extra parameter
                                       ##  for the length of enclave.
                                       ##
                                       ##  \param[in] enclave enclave to be validated
                                       ##  \param[in] enclave_length The number of characters in enclave
                                       ##  \param[out] validation_result int in which the result of the check is stored
                                       ##  \param[out] invalid_index index of the input string where an error occurred
                                       ##  \return #RCL_RET_OK on successfully running the check, or
                                       ##  \return #RCL_RET_INVALID_ARGUMENT on invalid parameters, or
                                       ##  \return #RCL_RET_ERROR when an unspecified error occurs.
                                       ##

proc rcl_enclave_name_validation_result_string*(validation_result: cint): cstring {.
    importc: "rcl_enclave_name_validation_result_string",
    header: "validate_enclave_name.h".}
  ##  Return a validation result description, or NULL if unknown or RCL_ENCLAVE_NAME_VALID.
                                       ##
                                       ##  \param[in] validation_result The validation result to get the string for
                                       ##  \return A string description of the validation result if successful, or
                                       ##  \return NULL if the validation result is invalid.
                                       ## 