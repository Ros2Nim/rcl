import rcutils/allocator

##  Copyright 2018 Apex.AI, Inc.
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

import
  rcutils/types/rcutils_ret, rcutils/visibility_control_macros,
  rcutils/types/string_array, rcutils/error_handling, rcutils/snprintf,
  rcutils/testing/fault_injection, rcutils/qsort


type

  rcl_bool_array_t* {.importc: "rcl_bool_array_t",
                      header: "rcl_yaml_param_parser/types.h", bycopy.} = object ##
                              ##  Array of bool values
                              ##
                              ##  \typedef rcl_bool_array_t
                              ##
    values* {.importc: "values".}: ptr bool ##  Array with bool values
    size* {.importc: "size".}: csize_t ##  Number of values in the array


  rcl_int64_array_t* {.importc: "rcl_int64_array_t",
                       header: "rcl_yaml_param_parser/types.h", bycopy.} = object ##
                              ##  Array of int64_t values
                              ##
                              ##  \typedef rcl_int64_array_t
                              ##
    values* {.importc: "values".}: ptr int64 ##  Array with int64 values
    size* {.importc: "size".}: csize_t ##  Number of values in the array


  rcl_double_array_t* {.importc: "rcl_double_array_t",
                        header: "rcl_yaml_param_parser/types.h", bycopy.} = object ##
                              ##  Array of double values
                              ##
                              ##  \typedef rcl_double_array_t
                              ##
    values* {.importc: "values".}: ptr cdouble ##  Array with double values
    size* {.importc: "size".}: csize_t ##  Number of values in the array


  rcl_byte_array_t* {.importc: "rcl_byte_array_t",
                      header: "rcl_yaml_param_parser/types.h", bycopy.} = object ##
                              ##  Array of byte values
                              ##
                              ##  \typedef rcl_byte_array_t
                              ##
    values* {.importc: "values".}: ptr uint8 ##  Array with uint8_t values
    size* {.importc: "size".}: csize_t ##  Number of values in the array


  rcl_variant_t* {.importc: "rcl_variant_t",
                   header: "rcl_yaml_param_parser/types.h", bycopy.} = object ##
                              ##  variant_t stores the value of a parameter
                              ##
                              ##  Only one pointer in this struct will store the value
                              ##  \typedef rcl_variant_t
                              ##
    bool_value* {.importc: "bool_value".}: ptr bool ##
                              ## < If bool, gets stored here
    integer_value* {.importc: "integer_value".}: ptr int64 ##
                              ## < If integer, gets stored here
    double_value* {.importc: "double_value".}: ptr cdouble ##
                              ## < If double, gets stored here
    string_value* {.importc: "string_value".}: cstring ##
                              ## < If string, gets stored here
    byte_array_value* {.importc: "byte_array_value".}: ptr rcl_byte_array_t ##
                              ## < If array of bytes
    bool_array_value* {.importc: "bool_array_value".}: ptr rcl_bool_array_t ##
                              ## < If array of bool's
    integer_array_value* {.importc: "integer_array_value".}: ptr rcl_int64_array_t ##
                              ## < If array of integers
    double_array_value* {.importc: "double_array_value".}: ptr rcl_double_array_t ##
                              ## < If array of doubles
    string_array_value* {.importc: "string_array_value".}: ptr rcutils_string_array_t
    ## < If array of strings


  rcl_node_params_t* {.importc: "rcl_node_params_t",
                       header: "rcl_yaml_param_parser/types.h", bycopy.} = object ##
                              ##  node_params_t stores all the parameters(key:value) of a single node
                              ##
                              ##  \typedef rcl_node_params_t
                              ##
    parameter_names* {.importc: "parameter_names".}: cstringArray ##
                              ## < Array of parameter names (keys)
    parameter_values* {.importc: "parameter_values".}: ptr rcl_variant_t ##
                              ## < Array of coressponding parameter values
    num_params* {.importc: "num_params".}: csize_t ##
                              ## < Number of parameters in the node
    capacity_params* {.importc: "capacity_params".}: csize_t
    ## < Capacity of parameters in the node


  rcl_params_t* {.importc: "rcl_params_t",
                  header: "rcl_yaml_param_parser/types.h", bycopy.} = object ##
                              ##  stores all the parameters of all nodes of a process
                              ##
                              ##  \typedef rcl_params_t
                              ##
    node_names* {.importc: "node_names".}: cstringArray ##
                              ## < List of names of the node
    params* {.importc: "params".}: ptr rcl_node_params_t ##
                              ## <  Array of parameters
    num_nodes* {.importc: "num_nodes".}: csize_t ## < Number of nodes
    capacity_nodes* {.importc: "capacity_nodes".}: csize_t ##
                              ## < Capacity of nodes
    allocator* {.importc: "allocator".}: rcutils_allocator_t
    ## < Allocator used


