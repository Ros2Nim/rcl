##  Copyright 2016-2017 Open Source Robotics Foundation, Inc.
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
  rmw/names_and_types, rcutils/types/rcutils_ret,
  rcutils/visibility_control_macros, rcutils/types/array_list,
  rcutils/types/char_array, rcutils/types/hash_map, rcutils/types/string_array,
  rcutils/error_handling, rcutils/snprintf, rcutils/testing/fault_injection,
  rcutils/qsort, rcutils/types/string_map, rcutils/types/uint8_array,
  rcutils/logging, rmw/events_statuses/events_statuses,
  rmw/events_statuses/incompatible_qos, rmw/qos_policy_kind,
  rmw/events_statuses/liveliness_changed, rmw/events_statuses/liveliness_lost,
  rmw/events_statuses/message_lost, rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/ret_types, rmw/security_options,
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time,
  rmw/get_topic_names_and_types, rmw/topic_endpoint_info_array,
  rmw/topic_endpoint_info, rosidl_runtime_c/service_type_support_struct,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/visibility_control, rosidl_typesupport_interface/macros,
  ./macros, ./client, ./event_callback, rmw/event_callback_type, ./node,
  ./allocator, ./arguments, ./log_level, ./types, ./visibility_control,
  ./context, ./init_options, ./guard_condition, ./node_options, ./domain_id


type

  rcl_names_and_types_t* = rmw_names_and_types_t ##  A structure that contains topic names and types.

  rcl_topic_endpoint_info_t* = rmw_topic_endpoint_info_t ##
                              ##  A structure that encapsulates the node name, node namespace,
                              ##  topic type, gid, and qos_profile or publishers and subscriptions
                              ##  for a topic.

  rcl_topic_endpoint_info_array_t* = rmw_topic_endpoint_info_array_t ##
                              ##  An array of topic endpoint information.

const
  rcl_get_zero_initialized_names_and_types* = rmw_get_zero_initialized_names_and_types ##
                              ##  Return a zero-initialized rcl_names_and_types_t structure.
  rcl_get_zero_initialized_topic_endpoint_info_array* = rmw_get_zero_initialized_topic_endpoint_info_array ##
                              ##  Return a zero-initialized rcl_topic_endpoint_info_t structure.
  rcl_topic_endpoint_info_array_fini* = rmw_topic_endpoint_info_array_fini ##
                              ##  Finalize a topic_endpoint_info_array_t structure.


