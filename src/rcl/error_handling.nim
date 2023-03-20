##  Copyright 2015 Open Source Robotics Foundation, Inc.
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
  rcutils/error_handling, rcutils/allocator, rcutils/macros,
  rcutils/types/rcutils_ret, rcutils/visibility_control,
  rcutils/visibility_control_macros, rcutils/snprintf,
  rcutils/testing/fault_injection


type

  rcl_error_state_t* = rcutils_error_state_t ##  The error handling in RCL is just an alias to the error handling in rcutils.

  rcl_error_string_t* = rcutils_error_string_t

const
  rcl_set_error_state* = rcutils_set_error_state
  rcl_initialize_error_handling_thread_local_storage* = rcutils_initialize_error_handling_thread_local_storage
  rcl_reset_error* = rcutils_reset_error
  rcl_get_error_string* = rcutils_get_error_string
  rcl_get_error_state* = rcutils_get_error_state
  rcl_error_is_set* = rcutils_error_is_set
