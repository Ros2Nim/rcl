import rcutils/allocator as rcutils_allocator
import rcutils/time as rcutils_time
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
  ./visibility_control, ./init_options, ./event_callback,
  rmw/event_callback_type, ./guard_condition, ./time, rmw/rmw,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/visibility_control as rosidl_runtime_c_visibility_control,
  rosidl_typesupport_interface/macros as rosidl_typesupport_interface_macros,
  rosidl_runtime_c/service_type_support_struct, rosidl_runtime_c/sequence_bound,
  rmw/event as rmw_event, rmw/message_sequence, rmw/publisher_options,
  rmw/qos_profiles, rmw/subscription_options


type

  rcl_timer_impl_t* {.importc: "rcl_timer_impl_t", header: "rcl/timer.h", bycopy.} = object


  rcl_timer_t* {.importc: "rcl_timer_t", header: "rcl/timer.h", bycopy.} = object ##
                              ##  Structure which encapsulates a ROS Timer.
    impl* {.importc: "impl".}: ptr rcl_timer_impl_t ##
                              ##  Private implementation pointer.


  rcl_timer_on_reset_callback_data_t* {.importc: "rcl_timer_on_reset_callback_data_t",
                                        header: "rcl/timer.h", bycopy.} = object ##
                              ##  Structure which encapsulates the on reset callback data
    on_reset_callback* {.importc: "on_reset_callback".}: rcl_event_callback_t
    user_data* {.importc: "user_data".}: pointer
    reset_counter* {.importc: "reset_counter".}: csize_t


  rcl_timer_callback_t* = proc (a1: ptr rcl_timer_t; a2: int64) ##
                              ##  User callback signature for timers.
                              ##
                              ##  The first argument the callback gets is a pointer to the timer.
                              ##  This can be used to cancel the timer, query the time until the next
                              ##  timer callback, exchange the callback with a different one, etc.
                              ##
                              ##  The only caveat is that the function rcl_timer_get_time_since_last_call()
                              ##  will return the time since just before this callback was called, not the
                              ##  previous call.
                              ##  Therefore the second argument given is the time since the previous callback
                              ##  was called, because that information is no longer accessible via the timer.
                              ##  The time since the last callback call is given in nanoseconds.
                              ##



proc rcl_get_zero_initialized_timer*(): rcl_timer_t {.
    importc: "rcl_get_zero_initialized_timer", header: "rcl/timer.h".}
  ##
                              ##  Return a zero initialized timer.

