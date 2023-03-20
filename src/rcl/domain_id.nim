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
  ./types, rmw/types, rcutils/logging, rcutils/types/rcutils_ret,
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
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time,
  ./visibility_control

let RCL_DOMAIN_ID_ENV_VAR* {.header: "rcl/domain_id.h".}: cstring


proc rcl_get_default_domain_id*(domain_id: ptr csize_t): rcl_ret_t {.
    importc: "rcl_get_default_domain_id", header: "rcl/domain_id.h".}
  ##
                              ##  Determine the default domain ID, based on the environment.
                              ##
                              ##  \param[out] domain_id Must not be NULL.
                              ##  \returns #RCL_RET_INVALID_ARGUMENT if an argument is invalid, or,
                              ##  \returns #RCL_RET_ERROR in case of an unexpected error, or,
                              ##  \returns #RCL_RET_OK.
                              ## 