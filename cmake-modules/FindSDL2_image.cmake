# - Find SDL2_image
# Find the SDL2 headers and libraries

# Set Library prefix and suffix
if (WIN32)
    if (MINGW)
        include(MinGWSearchPathExtras OPTIONAL)
        if (MINGWSEARCH_TARGET_TRIPLE)
            set(SDL2IMAGE_PREFIX ${MINGWSEARCH_TARGET_TRIPLE})
        endif ()
    endif ()

    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(SDL2IMAGE_LIB_PATH_SUFFIX lib/x64)
        if (NOT MSVC AND NOT SDL2IMAGE_PREFIX)
            set(SDL2IMAGE_PREFIX x86_64-w64-mingw32)
        endif ()
    else ()
        set(SDL2IMAGE_LIB_PATH_SUFFIX lib/x86)
        if (NOT MSVC AND NOT SDL2IMAGE_PREFIX)
            set(SDL2IMAGE_PREFIX i686-w64-mingw32)
        endif ()
    endif ()
endif ()

if (SDL2IMAGE_PREFIX)
    set(SDL2IMAGE_ORIGPREFIXPATH ${CMAKE_PREFIX_PATH})
    if (SDL2_ROOT_DIR)
        list(APPEND CMAKE_PREFIX_PATH ${SDL2_ROOT_DIR})
    endif ()
    if (CMAKE_PREFIX_PATH)
        foreach (_prefix ${CMAKE_PREFIX_PATH})
            list(APPEND CMAKE_PREFIX_PATH "${_prefix}/${SDL2IMAGE_PREFIX}")
        endforeach ()
    endif ()
    if (MINGWSEARCH_PREFIXES)
        list(APPEND CMAKE_PREFIX_PATH ${MINGWSEARCH_PREFIXES})
    endif ()

    foreach (_prefix ${CMAKE_PREFIX_PATH})
        message(STATUS "Detected Prefix=${_prefix}")
    endforeach ()
endif ()

# Invoke pkgconfig for hints
find_package(PkgConfig QUIET)
set(SDL2_IMAGE_INCLUDE_DIR)
set(SDL2IMAGE_LIB_DIR)
if (PKG_CONFIG_FOUND)
    pkg_search_module(SDL2IMAGEPC QUIET SDL2_image)
    if (SDL2IMAGEPC_INCLUDE_DIRS)
        set(SDL2_IMAGE_INCLUDE_DIR ${SDL2IMAGEPC_INCLUDE_DIRS})
    endif ()
    if (SDL2IMAGEPC_LIBRARY_DIRS)
        set(SDL2IMAGE_LIB_DIR ${SDL2IMAGEPC_LIBRARY_DIRS})
    endif ()
endif ()

include(FindPackageHandleStandardArgs)

find_library(SDL2IMAGE_LIBRARIES
        NAMES
        SDL2_image
        HINTS
        ${SDL2IMAGE_LIB_DIR}
        PATHS
        ${SDL2_ROOT_DIR}
        PATH_SUFFIXES lib SDL2 ${SDL2IMAGE_LIB_PATH_SUFFIX})

# For apple
set(_sdl2_framework FALSE)
if (APPLE AND "${SDL2IMAGE_LIBRARIES}" MATCHES "(/[^/]+)*.framework(/.*)?$")
    # TODO: To implement the searching script in Apple env
endif ()

# find include path
find_path(SDL2_IMAGE_INCLUDE_DIR
        NAMES
        SDL_image.h
        HINT
        ${SDL2IMAGE_INCLUDE_HINTS}
        PATHS
        ${SDL2_ROOT_DIR}
        PATH_SUFFIXES include include/sdl2 include/SDL2 SDL2)

if (WIN32 AND SDL2IMAGE_LIBRARIES)
    find_file(SDL2IMAGE_RUNTIME_LIBRARY
            NAMES
            SDL2_image.dll
            HINTS
            ${SDL2IMAGE_LIB_HINTS}
            PATHS
            ${SDL2_ROOT_DIR}
            PATH_SUFFIXES bin lib ${SDL2IMAGE_LIB_PATH_SUFFIX})
endif ()

if (WIN32 OR ANDROID OR IOS OR (APPLE AND NOT _sd2_framework))
    set(SDL2IMAGE_EXTRA_REQUIRED SDL2_SDLMAIN_LIBRARY)
    find_library(SDL2_SDLMAIN_LIBRARY
            NAMES
            SDL2main
            PATH
            ${SDL2_ROOT_DIR}
            PATH_SUFFIXES lib ${SDL2IMAGE_LIB_PATH_SUFFIX})
endif ()

if (MINGW AND NOT SDL2IMAGEPC_FOUND)
    find_library(SDL2IMAGE_MINGW_LIBRARY mingw32)
    find_library(SDL2IMAGE_MWINDOWS_LIBRARY mwindows)
endif ()

if (SDL2IMAGE_PREFIX)
    # Restore things the way they used to be.
    set(CMAKE_PREFIX_PATH ${SDL2IMAGE_ORIGPREFIXPATH})
endif ()

# handle the QUIETLY and REQUIRED arguments and set QUATLIB_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SDL2IMAGE
        DEFAULT_MSG
        SDL2IMAGE_LIBRARIES
        SDL2_IMAGE_INCLUDE_DIR
        ${SDL2IMAGE_EXTRA_REQUIRED})

if (SDL2IMAGE_FOUND)
    mark_as_advanced(SDL2_ROOT_DIR)
    message(STATUS "SDL2_IMAGE_INCLUDE_DIR=${SDL2_IMAGE_INCLUDE_DIR}")
    message(STATUS "SDL2IMAGE_LIBRARIES=${SDL2IMAGE_LIBRARIES}")
    message(STATUS "SDL2IMAGE_RUNTIME_LIBRARY=${SDL2IMAGE_RUNTIME_LIBRARY}")
else ()
    message(FATAL_ERROR "SDL2IMAGE NOT FOUND")
endif ()

mark_as_advanced(SDL2IMAGE_LIBRARIES
        SDL2IMAGE_RUNTIME_LIBRARY
        SDL2_IMAGE_INCLUDE_DIR
        SDL2_SDLMAIN_LIBRARY
        #SDL2_COCOA_LIBRARY
        SDL2IMAGE_MINGW_LIBRARY
        SDL2IMAGE_MWINDOWS_LIBRARY)