proc rcl_timer_init*(timer: ptr rcl_timer_t; clock: ptr rcl_clock_t;
                     context: ptr rcl_context_t; period: int64;
                     callback: rcl_timer_callback_t; allocator: rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_timer_init", header: "rcl/timer.h".}
  ##
                              ##  Initialize a timer.
                              ##
                              ##  A timer consists of a clock, a callback function and a period.
                              ##  A timer can be added to a wait set and waited on, such that the wait set
                              ##  will wake up when a timer is ready to be executed.
                              ##
                              ##  A timer simply holds state and does not automatically call callbacks.
                              ##  It does not create any threads, register interrupts, or consume signals.
                              ##  For blocking behavior it can be used in conjunction with a wait set and
                              ##  rcl_wait().
                              ##  When rcl_timer_is_ready() returns true, the timer must still be called
                              ##  explicitly using rcl_timer_call().
                              ##
                              ##  The timer handle must be a pointer to an allocated and zero initialized
                              ##  rcl_timer_t struct.
                              ##  Calling this function on an already initialized timer will fail.
                              ##  Calling this function on a timer struct which has been allocated but not
                              ##  zero initialized is undefined behavior.
                              ##
                              ##  The clock handle must be a pointer to an initialized rcl_clock_t struct.
                              ##  The life time of the clock must exceed the life time of the timer.
                              ##
                              ##  The period is a non-negative duration (rather an absolute time in the
                              ##  future).
                              ##  If the period is `0` then it will always be ready.
                              ##
                              ##  The callback is an optional argument.
                              ##  Valid inputs are either a pointer to the function callback, or `NULL` to
                              ##  indicate that no callback will be stored in rcl.
                              ##  If the callback is `NULL`, the caller client library is responsible for
                              ##  firing the timer callback.
                              ##  Else, it must be a function which returns void and takes two arguments,
                              ##  the first being a pointer to the associated timer, and the second a int64_t
                              ##  which is the time since the previous call, or since the timer was created
                              ##  if it is the first call to the callback.
                              ##
                              ##  Expected usage:
                              ##
                              ##  ```c
                              ##  #include <rcl/rcl.h>
                              ##
                              ##  void my_timer_callback(rcl_timer_t * timer, int64_t last_call_time)
                              ##  {
                              ##    // Do timer work...
                              ##    // Optionally reconfigure, cancel, or reset the timer...
                              ##  }
                              ##
                              ##  rcl_context_t * context;  // initialized previously by rcl_init()...
                              ##  rcl_clock_t clock;
                              ##  rcl_allocator_t allocator = rcl_get_default_allocator();
                              ##  rcl_ret_t ret = rcl_clock_init(RCL_STEADY_TIME, &clock, &allocator);
                              ##  // ... error handling
                              ##
                              ##  rcl_timer_t timer = rcl_get_zero_initialized_timer();
                              ##  ret = rcl_timer_init(
                              ##    &timer, &clock, context, RCL_MS_TO_NS(100), my_timer_callback, allocator);
                              ##  // ... error handling, use the timer with a wait set, or poll it manually, then cleanup
                              ##  ret = rcl_timer_fini(&timer);
                              ##  // ... error handling
                              ##  ```
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1][2][3]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_uintptr_t`</i>
                              ##
                              ##  <i>[2] if `atomic_is_lock_free()` returns true for `atomic_uint_least64_t`</i>
                              ##
                              ##  <i>[3] if `atomic_is_lock_free()` returns true for `atomic_bool`</i>
                              ##
                              ##  \param[inout] timer the timer handle to be initialized
                              ##  \param[in] clock the clock providing the current time
                              ##  \param[in] context the context that this timer is to be associated with
                              ##  \param[in] period the duration between calls to the callback in nanoseconds
                              ##  \param[in] callback the user defined function to be called every period
                              ##  \param[in] allocator the allocator to use for allocations
                              ##  \return #RCL_RET_OK if the timer was initialized successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ALREADY_INIT if the timer was already initialized, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_fini*(timer: ptr rcl_timer_t): rcl_ret_t {.
    importc: "rcl_timer_fini", header: "rcl/timer.h".}
  ##
                              ##  Finalize a timer.
                              ##
                              ##  This function will deallocate any memory and make the timer invalid.
                              ##
                              ##  A timer that is already invalid (zero initialized) or `NULL` will not fail.
                              ##
                              ##  This function is not thread-safe with any rcl_timer_* functions used on the
                              ##  same timer object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1][2][3]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_uintptr_t`</i>
                              ##
                              ##  <i>[2] if `atomic_is_lock_free()` returns true for `atomic_uint_least64_t`</i>
                              ##
                              ##  <i>[3] if `atomic_is_lock_free()` returns true for `atomic_bool`</i>
                              ##
                              ##  \param[inout] timer the handle to the timer to be finalized.
                              ##  \return #RCL_RET_OK if the timer was finalized successfully, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_call*(timer: ptr rcl_timer_t): rcl_ret_t {.
    importc: "rcl_timer_call", header: "rcl/timer.h".}
  ##
                              ##  Call the timer's callback and set the last call time.
                              ##
                              ##  This function will call the callback and change the last call time even if
                              ##  the timer's period has not yet elapsed.
                              ##  It is up to the calling code to make sure the period has elapsed by first
                              ##  calling rcl_timer_is_ready().
                              ##  If the callback pointer is `NULL` (either set in init or exchanged after
                              ##  initialized), no callback is fired.
                              ##  However, this function should still be called by the client library to
                              ##  update the state of the timer.
                              ##  The order of operations in this command are as follows:
                              ##
                              ##   - Ensure the timer has not been canceled.
                              ##   - Get the current time into a temporary rcl_steady_time_point_t.
                              ##   - Exchange the current time with the last call time of the timer.
                              ##   - Call the callback, passing this timer and the time since the last call.
                              ##   - Return after the callback has completed.
                              ##
                              ##  During the callback the timer can be canceled or have its period and/or
                              ##  callback modified.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes [1]
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [2]
                              ##  <i>[1] user callback might not be thread-safe</i>
                              ##
                              ##  <i>[2] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[inout] timer the handle to the timer to call
                              ##  \return #RCL_RET_OK if the timer was called successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer->impl is invalid, or
                              ##  \return #RCL_RET_TIMER_CANCELED if the timer has been canceled, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_clock*(timer: ptr rcl_timer_t; clock: ptr ptr rcl_clock_t): rcl_ret_t {.
    importc: "rcl_timer_clock", header: "rcl/timer.h".}
  ##
                              ##  Retrieve the clock of the timer.
                              ##
                              ##  This function retrieves the clock pointer and copies it into the given variable.
                              ##
                              ##  The clock argument must be a pointer to an already allocated rcl_clock_t *.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] timer the handle to the timer which is being queried
                              ##  \param[out] clock the rcl_clock_t * in which the clock is stored
                              ##  \return #RCL_RET_OK if the clock was retrieved successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer is invalid.
                              ##

