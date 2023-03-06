##  Copyright 2018-2020 Open Source Robotics Foundation, Inc.
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
  ./allocator, rcutils/allocator, rcutils/allocator, rcutils/macros,
  rcutils/macros, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/allocator, rcutils/types/rcutils_ret, rcutils/allocator,
  rcutils/visibility_control, rcutils/visibility_control_macros,
  rcutils/visibility_control_macros, rcutils/visibility_control,
  rcutils/allocator, ./allocator, ./types, rmw/types, rmw/types, rmw/types,
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
  rmw/types, ./types, ./visibility_control, ./visibility_control

const
  ROS_SECURITY_ENCLAVE_OVERRIDE* = "ROS_SECURITY_ENCLAVE_OVERRIDE" ##
                              ##  The name of the environment variable containing the security enclave override.
  ROS_SECURITY_KEYSTORE_VAR_NAME* = "ROS_SECURITY_KEYSTORE" ##
                              ##  The name of the environment variable containing the path to the keystore.
  ROS_SECURITY_STRATEGY_VAR_NAME* = "ROS_SECURITY_STRATEGY" ##
                              ##  The name of the environment variable containing the security strategy.
  ROS_SECURITY_ENABLE_VAR_NAME* = "ROS_SECURITY_ENABLE" ##
                              ##  The name of the environment variable controlling whether security is enabled.


proc rcl_get_security_options_from_environment*(name: cstring;
    allocator: ptr rcutils_allocator_t;
    security_options: ptr rmw_security_options_t): rcl_ret_t {.
    importc: "rcl_get_security_options_from_environment",
    header: "rcl/security.h".}
  ##  Initialize security options from values in the environment variables and given names.
                              ##
                              ##  Initialize the given security options based on the environment.
                              ##  For more details:
                              ##   \sa rcl_security_enabled()
                              ##   \sa rcl_get_enforcement_policy()
                              ##   \sa rcl_get_secure_root()
                              ##
                              ##  \param[in] name name used to find the security root path.
                              ##  \param[in] allocator used to do allocations.
                              ##  \param[out] security_options security options that will be configured according to
                              ##   the environment.
                              ##  \return #RCL_RET_OK If the security options are returned properly, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if an argument is not valid, or
                              ##  \return #RCL_RET_ERROR if an unexpected error happened
                              ##

proc rcl_security_enabled*(use_security: ptr _Bool): rcl_ret_t {.
    importc: "rcl_security_enabled", header: "rcl/security.h".}
  ##
                              ##  Check if security has to be used, according to the environment.
                              ##
                              ##  If the `ROS_SECURITY_ENABLE` environment variable is set to "true", `use_security` will be set to
                              ##  true.
                              ##
                              ##  \param[out] use_security Must not be NULL.
                              ##  \return #RCL_RET_INVALID_ARGUMENT if an argument is not valid, or
                              ##  \return #RCL_RET_ERROR if an unexpected error happened, or
                              ##  \return #RCL_RET_OK.
                              ##

proc rcl_get_enforcement_policy*(policy: ptr rmw_security_enforcement_policy_t): rcl_ret_t {.
    importc: "rcl_get_enforcement_policy", header: "rcl/security.h".}
  ##
                              ##  Get security enforcement policy from the environment.
                              ##
                              ##  Sets `policy` based on the value of the `ROS_SECURITY_STRATEGY` environment variable.
                              ##  If `ROS_SECURITY_STRATEGY` is "Enforce", `policy` will be `RMW_SECURITY_ENFORCEMENT_ENFORCE`.
                              ##  If not, `policy` will be `RMW_SECURITY_ENFORCEMENT_PERMISSIVE`.
                              ##
                              ##  \param[out] policy Must not be NULL.
                              ##  \return #RCL_RET_INVALID_ARGUMENT if an argument is not valid, or
                              ##  \return #RCL_RET_ERROR if an unexpected error happened, or
                              ##  \return #RCL_RET_OK.
                              ##

proc rcl_get_secure_root*(name: cstring; allocator: ptr rcl_allocator_t): cstring {.
    importc: "rcl_get_secure_root", header: "rcl/security.h".}
  ##
                              ##  Return the secure root given a enclave name.
                              ##
                              ##  Return the security directory associated with the enclave name.
                              ##
                              ##  The value of the environment variable `ROS_SECURITY_KEYSTORE` is used as a root.
                              ##  The specific directory to be used is found from that root using the `name` passed.
                              ##  E.g. for a context named "/a/b/c" and root "/r", the secure root path will be
                              ##  "/r/a/b/c", where the delimiter "/" is native for target file system (e.g. "\\" for _WIN32).
                              ##
                              ##  However, this expansion can be overridden by setting the secure enclave override environment
                              ##  (`ROS_SECURITY_ENCLAVE_OVERRIDE`) variable, allowing users to explicitly specify the exact enclave
                              ##  `name` to be utilized.
                              ##  Such an override is useful for applications where the enclave is non-deterministic
                              ##  before runtime, or when testing and using additional tools that may not otherwise be easily
                              ##  provisioned.
                              ##
                              ##  \param[in] name validated name (a single token)
                              ##  \param[in] allocator the allocator to use for allocation
                              ##  \return Machine specific (absolute) enclave directory path or NULL on failure.
                              ##   Returned pointer must be deallocated by the caller of this function
                              ## 