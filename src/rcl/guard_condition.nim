import rcutils/allocator as rcutils_allocator
import rcutils/time as rcutils_time
import rmw/types as rmw_types
import ./types
import rmw/types as rmw_types

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
##  @file

import
  ./allocator, rcutils/types/rcutils_ret, rcutils/visibility_control_macros,
  ./context, rmw/init as rmw_init, rmw/init as rmw_init_options,
  rmw/domain_id as rmw_domain_id, rmw/localhost, rmw/ret_types,
  rmw/security_options, ./arguments, ./log_level, ./macros, ./types,
  rcutils/logging, rcutils/error_handling as rcutils_error_handling,
  rcutils/snprintf, rcutils/testing/fault_injection, rcutils/types/array_list,
  rcutils/types/char_array, rcutils/types/hash_map, rcutils/types/string_array,
  rcutils/qsort, rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/events_statuses/liveliness_changed,
  rmw/events_statuses/liveliness_lost, rmw/events_statuses/message_lost,
  rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/serialized_message,
  rmw/subscription_content_filter_options, rmw/time as rmw_time,
  ./visibility_control, ./init_options


type

  rcl_guard_condition_impl_t* {.importc: "rcl_guard_condition_impl_t",
                                header: "rcl/guard_condition.h", bycopy.} = object ##
                              ##  Internal rcl guard condition implementation struct.


  rcl_guard_condition_t* {.importc: "rcl_guard_condition_t",
                           header: "rcl/guard_condition.h", bycopy.} = object ##
                              ##  Handle for a rcl guard condition.
    context* {.importc: "context".}: ptr rcl_context_t ##
                              ##  Context associated with this guard condition.
    impl* {.importc: "impl".}: ptr rcl_guard_condition_impl_t ##
                              ##  Pointer to the guard condition implementation


  rcl_guard_condition_options_t* {.importc: "rcl_guard_condition_options_t",
                                   header: "rcl/guard_condition.h", bycopy.} = object ##
                              ##  Options available for a rcl guard condition.
    allocator* {.importc: "allocator".}: rcl_allocator_t ##
                              ##  Custom allocator for the guard condition, used for internal allocations.




proc rcl_get_zero_initialized_guard_condition*(): rcl_guard_condition_t {.
    importc: "rcl_get_zero_initialized_guard_condition",
    header: "rcl/guard_condition.h".}
  ##  Return a rcl_guard_condition_t struct with members set to `NULL`.

proc rcl_guard_condition_init*(guard_condition: ptr rcl_guard_condition_t;
                               context: ptr rcl_context_t;
                               options: rcl_guard_condition_options_t): rcl_ret_t {.
    importc: "rcl_guard_condition_init", header: "rcl/guard_condition.h".}
  ##
                              ##  Initialize a rcl guard_condition.
                              ##
                              ##  After calling this function on a rcl_guard_condition_t, it can be passed to
                              ##  rcl_wait() and then concurrently it can be triggered to wake-up rcl_wait().
                              ##
                              ##  Expected usage:
                              ##
                              ##  ```c
                              ##  #include <rcl/rcl.h>
                              ##
                              ##  // ... error handling
                              ##  rcl_guard_condition_t guard_condition = rcl_get_zero_initialized_guard_condition();
                              ##  // ... customize guard condition options
                              ##  rcl_ret_t ret = rcl_guard_condition_init(
                              ##    &guard_condition, context, rcl_guard_condition_get_default_options());
                              ##  // ... error handling, and on shutdown do deinitialization:
                              ##  ret = rcl_guard_condition_fini(&guard_condition);
                              ##  // ... error handling for rcl_guard_condition_fini()
                              ##  ```
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[inout] guard_condition preallocated guard_condition structure
                              ##  \param[in] context the context instance with which the guard condition
                              ##    should be associated
                              ##  \param[in] options the guard_condition's options
                              ##  \return #RCL_RET_OK if guard_condition was initialized successfully, or
                              ##  \return #RCL_RET_ALREADY_INIT if the guard condition is already initialized, or
                              ##  \return #RCL_RET_NOT_INIT if the given context is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_guard_condition_init_from_rmw*(guard_condition: ptr rcl_guard_condition_t;
    rmw_guard_condition: ptr rmw_guard_condition_t; context: ptr rcl_context_t;
                                        options: rcl_guard_condition_options_t): rcl_ret_t {.
    importc: "rcl_guard_condition_init_from_rmw",
    header: "rcl/guard_condition.h".}
  ##  Same as rcl_guard_condition_init(), but reusing an existing rmw handle.
                                     ##
                                     ##  In addition to the documentation for rcl_guard_condition_init(), the
                                     ##  `rmw_guard_condition` parameter must not be `NULL` and must point to a valid
                                     ##  rmw guard condition.
                                     ##
                                     ##  Also the life time of the rcl guard condition is tied to the life time of
                                     ##  the rmw guard condition.
                                     ##  So if the rmw guard condition is destroyed before the rcl guard condition,
                                     ##  the rcl guard condition becomes invalid.
                                     ##
                                     ##  Similarly if the resulting rcl guard condition is fini'ed before the rmw
                                     ##  guard condition, then the rmw guard condition is no longer valid.
                                     ##
                                     ##  <hr>
                                     ##  Attribute          | Adherence
                                     ##  ------------------ | -------------
                                     ##  Allocates Memory   | Yes
                                     ##  Thread-Safe        | No
                                     ##  Uses Atomics       | No
                                     ##  Lock-Free          | Yes
                                     ##
                                     ##  \param[inout] guard_condition preallocated guard_condition structure
                                     ##  \param[in] rmw_guard_condition existing rmw guard condition to reuse
                                     ##  \param[in] context the context instance with which the rmw guard condition
                                     ##    was initialized with, i.e. the rmw context inside rcl context needs to
                                     ##    match rmw context in rmw guard condition
                                     ##  \param[in] options the guard_condition's options
                                     ##  \return #RCL_RET_OK if guard_condition was initialized successfully, or
                                     ##  \return #RCL_RET_ALREADY_INIT if the guard condition is already initialized, or
                                     ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                                     ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                                     ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                                     ##

