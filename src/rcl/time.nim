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
  ./allocator, rcutils/allocator, rcutils/macros, rcutils/types/rcutils_ret,
  rcutils/visibility_control, rcutils/visibility_control_macros, ./macros,
  ./types, rmw/types, rcutils/logging, rcutils/error_handling, rcutils/snprintf,
  rcutils/testing/fault_injection, rcutils/time, rcutils/types,
  rcutils/types/array_list, rcutils/types/char_array, rcutils/types/hash_map,
  rcutils/types/string_array, rcutils/qsort, rcutils/types/string_map,
  rcutils/types/uint8_array, rmw/events_statuses/events_statuses,
  rmw/events_statuses/incompatible_qos, rmw/qos_policy_kind,
  rmw/visibility_control, rmw/events_statuses/liveliness_changed,
  rmw/events_statuses/liveliness_lost, rmw/events_statuses/message_lost,
  rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/macros, rmw/ret_types, rmw/security_options,
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time,
  ./visibility_control


type

  rcl_time_point_value_t* = rcutils_time_point_value_t ##
                              ##  A single point in time, measured in nanoseconds since the Unix epoch.

  rcl_duration_value_t* = rcutils_duration_value_t ##
                              ##  A duration of time, measured in nanoseconds.

  rcl_clock_type_t* {.size: sizeof(cint).} = enum ##
                              ##  Time source type, used to indicate the source of a time measurement.
                              ##
                              ##  RCL_ROS_TIME will report the latest value reported by a ROS time source, or
                              ##  if a ROS time source is not active it reports the same as RCL_SYSTEM_TIME.
                              ##  For more information about ROS time sources, refer to the design document:
                              ##  http://design.ros2.org/articles/clock_and_time.html
                              ##
                              ##  RCL_SYSTEM_TIME reports the same value as the system clock.
                              ##
                              ##  RCL_STEADY_TIME reports a value from a monotonically increasing clock.
                              ##
    RCL_CLOCK_UNINITIALIZED = 0, ##  Use ROS time
    RCL_ROS_TIME,           ##  Use system time
    RCL_SYSTEM_TIME,        ##  Use a steady clock time
    RCL_STEADY_TIME

  rcl_duration_t* {.importc: "rcl_duration_t", header: "rcl/time.h", bycopy.} = object ##
                              ##  A duration of time, measured in nanoseconds and its source.
    nanoseconds* {.importc: "nanoseconds".}: rcl_duration_value_t ##
                              ##  Duration in nanoseconds and its source.


  rcl_clock_change_t* {.size: sizeof(cint).} = enum ##
                              ##  Enumeration to describe the type of time jump.
    RCL_ROS_TIME_NO_CHANGE = 1, ##  The source switched to ROS_TIME from SYSTEM_TIME.
    RCL_ROS_TIME_ACTIVATED = 2, ##  The source switched to SYSTEM_TIME from ROS_TIME.
    RCL_ROS_TIME_DEACTIVATED = 3, ##  The source before and after the jump is SYSTEM_TIME.
    RCL_SYSTEM_TIME_NO_CHANGE = 4

  rcl_time_jump_t* {.importc: "rcl_time_jump_t", header: "rcl/time.h", bycopy.} = object ##
                              ##  Struct to describe a jump in time.
    clock_change* {.importc: "clock_change".}: rcl_clock_change_t ##
                              ##  Indicate whether or not the source of time changed.
    delta* {.importc: "delta".}: rcl_duration_t ##  The new time minus the last time before the jump.


  rcl_jump_callback_t* = proc (time_jump: ptr rcl_time_jump_t;
                               before_jump: _Bool; user_data: pointer) ##
                              ##  Signature of a time jump callback.
                              ##  \param[in] time_jump A description of the jump in time.
                              ##  \param[in] before_jump Every jump callback is called twice: once before the clock changes and
                              ##  once after. This is true the first call and false the second.
                              ##  \param[in] user_data A pointer given at callback registration which is passed to the callback.

  rcl_jump_threshold_t* {.importc: "rcl_jump_threshold_t", header: "rcl/time.h",
                          bycopy.} = object ##  Describe the prerequisites for calling a time jump callback.
    on_clock_change* {.importc: "on_clock_change".}: _Bool ##
                              ##  True to call callback when the clock type changes.
    min_forward* {.importc: "min_forward".}: rcl_duration_t ##
                              ##  A positive duration indicating the minimum jump forwards to be considered exceeded, or zero
                              ##  to disable.
    min_backward* {.importc: "min_backward".}: rcl_duration_t ##
                              ##  A negative duration indicating the minimum jump backwards to be considered exceeded, or zero
                              ##  to disable.


  rcl_jump_callback_info_t* {.importc: "rcl_jump_callback_info_t",
                              header: "rcl/time.h", bycopy.} = object ##
                              ##  Struct to describe an added callback.
    callback* {.importc: "callback".}: rcl_jump_callback_t ##
                              ##  Callback to fucntion.
    threshold* {.importc: "threshold".}: rcl_jump_threshold_t ##
                              ##  Threshold to decide when to call the callback.
    user_data* {.importc: "user_data".}: pointer ##  Pointer passed to the callback.


  rcl_clock_t* {.importc: "rcl_clock_t", header: "rcl/time.h", bycopy.} = object ##
                              ##  Encapsulation of a time source.
    `type`* {.importc: "type".}: rcl_clock_type_t ##  Clock type
    jump_callbacks* {.importc: "jump_callbacks".}: ptr rcl_jump_callback_info_t ##
                              ##  An array of added jump callbacks.
    num_jump_callbacks* {.importc: "num_jump_callbacks".}: csize_t ##
                              ##  Number of callbacks in jump_callbacks.
    get_now* {.importc: "get_now".}: proc (data: pointer;
        now: ptr rcl_time_point_value_t): rcl_ret_t ##
                              ##  Pointer to get_now function
    data* {.importc: "data".}: pointer ##  void (*set_now) (rcl_time_point_value_t);
                                       ##  Clock storage
    allocator* {.importc: "allocator".}: rcl_allocator_t ##
                              ##  Custom allocator used for internal allocations.


  rcl_time_point_t* {.importc: "rcl_time_point_t", header: "rcl/time.h", bycopy.} = object ##
                              ##  A single point in time, measured in nanoseconds, the reference point is based on the source.
    nanoseconds* {.importc: "nanoseconds".}: rcl_time_point_value_t ##
                              ##  Nanoseconds of the point in time
    clock_type* {.importc: "clock_type".}: rcl_clock_type_t ##
                              ##  Clock type of the point in time


