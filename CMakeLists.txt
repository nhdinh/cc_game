cmake_minimum_required(VERSION 3.12)
project(cc_game)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_VERBOSE_MAKEFILE on)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake-modules)
message(STATUS "CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}")

include_directories(src)

set(cc_game_SRCS src/main.cxx src/GameClass.cxx src/GameClass.hxx)

add_executable(cc_game ${cc_game_SRCS})