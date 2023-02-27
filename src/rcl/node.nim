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
  ./allocator, rcutils/allocator, rcutils/allocator, rcutils/allocator,
  rcutils/macros, rcutils/macros, rcutils/macros, rcutils/macros,
  rcutils/macros, rcutils/allocator, rcutils/types/rcutils_ret,
  rcutils/allocator, rcutils/visibility_control,
  rcutils/visibility_control_macros, rcutils/visibility_control_macros,
  rcutils/visibility_control, rcutils/allocator, ./allocator, ./arguments,
  ./log_level, ./macros, ./log_level, ./types, rmw/types, rmw/types,
  rcutils/logging, rcutils/logging, rcutils/logging, rcutils/error_handling,
  rcutils/error_handling, rcutils/error_handling, rcutils/error_handling,
  rcutils/error_handling, rcutils/error_handling, rcutils/snprintf,
  rcutils/snprintf, rcutils/error_handling, rcutils/testing/fault_injection,
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
  rmw/visibility_control, rmw/visibility_control, rmw/qos_policy_kind,
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
  rmw/events_statuses/events_statuses, rmw/types, rmw/init, rmw/init_options,
  rmw/init_options, rmw/domain_id, rmw/init_options, rmw/localhost,
  rmw/init_options, rmw/macros, rmw/init_options, rmw/ret_types,
  rmw/init_options, rmw/security_options, rmw/security_options,
  rmw/init_options, rmw/init, rmw/types, rmw/serialized_message, rmw/types,
  rmw/subscription_content_filter_options,
  rmw/subscription_content_filter_options, rmw/types, rmw/time, rmw/time,
  rmw/types, ./types, ./log_level, ./visibility_control, ./visibility_control,
  ./log_level, ./arguments, rcl_yaml_param_parser/types, ./arguments, ./context,
  ./context, ./init_options, ./init_options, ./context, ./context,
  ./guard_condition, ./guard_condition, ./node_options, ./node_options,
  ./domain_id, ./domain_id, ./node_options

let RCL_DISABLE_LOANED_MESSAGES_ENV_VAR* {.
    importc: "RCL_DISABLE_LOANED_MESSAGES_ENV_VAR", header: "node.h".}: cstring

type

  rcl_node_impl_t* = rcl_node_impl_s

  rcl_node_t* {.importc: "rcl_node_t", header: "node.h", bycopy.} = object ##
                              ##  Structure which encapsulates a ROS Node.
    context* {.importc: "context".}: ptr rcl_context_t ##
                              ##  Context associated with this node.
    impl* {.importc: "impl".}: ptr rcl_node_impl_t ##
                              ##  Private implementation pointer.



proc rcl_get_zero_initialized_node*(): rcl_node_t {.
    importc: "rcl_get_zero_initialized_node", header: "node.h".}
  ##
                              ##  Return a rcl_node_t struct with members initialized to `NULL`.

