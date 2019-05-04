cmake_minimum_required(VERSION 3.4.1)

add_library(
        native-lib
        SHARED
        native-lib.cpp)

add_library(
        argon2
        SHARED

        argon2/src/argon2.c
        argon2/src/core.c
        argon2/src/blake2/blake2b.c
        argon2/src/encoding.c
        argon2/src/ref.c
        argon2/src/thread.c
)

add_library(
        argon2-binding
        SHARED

        argon2_binding.cpp
)

target_include_directories(
        argon2
        PRIVATE
        argon2/include
)

target_include_directories(
        argon2-binding
        PRIVATE
        argon2/include
)

find_library(
        log-lib
        log)


target_link_libraries(
        native-lib
        ${log-lib})

target_link_libraries(
        argon2-binding

        argon2
        ${log-lib})