proc rcl_timer_is_ready*(timer: ptr rcl_timer_t; is_ready: ptr bool): rcl_ret_t {.
    importc: "rcl_timer_is_ready", header: "rcl/timer.h".}
  ##
                              ##  Calculates whether or not the timer should be called.
                              ##
                              ##  The result is true if the time until next call is less than, or equal to, 0
                              ##  and the timer has not been canceled.
                              ##  Otherwise the result is false, indicating the timer should not be called.
                              ##
                              ##  The is_ready argument must point to an allocated bool object, as the result
                              ##  is copied into it.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[in] timer the handle to the timer which is being checked
                              ##  \param[out] is_ready the bool used to store the result of the calculation
                              ##  \return #RCL_RET_OK if the last call time was retrieved successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer->impl is invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_get_time_until_next_call*(timer: ptr rcl_timer_t;
    time_until_next_call: ptr int64): rcl_ret_t {.
    importc: "rcl_timer_get_time_until_next_call", header: "rcl/timer.h".}
  ##
                              ##  Calculate and retrieve the time until the next call in nanoseconds.
                              ##
                              ##  This function calculates the time until the next call by adding the timer's
                              ##  period to the last call time and subtracting that sum from the current time.
                              ##  The calculated time until the next call can be positive, indicating that it
                              ##  is not ready to be called as the period has not elapsed since the last call.
                              ##  The calculated time until the next call can also be 0 or negative,
                              ##  indicating that the period has elapsed since the last call and the timer
                              ##  should be called.
                              ##  A negative value indicates the timer call is overdue by that amount.
                              ##
                              ##  The `time_until_next_call` argument must point to an allocated int64_t, as
                              ##  the time until is copied into that instance.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[in] timer the handle to the timer that is being queried
                              ##  \param[out] time_until_next_call the output variable for the result
                              ##  \return #RCL_RET_OK if the timer until next call was successfully calculated, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer->impl is invalid, or
                              ##  \return #RCL_RET_TIMER_CANCELED if the timer is canceled, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_get_time_since_last_call*(timer: ptr rcl_timer_t;
    time_since_last_call: ptr int64): rcl_ret_t {.
    importc: "rcl_timer_get_time_since_last_call", header: "rcl/timer.h".}
  ##
                              ##  Retrieve the time since the previous call to rcl_timer_call() occurred.
                              ##
                              ##  This function calculates the time since the last call and copies it into
                              ##  the given int64_t variable.
                              ##
                              ##  Calling this function within a callback will not return the time since the
                              ##  previous call but instead the time since the current callback was called.
                              ##
                              ##  The time_since_last_call argument must be a pointer to an already allocated
                              ##  int64_t.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[in] timer the handle to the timer which is being queried
                              ##  \param[out] time_since_last_call the struct in which the time is stored
                              ##  \return #RCL_RET_OK if the last call time was retrieved successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer->impl is invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_get_period*(timer: ptr rcl_timer_t; period: ptr int64): rcl_ret_t {.
    importc: "rcl_timer_get_period", header: "rcl/timer.h".}
  ##
                              ##  Retrieve the period of the timer.
                              ##
                              ##  This function retrieves the period and copies it into the given variable.
                              ##
                              ##  The period argument must be a pointer to an already allocated int64_t.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[in] timer the handle to the timer which is being queried
                              ##  \param[out] period the int64_t in which the period is stored
                              ##  \return #RCL_RET_OK if the period was retrieved successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer->impl is invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_exchange_period*(timer: ptr rcl_timer_t; new_period: int64;
                                old_period: ptr int64): rcl_ret_t {.
    importc: "rcl_timer_exchange_period", header: "rcl/timer.h".}
  ##
                              ##  Exchange the period of the timer and return the previous period.
                              ##
                              ##  This function exchanges the period in the timer and copies the old one into
                              ##  the given variable.
                              ##
                              ##  Exchanging (changing) the period will not affect already waiting wait sets.
                              ##
                              ##  The old_period argument must be a pointer to an already allocated int64_t.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[in] timer the handle to the timer which is being modified
                              ##  \param[out] new_period the int64_t to exchange into the timer
                              ##  \param[out] old_period the int64_t in which the previous period is stored
                              ##  \return #RCL_RET_OK if the period was retrieved successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer->impl is invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_get_callback*(timer: ptr rcl_timer_t): rcl_timer_callback_t {.
    importc: "rcl_timer_get_callback", header: "rcl/timer.h".}
  ##
                              ##  Return the current timer callback.
                              ##
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - timer is `NULL`
                              ##    - timer has not been initialized (the implementation is invalid)
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[in] timer handle to the timer from the callback should be returned
                              ##  \return function pointer to the callback, or `NULL` if an error occurred
                              ##