proc rcl_guard_condition_fini*(guard_condition: ptr rcl_guard_condition_t): rcl_ret_t {.
    importc: "rcl_guard_condition_fini", header: "rcl/guard_condition.h".}
  ##
                              ##  Finalize a rcl_guard_condition_t.
                              ##
                              ##  After calling, calls to rcl_trigger_guard_condition() will fail when using
                              ##  this guard condition.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] specifically not thread-safe with rcl_trigger_guard_condition()</i>
                              ##
                              ##  \param[inout] guard_condition handle to the guard_condition to be finalized
                              ##  \return #RCL_RET_OK if guard_condition was finalized successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_guard_condition_get_default_options*(): rcl_guard_condition_options_t {.
    importc: "rcl_guard_condition_get_default_options",
    header: "rcl/guard_condition.h".}
  ##  Return the default options in a rcl_guard_condition_options_t struct.
                                     ##
                                     ##  The defaults are:
                                     ##
                                     ##  - allocator = rcl_get_default_allocator()
                                     ##
                                     ##  \return the default options in an rcl_guard_condition_options_t struct.
                                     ##

proc rcl_trigger_guard_condition*(guard_condition: ptr rcl_guard_condition_t): rcl_ret_t {.
    importc: "rcl_trigger_guard_condition", header: "rcl/guard_condition.h".}
  ##
                              ##  Trigger a rcl guard condition.
                              ##
                              ##  This function can fail, and return RCL_RET_INVALID_ARGUMENT, if the:
                              ##    - guard condition is `NULL`
                              ##    - guard condition is invalid (never called init or called fini)
                              ##
                              ##  A guard condition can be triggered from any thread.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] it can be called concurrently with itself, even on the same guard condition</i>
                              ##
                              ##  \param[in] guard_condition handle to the guard_condition to be triggered
                              ##  \return #RCL_RET_OK if the guard condition was triggered, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_guard_condition_get_options*(guard_condition: ptr rcl_guard_condition_t): ptr rcl_guard_condition_options_t {.
    importc: "rcl_guard_condition_get_options", header: "rcl/guard_condition.h".}
  ##
                              ##  Return the guard condition options.
                              ##
                              ##  Returned is a pointer to the internally held rcl_guard_condition_options_t.
                              ##  This function can fail, and therefore return `NULL`, if the:
                              ##    - guard_condition is `NULL`
                              ##    - guard_condition is invalid (never called init, called fini, or invalid node)
                              ##
                              ##  The returned pointer is made invalid if the guard condition is finalized.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] guard_condition pointer to the rcl guard_condition
                              ##  \return rcl guard condition options if successful, otherwise `NULL`
                              ##

proc rcl_guard_condition_get_rmw_handle*(
    guard_condition: ptr rcl_guard_condition_t): ptr rmw_guard_condition_t {.
    importc: "rcl_guard_condition_get_rmw_handle",
    header: "rcl/guard_condition.h".}
  ##  Return the rmw guard condition handle.
                                     ##
                                     ##  The handle returned is a pointer to the internally held rmw handle.
                                     ##  This function can fail, and therefore return `NULL`, if the:
                                     ##    - guard_condition is `NULL`
                                     ##    - guard_condition is invalid (never called init, called fini, or invalid node)
                                     ##
                                     ##  The returned handle is made invalid if the guard condition is finalized or
                                     ##  if rcl_shutdown() is called.
                                     ##  The returned handle is not guaranteed to be valid for the life time of the
                                     ##  guard condition as it may be finalized and recreated itself.
                                     ##  Therefore it is recommended to get the handle from the guard condition using
                                     ##  this function each time it is needed and avoid use of the handle
                                     ##  concurrently with functions that might change it.
                                     ##
                                     ##  <hr>
                                     ##  Attribute          | Adherence
                                     ##  ------------------ | -------------
                                     ##  Allocates Memory   | No
                                     ##  Thread-Safe        | No
                                     ##  Uses Atomics       | No
                                     ##  Lock-Free          | Yes
                                     ##
                                     ##  \param[in] guard_condition pointer to the rcl guard_condition
                                     ##  \return rmw guard condition handle if successful, otherwise `NULL`
                                     ## 