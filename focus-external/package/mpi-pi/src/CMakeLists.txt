cmake_minimum_required(VERSION 2.4)

project(mpi-pi C)

add_executable(mpi-pi mpi-pi.c)

target_link_libraries(mpi-pi mpi)
