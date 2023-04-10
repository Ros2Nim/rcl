# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

{.localPassC:"".}

import rcutils
import rcl

proc testPublisherFixture(): rcl_node_t =
  let context = rcl_get_zero_initialized_context()
  let init_options = rcl_get_zero_initialized_init_options()
  let allocator = rcutils_get_default_allocator()

  result = rcl_get_zero_initialized_node()
  var node_ops: rcl_node_options_t = rcl_node_get_default_options()
  let ret = rcl_node_init(addr result, "node_name".cstring, "/my_namespace".cstring, cast[ptr rcl_context_t](addr(node_ops)))

proc testPublisherFixture(): rcl_ret_t =
  let publisher: rcl_publisher_t = rcl_get_zero_initialized_publisher()
  let ts: rosidl_message_type_support_t =
    rosidlGetMsgTypeSupport("test_msgs", "msg", "BasicTypes")
  
  let topic_name = "chatter"
  let expected_topic_name = "/chatter"
  let publisher_options: rcl_publisher_options_t = rcl_publisher_get_default_options()
  result = rcl_publisher_init(addr publisher, this->node_ptr, ts, topic_name, &publisher_options)

  ASSERT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
  OSRF_TESTING_TOOLS_CPP_SCOPE_EXIT(
  {
    rcl_ret_t ret = rcl_publisher_fini(&publisher, this->node_ptr);
    EXPECT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
  });
  EXPECT_EQ(strcmp(rcl_publisher_get_topic_name(&publisher), expected_topic_name), 0);
  test_msgs__msg__BasicTypes msg;
  test_msgs__msg__BasicTypes__init(&msg);
  msg.int64_value = 42;
  ret = rcl_publish(&publisher, &msg, nullptr);
  test_msgs__msg__BasicTypes__fini(&msg);
  ASSERT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
}