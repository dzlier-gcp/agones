# Copyright 2018 Google Inc. All Rights Reserved.
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

if("${AGONES_GRPC_PROVIDER}" STREQUAL "module")
  if(NOT GRPC_ROOT_DIR)
    set(GRPC_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/grpc)
  endif()
  if(EXISTS "${GRPC_ROOT_DIR}/CMakeLists.txt")
    include_directories("${GRPC_ROOT_DIR}")
    add_subdirectory(${GRPC_ROOT_DIR} third_party/grpc)

    if(TARGET grpcstatic)
      set(_AGONES_GRPC_LIBRARIES grpcstatic)
      set(_AGONES_GRPC_INCLUDE_DIR "${GRPC_ROOT_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/third_party/grpc")
    endif()
  else()
      message(WARNING "AGONES_GRPC_PROVIDER is \"module\" but GRPC_ROOT_DIR is wrong")
  endif()
  if(AGONES_INSTALL)
    message(WARNING "AGONES_INSTALL will be forced to FALSE because AGONES_GRPC_PROVIDER is \"module\"")
    set(AGONES_INSTALL FALSE)
  endif()
elseif("${AGONES_GRPC_PROVIDER}" STREQUAL "package")
  # grpc installation directory can be configured by setting GRPC_ROOT
  # We allow locating grpc using both "CONFIG" and "MODULE" as the expectation
  # is that many Linux systems will have grpc installed via a distribution
  # package ("MODULE"), while on Windows the user is likely to have installed
  # grpc using cmake ("CONFIG").
  find_package(GRPC REQUIRED)

  if(TARGET GRPC::GRPC)
    set(_AGONES_GRPC_LIBRARIES GRPC::GRPC)
  else()
    set(_AGONES_GRPC_LIBRARIES ${GRPC_LIBRARIES})
  endif()
  set(_AGONES_GRPC_INCLUDE_DIR ${GRPC_INCLUDE_DIRS})
  set(_gRPC_FIND_GRPC "if(NOT GRPC_FOUND)\n  find_package(GRPC)\nendif()")
endif()
