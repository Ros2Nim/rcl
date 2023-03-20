##  Copyright 2016 Open Source Robotics Foundation, Inc.
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
  rosidl_runtime_c/service_type_support_struct, rcutils/allocator,
  rcutils/macros, rcutils/types/rcutils_ret, rcutils/visibility_control,
  rcutils/visibility_control_macros,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/visibility_control, rosidl_typesupport_interface/macros,
  ./event_callback, rmw/event_callback_type, ./macros, ./node, ./allocator,
  ./arguments, ./log_level, ./types, rmw/types, rcutils/logging,
  rcutils/error_handling, rcutils/snprintf, rcutils/testing/fault_injection,
  rcutils/time, rcutils/types, rcutils/types/array_list,
  rcutils/types/char_array, rcutils/types/hash_map, rcutils/types/string_array,
  rcutils/qsort, rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/visibility_control,
  rmw/events_statuses/liveliness_changed, rmw/events_statuses/liveliness_lost,
  rmw/events_statuses/message_lost, rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/macros, rmw/ret_types, rmw/security_options,
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time,
  ./visibility_control, rcl_yaml_param_parser/types, ./context, ./init_options,
  ./guard_condition, ./node_options, ./domain_id


type

  rcl_client_impl_t* = rcl_client_impl_s ##  Internal rcl client implementation struct.

  rcl_client_t* {.importc: "rcl_client_t", header: "rcl/client.h", bycopy.} = object ##
                              ##  Structure which encapsulates a ROS Client.
    impl* {.importc: "impl".}: ptr rcl_client_impl_t ##
                              ##  Pointer to the client implementation


  rcl_client_options_t* {.importc: "rcl_client_options_t",
                          header: "rcl/client.h", bycopy.} = object ##
                              ##  Options available for a rcl_client_t.
    qos* {.importc: "qos".}: rmw_qos_profile_t ##  Middleware quality of service settings for the client.
    ##  Custom allocator for the client, used for incidental allocations.
    allocator* {.importc: "allocator".}: rcl_allocator_t ##
                              ##  For default behavior (malloc/free), use: rcl_get_default_allocator()




proc rcl_get_zero_initialized_client*(): rcl_client_t {.
    importc: "rcl_get_zero_initialized_client", header: "rcl/client.h".}
  ##
                              ##  Return a rcl_client_t struct with members set to `NULL`.
                              ##
                              ##  Should be called to get a null rcl_client_t before passing to
                              ##  rcl_client_init().
                              ##

