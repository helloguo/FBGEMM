# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

################################################################################
# Utility Functions
################################################################################

function(BLOCK_PRINT)
  message("")
  message("")
  message("================================================================================")
  foreach(ARG IN LISTS ARGN)
     message("${ARG}")
  endforeach()
  message("================================================================================")
  message("")
endfunction()

function(LIST_FILTER)
  set(flags)
  set(singleValueArgs OUTPUT REGEX)
  set(multiValueArgs INPUT)

  cmake_parse_arguments(
    args
    "${flags}" "${singleValueArgs}" "${multiValueArgs}"
    ${ARGN})

  set(${args_OUTPUT})

  foreach(value ${args_INPUT})
    if("${value}" MATCHES "${args_REGEX}")
      list(APPEND ${args_OUTPUT} ${value})
    endif()
  endforeach()

  set(${args_OUTPUT} ${${args_OUTPUT}} PARENT_SCOPE)
endfunction()

function(prepend_filepaths)
  set(flags)
  set(singleValueArgs PREFIX OUTPUT)
  set(multiValueArgs INPUT)

  cmake_parse_arguments(
    args
    "${flags}" "${singleValueArgs}" "${multiValueArgs}"
    ${ARGN})

  set(${args_OUTPUT})

  foreach(filepath ${args_INPUT})
    list(APPEND ${args_OUTPUT} "${args_PREFIX}/${filepath}")
  endforeach()

  set(${args_OUTPUT} ${${args_OUTPUT}} PARENT_SCOPE)
endfunction()

macro(handle_genfiles_rocm variable)
  if(USE_ROCM)
    prepend_filepaths(
      PREFIX ${CMAKE_BINARY_DIR}
      INPUT ${${variable}}
      OUTPUT ${variable})
  endif()
endmacro()

function(add_to_package)
  set(flags)
  set(singleValueArgs DESTINATION)
  set(multiValueArgs FILES TARGETS)

  cmake_parse_arguments(
    args
    "${flags}" "${singleValueArgs}" "${multiValueArgs}"
    ${ARGN})

  install(TARGETS ${args_TARGETS} DESTINATION ${args_DESTINATION})
  install(FILES ${args_FILES} DESTINATION ${args_DESTINATION})

  BLOCK_PRINT(
    "Adding to Package: ${args_DESTINATION}"
    " "
    "TARGETS:"
    "${args_TARGETS}"
    " "
    "FILES:"
    "${args_FILES}"
  )
endfunction()
