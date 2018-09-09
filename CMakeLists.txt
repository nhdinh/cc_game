cmake_minimum_required(VERSION 3.12)
project(cc_game)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_VERBOSE_MAKEFILE on)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake-modules)
message(STATUS "CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}")

include_directories(src)

set(cc_game_SRCS src/main.cxx src/GameClass.hxx src/GameClass.cxx)

add_executable(cc_game ${cc_game_SRCS})

# config for external SDL2 in Windows
if (WIN32)
    set(SDL2_ROOT_DIR ${CMAKE_SOURCE_DIR}/../cc_game_exlibs/SDL2-2.0.8-VC)
    if (MINGW)
        set(SDL2_ROOT_DIR ${CMAKE_SOURCE_DIR}/../cc_game_exlibs/SDL2-2.0.8-MingW)
    endif ()
    message(STATUS "SDL2_ROOT_DIR=${SDL2_ROOT_DIR}")
endif ()

find_package(SDL2 REQUIRED)
find_package(SDL2_image REQUIRED)
find_package(SDL2_ttf REQUIRED)

include_directories(${SDL2_INCLUDE_DIR}
        ${SDL2_IMAGE_INCLUDE_DIR}
        ${SDL2_TTF_INCLUDE_DIR})

target_link_libraries(cc_game
        ${SDL2_LIBRARY}
        ${SDL2IMAGE_LIBRARIES}
        ${SDL2TTF_LIBRARIES})

# copy dll files post build in Windows build
if (WIN32)
    add_custom_command(TARGET cc_game POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${SDL2_RUNTIME_LIBRARY}" $<TARGET_FILE_DIR:cc_game>)
endif ()