proc rcl_timer_exchange_callback*(timer: ptr rcl_timer_t;
                                  new_callback: rcl_timer_callback_t): rcl_timer_callback_t {.
    importc: "rcl_timer_exchange_callback", header: "rcl/timer.h".}
  ##
                              ##  Exchange the current timer callback and return the current callback.
                              ##
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - timer is `NULL`
                              ##    - timer has not been initialized (the implementation is invalid)
                              ##
                              ##  This function can set callback to `NULL`, in which case the callback is
                              ##  ignored when rcl_timer_call is called.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[inout] timer handle to the timer from the callback should be exchanged
                              ##  \param[in] new_callback the callback to be exchanged into the timer
                              ##  \return function pointer to the old callback, or `NULL` if an error occurred
                              ##

proc rcl_timer_cancel*(timer: ptr rcl_timer_t): rcl_ret_t {.
    importc: "rcl_timer_cancel", header: "rcl/timer.h".}
  ##
                              ##  Cancel a timer.
                              ##
                              ##  When a timer is canceled, rcl_timer_is_ready() will return false for that
                              ##  timer, and rcl_timer_call() will fail with RCL_RET_TIMER_CANCELED.
                              ##
                              ##  A canceled timer can be reset with rcl_timer_reset(), and then used again.
                              ##  Calling this function on an already canceled timer will succeed.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[inout] timer the timer to be canceled
                              ##  \return #RCL_RET_OK if the timer was canceled successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer is invalid.
                              ##

proc rcl_timer_is_canceled*(timer: ptr rcl_timer_t; is_canceled: ptr bool): rcl_ret_t {.
    importc: "rcl_timer_is_canceled", header: "rcl/timer.h".}
  ##
                              ##  Retrieve the canceled state of a timer.
                              ##
                              ##  If the timer is canceled true will be stored in the is_canceled argument.
                              ##  Otherwise false will be stored in the is_canceled argument.
                              ##
                              ##  The is_canceled argument must point to an allocated bool, as the result is
                              ##  copied into this variable.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_bool`</i>
                              ##
                              ##  \param[in] timer the timer to be queried
                              ##  \param[out] is_canceled storage for the is canceled bool
                              ##  \return #RCL_RET_OK if the last call time was retrieved successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer->impl is invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_reset*(timer: ptr rcl_timer_t): rcl_ret_t {.
    importc: "rcl_timer_reset", header: "rcl/timer.h".}
  ##
                              ##  Reset a timer.
                              ##
                              ##  This function can be called on a timer, canceled or not.
                              ##  For all timers it will reset the last call time to now.
                              ##  For canceled timers it will additionally make the timer not canceled.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_int_least64_t`</i>
                              ##
                              ##  \param[inout] timer the timer to be reset
                              ##  \return #RCL_RET_OK if the timer was reset successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMER_INVALID if the timer is invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_timer_get_allocator*(timer: ptr rcl_timer_t): ptr rcl_allocator_t {.
    importc: "rcl_timer_get_allocator", header: "rcl/timer.h".}
  ##
                              ##  Return the allocator for the timer.
                              ##
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - timer is `NULL`
                              ##    - timer has not been initialized (the implementation is invalid)
                              ##
                              ##  The returned pointer is only valid as long as the timer object is valid.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[inout] timer handle to the timer object
                              ##  \return pointer to the allocator, or `NULL` if an error occurred
                              ##

proc rcl_timer_get_guard_condition*(timer: ptr rcl_timer_t): ptr rcl_guard_condition_t {.
    importc: "rcl_timer_get_guard_condition", header: "rcl/timer.h".}
  ##
                              ##  Retrieve a guard condition used by the timer to wake the waitset when using ROSTime.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] timer the timer to be queried
                              ##  \return `NULL` if the timer is invalid or does not have a guard condition, or
                              ##  \return a guard condition pointer.
                              ##

proc rcl_timer_set_on_reset_callback*(timer: ptr rcl_timer_t;
                                      on_reset_callback: rcl_event_callback_t;
                                      user_data: pointer): rcl_ret_t {.
    importc: "rcl_timer_set_on_reset_callback", header: "rcl/timer.h".}
  ##
                              ##  Set the on reset callback function for the timer.
                              ##
                              ##  This API sets the callback function to be called whenever the
                              ##  timer is reset.
                              ##  If the timer has already been reset, the callback will be called.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | No
                              ##
                              ##  \param[in] timer The handle to the timer on which to set the callback
                              ##  \param[in] on_reset_callback The callback to be called when timer is reset
                              ##  \param[in] user_data Given to the callback when called later, may be NULL
                              ##  \return `RCL_RET_OK` if successful, or
                              ##  \return `RCL_RET_INVALID_ARGUMENT` if `timer` is NULL
                              ## 