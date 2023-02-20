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
  ./visibility_control, ./visibility_control

const
  RMW_IMPLEMENTATION_ENV_VAR_NAME* = "RMW_IMPLEMENTATION" ##
                              ##  The environment variable name to control which RMW implementation is used.
  RCL_ASSERT_RMW_ID_MATCHES_ENV_VAR_NAME* = "RCL_ASSERT_RMW_ID_MATCHES" ##
                              ##  The environment variable name to control whether the chosen RMW implementation
                              ##  matches the one that is in use.


proc rcl_rmw_implementation_identifier_check*(): rcl_ret_t {.
    importc: "rcl_rmw_implementation_identifier_check",
    header: "rmw_implementation_identifier_check.h".}
  ##
                              ##  Check whether the RMW implementation in use matches what the user requested.
                              ##
                              ##  \return #RCL_RET_OK if the RMW implementation in use matches what the user requested, or
                              ##  \return #RCL_RET_MISMATCHED_RMW_ID if the RMW implementation does not match, or
                              ##  \return #RCL_RET_BAD_ALLOC if memory allocation failed, or
                              ##  \return #RCL_RET_ERROR if some other error occurred.
                              ## 