proc rcl_get_publisher_names_and_types_by_node*(node: ptr rcl_node_t;
    allocator: ptr rcl_allocator_t; no_demangle: _Bool; node_name: cstring;
    node_namespace: cstring; topic_names_and_types: ptr rcl_names_and_types_t): rcl_ret_t {.
    importc: "rcl_get_publisher_names_and_types_by_node", header: "rcl/graph.h".}
  ##
                              ##  Return a list of topic names and types for publishers associated with a node.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `topic_names_and_types` parameter must be allocated and zero initialized.
                              ##  This function allocates memory for the returned list of names and types and so it is the
                              ##  callers responsibility to pass `topic_names_and_types` to rcl_names_and_types_fini()
                              ##  when it is no longer needed.
                              ##  Failing to do so will result in leaked memory.
                              ##
                              ##  There may be some demangling that occurs when listing the names from the middleware
                              ##  implementation.
                              ##  If the `no_demangle` argument is set to `true`, then this will be avoided and the names will be
                              ##  returned as they appear to the middleware.
                              ##
                              ##  \see rmw_get_topic_names_and_types for more details on no_demangle
                              ##
                              ##  The returned names are not automatically remapped by this function.
                              ##  Attempting to create publishers or subscribers using names returned by this function may not
                              ##  result in the desired topic name being used depending on the remap rules in use.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator allocator to be used when allocating space for strings
                              ##  \param[in] no_demangle if true, list all topics without any demangling
                              ##  \param[in] node_name the node name of the topics to return
                              ##  \param[in] node_namespace the node namespace of the topics to return
                              ##  \param[out] topic_names_and_types list of topic names and their types
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAME if the node name is invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAMESPACE if the node namespace is invalid, or
                              ##  \return #RCL_RET_NODE_NAME_NON_EXISTENT if the node name wasn't found, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_subscriber_names_and_types_by_node*(node: ptr rcl_node_t;
    allocator: ptr rcl_allocator_t; no_demangle: _Bool; node_name: cstring;
    node_namespace: cstring; topic_names_and_types: ptr rcl_names_and_types_t): rcl_ret_t {.
    importc: "rcl_get_subscriber_names_and_types_by_node", header: "rcl/graph.h".}
  ##
                              ##  Return a list of topic names and types for subscriptions associated with a node.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `topic_names_and_types` parameter must be allocated and zero initialized.
                              ##  This function allocates memory for the returned list of names and types and so it is the
                              ##  callers responsibility to pass `topic_names_and_types` to rcl_names_and_types_fini()
                              ##  when it is no longer needed.
                              ##  Failing to do so will result in leaked memory.
                              ##
                              ##  \see rcl_get_publisher_names_and_types_by_node for details on the `no_demangle` parameter.
                              ##
                              ##  The returned names are not automatically remapped by this function.
                              ##  Attempting to create publishers or subscribers using names returned by this function may not
                              ##  result in the desired topic name being used depending on the remap rules in use.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator allocator to be used when allocating space for strings
                              ##  \param[in] no_demangle if true, list all topics without any demangling
                              ##  \param[in] node_name the node name of the topics to return
                              ##  \param[in] node_namespace the node namespace of the topics to return
                              ##  \param[out] topic_names_and_types list of topic names and their types
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAME if the node name is invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAMESPACE if the node namespace is invalid, or
                              ##  \return #RCL_RET_NODE_NAME_NON_EXISTENT if the node name wasn't found, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_service_names_and_types_by_node*(node: ptr rcl_node_t;
    allocator: ptr rcl_allocator_t; node_name: cstring; node_namespace: cstring;
    service_names_and_types: ptr rcl_names_and_types_t): rcl_ret_t {.
    importc: "rcl_get_service_names_and_types_by_node", header: "rcl/graph.h".}
  ##
                              ##  Return a list of service names and types associated with a node.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `service_names_and_types` parameter must be allocated and zero initialized.
                              ##  This function allocates memory for the returned list of names and types and so it is the
                              ##  callers responsibility to pass `service_names_and_types` to rcl_names_and_types_fini()
                              ##  when it is no longer needed.
                              ##  Failing to do so will result in leaked memory.
                              ##
                              ##  \see rcl_get_publisher_names_and_types_by_node for details on the `no_demangle` parameter.
                              ##
                              ##  The returned names are not automatically remapped by this function.
                              ##  Attempting to create service clients using names returned by this function may not
                              ##  result in the desired service name being used depending on the remap rules in use.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator allocator to be used when allocating space for strings
                              ##  \param[in] node_name the node name of the services to return
                              ##  \param[in] node_namespace the node namespace of the services to return
                              ##  \param[out] service_names_and_types list of service names and their types
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAME if the node name is invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAMESPACE if the node namespace is invalid, or
                              ##  \return #RCL_RET_NODE_NAME_NON_EXISTENT if the node name wasn't found, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_client_names_and_types_by_node*(node: ptr rcl_node_t;
    allocator: ptr rcl_allocator_t; node_name: cstring; node_namespace: cstring;
    service_names_and_types: ptr rcl_names_and_types_t): rcl_ret_t {.
    importc: "rcl_get_client_names_and_types_by_node", header: "rcl/graph.h".}
  ##
                              ##  Return a list of service client names and types associated with a node.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `service_names_and_types` parameter must be allocated and zero initialized.
                              ##  This function allocates memory for the returned list of names and types and so it is the
                              ##  callers responsibility to pass `service_names_and_types` to rcl_names_and_types_fini()
                              ##  when it is no longer needed.
                              ##  Failing to do so will result in leaked memory.
                              ##
                              ##  \see rcl_get_publisher_names_and_types_by_node for details on the `no_demangle` parameter.
                              ##
                              ##  The returned names are not automatically remapped by this function.
                              ##  Attempting to create service servers using names returned by this function may not
                              ##  result in the desired service name being used depending on the remap rules in use.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator allocator to be used when allocating space for strings
                              ##  \param[in] node_name the node name of the services to return
                              ##  \param[in] node_namespace the node namespace of the services to return
                              ##  \param[out] service_names_and_types list of service client names and their types
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAME if the node name is invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAMESPACE if the node namespace is invalid, or
                              ##  \return #RCL_RET_NODE_NAME_NON_EXISTENT if the node name wasn't found, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_topic_names_and_types*(node: ptr rcl_node_t;
                                    allocator: ptr rcl_allocator_t;
                                    no_demangle: _Bool; topic_names_and_types: ptr rcl_names_and_types_t): rcl_ret_t {.
    importc: "rcl_get_topic_names_and_types", header: "rcl/graph.h".}
  ##
                              ##  Return a list of topic names and their types.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `topic_names_and_types` parameter must be allocated and zero initialized.
                              ##  This function allocates memory for the returned list of names and types and so it is the
                              ##  callers responsibility to pass `topic_names_and_types` to rcl_names_and_types_fini()
                              ##  when it is no longer needed.
                              ##  Failing to do so will result in leaked memory.
                              ##
                              ##  \see rcl_get_publisher_names_and_types_by_node for details on the `no_demangle` parameter.
                              ##
                              ##  The returned names are not automatically remapped by this function.
                              ##  Attempting to create publishers or subscribers using names returned by this function may not
                              ##  result in the desired topic name being used depending on the remap rules in use.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator allocator to be used when allocating space for strings
                              ##  \param[in] no_demangle if true, list all topics without any demangling
                              ##  \param[out] topic_names_and_types list of topic names and their types
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAME if the node name is invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAMESPACE if the node namespace is invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_service_names_and_types*(node: ptr rcl_node_t;
                                      allocator: ptr rcl_allocator_t;
    service_names_and_types: ptr rcl_names_and_types_t): rcl_ret_t {.
    importc: "rcl_get_service_names_and_types", header: "rcl/graph.h".}
  ##
                              ##  Return a list of service names and their types.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `service_names_and_types` parameter must be allocated and zero initialized.
                              ##  This function allocates memory for the returned list of names and types and so it is the
                              ##  callers responsibility to pass `service_names_and_types` to rcl_names_and_types_fini()
                              ##  when it is no longer needed.
                              ##  Failing to do so will result in leaked memory.
                              ##
                              ##  The returned names are not automatically remapped by this function.
                              ##  Attempting to create clients or services using names returned by this function may not result in
                              ##  the desired service name being used depending on the remap rules in use.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator allocator to be used when allocating space for strings
                              ##  \param[out] service_names_and_types list of service names and their types
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_names_and_types_init*(names_and_types: ptr rcl_names_and_types_t;
                               size: csize_t; allocator: ptr rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_names_and_types_init", header: "rcl/graph.h".}
  ##
                              ##  Initialize a rcl_names_and_types_t object.
                              ##
                              ##  This function initializes the string array for the names and allocates space
                              ##  for all the string arrays for the types according to the given size, but
                              ##  it does not initialize the string array for each set of types.
                              ##  However, the string arrays for each set of types is zero initialized.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[inout] names_and_types object to be initialized
                              ##  \param[in] size the number of names and sets of types to be stored
                              ##  \param[in] allocator to be used to allocate and deallocate memory
                              ##  \return #RCL_RET_OK on success, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if memory allocation fails, or
                              ##  \return #RCL_RET_ERROR when an unspecified error occurs.
                              ##

proc rcl_names_and_types_fini*(names_and_types: ptr rcl_names_and_types_t): rcl_ret_t {.
    importc: "rcl_names_and_types_fini", header: "rcl/graph.h".}
  ##
                              ##  Finalize a rcl_names_and_types_t object.
                              ##
                              ##  The object is populated when given to one of the rcl_get_*_names_and_types()
                              ##  functions.
                              ##  This function reclaims any resources allocated during population.
                              ##
                              ##  The `names_and_types` parameter must not be `NULL`, and must point to an
                              ##  already allocated rcl_names_and_types_t struct that was previously
                              ##  passed to a successful rcl_get_*_names_and_types() function call.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[inout] names_and_types struct to be finalized
                              ##  \return #RCL_RET_OK if successful, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_node_names*(node: ptr rcl_node_t; allocator: rcl_allocator_t;
                         node_names: ptr rcutils_string_array_t;
                         node_namespaces: ptr rcutils_string_array_t): rcl_ret_t {.
    importc: "rcl_get_node_names", header: "rcl/graph.h".}
  ##
                              ##  Return a list of available nodes in the ROS graph.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `node_names` parameter must be allocated and zero initialized.
                              ##  `node_names` is the output for this function, and contains allocated memory.
                              ##  Use rcutils_get_zero_initialized_string_array() for initializing an empty
                              ##  rcutils_string_array_t struct.
                              ##  This `node_names` struct should therefore be passed to rcutils_string_array_fini()
                              ##  when it is no longer needed.
                              ##  Failing to do so will result in leaked memory.
                              ##
                              ##  Example:
                              ##
                              ##  ```c
                              ##  rcutils_string_array_t node_names =
                              ##    rcutils_get_zero_initialized_string_array();
                              ##  rcl_ret_t ret = rcl_get_node_names(node, &node_names);
                              ##  if (ret != RCL_RET_OK) {
                              ##    // ... error handling
                              ##  }
                              ##  // ... use the node_names struct, and when done:
                              ##  rcutils_ret_t rcutils_ret = rcutils_string_array_fini(&node_names);
                              ##  if (rcutils_ret != RCUTILS_RET_OK) {
                              ##    // ... error handling
                              ##  }
                              ##  ```
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator used to control allocation and deallocation of names
                              ##  \param[out] node_names struct storing discovered node names
                              ##  \param[out] node_namespaces struct storing discovered node namespaces
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_BAD_ALLOC if an error occurred while allocating memory, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_NODE_INVALID_NAME if a node with an invalid name is detected, or
                              ##  \return #RCL_RET_NODE_INVALID_NAMESPACE if a node with an invalid namespace is detected, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_node_names_with_enclaves*(node: ptr rcl_node_t;
                                       allocator: rcl_allocator_t;
                                       node_names: ptr rcutils_string_array_t;
    node_namespaces: ptr rcutils_string_array_t;
                                       enclaves: ptr rcutils_string_array_t): rcl_ret_t {.
    importc: "rcl_get_node_names_with_enclaves", header: "rcl/graph.h".}
  ##
                              ##  Return a list of available nodes in the ROS graph, including their enclave names.
                              ##
                              ##  An rcl_get_node_names() equivalent, but including in its output the enclave
                              ##  name the node is using.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] RMW implementation in use may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator used to control allocation and deallocation of names
                              ##  \param[out] node_names struct storing discovered node names
                              ##  \param[out] node_namespaces struct storing discovered node namespaces
                              ##  \param[out] enclaves struct storing discovered node enclaves
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_BAD_ALLOC if an error occurred while allocating memory, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_count_publishers*(node: ptr rcl_node_t; topic_name: cstring;
                           count: ptr csize_t): rcl_ret_t {.
    importc: "rcl_count_publishers", header: "rcl/graph.h".}
  ##
                              ##  Return the number of publishers on a given topic.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `topic_name` parameter must not be `NULL`, and must not be an empty string.
                              ##  It should also follow the topic name rules.
                              ##  \todo TODO(wjwwood): link to the topic name rules.
                              ##
                              ##  The `count` parameter must point to a valid bool.
                              ##  The `count` parameter is the output for this function and will be set.
                              ##
                              ##  In the event that error handling needs to allocate memory, this function
                              ##  will try to use the node's allocator.
                              ##
                              ##  The topic name is not automatically remapped by this function.
                              ##  If there is a publisher created with topic name `foo` and remap rule `foo:=bar` then calling
                              ##  this with `topic_name` set to `bar` will return a count of 1, and with `topic_name` set to `foo`
                              ##  will return a count of 0.
                              ##  /sa rcl_remap_topic_name()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] topic_name the name of the topic in question
                              ##  \param[out] count number of publishers on the given topic
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_count_subscribers*(node: ptr rcl_node_t; topic_name: cstring;
                            count: ptr csize_t): rcl_ret_t {.
    importc: "rcl_count_subscribers", header: "rcl/graph.h".}
  ##
                              ##  Return the number of subscriptions on a given topic.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `topic_name` parameter must not be `NULL`, and must not be an empty string.
                              ##  It should also follow the topic name rules.
                              ##  \todo TODO(wjwwood): link to the topic name rules.
                              ##
                              ##  The `count` parameter must point to a valid bool.
                              ##  The `count` parameter is the output for this function and will be set.
                              ##
                              ##  In the event that error handling needs to allocate memory, this function
                              ##  will try to use the node's allocator.
                              ##
                              ##  The topic name is not automatically remapped by this function.
                              ##  If there is a subscriber created with topic name `foo` and remap rule `foo:=bar` then calling
                              ##  this with `topic_name` set to `bar` will return a count of 1, and with `topic_name` set to `foo`
                              ##  will return a count of 0.
                              ##  /sa rcl_remap_topic_name()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] topic_name the name of the topic in question
                              ##  \param[out] count number of subscriptions on the given topic
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_wait_for_publishers*(node: ptr rcl_node_t;
                              allocator: ptr rcl_allocator_t;
                              topic_name: cstring; count: csize_t;
                              timeout: rcutils_duration_value_t;
                              success: ptr _Bool): rcl_ret_t {.
    importc: "rcl_wait_for_publishers", header: "rcl/graph.h".}
  ##
                              ##  Wait for there to be a specified number of publishers on a given topic.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##  The nodes graph guard condition is used by this function, and therefore the caller should
                              ##  take care not to use the guard condition concurrently in any other wait sets.
                              ##
                              ##  The `allocator` parameter must point to a valid allocator.
                              ##
                              ##  The `topic_name` parameter must not be `NULL`, and must not be an empty string.
                              ##  It should also follow the topic name rules.
                              ##
                              ##  This function blocks and will return when the number of publishers for `topic_name`
                              ##  is greater than or equal to the `count` parameter, or the specified `timeout` is reached.
                              ##
                              ##  The `timeout` parameter is in nanoseconds.
                              ##  The timeout is based on system time elapsed.
                              ##  A negative value disables the timeout (i.e. this function blocks until the number of
                              ##  publishers is greater than or equals to `count`).
                              ##
                              ##  The `success` parameter must point to a valid bool.
                              ##  The `success` parameter is the output for this function and will be set.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator to allocate space for the rcl_wait_set_t used to wait for graph events
                              ##  \param[in] topic_name the name of the topic in question
                              ##  \param[in] count number of publishers to wait for
                              ##  \param[in] timeout maximum duration to wait for publishers
                              ##  \param[out] success `true` if the number of publishers is equal to or greater than count, or
                              ##    `false` if a timeout occurred waiting for publishers.
                              ##  \return #RCL_RET_OK if there was no errors, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMEOUT if a timeout occurs before the number of publishers is detected, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurred.
                              ##