const
  RCL_S_TO_NS* = RCUTILS_S_TO_NS ##  Convenience macro to convert seconds to nanoseconds.
  RCL_MS_TO_NS* = RCUTILS_MS_TO_NS ##  Convenience macro to convert milliseconds to nanoseconds.
  RCL_US_TO_NS* = RCUTILS_US_TO_NS ##  Convenience macro to convert microseconds to nanoseconds.
  RCL_NS_TO_S* = RCUTILS_NS_TO_S ##  Convenience macro to convert nanoseconds to seconds.
  RCL_NS_TO_MS* = RCUTILS_NS_TO_MS ##  Convenience macro to convert nanoseconds to milliseconds.
  RCL_NS_TO_US* = RCUTILS_NS_TO_US ##  Convenience macro to convert nanoseconds to microseconds.


proc rcl_clock_time_started*(clock: ptr rcl_clock_t): _Bool {.
    importc: "rcl_clock_time_started", header: "rcl/time.h".}
  ##
                              ##  typedef struct rcl_rate_t
                              ##  {
                              ##    rcl_time_point_value_t trigger_time;
                              ##    int64_t period;
                              ##    rcl_clock_type_t clock;;
                              ##  } rcl_rate_t;
                              ##  TODO(tfoote) integrate rate and timer implementations
                              ##  Check if the clock has started.
                              ##
                              ##  This function returns true if the clock contains a time point value
                              ##  that is non-zero.
                              ##  Note that if data is uninitialized it may give a false positive.
                              ##
                              ##  This function is primarily used to check if a clock using ROS time
                              ##  has started. This is because it is possible that a simulator might be
                              ##  initialized paused, causing ROS time to be 0 until it is unpaused.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] clock the handle to the clock which is being queried
                              ##  \return true if the clock has started, otherwise return false.
                              ##

proc rcl_clock_valid*(clock: ptr rcl_clock_t): _Bool {.
    importc: "rcl_clock_valid", header: "rcl/time.h".}
  ##
                              ##  Check if the clock has valid values.
                              ##
                              ##  This function returns true if the time source appears to be valid.
                              ##  It will check that the type is not uninitialized, and that pointers
                              ##  are not invalid.
                              ##  Note that if data is uninitialized it may give a false positive.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] clock the handle to the clock which is being queried
                              ##  \return true if the source is believed to be valid, otherwise return false.
                              ##

