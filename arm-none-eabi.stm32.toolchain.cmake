# Basis taken from https://github.com/jobroe/cmake-arm-embedded/blob/master/toolchain-arm-none-eabi.cmake

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(TOOLCHAIN arm-none-eabi)
if(NOT DEFINED TOOLCHAIN_PATH)
    message(FATAL_ERROR "Please specify the TOOLCHAIN_PATH!\nFor example: -DTOOLCHAIN_PATH=\"C:/Users/You/Desktop/gcc-arm-none-eabi-7-2018-q2-update/\"")
endif()
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_PATH}/bin)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_PATH}/${TOOLCHAIN}/include)
set(TOOLCHAIN_LIB_DIR ${TOOLCHAIN_PATH}/${TOOLCHAIN}/lib)

if(WIN32)
    set(TOOLCHAIN_EXT ".exe")
else()
    set(TOOLCHAIN_EXT "")
endif()

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# GCC flags (taken from STM32CubeIDE build):
# -mthumb: Use the thumb instruction set
# -Wall: All warnings
# -ffunction-sections: Put each function in own section
# -fdata-sections: Put each variable in own section
# -fstack-usage: Generate stack usage file for each source (could be removed from CI builds)
# --specs=nano.specs: Reduced runtime libraries
# -std=gnu11: C11 standard with GNU extensions
set(CMAKE_C_FLAGS "-mthumb -Wall -ffunction-sections -fdata-sections -fstack-usage --specs=nano.specs -std=gnu11" CACHE INTERNAL "C Compiler options")

# G++ flags (taken from STM32CubeIDE build):
# -mthumb: Use the thumb instruction set
# -Wall: All warnings
# -ffunction-sections: Put each function in own section
# -fdata-sections: Put each variable in own section
# -fstack-usage: Generate stack usage file for each source (could be removed from CI builds)
# --specs=nano.specs: Reduced runtime libraries
# -std=gnu++14: C++14 standard with GNU extensions
# -fno-exceptions: Disable exception handling
# -fno-rtti: Disable real time type info, i.e dynamic polymorphism
# -fno-threadsafe-statics: Don't make static variable allocation atomic
# -fno-use-cxa-atexit: Not much documentation on this, apparently deallocates statics/globals somewhere specific
set(CMAKE_CXX_FLAGS "-mthumb -Wall -ffunction-sections -fdata-sections -fstack-usage --specs=nano.specs -std=gnu++14 -fno-exceptions -fno-rtti -fno-threadsafe-statics -fno-use-cxa-atexit" CACHE INTERNAL "C++ Compiler options")

# Assembler flags (taken from STM32CubeIDE build):
# -mthumb: Use the thumb instruction set
# --specs=nano.specs: Reduced runtime libraries
# -x assembler-with-cpp: Assembly may contain C preprocessor commands
set(CMAKE_ASM_FLAGS "-mthumb --specs=nano.specs -x assembler-with-cpp" CACHE INTERNAL "ASM Compiler options")

# Linker flags:
# -Wl,--gc-sections: Perform dead code elimination
# -static: Do not link against shared libraries
# --specs=nano.specs: Reduced runtime libraries
# -mthumb: Use the thumb instruction set
# -Wl,-Map=${CMAKE_PROJECT_NAME}.map: Print link map to file ${CMAKE_PROJECT_NAME}.map
# -Wl,--start-group -lc -lm -lstdc++ -lsupc++ -Wl,--end-group: Link against libc.so, libm.so, libstdc++.so, libsupc++.so
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -static --specs=nano.specs -mthumb -Wl,-Map=${CMAKE_PROJECT_NAME}.map -Wl,--start-group -lc -lm -lstdc++ -lsupc++ -Wl,--end-group" CACHE INTERNAL "Linker options")

# DEBUG build flags:
# -g: Enable debug symbols
set(CMAKE_C_FLAGS_DEBUG "-g" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_DEBUG "-g" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_ASM_FLAGS_DEBUG "-g" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "Linker options for debug build type")

# RELEASE build flags:
# -flto: Enable link time optimization
set(CMAKE_C_FLAGS_RELEASE "-flto" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_RELEASE "-flto" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-flto" CACHE INTERNAL "Linker options for release build type")

set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-g++${TOOLCHAIN_EXT} CACHE INTERNAL "C++ Compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "ASM Compiler")

set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PATH}/${${TOOLCHAIN}})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
