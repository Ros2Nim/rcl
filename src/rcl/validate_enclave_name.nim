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
  rmw/validate_namespace, rcutils/logging, rcutils/types/rcutils_ret,
  rcutils/visibility_control_macros, rcutils/error_handling, rcutils/snprintf,
  rcutils/testing/fault_injection, rcutils/types/array_list,
  rcutils/types/char_array, rcutils/types/hash_map, rcutils/types/string_array,
  rcutils/qsort, rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/events_statuses/liveliness_changed,
  rmw/events_statuses/liveliness_lost, rmw/events_statuses/message_lost,
  rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/ret_types, rmw/security_options,
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time,
  rmw/validate_full_topic_name, rmw/validate_node_name, ./macros, ./types,
  ./visibility_control


proc rcl_validate_enclave_name*(enclave: cstring; validation_result: ptr cint;
                                invalid_index: ptr csize_t): rcl_ret_t {.
    importc: "rcl_validate_enclave_name", header: "rcl/validate_enclave_name.h".}
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
    header: "rcl/validate_enclave_name.h".}
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
    header: "rcl/validate_enclave_name.h".}
  ##  Return a validation result description, or NULL if unknown or RCL_ENCLAVE_NAME_VALID.
                                           ##
                                           ##  \param[in] validation_result The validation result to get the string for
                                           ##  \return A string description of the validation result if successful, or
                                           ##  \return NULL if the validation result is invalid.
                                           ## 