proc rcl_node_init*(node: ptr rcl_node_t; name: cstring; namespace_: cstring;
                    context: ptr rcl_context_t; options: ptr rcl_node_options_t): rcl_ret_t {.
    importc: "rcl_node_init", header: "node.h".}
  ##  Initialize a ROS node.
                                                ##
                                                ##  Calling this on a rcl_node_t makes it a valid node handle until rcl_shutdown
                                                ##  is called or until rcl_node_fini is called on it.
                                                ##
                                                ##  After calling, the ROS node object can be used to create other middleware
                                                ##  primitives like publishers, services, parameters, etc.
                                                ##
                                                ##  The name of the node must not be NULL and adhere to naming restrictions,
                                                ##  see the rmw_validate_node_name() function for rules.
                                                ##
                                                ##  \todo TODO(wjwwood): node name uniqueness is not yet enforced
                                                ##
                                                ##  The name of the node cannot coincide with another node of the same name.
                                                ##  If a node of the same name is already in the domain, it will be shutdown.
                                                ##
                                                ##  The namespace of the node should not be NULL and should also pass the
                                                ##  rmw_validate_namespace() function's rules.
                                                ##
                                                ##  Additionally this function allows namespaces which lack a leading forward
                                                ##  slash.
                                                ##  Because there is no notion of a relative namespace, there is no difference
                                                ##  between a namespace which lacks a forward and the same namespace with a
                                                ##  leading forward slash.
                                                ##  Therefore, a namespace like ``"foo/bar"`` is automatically changed to
                                                ##  ``"/foo/bar"`` by this function.
                                                ##  Similarly, the namespace ``""`` will implicitly become ``"/"`` which is a
                                                ##  valid namespace.
                                                ##
                                                ##  \todo TODO(wjwwood):
                                                ##    Parameter infrastructure is currently initialized in the language specific
                                                ##    client library, e.g. rclcpp for C++, but will be initialized here in the
                                                ##    future. When that happens there will be an option to avoid parameter
                                                ##    infrastructure with an option in the rcl_node_options_t struct.
                                                ##
                                                ##  A node contains infrastructure for ROS parameters, which include advertising
                                                ##  publishers and service servers.
                                                ##  This function will create those external parameter interfaces even if
                                                ##  parameters are not used later.
                                                ##
                                                ##  The rcl_node_t given must be allocated and zero initialized.
                                                ##  Passing an rcl_node_t which has already had this function called on it, more
                                                ##  recently than rcl_node_fini, will fail.
                                                ##  An allocated rcl_node_t with uninitialized memory is undefined behavior.
                                                ##
                                                ##  Expected usage:
                                                ##
                                                ##  ```c
                                                ##  rcl_context_t context = rcl_get_zero_initialized_context();
                                                ##  // ... initialize the context with rcl_init()
                                                ##  rcl_node_t node = rcl_get_zero_initialized_node();
                                                ##  rcl_node_options_t node_ops = rcl_node_get_default_options();
                                                ##  // ... node options customization
                                                ##  rcl_ret_t ret = rcl_node_init(&node, "node_name", "/node_ns", &context, &node_ops);
                                                ##  // ... error handling and then use the node, but eventually deinitialize it:
                                                ##  ret = rcl_node_fini(&node);
                                                ##  // ... error handling for rcl_node_fini()
                                                ##  ```
                                                ##
                                                ##  <hr>
                                                ##  Attribute          | Adherence
                                                ##  ------------------ | -------------
                                                ##  Allocates Memory   | Yes
                                                ##  Thread-Safe        | No
                                                ##  Uses Atomics       | Yes
                                                ##  Lock-Free          | Yes [1]
                                                ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_uint_least64_t`</i>
                                                ##
                                                ##  \pre the node handle must be allocated, zero initialized, and invalid
                                                ##  \pre the context handle must be allocated, initialized, and valid
                                                ##  \post the node handle is valid and can be used in other `rcl_*` functions
                                                ##
                                                ##  \param[inout] node a preallocated rcl_node_t
                                                ##  \param[in] name the name of the node, must be a valid c-string
                                                ##  \param[in] namespace_ the namespace of the node, must be a valid c-string
                                                ##  \param[in] context the context instance with which the node should be
                                                ##    associated
                                                ##  \param[in] options the node options.
                                                ##    The options are deep copied into the node.
                                                ##    The caller is always responsible for freeing memory used options they
                                                ##    pass in.
                                                ##  \return #RCL_RET_OK if the node was initialized successfully, or
                                                ##  \return #RCL_RET_ALREADY_INIT if the node has already be initialized, or
                                                ##  \return #RCL_RET_NOT_INIT if the given context is invalid, or
                                                ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                                                ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                                                ##  \return #RCL_RET_NODE_INVALID_NAME if the name is invalid, or
                                                ##  \return #RCL_RET_NODE_INVALID_NAMESPACE if the namespace_ is invalid, or
                                                ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                                                ##

proc rcl_node_fini*(node: ptr rcl_node_t): rcl_ret_t {.importc: "rcl_node_fini",
    header: "node.h".}
  ##  Finalize a rcl_node_t.
                      ##
                      ##  Destroys any automatically created infrastructure and deallocates memory.
                      ##  After calling, the rcl_node_t can be safely deallocated.
                      ##
                      ##  All middleware primitives created by the user, e.g. publishers, services, etc,
                      ##  which were created from this node must be finalized using their respective
                      ##  `rcl_*_fini()` functions before this is called.
                      ##  \sa rcl_publisher_fini()
                      ##  \sa rcl_subscription_fini()
                      ##  \sa rcl_client_fini()
                      ##  \sa rcl_service_fini()
                      ##
                      ##  <hr>
                      ##  Attribute          | Adherence
                      ##  ------------------ | -------------
                      ##  Allocates Memory   | Yes
                      ##  Thread-Safe        | No
                      ##  Uses Atomics       | Yes
                      ##  Lock-Free          | Yes [1]
                      ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_uint_least64_t`</i>
                      ##
                      ##  \param[in] node rcl_node_t to be finalized
                      ##  \return #RCL_RET_OK if node was finalized successfully, or
                      ##  \return #RCL_RET_NODE_INVALID if the node pointer is null, or
                      ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                      ##