proc rcl_clock_init*(clock_type: rcl_clock_type_t; clock: ptr rcl_clock_t;
                     allocator: ptr rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_clock_init", header: "rcl/time.h".}
  ##
                              ##  Initialize a clock based on the passed type.
                              ##
                              ##  This will allocate all necessary internal structures, and initialize variables.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes [1]
                              ##  Thread-Safe        | No [2]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] If `clock_type` is #RCL_ROS_TIME</i>
                              ##  <i>[2] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object.</i>
                              ##
                              ##  \param[in] clock_type the type identifying the time source to provide
                              ##  \param[in] clock the handle to the clock which is being initialized
                              ##  \param[in] allocator The allocator to use for allocations
                              ##  \return #RCL_RET_OK if the time source was successfully initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_clock_fini*(clock: ptr rcl_clock_t): rcl_ret_t {.
    importc: "rcl_clock_fini", header: "rcl/time.h".}
  ##
                              ##  Finalize a clock.
                              ##
                              ##  This will deallocate all necessary internal structures, and clean up any variables.
                              ##  It can be combined with any of the init functions.
                              ##
                              ##  Passing a clock with type #RCL_CLOCK_UNINITIALIZED will result in
                              ##  #RCL_RET_INVALID_ARGUMENT being returned.
                              ##
                              ##  This function is not thread-safe with any other function operating on the same
                              ##  clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object associated with the
                              ##         `clock` object.</i>
                              ##
                              ##  \param[in] clock the handle to the clock which is being finalized
                              ##  \return #RCL_RET_OK if the time source was successfully finalized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_ros_clock_init*(clock: ptr rcl_clock_t; allocator: ptr rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_ros_clock_init", header: "rcl/time.h".}
  ##
                              ##  Initialize a clock as a #RCL_ROS_TIME time source.
                              ##
                              ##  This will allocate all necessary internal structures, and initialize variables.
                              ##  It is specifically setting up a #RCL_ROS_TIME time source.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[2] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object.</i>
                              ##
                              ##  \param[in] clock the handle to the clock which is being initialized
                              ##  \param[in] allocator The allocator to use for allocations
                              ##  \return #RCL_RET_OK if the time source was successfully initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_ros_clock_fini*(clock: ptr rcl_clock_t): rcl_ret_t {.
    importc: "rcl_ros_clock_fini", header: "rcl/time.h".}
  ##
                              ##  Finalize a clock as a #RCL_ROS_TIME time source.
                              ##
                              ##  This will deallocate all necessary internal structures, and clean up any variables.
                              ##  It is specifically setting up a #RCL_ROS_TIME time source. It is expected
                              ##  to be paired with the init fuction.
                              ##
                              ##  This function is not thread-safe with any other function operating on the same
                              ##  clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object associated with the
                              ##         `clock` object.</i>
                              ##
                              ##  \param[in] clock the handle to the clock which is being initialized
                              ##  \return #RCL_RET_OK if the time source was successfully finalized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_steady_clock_init*(clock: ptr rcl_clock_t;
                            allocator: ptr rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_steady_clock_init", header: "rcl/time.h".}
  ##
                              ##  Initialize a clock as a #RCL_STEADY_TIME time source.
                              ##
                              ##  This will allocate all necessary internal structures, and initialize variables.
                              ##  It is specifically setting up a #RCL_STEADY_TIME time source.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object.</i>
                              ##
                              ##  \param[in] clock the handle to the clock which is being initialized
                              ##  \param[in] allocator The allocator to use for allocations
                              ##  \return #RCL_RET_OK if the time source was successfully initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_steady_clock_fini*(clock: ptr rcl_clock_t): rcl_ret_t {.
    importc: "rcl_steady_clock_fini", header: "rcl/time.h".}
  ##
                              ##  Finalize a clock as a #RCL_STEADY_TIME time source.
                              ##
                              ##  Finalize the clock as a #RCL_STEADY_TIME time source.
                              ##
                              ##  This will deallocate all necessary internal structures, and clean up any variables.
                              ##  It is specifically setting up a steady time source. It is expected to be
                              ##  paired with the init fuction.
                              ##
                              ##  This function is not thread-safe with any other function operating on the same
                              ##  clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object associated with the
                              ##         `clock` object.</i>
                              ##
                              ##  \param[in] clock the handle to the clock which is being initialized
                              ##  \return #RCL_RET_OK if the time source was successfully finalized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_system_clock_init*(clock: ptr rcl_clock_t;
                            allocator: ptr rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_system_clock_init", header: "rcl/time.h".}
  ##
                              ##  Initialize a clock as a #RCL_SYSTEM_TIME time source.
                              ##
                              ##  Initialize the clock as a #RCL_SYSTEM_TIME time source.
                              ##
                              ##  This will allocate all necessary internal structures, and initialize variables.
                              ##  It is specifically setting up a system time source.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object associated with the
                              ##         `clock` object.</i>
                              ##
                              ##  \param[in] clock the handle to the clock which is being initialized
                              ##  \param[in] allocator The allocator to use for allocations
                              ##  \return #RCL_RET_OK if the time source was successfully initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_system_clock_fini*(clock: ptr rcl_clock_t): rcl_ret_t {.
    importc: "rcl_system_clock_fini", header: "rcl/time.h".}
  ##
                              ##  Finalize a clock as a #RCL_SYSTEM_TIME time source.
                              ##
                              ##  Finalize the clock as a #RCL_SYSTEM_TIME time source.
                              ##
                              ##  This will deallocate all necessary internal structures, and clean up any variables.
                              ##  It is specifically setting up a system time source. It is expected to be paired with
                              ##  the init fuction.
                              ##
                              ##  This function is not thread-safe with any function operating on the same clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object associated with the
                              ##         `clock` object.</i>
                              ##
                              ##  \param[in] clock the handle to the clock which is being initialized.
                              ##  \return #RCL_RET_OK if the time source was successfully finalized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_difference_times*(start: ptr rcl_time_point_t;
                           finish: ptr rcl_time_point_t;
                           delta: ptr rcl_duration_t): rcl_ret_t {.
    importc: "rcl_difference_times", header: "rcl/time.h".}
  ##
                              ##  Compute the difference between two time points
                              ##
                              ##  This function takes two time points and computes the duration between them.
                              ##  The two time points must be using the same time abstraction, and the
                              ##  resultant duration will also be of the same abstraction.
                              ##
                              ##  The value will be computed as duration = finish - start. If start is after
                              ##  finish the duration will be negative.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] start The time point for the start of the duration.
                              ##  \param[in] finish The time point for the end of the duration.
                              ##  \param[out] delta The duration between the start and finish.
                              ##  \return #RCL_RET_OK if the difference was computed successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_clock_get_now*(clock: ptr rcl_clock_t;
                        time_point_value: ptr rcl_time_point_value_t): rcl_ret_t {.
    importc: "rcl_clock_get_now", header: "rcl/time.h".}
  ##
                              ##  Fill the time point value with the current value of the associated clock.
                              ##
                              ##  This function will populate the data of the time_point_value object with the
                              ##  current value from it's associated time abstraction.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Yes [1]
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] If `clock` is of #RCL_ROS_TIME type.</i>
                              ##
                              ##  \param[in] clock The time source from which to set the value.
                              ##  \param[out] time_point_value The time_point value to populate.
                              ##  \return #RCL_RET_OK if the last call time was retrieved successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_enable_ros_time_override*(clock: ptr rcl_clock_t): rcl_ret_t {.
    importc: "rcl_enable_ros_time_override", header: "rcl/time.h".}
  ##
                              ##  Enable the ROS time abstraction override.
                              ##
                              ##  This method will enable the ROS time abstraction override values,
                              ##  such that the time source will report the set value instead of falling
                              ##  back to system time.
                              ##
                              ##  This function is not thread-safe with rcl_clock_add_jump_callback(),
                              ##  nor rcl_clock_remove_jump_callback() functions when used on the same
                              ##  clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence [1]
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [2]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Only applies to the function itself, as jump callbacks may not abide to it.</i>
                              ##  <i>[2] Function is reentrant, but concurrent calls on the same `clock` object are not safe.</i>
                              ##
                              ##  \param[in] clock The clock to enable.
                              ##  \return #RCL_RET_OK if the time source was enabled successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_disable_ros_time_override*(clock: ptr rcl_clock_t): rcl_ret_t {.
    importc: "rcl_disable_ros_time_override", header: "rcl/time.h".}
  ##
                              ##  Disable the ROS time abstraction override.
                              ##
                              ##  This method will disable the #RCL_ROS_TIME time abstraction override values,
                              ##  such that the time source will report the system time even if a custom
                              ##  value has been set.
                              ##
                              ##  This function is not thread-safe with rcl_clock_add_jump_callback(),
                              ##  nor rcl_clock_remove_jump_callback() functions when used on the same
                              ##  clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence [1]
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [2]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Only applies to the function itself, as jump callbacks may not abide to it.</i>
                              ##  <i>[2] Function is reentrant, but concurrent calls on the same `clock` object are not safe.</i>
                              ##
                              ##  \param[in] clock The clock to disable.
                              ##  \return #RCL_RET_OK if the time source was disabled successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_is_enabled_ros_time_override*(clock: ptr rcl_clock_t;
                                       is_enabled: ptr _Bool): rcl_ret_t {.
    importc: "rcl_is_enabled_ros_time_override", header: "rcl/time.h".}
  ##
                              ##  Check if the #RCL_ROS_TIME time source has the override enabled.
                              ##
                              ##  This will populate the is_enabled object to indicate if the
                              ##  time overide is enabled. If it is enabled, the set value will be returned.
                              ##  Otherwise this time source will return the equivalent to system time abstraction.
                              ##
                              ##  This function is not thread-safe with rcl_enable_ros_time_override() nor
                              ##  rcl_disable_ros_time_override() functions when used on the same clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.</i>
                              ##
                              ##  \param[in] clock The clock to query.
                              ##  \param[out] is_enabled Whether the override is enabled..
                              ##  \return #RCL_RET_OK if the time source was queried successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_set_ros_time_override*(clock: ptr rcl_clock_t;
                                time_value: rcl_time_point_value_t): rcl_ret_t {.
    importc: "rcl_set_ros_time_override", header: "rcl/time.h".}
  ##
                              ##  Set the current time for this #RCL_ROS_TIME time source.
                              ##
                              ##  This function will update the internal storage for the #RCL_ROS_TIME
                              ##  time source.
                              ##  If queried and override enabled the time source will return this value,
                              ##  otherwise it will return the system time.
                              ##
                              ##  This function is not thread-safe with rcl_clock_add_jump_callback(),
                              ##  nor rcl_clock_remove_jump_callback() functions when used on the same
                              ##  clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence [1]
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No [2]
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Only applies to the function itself, as jump callbacks may not abide to it.</i>
                              ##  <i>[2] Function is reentrant, but concurrent calls on the same `clock` object are not safe.</i>
                              ##
                              ##  \param[in] clock The clock to update.
                              ##  \param[in] time_value The new current time.
                              ##  \return #RCL_RET_OK if the time source was set successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occur.
                              ##