proc rcl_client_init*(client: ptr rcl_client_t; node: ptr rcl_node_t;
                      type_support: ptr rosidl_service_type_support_t;
                      service_name: cstring; options: ptr rcl_client_options_t): rcl_ret_t {.
    importc: "rcl_client_init", header: "rcl/client.h".}
  ##
                              ##  Initialize a rcl client.
                              ##
                              ##  After calling this function on a rcl_client_t, it can be used to send
                              ##  requests of the given type by calling rcl_send_request().
                              ##  If the request is received by a (possibly remote) service and if the service
                              ##  sends a response, the client can access the response through
                              ##  rcl_take_response() once the response is available to the client.
                              ##
                              ##  The given rcl_node_t must be valid and the resulting rcl_client_t is only
                              ##  valid as long as the given rcl_node_t remains valid.
                              ##
                              ##  The rosidl_service_type_support_t is obtained on a per `.srv` type basis.
                              ##  When the user defines a ROS service, code is generated which provides the
                              ##  required rosidl_service_type_support_t object.
                              ##  This object can be obtained using a language appropriate mechanism.
                              ##  \todo TODO(wjwwood) write these instructions once and link to it instead
                              ##
                              ##  For C, a macro can be used (for example `example_interfaces/AddTwoInts`):
                              ##
                              ##  ```c
                              ##  #include <rosidl_runtime_c/service_type_support_struct.h>
                              ##  #include <example_interfaces/srv/add_two_ints.h>
                              ##
                              ##  const rosidl_service_type_support_t * ts =
                              ##    ROSIDL_GET_SRV_TYPE_SUPPORT(example_interfaces, srv, AddTwoInts);
                              ##  ```
                              ##
                              ##  For C++, a template function is used:
                              ##
                              ##  ```cpp
                              ##  #include <rosidl_typesupport_cpp/service_type_support.hpp>
                              ##  #include <example_interfaces/srv/add_two_ints.hpp>
                              ##
                              ##  using rosidl_typesupport_cpp::get_service_type_support_handle;
                              ##  const rosidl_service_type_support_t * ts =
                              ##    get_service_type_support_handle<example_interfaces::srv::AddTwoInts>();
                              ##  ```
                              ##
                              ##  The rosidl_service_type_support_t object contains service type specific
                              ##  information used to send or take requests and responses.
                              ##
                              ##  The topic name must be a c string which follows the topic and service name
                              ##  format rules for unexpanded names, also known as non-fully qualified names:
                              ##
                              ##  \see rcl_expand_topic_name
                              ##
                              ##  The options struct allows the user to set the quality of service settings as
                              ##  well as a custom allocator which is used when initializing/finalizing the
                              ##  client to allocate space for incidentals, e.g. the service name string.
                              ##
                              ##  Expected usage (for C services):
                              ##
                              ##  ```c
                              ##  #include <rcl/rcl.h>
                              ##  #include <rosidl_runtime_c/service_type_support_struct.h>
                              ##  #include <example_interfaces/srv/add_two_ints.h>
                              ##
                              ##  rcl_node_t node = rcl_get_zero_initialized_node();
                              ##  rcl_node_options_t node_ops = rcl_node_get_default_options();
                              ##  rcl_ret_t ret = rcl_node_init(&node, "node_name", "/my_namespace", &node_ops);
                              ##  // ... error handling
                              ##  const rosidl_service_type_support_t * ts =
                              ##    ROSIDL_GET_SRV_TYPE_SUPPORT(example_interfaces, srv, AddTwoInts);
                              ##  rcl_client_t client = rcl_get_zero_initialized_client();
                              ##  rcl_client_options_t client_ops = rcl_client_get_default_options();
                              ##  ret = rcl_client_init(&client, &node, ts, "add_two_ints", &client_ops);
                              ##  // ... error handling, and on shutdown do finalization:
                              ##  ret = rcl_client_fini(&client, &node);
                              ##  // ... error handling for rcl_client_fini()
                              ##  ret = rcl_node_fini(&node);
                              ##  // ... error handling for rcl_node_fini()
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
                              ##  \param[inout] client preallocated rcl_client_t structure
                              ##  \param[in] node valid rcl_node_t
                              ##  \param[in] type_support type support object for the service's type
                              ##  \param[in] service_name the name of the service to request
                              ##  \param[in] options client options, including quality of service settings
                              ##  \return #RCL_RET_OK if the client was initialized successfully, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_ALREADY_INIT if the client is already initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory fails, or
                              ##  \return #RCL_RET_SERVICE_NAME_INVALID if the given service name is invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_client_fini*(client: ptr rcl_client_t; node: ptr rcl_node_t): rcl_ret_t {.
    importc: "rcl_client_fini", header: "rcl/client.h".}
  ##
                              ##  Finalize a rcl_client_t.
                              ##
                              ##  After calling this function, calls to rcl_send_request() and
                              ##  rcl_take_response() will fail when using this client.
                              ##  However, the given node handle is still valid.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[inout] client handle to the client to be finalized
                              ##  \param[in] node a valid (not finalized) handle to the node used to create the client
                              ##  \return #RCL_RET_OK if client was finalized successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_NODE_INVALID if the node is invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_client_get_default_options*(): rcl_client_options_t {.
    importc: "rcl_client_get_default_options", header: "rcl/client.h".}
  ##
                              ##  Return the default client options in a rcl_client_options_t.
                              ##
                              ##  The defaults are:
                              ##
                              ##  - qos = rmw_qos_profile_services_default
                              ##  - allocator = rcl_get_default_allocator()
                              ##

