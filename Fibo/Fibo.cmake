macro(find_module FILENAME)
    if(EXISTS "${FILENAME}")
        set(MODULE_FOUND TRUE)
        include("${FILENAME}")
    endif()
endmacro()

# Macro to search for all modules
macro(find_modules PREFIX)
    foreach(module_name ${MODULE_NAMES})
        if(TARGET ${module_name})
            set(MODULE_FOUND TRUE)
        else()
            find_module("${CMAKE_CURRENT_LIST_DIR}/${PREFIX}/${module_name}/${module_name}-export.cmake")
        endif()
    endforeach(module_name)
endmacro()


# Try install location
set(MODULE_FOUND FALSE)
find_modules("cmake")

if(MODULE_FOUND)
    return()
endif()

# Try common build locations
if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    find_modules("build-debug/cmake")
    find_modules("build/cmake")
else()
    find_modules("build/cmake")
    find_modules("build-debug/cmake")
endif()

# Signal success/failure to CMake
set(cppfs_FOUND ${MODULE_FOUND})