proc rcl_clock_add_jump_callback*(clock: ptr rcl_clock_t;
                                  threshold: rcl_jump_threshold_t;
                                  callback: rcl_jump_callback_t;
                                  user_data: pointer): rcl_ret_t {.
    importc: "rcl_clock_add_jump_callback", header: "rcl/time.h".}
  ##
                              ##  Add a callback to be called when a time jump exceeds a threshold.
                              ##
                              ##  The callback is called twice when the threshold is exceeded: once before the clock is
                              ##  updated, and once after.
                              ##  The user_data pointer is passed to the callback as the last argument.
                              ##  A callback and user_data pair must be unique among the callbacks added to a clock.
                              ##
                              ##  This function is not thread-safe with rcl_clock_remove_jump_callback(),
                              ##  rcl_enable_ros_time_override(), rcl_disable_ros_time_override() nor
                              ##  rcl_set_ros_time_override() functions when used on the same clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object associated with the
                              ##         `clock` object.</i>
                              ##
                              ##  \param[in] clock A clock to add a jump callback to.
                              ##  \param[in] threshold Criteria indicating when to call the callback.
                              ##  \param[in] callback A callback to call.
                              ##  \param[in] user_data A pointer to be passed to the callback.
                              ##  \return #RCL_RET_OK if the callback was added successfully, or
                              ##  \return #RCL_RET_BAD_ALLOC if a memory allocation failed, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR an unspecified error occurs.
                              ##

proc rcl_clock_remove_jump_callback*(clock: ptr rcl_clock_t;
                                     callback: rcl_jump_callback_t;
                                     user_data: pointer): rcl_ret_t {.
    importc: "rcl_clock_remove_jump_callback", header: "rcl/time.h".}
  ##
                              ##  Remove a previously added time jump callback.
                              ##
                              ##  This function is not thread-safe with rcl_clock_add_jump_callback()
                              ##  rcl_enable_ros_time_override(), rcl_disable_ros_time_override() nor
                              ##  rcl_set_ros_time_override() functions when used on the same clock object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  <i>[1] Function is reentrant, but concurrent calls on the same `clock` object are not safe.
                              ##         Thread-safety is also affected by that of the `allocator` object associated with the
                              ##         `clock` object.</i>
                              ##
                              ##  \param[in] clock The clock to remove a jump callback from.
                              ##  \param[in] callback The callback to call.
                              ##  \param[in] user_data A pointer to be passed to the callback.
                              ##  \return #RCL_RET_OK if the callback was added successfully, or
                              ##  \return #RCL_RET_BAD_ALLOC if a memory allocation failed, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR the callback was not found or an unspecified error occurs.
                              ## 