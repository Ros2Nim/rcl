import rcutils/allocator as rcutils_allocator
import rcutils/time as rcutils_time
import rmw/types as rmw_types

##  Copyright 2018-2019 Open Source Robotics Foundation, Inc.
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
  ./error_handling, rcutils/error_handling as rcutils_error_handling,
  rcutils/snprintf, rcutils/testing/fault_injection, ./node, ./arguments,
  ./log_level, ./macros, ./types, rcutils/logging, rcutils/types/array_list,
  rcutils/types/char_array, rcutils/types/hash_map, rcutils/types/string_array,
  rcutils/qsort, rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/events_statuses/liveliness_changed,
  rmw/events_statuses/liveliness_lost, rmw/events_statuses/message_lost,
  rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init as rmw_init,
  rmw/init as rmw_init_options, rmw/domain_id as rmw_domain_id, rmw/localhost,
  rmw/ret_types, rmw/security_options, rmw/serialized_message,
  rmw/subscription_content_filter_options, rmw/time as rmw_time,
  ./visibility_control, ./context, ./init_options, ./guard_condition,
  ./node_options, ./domain_id

##  The default qos profile setting for topic /rosout
##
##  - depth = 1000
##  - durability = RMW_QOS_POLICY_DURABILITY_TRANSIENT_LOCAL
##  - lifespan = {10, 0}
##

let rcl_qos_profile_rosout_default* {.header: "rcl/logging_rosout.h".}: rmw_qos_profile_t


proc rcl_logging_rosout_init*(allocator: ptr rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_logging_rosout_init", header: "rcl/logging_rosout.h".}
  ##
                              ##  Initializes the rcl_logging_rosout features
                              ##
                              ##  Calling this will initialize the rcl_logging_rosout features. This function must be called
                              ##  before any other rcl_logging_rosout_* functions can be called.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] allocator The allocator used for metadata related to the rcl_logging_rosout features
                              ##  \return #RCL_RET_OK if the rcl_logging_rosout features are successfully initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_logging_rosout_fini*(): rcl_ret_t {.importc: "rcl_logging_rosout_fini",
    header: "rcl/logging_rosout.h".}
  ##  Uninitializes the rcl_logging_rosout features
                                    ##
                                    ##  Calling this will set the rcl_logging_rosout features into the an unitialized state that is
                                    ##  functionally the same as before rcl_logging_rosout_init was called.
                                    ##
                                    ##  <hr>
                                    ##  Attribute          | Adherence
                                    ##  ------------------ | -------------
                                    ##  Allocates Memory   | Yes
                                    ##  Thread-Safe        | No
                                    ##  Uses Atomics       | No
                                    ##  Lock-Free          | Yes
                                    ##
                                    ##  \return #RCL_RET_OK if the rcl_logging_rosout feature was successfully unitialized, or
                                    ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                                    ##

proc rcl_logging_rosout_init_publisher_for_node*(node: ptr rcl_node_t): rcl_ret_t {.
    importc: "rcl_logging_rosout_init_publisher_for_node",
    header: "rcl/logging_rosout.h".}
  ##  Creates a rosout publisher for a node and registers it to be used by the logging system
                                    ##
                                    ##  Calling this for an rcl_node_t will create a new publisher on that node that will be
                                    ##  used by the logging system to publish all log messages from that Node's logger.
                                    ##
                                    ##  If a publisher already exists for this node then a new publisher will NOT be created.
                                    ##
                                    ##  It is expected that after creating a rosout publisher with this function
                                    ##  rcl_logging_destroy_rosout_publisher_for_node() will be called for the node to cleanup
                                    ##  the publisher while the Node is still valid.
                                    ##
                                    ##
                                    ##  <hr>
                                    ##  Attribute          | Adherence
                                    ##  ------------------ | -------------
                                    ##  Allocates Memory   | Yes
                                    ##  Thread-Safe        | No
                                    ##  Uses Atomics       | No
                                    ##  Lock-Free          | Yes
                                    ##
                                    ##  \param[in] node a valid rcl_node_t that the publisher will be created on
                                    ##  \return #RCL_RET_OK if the logging publisher was created successfully, or
                                    ##  \return #RCL_RET_NODE_INVALID if the argument is invalid, or
                                    ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                                    ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                                    ##

proc rcl_logging_rosout_fini_publisher_for_node*(node: ptr rcl_node_t): rcl_ret_t {.
    importc: "rcl_logging_rosout_fini_publisher_for_node",
    header: "rcl/logging_rosout.h".}
  ##  Deregisters a rosout publisher for a node and cleans up allocated resources
                                    ##
                                    ##  Calling this for an rcl_node_t will destroy the rosout publisher on that node and remove it from
                                    ##  the logging system so that no more Log messages are published to this function.
                                    ##
                                    ##
                                    ##  <hr>
                                    ##  Attribute          | Adherence
                                    ##  ------------------ | -------------
                                    ##  Allocates Memory   | Yes
                                    ##  Thread-Safe        | No
                                    ##  Uses Atomics       | No
                                    ##  Lock-Free          | Yes
                                    ##
                                    ##  \param[in] node a valid rcl_node_t that the publisher will be created on
                                    ##  \return #RCL_RET_OK if the logging publisher was finalized successfully, or
                                    ##  \return #RCL_RET_NODE_INVALID if any arguments are invalid, or
                                    ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                                    ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                                    ##

proc rcl_logging_rosout_output_handler*(location: ptr rcutils_log_location_t;
                                        severity: cint; name: cstring;
                                        timestamp: rcutils_time_point_value_t;
                                        format: cstring;
                                        args: ptr varargs[pointer]) {.
    importc: "rcl_logging_rosout_output_handler", header: "rcl/logging_rosout.h".}
  ##
                              ##  The output handler outputs log messages to rosout topics.
                              ##
                              ##  When called with a logger name and log message this function will attempt to
                              ##  find a rosout publisher correlated with the logger name and publish a Log
                              ##  message out via that publisher. If there is no publisher directly correlated
                              ##  with the logger then nothing will be done.
                              ##
                              ##  This function is meant to be registered with the logging functions for
                              ##  rcutils, and shouldn't be used outside of that context.
                              ##  Additionally, arguments like args should be non-null and properly initialized
                              ##  otherwise it is undefined behavior.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] location The pointer to the location struct or NULL
                              ##  \param[in] severity The severity level
                              ##  \param[in] name The name of the logger, must be null terminated c string
                              ##  \param[in] timestamp The timestamp for when the log message was made
                              ##  \param[in] format The list of arguments to insert into the formatted log message
                              ##  \param[in] args argument for the string format
                              ## 