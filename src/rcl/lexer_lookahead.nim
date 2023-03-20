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
  ./allocator, rcutils/allocator, rcutils/macros, rcutils/types/rcutils_ret,
  rcutils/visibility_control, rcutils/visibility_control_macros, ./lexer,
  ./macros, ./types, rmw/types, rcutils/logging, rcutils/error_handling,
  rcutils/snprintf, rcutils/testing/fault_injection, rcutils/time,
  rcutils/types, rcutils/types/array_list, rcutils/types/char_array,
  rcutils/types/hash_map, rcutils/types/string_array, rcutils/qsort,
  rcutils/types/string_map, rcutils/types/uint8_array,
  rmw/events_statuses/events_statuses, rmw/events_statuses/incompatible_qos,
  rmw/qos_policy_kind, rmw/visibility_control,
  rmw/events_statuses/liveliness_changed, rmw/events_statuses/liveliness_lost,
  rmw/events_statuses/message_lost, rmw/events_statuses/offered_deadline_missed,
  rmw/events_statuses/requested_deadline_missed, rmw/init, rmw/init_options,
  rmw/domain_id, rmw/localhost, rmw/macros, rmw/ret_types, rmw/security_options,
  rmw/serialized_message, rmw/subscription_content_filter_options, rmw/time,
  ./visibility_control


type

  rcl_lexer_lookahead2_impl_t* = rcl_lexer_lookahead2_impl_s ##
                              ##  Forward declaration

  rcl_lexer_lookahead2_t* {.importc: "rcl_lexer_lookahead2_t",
                            header: "rcl/lexer_lookahead.h", bycopy.} = object ##
                              ##  Track lexical analysis and allow looking ahead 2 lexemes.
    impl* {.importc: "impl".}: ptr rcl_lexer_lookahead2_impl_t ##
                              ##  Pointer to the lexer look ahead2 implementation




proc rcl_get_zero_initialized_lexer_lookahead2*(): rcl_lexer_lookahead2_t {.
    importc: "rcl_get_zero_initialized_lexer_lookahead2",
    header: "rcl/lexer_lookahead.h".}
  ##  Get a zero initialized rcl_lexer_lookahead2_t instance.
                                     ##
                                     ##  \sa rcl_lexer_lookahead2_init()
                                     ##  <hr>
                                     ##  Attribute          | Adherence
                                     ##  ------------------ | -------------
                                     ##  Allocates Memory   | No
                                     ##  Thread-Safe        | Yes
                                     ##  Uses Atomics       | No
                                     ##  Lock-Free          | Yes
                                     ##
                                     ##  \return zero initialized lookahead2 buffer.
                                     ##

proc rcl_lexer_lookahead2_init*(buffer: ptr rcl_lexer_lookahead2_t;
                                text: cstring; allocator: rcl_allocator_t): rcl_ret_t {.
    importc: "rcl_lexer_lookahead2_init", header: "rcl/lexer_lookahead.h".}
  ##
                              ##  Initialize an rcl_lexer_lookahead2_t instance.
                              ##
                              ##  The lookahead2 buffer borrows a reference to the provided text.
                              ##  The text must not be freed before the buffer is finalized.
                              ##  The lookahead2 buffer only needs to be finalized if this function does not return RCL_RET_OK.
                              ##  \sa rcl_lexer_lookahead2_fini()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] buffer A buffer that is zero initialized.
                              ##  \sa rcl_get_zero_initialized_lexer_lookahead2()
                              ##  \param[in] text The string to analyze.
                              ##  \param[in] allocator An allocator to use if an error occurs.
                              ##  \return #RCL_RET_OK if the buffer is successfully initialized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_BAD_ALLOC if allocating memory failed, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurrs.
                              ##

