# Package

version       = "0.2.1"
author        = "Jaremy Creechley"
description   = "Nim wrapper for RCL from ROS2"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["rcl"]


# Dependencies

requires "nim >= 1.6.10"
requires "https://github.com/Ros2Nim/rcutils >= 0.2.0"
requires "https://github.com/Ros2Nim/rmw >= 0.2.0"
# requires "https://github.com/Ros2Nim/rcl_yaml_param_parser"
# requires "https://github.com/elcritch/ants >= 0.1.6"