proc rcl_node_is_valid*(node: ptr rcl_node_t): _Bool {.
    importc: "rcl_node_is_valid", header: "node.h".}
  ##
                              ##  Return `true` if the node is valid, else `false`.
                              ##
                              ##  Also return `false` if the node pointer is `NULL` or the allocator is invalid.
                              ##
                              ##  A node is invalid if:
                              ##    - the implementation is `NULL` (rcl_node_init not called or failed)
                              ##    - rcl_shutdown has been called since the node has been initialized
                              ##    - the node has been finalized with rcl_node_fini
                              ##
                              ##  There is a possible validity race condition.
                              ##
                              ##  Consider:
                              ##
                              ##  ```c
                              ##  assert(rcl_node_is_valid(node));  // <-- thread 1
                              ##  rcl_shutdown();                   // <-- thread 2
                              ##  // use node as if valid           // <-- thread 1
                              ##  ```
                              ##
                              ##  In the third line the node is now invalid, even though on the previous line
                              ##  of thread 1 it was checked to be valid.
                              ##  This is why this function is considered not thread-safe.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | Yes
                              ##  Lock-Free          | Yes [1]
                              ##  <i>[1] if `atomic_is_lock_free()` returns true for `atomic_uint_least64_t`</i>
                              ##
                              ##  \param[in] node rcl_node_t to be validated
                              ##  \return `true` if the node and allocator are valid, otherwise `false`.
                              ##

proc rcl_node_is_valid_except_context*(node: ptr rcl_node_t): _Bool {.
    importc: "rcl_node_is_valid_except_context", header: "node.h".}
  ##
                              ##  Return true if node is valid, except for the context being valid.
                              ##
                              ##  This is used in clean up functions that need to access the node, but do not
                              ##  need use any functions with the context.
                              ##
                              ##  It is identical to rcl_node_is_valid except it ignores the state of the
                              ##  context associated with the node.
                              ##  \sa rcl_node_is_valid()
                              ##

proc rcl_node_get_name*(node: ptr rcl_node_t): cstring {.
    importc: "rcl_node_get_name", header: "node.h".}
  ##
                              ##  Return the name of the node.
                              ##
                              ##  This function returns the node's internal name string.
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - node is `NULL`
                              ##    - node has not been initialized (the implementation is invalid)
                              ##
                              ##  The returned string is only valid as long as the given rcl_node_t is valid.
                              ##  The value of the string may change if the value in the rcl_node_t changes,
                              ##  and therefore copying the string is recommended if this is a concern.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node pointer to the node
                              ##  \return name string if successful, otherwise `NULL`
                              ##

proc rcl_node_get_namespace*(node: ptr rcl_node_t): cstring {.
    importc: "rcl_node_get_namespace", header: "node.h".}
  ##
                              ##  Return the namespace of the node.
                              ##
                              ##  This function returns the node's internal namespace string.
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - node is `NULL`
                              ##    - node has not been initialized (the implementation is invalid)
                              ##
                              ##  The returned string is only valid as long as the given rcl_node_t is valid.
                              ##  The value of the string may change if the value in the rcl_node_t changes,
                              ##  and therefore copying the string is recommended if this is a concern.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node pointer to the node
                              ##  \return name string if successful, otherwise `NULL`
                              ##

