# Package

version       = "0.1.0"
author        = "Jaremy Creechley"
description   = "Nim wrapper for RCL from ROS2"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["rcl"]


# Dependencies

requires "nim >= 1.6.10"
requires "https://github.com/elcritch/ants >= 0.1.6"
