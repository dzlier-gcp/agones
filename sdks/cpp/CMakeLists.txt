# Copyright 2017 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Makefile for testing and building the C++ SDK

cmake_minimum_required(VERSION 2.8)

set(PACKAGE_NAME      "agones-$(shell git rev-parse --short HEAD)")
set(PACKAGE_VERSION   "0.2")
set(PACKAGE_STRING    "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_TARNAME   "${PACKAGE_NAME}-${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT "https://github.com/GoogleCloudPlatform/agones/issues/")
project(${PACKAGE_NAME} CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS    "-std=c++11")
set(CMAKE_CXX_COMPILER g++)

add_library(agonessdk SHARED
  sdk.grpc.pb.cc
  sdk.pb.cc
  sdk.cc)

set_target_properties(agonessdk PROPERTIES LINKER_LANGUAGE CXX)

target_link_libraries(agonessdk
  ssl
  gpr
  grpc++_unsecure
  grpc++
  grpc_csharp_ext
  protobuf
  pthread
  dl
)

add_custom_command(
  TARGET agonessdk
  POST_BUILD
  COMMAND -mkdir /usr/local/include/agones/
  COMMAND cp
    ${CMAKE_CURRENT_BINARY_DIR}/libagonessdk.*
    /usr/local/lib/
  COMMAND cp
    ${CMAKE_SOURCE_DIR}/*.h
    /usr/local/include/agones/
)