proc rcl_lexer_lookahead2_fini*(buffer: ptr rcl_lexer_lookahead2_t): rcl_ret_t {.
    importc: "rcl_lexer_lookahead2_fini", header: "rcl/lexer_lookahead.h".}
  ##
                              ##  Finalize an instance of an rcl_lexer_lookahead2_t structure.
                              ##
                              ##  \sa rcl_lexer_lookahead2_init()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes [1]
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] Only allocates if an argument is invalid.</i>
                              ##
                              ##  \param[in] buffer The structure to be deallocated.
                              ##  \return #RCL_RET_OK if the structure was successfully finalized, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_lexer_lookahead2_peek*(buffer: ptr rcl_lexer_lookahead2_t;
                                next_type: ptr rcl_lexeme_t): rcl_ret_t {.
    importc: "rcl_lexer_lookahead2_peek", header: "rcl/lexer_lookahead.h".}
  ##
                              ##  Look ahead at the next lexeme in the string.
                              ##
                              ##  Repeated calls to peek will return the same lexeme.
                              ##  A parser that deems the next lexeme as valid must accept it to advance lexing.
                              ##  \sa rcl_lexer_lookahead2_accept()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes [1]
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] Only allocates if an argument is invalid or an internal bug is detected.</i>
                              ##
                              ##  \param[in] buffer the lookahead2 buffer being used to analyze a string.
                              ##  \param[out] next_type an output variable for the next lexeme in the string.
                              ##  \return #RCL_RET_OK if peeking was successfull, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_lexer_lookahead2_peek2*(buffer: ptr rcl_lexer_lookahead2_t;
                                 next_type1: ptr rcl_lexeme_t;
                                 next_type2: ptr rcl_lexeme_t): rcl_ret_t {.
    importc: "rcl_lexer_lookahead2_peek2", header: "rcl/lexer_lookahead.h".}
  ##
                              ##  Look ahead at the next two lexemes in the string.
                              ##
                              ##  Repeated calls to peek2 will return the same two lexemes.
                              ##  A parser that deems the next two lexemes as valid must accept twice to advance lexing.
                              ##  \sa rcl_lexer_lookahead2_accept()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes [1]
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] Only allocates if an argument is invalid or an internal bug is detected.</i>
                              ##
                              ##  \param[in] buffer the lookahead2 buffer being used to analyze a string.
                              ##  \param[out] next_type1 an output variable for the next lexeme in the string.
                              ##  \param[out] next_type2 an output variable for the lexeme after the next lexeme in the string.
                              ##  \return #RCL_RET_OK if peeking was successfull, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_lexer_lookahead2_accept*(buffer: ptr rcl_lexer_lookahead2_t;
                                  lexeme_text: cstringArray;
                                  lexeme_text_length: ptr csize_t): rcl_ret_t {.
    importc: "rcl_lexer_lookahead2_accept", header: "rcl/lexer_lookahead.h".}
  ##
                              ##  Accept a lexeme and advance analysis.
                              ##
                              ##  A token must have been peeked before it can be accepted.
                              ##  \sa rcl_lexer_lookahead2_peek()
                              ##  \sa rcl_lexer_lookahead2_peek2()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes [1]
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] Only allocates if an argument is invalid or an error occurs.</i>
                              ##
                              ##  \param[in] buffer the lookahead2 buffer being used to analyze a string.
                              ##  \param[out] lexeme_text pointer to where lexeme begins in string.
                              ##  \param[out] lexeme_text_length length of lexeme_text.
                              ##  \return #RCL_RET_OK if peeking was successfull, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_lexer_lookahead2_expect*(buffer: ptr rcl_lexer_lookahead2_t;
                                  `type`: rcl_lexeme_t;
                                  lexeme_text: cstringArray;
                                  lexeme_text_length: ptr csize_t): rcl_ret_t {.
    importc: "rcl_lexer_lookahead2_expect", header: "rcl/lexer_lookahead.h".}
  ##
                              ##  Require the next lexeme to be a certain type and advance analysis.
                              ##
                              ##  This method is a shortcut to peeking and accepting a lexeme.
                              ##  It should be used by a parser when there is only one valid lexeme that could come next.
                              ##  \sa rcl_lexer_lookahead2_peek()
                              ##  \sa rcl_lexer_lookahead2_accept()
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | Yes [1]
                              ##  Thread-Safe        | No
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##  <i>[1] Only allocates if an argument is invalid or an error occurs.</i>
                              ##
                              ##  \param[in] buffer the lookahead2 buffer being used to analyze a string.
                              ##  \param[in] type the type the next lexeme must be.
                              ##  \param[out] lexeme_text pointer to where lexeme begins in string.
                              ##  \param[out] lexeme_text_length length of lexeme_text.
                              ##  \return #RCL_RET_OK if the next lexeme was the expected one, or
                              ##  \return #RCL_RET_WRONG_LEXEME if the next lexeme was not the expected one, or
                              ##  \return #RCL_RET_INVALID_ARGUMENT if any function arguments are invalid, or
                              ##  \return #RCL_RET_ERROR if an unspecified error occurs.
                              ##

proc rcl_lexer_lookahead2_get_text*(buffer: ptr rcl_lexer_lookahead2_t): cstring {.
    importc: "rcl_lexer_lookahead2_get_text", header: "rcl/lexer_lookahead.h".}
  ##
                              ##  Get the text at the point where it is currently being analyzed.
                              ##
                              ##  <hr>
                              ##  Attribute          | Adherence
                              ##  ------------------ | -------------
                              ##  Allocates Memory   | No
                              ##  Thread-Safe        | Yes
                              ##  Uses Atomics       | No
                              ##  Lock-Free          | Yes
                              ##
                              ##  \param[in] buffer the lookahead2 buffer being used to analyze a string.
                              ##  \return a pointer inside the original text at the position being analyzed, or
                              ##  \return `NULL` if buffer is itself `NULL` or zero initialized, or
                              ##  \return an undefined value if buffer is not initialized or has been finalized.
                              ## 