##  Copyright 2018 Open Source Robotics Foundation, Inc.
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
  rmw/init, rmw/init, rmw/init_options, rcutils/allocator, rcutils/allocator,
  rcutils/allocator, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, rcutils/macros, rcutils/allocator, rcutils/types/rcutils_ret,
  rcutils/allocator, rcutils/visibility_control,
  rcutils/visibility_control_macros, rcutils/visibility_control_macros,
  rcutils/visibility_control, rcutils/allocator, rmw/init_options,
  rmw/domain_id, rmw/init_options, rmw/localhost, rmw/visibility_control,
  rmw/visibility_control, rmw/localhost, rmw/init_options, rmw/macros,
  rmw/init_options, rmw/ret_types, rmw/init_options, rmw/security_options,
  rmw/security_options, rmw/init_options, rmw/init, ./allocator, ./macros,
  ./types, rmw/types, rmw/types, rcutils/logging, rcutils/logging,
  rcutils/logging, rcutils/error_handling, rcutils/error_handling,
  rcutils/error_handling, rcutils/error_handling, rcutils/error_handling,
  rcutils/error_handling, rcutils/snprintf, rcutils/snprintf,
  rcutils/error_handling, rcutils/testing/fault_injection,
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
  rmw/events_statuses/events_statuses, rmw/types, rmw/serialized_message,
  rmw/types, rmw/subscription_content_filter_options,
  rmw/subscription_content_filter_options, rmw/types, rmw/time, rmw/time,
  rmw/types, ./types, ./visibility_control, ./visibility_control

type

  rcl_init_options_impl_t* = rcl_init_options_impl_s

  rcl_init_options_t* {.importc: "rcl_init_options_t",
                        header: "rcl/init_options.h", bycopy.} = object ##
                              ##  Encapsulation of init options and implementation defined init options.
    impl* {.importc: "impl".}: ptr rcl_init_options_impl_t ##
                              ##  Implementation specific pointer.



proc rcl_get_zero_initialized_init_options*(): rcl_init_options_t {.
    importc: "rcl_get_zero_initialized_init_options",
    header: "rcl/init_options.h".}
  ##  Return a zero initialized rcl_init_options_t struct.

proc rcl_init_options_init*(init_options: ptr rcl_init_options_t;
                            allocator: rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_init_options_init", header: "rcl/init_options.h".}
  ##
                              ##  Initialize given init_options with the default values and implementation specific values.
                              ##
                              ##  The given allocator is used, if required, during setup of the init options,
                              ##  but is also used during initialization.
                              ##
                              ##  In either case the given allocator is stored in the returned init options.
                              ##
                              ##  The `impl` pointer should not be changed manually.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[inout] init_options object to be setup
                              ##  \param[in] allocator to be used during setup and during initialization
                              ##  \return #RCL_RET_OK if setup is successful, or
                              ##  \return #RCL_RET_ALREADY_INIT if init_options has already be initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_init_options_copy*(src: ptr rcl_init_options_t;
                            dst: ptr rcl_init_options_t): rcl_ret_t {.
    importc: "rcl_init_options_copy", header: "rcl/init_options.h".}
  ##
                              ##  Copy the given source init_options to the destination init_options.
                              ##
                              ##  The allocator from the source is used for any allocations and stored in the
                              ##  destination.
                              ##
                              ##  The destination should either be zero initialized with
                              ##  rcl_get_zero_initialized_init_options() or should have had
                              ##  rcl_init_options_fini() called on it.
                              ##  Giving an already initialized init options for the destination will result
                              ##  in a failure with return code #RCL_RET_ALREADY_INIT.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] src rcl_init_options_t object to be copied from
                              ##  \param[out] dst rcl_init_options_t object to be copied into
                              ##  \return #RCL_RET_OK if the copy is successful, or
                              ##  \return #RCL_RET_ALREADY_INIT if the dst has already be initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_init_options_fini*(init_options: ptr rcl_init_options_t): rcl_ret_t {.
    importc: "rcl_init_options_fini", header: "rcl/init_options.h".}
  ##
                              ##  Finalize the given init_options.
                              ##
                              ##  The given init_options must be non-`NULL` and valid, i.e. had
                              ##  rcl_init_options_init() called on it but not this function yet.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[inout] init_options object to be setup
                              ##  \return #RCL_RET_OK if setup is successful, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_init_options_get_domain_id*(init_options: ptr rcl_init_options_t;
                                     domain_id: ptr csize_t): rcl_ret_t {.
    importc: "rcl_init_options_get_domain_id", header: "rcl/init_options.h".}
  ##
                              ##  Return the domain_id stored in the init options.
                              ##
                              ##  Get the domain id from the specified rcl_init_options_t object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] init_options object from which the domain id should be retrieved.
                              ##  \param[out] domain_id domain id to be set in init_options object.
                              ##  \return #RCL_RET_OK if successful, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid.
                              ##

proc rcl_init_options_set_domain_id*(init_options: ptr rcl_init_options_t;
                                     domain_id: csize_t): rcl_ret_t {.
    importc: "rcl_init_options_set_domain_id", header: "rcl/init_options.h".}
  ##
                              ##  Set a domain id in the init options provided.
                              ##
                              ##  Store the domain id in the specified init_options object.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] init_options objects in which to set the specified domain id.
                              ##  \param[in] domain_id domain id to be set in init_options object.
                              ##  \return #RCL_RET_OK if successful, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid.
                              ##

proc rcl_init_options_get_rmw_init_options*(init_options: ptr rcl_init_options_t): ptr rmw_init_options_t {.
    importc: "rcl_init_options_get_rmw_init_options",
    header: "rcl/init_options.h".}
  ##  Return the rmw init options which are stored internally.
                                  ##
                                  ##  This function can fail and return `NULL` if:
                                  ##    - init_options is NULL
                                  ##    - init_options is invalid, e.g. init_options->impl is NULL
                                  ##
                                  ##  If NULL is returned an error message will have been set.
                                  ##
                                  ##  <hr>
                                  ##  Attribute          | Adherence
                                  ##  ------------------ | -------------
                                  ##  Allocates Memory   | No
                                  ##  Thread-Safe        | No
                                  ##  Uses Atomics       | Yes
                                  ##  Lock-Free          | Yes
                                  ##
                                  ##  \param[in] init_options object from which the rmw init options should be retrieved
                                  ##  \return pointer to the the rcl init options, or
                                  ##  \return `NULL` if there was an error
                                  ##

proc rcl_init_options_get_allocator*(init_options: ptr rcl_init_options_t): ptr rcl_allocator_t {.
    importc: "rcl_init_options_get_allocator", header: "rcl/init_options.h".}
  ##
                              ##  Return the allocator stored in the init_options.
                              ##
                              ##  This function can fail and return `NULL` if:
                              ##    - init_options is NULL
                              ##    - init_options is invalid, e.g. init_options->impl is NULL
                              ##
                              ##  If NULL is returned an error message will have been set.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] init_options object from which the allocator should be retrieved
                              ##  \return pointer to the rcl allocator, or
                              ##  \return `NULL` if there was an error
                              ## 