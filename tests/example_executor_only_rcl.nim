##  Copyright (c) 2020 - for information on the respective copyright owner
##  see the NOTICE file and/or the repository https://github.com/ros2/rclc.
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

##  these data structures for the publisher and subscriber are global, so that
##  they can be configured in main() and can be used in the corresponding callback.

import strutils
import rcutils, rcl

import rosidl/msg_parser
import rosidl/ctypes

{.passC: "-I../deps/local/std_msgs -Ideps/local/std_msgs".}

importcRosMsgFile("../deps/local/std_msgs/std_msgs/msg/Bool.msg")

var my_pub*: rcl_publisher_t

var pub_msg*: StdMsgsBool
var sub_msg*: StdMsgsBool

## *************************** CALLBACKS **********************************

proc my_subscriber_callback*(msgin: pointer) =
  let msg: ptr StdMsgsBool = cast[ptr StdMsgsBool](msgin)
  if msg.isNil:
    echo("Callback: msg NULL\n")
  else:
    let data = msg[].data
    echo("Callback: I heard: $1\n" % [data])

proc my_timer_callback*(timer: ptr rcl_timer_t; last_call_time: int64_t) =
  var rc: rcl_ret_t
  RCLC_UNUSED(last_call_time)
  if timer != nil:
    ## printf("Timer: time since last call %d\n", (int) last_call_time);
    rc = rcl_publish(addr(my_pub), addr(pub_msg), nil)
    if rc == RCL_RET_OK:
      printf("Published message %s\n", pub_msg.data.data)
    else:
      printf("timer_callback: Error publishing message %s\n", pub_msg.data.data)
  else:
    printf("timer_callback Error: timer parameter is NULL\n")

## ****************** MAIN PROGRAM ***************************************

proc main*(argc: cint; argv: ptr cstring): cint =
  var context: rcl_context_t = rcl_get_zero_initialized_context()
  var init_options: rcl_init_options_t = rcl_get_zero_initialized_init_options()
  var allocator: rcl_allocator_t = rcl_get_default_allocator()
  var rc: rcl_ret_t
  ##  create init_options
  rc = rcl_init_options_init(addr(init_options), allocator)
  if rc != RCL_RET_OK:
    printf("Error rcl_init_options_init.\n")
    return -1
  rc = rcl_init(argc, argv, addr(init_options), addr(context))
  if rc != RCL_RET_OK:
    printf("Error in rcl_init.\n")
    return -1
  var my_node: rcl_node_t = rcl_get_zero_initialized_node()
  var node_ops: rcl_node_options_t = rcl_node_get_default_options()
  rc = rcl_node_init(addr(my_node), "node_0", "executor_examples", addr(context),
                   addr(node_ops))
  if rc != RCL_RET_OK:
    printf("Error in rcl_node_init\n")
    return -1
  let topic_name: cstring = "topic_0"
  let my_type_support: ptr rosidl_message_type_support_t = ROSIDL_GET_MSG_TYPE_SUPPORT(
      std_msgs, msg, String)
  var pub_options: rcl_publisher_options_t = rcl_publisher_get_default_options()
  rc = rcl_publisher_init(addr(my_pub), addr(my_node), my_type_support, topic_name,
                        addr(pub_options))
  if RCL_RET_OK != rc:
    printf("Error in rcl_publisher_init %s.\n", topic_name)
    return -1
  var clock: rcl_clock_t
  rc = rcl_clock_init(RCL_STEADY_TIME, addr(clock), addr(allocator))
  if rc != RCL_RET_OK:
    printf("Error in rcl_clock_init.\n")
    return -1
  var my_timer: rcl_timer_t = rcl_get_zero_initialized_timer()
  let timer_timeout: cuint = 1000
  rc = rcl_timer_init(addr(my_timer), addr(clock), addr(context),
                    RCL_MS_TO_NS(timer_timeout), my_timer_callback, allocator)
  if rc != RCL_RET_OK:
    printf("Error in rcl_timer_init.\n")
    return -1
  else:
    printf("Created timer with timeout %d ms.\n", timer_timeout)
  ##  assign message to publisher
  StdMsgs__msg__String__init(addr(pub_msg))
  let PUB_MSG_CAPACITY: cuint = 20
  pub_msg.data.data = malloc(PUB_MSG_CAPACITY)
  pub_msg.data.capacity = PUB_MSG_CAPACITY
  snprintf(pub_msg.data.data, pub_msg.data.capacity, "Hello World!")
  pub_msg.data.size = strlen(pub_msg.data.data)
  ##  create subscription
  var my_sub: rcl_subscription_t = rcl_get_zero_initialized_subscription()
  var my_subscription_options: rcl_subscription_options_t = rcl_subscription_get_default_options()
  rc = rcl_subscription_init(addr(my_sub), addr(my_node), my_type_support,
                           topic_name, addr(my_subscription_options))
  if rc != RCL_RET_OK:
    printf("Failed to create subscriber %s.\n", topic_name)
    return -1
  else:
    printf("Created subscriber %s:\n", topic_name)
  ##  one string message for subscriber
  std_msgs__msg__String__init(addr(sub_msg))
  ## /////////////////////////////////////////////////////////////////////////
  ##  Configuration of RCL Executor
  ## /////////////////////////////////////////////////////////////////////////
  var executor: rclc_executor_t
  ##  Note:
  ##  If you need more than the default number of publisher/subscribers, etc., you
  ##  need to configure the micro-ROS middleware also!
  ##  See documentation in the executor.h at the function rclc_executor_init()
  ##  for more details.
  var num_handles: cuint = 1 + 1
  printf("Debug: number of DDS handles: %u\n", num_handles)
  rclc_executor_init(addr(executor), addr(context), num_handles, addr(allocator))
  ##  set timeout for rcl_wait()
  var rcl_wait_timeout: cuint = 1000
  ##  in ms
  rc = rclc_executor_set_timeout(addr(executor), RCL_MS_TO_NS(rcl_wait_timeout))
  if rc != RCL_RET_OK:
    printf("Error in rclc_executor_set_timeout.")
  rc = rclc_executor_add_subscription(addr(executor), addr(my_sub), addr(sub_msg),
                                    addr(my_subscriber_callback), ON_NEW_DATA)
  if rc != RCL_RET_OK:
    printf("Error in rclc_executor_add_subscription. \n")
  rclc_executor_add_timer(addr(executor), addr(my_timer))
  if rc != RCL_RET_OK:
    printf("Error in rclc_executor_add_timer.\n")
  rclc_executor_spin(addr(executor))
  ##  clean up (never reached)
  rc = rclc_executor_fini(addr(executor))
  inc(rc, rcl_publisher_fini(addr(my_pub), addr(my_node)))
  inc(rc, rcl_timer_fini(addr(my_timer)))
  inc(rc, rcl_subscription_fini(addr(my_sub), addr(my_node)))
  inc(rc, rcl_node_fini(addr(my_node)))
  inc(rc, rcl_init_options_fini(addr(init_options)))
  std_msgs__msg__String__fini(addr(pub_msg))
  std_msgs__msg__String__fini(addr(sub_msg))
  if rc != RCL_RET_OK:
    printf("Error while cleaning up!\n")
    return -1
  return 0
