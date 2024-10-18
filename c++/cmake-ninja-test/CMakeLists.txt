# 指定 CMake 的最低版本
cmake_minimum_required(VERSION 3.10)

# 项目信息
project(HelloNinja)

# 指定 C++ 标准
set(CMAKE_CXX_STANDARD 11)

# 添加可执行文件
add_executable(hello main.cpp)
