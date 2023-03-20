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
  ./allocator, rcutils/types/rcutils_ret, rcutils/visibility_control,
  rcutils/visibility_control_macros, ./macros, ./types, rmw/types,
  rcutils/logging, rcutils/error_handling, rcutils/snprintf,
  rcutils/testing/fault_injection, rcutils/time, rcutils/types/array_list,
  rcutils/types/char_array, rcutils/types/hash_map, rcutils/types/string_array,
  rcutils/qsort, rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/visibility_control,
  rmw/events_statuses/liveliness_changed, rmw/events_statuses/liveliness_lost,
  rmw/events_statuses/message_lost, rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/macros, rmw/ret_types, rmw/security_options,
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time,
  ./visibility_control


type

  rcl_log_severity_t* = RCUTILS_LOG_SEVERITY ##  typedef for RCUTILS_LOG_SEVERITY;

  rcl_logger_setting_t* {.importc: "rcl_logger_setting_t",
                          header: "rcl/log_level.h", bycopy.} = object ##
                              ##  A logger item to specify a name and a log level.
    name* {.importc: "name".}: cstring ##  Name for the logger.
    level* {.importc: "level".}: rcl_log_severity_t ##
                              ##  Minimum log level severity of the logger.


  rcl_log_levels_t* {.importc: "rcl_log_levels_t", header: "rcl/log_level.h",
                      bycopy.} = object ##  Hold default logger level and other logger setting.
    default_logger_level* {.importc: "default_logger_level".}: rcl_log_severity_t ##
                              ##  Minimum default logger level severity.
    logger_settings* {.importc: "logger_settings".}: ptr rcl_logger_setting_t ##
                              ##  Array of logger setting.
    num_logger_settings* {.importc: "num_logger_settings".}: csize_t ##
                              ##  Number of logger settings.
    capacity_logger_settings* {.importc: "capacity_logger_settings".}: csize_t ##
                              ##  Capacity of logger settings.
    allocator* {.importc: "allocator".}: rcl_allocator_t ##
                              ##  Allocator used to allocate objects in this struct.




proc rcl_get_zero_initialized_log_levels*(): rcl_log_levels_t {.
    importc: "rcl_get_zero_initialized_log_levels", header: "rcl/log_level.h".}
  ##
                              ##  Return a rcl_log_levels_t struct with members initialized to zero value.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \return a rcl_log_levels_t struct with members initialized to zero value.
                              ##

proc rcl_log_levels_init*(log_levels: ptr rcl_log_levels_t;
                          allocator: ptr rcl_allocator_t; logger_count: csize_t): rcl_ret_t {.
    importc: "rcl_log_levels_init", header: "rcl/log_level.h".}
  ##
                              ##  Initialize a log levels structure.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] log_levels The structure to be initialized.
                              ##  \param[in] allocator Memory allocator to be used and assigned into log_levels.
                              ##  \param[in] logger_count Number of logger settings to be allocated.
                              ##   This reserves memory for logger_settings, but doesn't initialize it.
                              ##  \return #RCL_RET_OK if the structure was initialized successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if log_levels is NULL, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if log_levels contains initialized memory, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if allocator is invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed.
                              ##

proc rcl_log_levels_copy*(src: ptr rcl_log_levels_t; dst: ptr rcl_log_levels_t): rcl_ret_t {.
    importc: "rcl_log_levels_copy", header: "rcl/log_level.h".}
  ##
                              ##  Copy one log levels structure into another.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] src The structure to be copied.
                              ##   Its allocator is used to copy memory into the new structure.
                              ##  \param[out] dst A log levels structure to be copied into.
                              ##  \return #RCL_RET_OK if the structure was copied successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if src is NULL, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if src allocator is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if dst is NULL, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if dst contains already allocated memory, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed.
                              ##

proc rcl_log_levels_fini*(log_levels: ptr rcl_log_levels_t): rcl_ret_t {.
    importc: "rcl_log_levels_fini", header: "rcl/log_level.h".}
  ##
                              ##  Reclaim resources held inside rcl_log_levels_t structure.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] log_levels The structure which its resources have to be deallocated.
                              ##  \return #RCL_RET_OK if the memory was successfully freed, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if log_levels is NULL, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if the log_levels allocator is invalid and the structure contains initialized memory.
                              ##

proc rcl_log_levels_shrink_to_size*(log_levels: ptr rcl_log_levels_t): rcl_ret_t {.
    importc: "rcl_log_levels_shrink_to_size", header: "rcl/log_level.h".}
  ##
                              ##  Shrink log levels structure.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] log_levels The structure to be shrunk.
                              ##  \return #RCL_RET_OK if the memory was successfully shrunk, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if log_levels is NULL or if its allocator is invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if reallocating memory failed.
                              ##

proc rcl_log_levels_add_logger_setting*(log_levels: ptr rcl_log_levels_t;
                                        logger_name: cstring;
                                        log_level: rcl_log_severity_t): rcl_ret_t {.
    importc: "rcl_log_levels_add_logger_setting", header: "rcl/log_level.h".}
  ##
                              ##  Add logger setting with a name and a level.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] log_levels The structure where to set the logger log level.
                              ##  \param[in] logger_name Name for the logger, a copy of it will be stored in the structure.
                              ##  \param[in] log_level Minimum log level severity to be set for logger_name.
                              ##  \return #RCL_RET_OK if add logger setting successfully, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if log_levels is NULL, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if log_levels was not initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if log_levels allocator is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if logger_name is NULL, or
                              ##  \return #RCL_RET_ERROR if the log_levels structure is already full.
                              ## 