proc rcl_node_get_fully_qualified_name*(node: ptr rcl_node_t): cstring {.
    importc: "rcl_node_get_fully_qualified_name", header: "node.h".}
  ##
                              ##  Return the fully qualified name of the node.
                              ##
                              ##  This function returns the node's internal namespace and name combined string.
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - node is `NULL`
                              ##    - node has not been initialized (the implementation is invalid)
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node pointer to the node
                              ##  \return fully qualified name string if successful, otherwise `NULL`
                              ##

proc rcl_node_get_options*(node: ptr rcl_node_t): ptr rcl_node_options_t {.
    importc: "rcl_node_get_options", header: "node.h".}
  ##
                              ##  Return the rcl node options.
                              ##
                              ##  This function returns the node's internal options struct.
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - node is `NULL`
                              ##    - node has not been initialized (the implementation is invalid)
                              ##
                              ##  The returned struct is only valid as long as the given rcl_node_t is valid.
                              ##  The values in the struct may change if the options of the rcl_node_t changes,
                              ##  and therefore copying the struct is recommended if this is a concern.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node pointer to the node
                              ##  \return options struct if successful, otherwise `NULL`
                              ##

proc rcl_node_get_domain_id*(node: ptr rcl_node_t; domain_id: ptr csize_t): rcl_ret_t {.
    importc: "rcl_node_get_domain_id", header: "node.h".}
  ##
                              ##  Return the ROS domain ID that the node is using.
                              ##
                              ##  This function returns the ROS domain ID that the node is in.
                              ##
                              ##  This function should be used to determine what `domain_id` was used rather
                              ##  than checking the domain_id field in the node options, because if
                              ##  #RCL_NODE_OPTIONS_DEFAULT_DOMAIN_ID is used when creating the node then
                              ##  it is not changed after creation, but this function will return the actual
                              ##  `domain_id` used.
                              ##
                              ##  The `domain_id` field must point to an allocated `size_t` object to which
                              ##  the ROS domain ID will be written.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node the handle to the node being queried
                              ##  \param[out] domain_id storage for the domain id
                              ##  \return #RCL_RET_OK if node the domain ID was retrieved successfully, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_node_get_rmw_handle*(node: ptr rcl_node_t): ptr rmw_node_t {.
    importc: "rcl_node_get_rmw_handle", header: "node.h".}
  ##
                              ##  Return the rmw node handle.
                              ##
                              ##  The handle returned is a pointer to the internally held rmw handle.
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - node is `NULL`
                              ##    - node has not been initialized (the implementation is invalid)
                              ##
                              ##  The returned handle is made invalid if the node is finalized or if
                              ##  rcl_shutdown() is called.
                              ##  The returned handle is not guaranteed to be valid for the life time of the
                              ##  node as it may be finalized and recreated itself.
                              ##  Therefore it is recommended to get the handle from the node using
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
                              ##  \param[in] node pointer to the rcl node
                              ##  \return rmw node handle if successful, otherwise `NULL`
                              ##

proc rcl_node_get_rcl_instance_id*(node: ptr rcl_node_t): uint64 {.
    importc: "rcl_node_get_rcl_instance_id", header: "node.h".}
  ##
                              ##  Return the associated rcl instance id.
                              ##
                              ##  This id is stored when rcl_node_init is called and can be compared with the
                              ##  value returned by rcl_get_instance_id() to check if this node was created in
                              ##  the current rcl context (since the latest call to rcl_init().
                              ##
                              ##  This function can fail, and therefore return `0`, if:
                              ##    - node is `NULL`
                              ##    - node has not been initialized (the implementation is invalid)
                              ##
                              ##  This function will succeed even if rcl_shutdown() has been called
                              ##  since the node was created.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node pointer to the rcl node
                              ##  \return rcl instance id captured during node init or `0` on error
                              ##