proc rcl_send_request*(client: ptr rcl_client_t; ros_request: pointer;
                       sequence_number: ptr int64): rcl_ret_t {.
    importc: "rcl_send_request", header: "rcl/client.h".}
  ##
                              ##  Send a ROS request using a client.
                              ##
                              ##  It is the job of the caller to ensure that the type of the `ros_request`
                              ##  parameter and the type associate with the client (via the type support)
                              ##  match.
                              ##  Passing a different type to `send_request` produces undefined behavior and
                              ##  cannot be checked by this function and therefore no deliberate error will
                              ##  occur.
                              ##
                              ##  rcl_send_request() is an non-blocking call.
                              ##
                              ##  The ROS request message given by the `ros_request` void pointer is always
                              ##  owned by the calling code, but should remain constant during `send_request`.
                              ##
                              ##  This function is thread safe so long as access to both the client and the
                              ##  `ros_request` is synchronized.
                              ##  That means that calling rcl_send_request() from multiple threads is allowed,
                              ##  but calling rcl_send_request() at the same time as non-thread safe client
                              ##  functions is not, e.g. calling rcl_send_request() and rcl_client_fini()
                              ##  concurrently is not allowed.
                              ##  Before calling rcl_send_request() the message can change and after calling
                              ##  rcl_send_request() the message can change, but it cannot be changed during
                              ##  the `send_request` call.
                              ##  The same `ros_request`, however, can be passed to multiple calls of
                              ##  rcl_send_request() simultaneously, even if the clients differ.
                              ##  The `ros_request` is unmodified by rcl_send_request().
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes [1]
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] for unique pairs of clients and requests, see above for more</i>
                              ##
                              ##  \param[in] client handle to the client which will make the response
                              ##  \param[in] ros_request type-erased pointer to the ROS request message
                              ##  \param[out] sequence_number the sequence number
                              ##  \return #RCL_RET_OK if the request was sent successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_CLIENT_INVALID if the client is invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_take_response_with_info*(client: ptr rcl_client_t;
                                  request_header: ptr rmw_service_info_t;
                                  ros_response: pointer): rcl_ret_t {.
    importc: "rcl_take_response_with_info", header: "rcl/client.h".}
  ##
                              ##  Take a ROS response using a client
                              ##
                              ##  It is the job of the caller to ensure that the type of the `ros_response`
                              ##  parameter and the type associate with the client (via the type support)
                              ##  match.
                              ##  Passing a different type to take_response produces undefined behavior and
                              ##  cannot be checked by this function and therefore no deliberate error will
                              ##  occur.
                              ##  The request_header is an rmw struct for meta-information about the request
                              ##  sent (e.g. the sequence number).
                              ##  The caller must provide a pointer to an allocated struct.
                              ##  This function will populate the struct's fields.
                              ##  `ros_response` should point to an already allocated ROS response message
                              ##  struct of the correct type, into which the response from the service will be
                              ##  copied.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Maybe [1]
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] only if required when filling the message, avoided for fixed sizes</i>
                              ##
                              ##  \param[in] client handle to the client which will take the response
                              ##  \param[inout] request_header pointer to the request header
                              ##  \param[inout] ros_response type-erased pointer to the ROS response message
                              ##  \return #RCL_RET_OK if the response was taken successfully, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any arguments are invalid, or
                              ##  \return #RCL_RET_CLIENT_INVALID if the client is invalid, or
                              ##  \return #RCL_RET_CLIENT_TAKE_FAILED if take failed but no error occurred
                              ##          in the middleware, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_take_response*(client: ptr rcl_client_t;
                        request_header: ptr rmw_request_id_t;
                        ros_response: pointer): rcl_ret_t {.
    importc: "rcl_take_response", header: "rcl/client.h".}
  ##
                              ##  backwards compatibility function that takes a rmw_request_id_t only

proc rcl_client_get_service_name*(client: ptr rcl_client_t): cstring {.
    importc: "rcl_client_get_service_name", header: "rcl/client.h".}
  ##
                              ##  Get the name of the service that this client will request a response from.
                              ##
                              ##  This function returns the client's internal service name string.
                              ##  This function can fail, and therefore return `NULL`, if the:
                              ##    - client is `NULL`
                              ##    - client is invalid (never called init, called fini, or invalid node)
                              ##
                              ##  The returned string is only valid as long as the rcl_client_t is valid.
                              ##  The value of the string may change if the service name changes, and therefore
                              ##  copying the string is recommended if this is a concern.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] client pointer to the client
                              ##  \return name string if successful, otherwise `NULL`
                              ##

proc rcl_client_get_options*(client: ptr rcl_client_t): ptr rcl_client_options_t {.
    importc: "rcl_client_get_options", header: "rcl/client.h".}
  ##
                              ##  Return the rcl client options.
                              ##
                              ##  This function returns the client's internal options struct.
                              ##  This function can fail, and therefore return `NULL`, if the:
                              ##    - client is `NULL`
                              ##    - client is invalid (never called init, called fini, or invalid node)
                              ##
                              ##  The returned struct is only valid as long as the rcl_client_t is valid.
                              ##  The values in the struct may change if the options of the client change,
                              ##  and therefore copying the struct is recommended if this is a concern.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] client pointer to the client
                              ##  \return options struct if successful, otherwise `NULL`
                              ##