proc rcl_wait_for_subscribers*(node: ptr rcl_node_t;
                               allocator: ptr rcl_allocator_t;
                               topic_name: cstring; count: csize_t;
                               timeout: rcutils_duration_value_t;
                               success: ptr _Bool): rcl_ret_t {.
    importc: "rcl_wait_for_subscribers", header: "rcl/graph.h".}
  ##
                              ##  Wait for there to be a specified number of subscribers on a given topic.
                              ##
                              ##  \see rcl_wait_for_publishers
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator to allocate space for the rcl_wait_set_t used to wait for graph events
                              ##  \param[in] topic_name the name of the topic in question
                              ##  \param[in] count number of subscribers to wait for
                              ##  \param[in] timeout maximum duration to wait for subscribers
                              ##  \param[out] success `true` if the number of subscribers is equal to or greater than count, or
                              ##    `false` if a timeout occurred waiting for subscribers.
                              ##  \return #RCL_RET_OK if there was no errors, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_TIMEOUT if a timeout occurs before the number of subscribers is detected, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurred.
                              ##

proc rcl_get_publishers_info_by_topic*(node: ptr rcl_node_t;
                                       allocator: ptr rcutils_allocator_t;
                                       topic_name: cstring; no_mangle: _Bool;
    publishers_info: ptr rcl_topic_endpoint_info_array_t): rcl_ret_t {.
    importc: "rcl_get_publishers_info_by_topic", header: "rcl/graph.h".}
  ##
                              ##  Return a list of all publishers to a topic.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `topic_name` parameter must not be `NULL`.
                              ##
                              ##  When the `no_mangle` parameter is `true`, the provided `topic_name` should be a valid topic name
                              ##  for the middleware (useful when combining ROS with native middleware (e.g. DDS) apps).
                              ##  When the `no_mangle` parameter is `false`, the provided `topic_name` should follow
                              ##  ROS topic name conventions.
                              ##  In either case, the topic name should always be fully qualified.
                              ##
                              ##  Each element in the `publishers_info` array will contain the node name, node namespace,
                              ##  topic type, gid and the qos profile of the publisher.
                              ##  It is the responsibility of the caller to ensure that `publishers_info` parameter points
                              ##  to a valid struct of type rcl_topic_endpoint_info_array_t.
                              ##  The `count` field inside the struct must be set to 0 and the `info_array` field inside
                              ##  the struct must be set to null.
                              ##  \see rmw_get_zero_initialized_topic_endpoint_info_array
                              ##
                              ##  The `allocator` will be used to allocate memory to the `info_array` member
                              ##  inside of `publishers_info`.
                              ##  Moreover, every const char * member inside of
                              ##  rmw_topic_endpoint_info_t will be assigned a copied value on allocated memory.
                              ##  \see rmw_topic_endpoint_info_set_node_name and the likes.
                              ##  However, it is the responsibility of the caller to
                              ##  reclaim any allocated resources to `publishers_info` to avoid leaking memory.
                              ##  \see rmw_topic_endpoint_info_array_fini
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator allocator to be used when allocating space for
                              ##             the array inside publishers_info
                              ##  \param[in] topic_name the name of the topic in question
                              ##  \param[in] no_mangle if `true`, `topic_name` needs to be a valid middleware topic name,
                              ##             otherwise it should be a valid ROS topic name
                              ##  \param[out] publishers_info a struct representing a list of publisher information
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if memory allocation fails, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_subscriptions_info_by_topic*(node: ptr rcl_node_t;
    allocator: ptr rcutils_allocator_t; topic_name: cstring; no_mangle: _Bool;
    subscriptions_info: ptr rcl_topic_endpoint_info_array_t): rcl_ret_t {.
    importc: "rcl_get_subscriptions_info_by_topic", header: "rcl/graph.h".}
  ##
                              ##  Return a list of all subscriptions to a topic.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `topic_name` parameter must not be `NULL`.
                              ##
                              ##  When the `no_mangle` parameter is `true`, the provided `topic_name` should be a valid topic name
                              ##  for the middleware (useful when combining ROS with native middleware (e.g. DDS) apps).
                              ##  When the `no_mangle` parameter is `false`, the provided `topic_name` should follow
                              ##  ROS topic name conventions.
                              ##  In either case, the topic name should always be fully qualified.
                              ##
                              ##  Each element in the `subscriptions_info` array will contain the node name, node namespace,
                              ##  topic type, gid and the qos profile of the subscription.
                              ##  It is the responsibility of the caller to ensure that `subscriptions_info` parameter points
                              ##  to a valid struct of type rcl_topic_endpoint_info_array_t.
                              ##  The `count` field inside the struct must be set to 0 and the `info_array` field inside
                              ##  the struct must be set to null.
                              ##  \see rmw_get_zero_initialized_topic_endpoint_info_array
                              ##
                              ##  The `allocator` will be used to allocate memory to the `info_array` member
                              ##  inside of `subscriptions_info`.
                              ##  Moreover, every const char * member inside of
                              ##  rmw_topic_endpoint_info_t will be assigned a copied value on allocated memory.
                              ##  \see rmw_topic_endpoint_info_set_node_name and the likes.
                              ##  However, it is the responsibility of the caller to
                              ##  reclaim any allocated resources to `subscriptions_info` to avoid leaking memory.
                              ##  \see rmw_topic_endpoint_info_array_fini
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] allocator allocator to be used when allocating space for
                              ##             the array inside publishers_info
                              ##  \param[in] topic_name the name of the topic in question
                              ##  \param[in] no_mangle if `true`, `topic_name` needs to be a valid middleware topic name,
                              ##             otherwise it should be a valid ROS topic name
                              ##  \param[out] subscriptions_info a struct representing a list of subscriptions information
                              ##  \return #RCL_RET_OK if the query was successful, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if memory allocation fails, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_service_server_is_available*(node: ptr rcl_node_t;
                                      client: ptr rcl_client_t;
                                      is_available: ptr _Bool): rcl_ret_t {.
    importc: "rcl_service_server_is_available", header: "rcl/graph.h".}
  ##
                              ##  Check if a service server is available for the given service client.
                              ##
                              ##  This function will return true for `is_available` if there is a service server
                              ##  available for the given client.
                              ##
                              ##  The `node` parameter must point to a valid node.
                              ##
                              ##  The `client` parameter must point to a valid client.
                              ##
                              ##  The given client and node must match, i.e. the client must have been created
                              ##  using the given node.
                              ##
                              ##  The `is_available` parameter must not be `NULL`, and must point a bool variable.
                              ##  The result of the check will be stored in the `is_available` parameter.
                              ##
                              ##  In the event that error handling needs to allocate memory, this function
                              ##  will try to use the node's allocator.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] implementation may need to protect the data structure with a lock</i>
                              ##
                              ##  \param[in] node the handle to the node being used to query the ROS graph
                              ##  \param[in] client the handle to the service client being queried
                              ##  \param[out] is_available set to true if there is a service server available, else false
                              ##  \return #RCL_RET_OK if the check was made successfully (regardless of the service readiness), or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ## 