proc rcl_node_get_graph_guard_condition*(node: ptr rcl_node_t): ptr rcl_guard_condition_t {.
    importc: "rcl_node_get_graph_guard_condition", header: "node.h".}
  ##
                              ##  Return a guard condition which is triggered when the ROS graph changes.
                              ##
                              ##  The handle returned is a pointer to an internally held rcl guard condition.
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - node is `NULL`
                              ##    - node is invalid
                              ##
                              ##  The returned handle is made invalid if the node is finialized or if
                              ##  rcl_shutdown() is called.
                              ##
                              ##  The guard condition will be triggered anytime a change to the ROS graph occurs.
                              ##  A ROS graph change includes things like (but not limited to) a new publisher
                              ##  advertises, a new subscription is created, a new service becomes available,
                              ##  a subscription is canceled, etc.
                              ##
                              ##  \todo TODO(wjwwood): link to exhaustive list of graph events
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node pointer to the rcl node
                              ##  \return rcl guard condition handle if successful, otherwise `NULL`
                              ##

proc rcl_node_get_logger_name*(node: ptr rcl_node_t): cstring {.
    importc: "rcl_node_get_logger_name", header: "node.h".}
  ##
                              ##  Return the logger name of the node.
                              ##
                              ##  This function returns the node's internal logger name string.
                              ##  This function can fail, and therefore return `NULL`, if:
                              ##    - node is `NULL`
                              ##    - node has not been initialized (the implementation is invalid)
                              ##
                              ##  The returned string is only valid as long as the given rcl_node_t is valid.
                              ##  The value of the string may change if the value in the rcl_node_t changes,
                              ##  and therefore copying the string is recommended if this is a concern.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node pointer to the node
                              ##  \return logger_name string if successful, otherwise `NULL`
                              ##

proc rcl_node_resolve_name*(node: ptr rcl_node_t; input_name: cstring;
                            allocator: rcl_allocator_t; is_service: _Bool;
                            only_expand: _Bool; output_name: cstringArray): rcl_ret_t {.
    importc: "rcl_node_resolve_name", header: "node.h".}
  ##
                              ##  Expand a given name into a fully-qualified topic name and apply remapping rules.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] node Node object. Its name, namespace, local/global command line arguments are used.
                              ##  \param[in] input_name Topic name to be expanded and remapped.
                              ##  \param[in] allocator The allocator to be used when creating the output topic.
                              ##  \param[in] is_service For services use `true`, for topics use `false`.
                              ##  \param[in] only_expand When `true`, remapping rules are ignored.
                              ##  \param[out] output_name Output char * pointer.
                              ##  \return #RCL_RET_OK if the topic name was expanded successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any of input_name, node_name, node_namespace
                              ##   or output_name are NULL, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if both local_args and global_args are NULL, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_TOPIC_NAME_INVALID if the given topic name is invalid
                              ##   (see rcl_validate_topic_name()), or
                              ##  \return #RCL_RET_NODE_INVALID_NAME if the given node name is invalid
                              ##   (see rmw_validate_node_name()), or
                              ##  \return #RCL_RET_NODE_INVALID_NAMESPACE if the given node namespace is invalid
                              ##   (see rmw_validate_namespace()), or
                              ##  \return #RCL_RET_UNKNOWN_SUBSTITUTION for unknown substitutions in name, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_get_disable_loaned_message*(disable_loaned_message: ptr _Bool): rcl_ret_t {.
    importc: "rcl_get_disable_loaned_message", header: "node.h".}
  ##
                              ##  Check if loaned message is disabled, according to the environment variable.
                              ##
                              ##  If the `ROS_DISABLE_LOANED_MESSAGES` environment variable is set to "1",
                              ##  `disable_loaned_message` will be set to true.
                              ##
                              ##  \param[out] disable_loaned_message Must not be NULL.
                              ##  \return #RCL_RET_INVALID_ARGUMENT if an argument is not valid, or
                              ##  \return #RCL_RET_ERROR if an unexpected error happened, or
                              ##  \return #RCL_RET_OK.
                              ## 