proc rcl_client_get_rmw_handle*(client: ptr rcl_client_t): ptr rmw_client_t {.
    importc: "rcl_client_get_rmw_handle", header: "rcl/client.h".}
  ##
                              ##  Return the rmw client handle.
                              ##
                              ##  The handle returned is a pointer to the internally held rmw handle.
                              ##  This function can fail, and therefore return `NULL`, if the:
                              ##    - client is `NULL`
                              ##    - client is invalid (never called init, called fini, or invalid node)
                              ##
                              ##  The returned handle is made invalid if the client is finalized or if
                              ##  rcl_shutdown() is called.
                              ##  The returned handle is not guaranteed to be valid for the life time of the
                              ##  client as it may be finalized and recreated itself.
                              ##  Therefore it is recommended to get the handle from the client using
                              ##  this function each time it is needed and avoid use of the handle
                              ##  concurrently with functions that might change it.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] client pointer to the rcl client
                              ##  \return rmw client handle if successful, otherwise `NULL`
                              ##

proc rcl_client_is_valid*(client: ptr rcl_client_t): _Bool {.
    importc: "rcl_client_is_valid", header: "rcl/client.h".}
  ##
                              ##  Check that the client is valid.
                              ##
                              ##  The bool returned is `false` if client is invalid.
                              ##  The bool returned is `true` otherwise.
                              ##  In the case where `false` is to be returned, an error message is set.
                              ##  This function cannot fail.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] client pointer to the rcl client
                              ##  \return `true` if `client` is valid, otherwise `false`
                              ##

proc rcl_client_request_publisher_get_actual_qos*(client: ptr rcl_client_t): ptr rmw_qos_profile_t {.
    importc: "rcl_client_request_publisher_get_actual_qos",
    header: "rcl/client.h".}
  ##  Get the actual qos settings of the client's request publisher.
                            ##
                            ##  Used to get the actual qos settings of the client's request publisher.
                            ##  The actual configuration applied when using RMW_*_SYSTEM_DEFAULT
                            ##  can only be resolved after the creation of the client, and it
                            ##  depends on the underlying rmw implementation.
                            ##  If the underlying setting in use can't be represented in ROS terms,
                            ##  it will be set to RMW_*_UNKNOWN.
                            ##  The returned struct is only valid as long as the rcl_client_t is valid.
                            ##
                            ##  <hr>
                            ##  Attribute          | Adherence
                            ##  ------------------ | -------------
                            ##  Allocates Memory   | No
                            ##  Thread-Safe        | Yes
                            ##  Uses Atomics       | No
                            ##  Lock-Free          | Yes
                            ##
                            ##  \param[in] client pointer to the rcl client
                            ##  \return qos struct if successful, otherwise `NULL`
                            ##

proc rcl_client_response_subscription_get_actual_qos*(client: ptr rcl_client_t): ptr rmw_qos_profile_t {.
    importc: "rcl_client_response_subscription_get_actual_qos",
    header: "rcl/client.h".}
  ##  Get the actual qos settings of the client's response subscription.
                            ##
                            ##  Used to get the actual qos settings of the client's response subscription.
                            ##  The actual configuration applied when using RMW_*_SYSTEM_DEFAULT
                            ##  can only be resolved after the creation of the client, and it
                            ##  depends on the underlying rmw implementation.
                            ##  If the underlying setting in use can't be represented in ROS terms,
                            ##  it will be set to RMW_*_UNKNOWN.
                            ##  The returned struct is only valid as long as the rcl_client_t is valid.
                            ##
                            ##  <hr>
                            ##  Attribute          | Adherence
                            ##  ------------------ | -------------
                            ##  Allocates Memory   | No
                            ##  Thread-Safe        | Yes
                            ##  Uses Atomics       | No
                            ##  Lock-Free          | Yes
                            ##
                            ##  \param[in] client pointer to the rcl client
                            ##  \return qos struct if successful, otherwise `NULL`
                            ##

proc rcl_client_set_on_new_response_callback*(client: ptr rcl_client_t;
    callback: rcl_event_callback_t; user_data: pointer): rcl_ret_t {.
    importc: "rcl_client_set_on_new_response_callback", header: "rcl/client.h".}
  ##
                              ##  Set the on new response callback function for the client.
                              ##
                              ##  This API sets the callback function to be called whenever the
                              ##  client is notified about a new response.
                              ##
                              ##  \sa rmw_client_set_on_new_response_callback for details about this function.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | Maybe [1]
                              ##  Lock-Free          | Maybe [1]
                              ##  <i>[1] rmw implementation defined</i>
                              ##
                              ##  \param[in] client The client on which to set the callback
                              ##  \param[in] callback The callback to be called when new responses arrive, may be NULL
                              ##  \param[in] user_data Given to the callback when called later, may be NULL
                              ##  \return `RCL_RET_OK` if callback was set to the listener, or
                              ##  \return `RCL_RET_INVALID_ARGUMENT` if `client` is NULL, or
                              ##  \return `RCL_RET_UNSUPPORTED` if the API is not implemented in the dds implementation
                              ## 