# determine the compiler to use for C programs
# NOTE, a generator may set CMAKE_C_COMPILER before
# loading this file to force a compiler.
# use environment variable CCC first if defined by user, next use 
# the cmake variable CMAKE_GENERATOR_CC which can be defined by a generator
# as a default compiler

IF(NOT CMAKE_C_COMPILER)
  # if the user has specified CC via the environment, then use that without checking
  IF($ENV{CC} MATCHES ".+")
    GET_FILENAME_COMPONENT(CMAKE_C_COMPILER_INIT $ENV{CC} PROGRAM PROGRAM_ARGS CMAKE_C_FLAGS_ENV_INIT)
    IF(EXISTS ${CMAKE_C_COMPILER_INIT})
    ELSE(EXISTS ${CMAKE_C_COMPILER_INIT})
      MESSAGE(SEND_ERROR "Could not find compiler set in environment variable CC:\n$ENV{CC}.") 
    ENDIF(EXISTS ${CMAKE_C_COMPILER_INIT})
  ELSE($ENV{CC} MATCHES ".+")
  # if not in the envionment then search for the compiler in the path
    SET(CMAKE_C_COMPILER_LIST ${CMAKE_GENERATOR_CC} gcc cc cl bcc )  
    FIND_PROGRAM(CMAKE_C_COMPILER_FULLPATH NAMES ${CMAKE_C_COMPILER_LIST} )
    GET_FILENAME_COMPONENT(CMAKE_C_COMPILER_INIT
                           ${CMAKE_C_COMPILER_FULLPATH} NAME)
  ENDIF($ENV{CC} MATCHES ".+")
  # set this to notfound right after so that it is searched for each time this
  # file is included
  SET(CMAKE_C_COMPILER ${CMAKE_C_COMPILER_INIT} CACHE STRING "C compiler")
  IF($ENV{CC} MATCHES ".+")
    IF(NOT CMAKE_C_COMPILER)
       MESSAGE(SEND_ERROR "Could not find compiler set in environment variable CC:\n$ENV{CC}, make sure CC does not have flags in it, use CFLAGS instead.")
    ENDIF(NOT CMAKE_C_COMPILER) 
  ENDIF($ENV{CC} MATCHES ".+")
ENDIF(NOT CMAKE_C_COMPILER)
MARK_AS_ADVANCED(CMAKE_C_COMPILER)  
FIND_PROGRAM(CMAKE_AR NAMES ar PATHS /bin /usr/bin /usr/local/bin)

FIND_PROGRAM(CMAKE_RANLIB NAMES ranlib PATHS /bin /usr/bin /usr/local/bin)
IF(NOT CMAKE_RANLIB)
   SET(CMAKE_RANLIB : CACHE INTERNAL "noop for ranlib")
ENDIF(NOT CMAKE_RANLIB)
MARK_AS_ADVANCED(CMAKE_RANLIB)
# test to see if the c compiler is gnu
EXEC_PROGRAM(${CMAKE_C_COMPILER} ARGS -E ${CMAKE_ROOT}/Modules/CMakeTestGNU.c OUTPUT_VARIABLE CMAKE_COMPILER_OUTPUT RETURN_VALUE CMAKE_COMPILER_RETURN)
IF(NOT CMAKE_COMPILER_RETURN)
   IF(${CMAKE_COMPILER_OUTPUT} MATCHES ".*THIS_IS_GNU.*" )
      SET(CMAKE_COMPILER_IS_GNUCC 1)
   ENDIF(${CMAKE_COMPILER_OUTPUT} MATCHES ".*THIS_IS_GNU.*" )
ENDIF(NOT CMAKE_COMPILER_RETURN)


# configure variables set in this file for fast reload later on
CONFIGURE_FILE(${CMAKE_ROOT}/Modules/CMakeCCompiler.cmake.in 
               ${PROJECT_BINARY_DIR}/CMakeCCompiler.cmake IMMEDIATE)
MARK_AS_ADVANCED(CMAKE_AR CMAKE_C_COMPILER_FULLPATH)
