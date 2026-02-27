cmake_minimum_required(VERSION 3.24)

project(Mitsuba LANGUAGES C CXX)

if(POLICY CMP0167)
    cmake_policy(SET CMP0167 OLD)
endif()

option(MTS_BUILD_APPS "Build command-line applications" ON)
option(MTS_BUILD_CORE_LIBS "Build core Mitsuba shared libraries" ON)
option(MTS_BUILD_BSDF_PLUGINS "Build BSDF plugins" ON)
option(MTS_BUILD_PLUGIN_GROUPS "Build all plugin groups" ON)
option(MTS_BUILD_TEST_PLUGINS "Build test plugins (test_*.so)" ON)
option(MTS_BUILD_CONVERTER "Build COLLADA converter (mtsimport)" ON)
option(MTS_BUILD_GUI "Build Qt GUI (mtsgui)" ON)
option(MTS_BUILD_PYTHON "Build Python extension module" ON)
option(MTS_ENABLE_OPENMP "Enable OpenMP if available" ON)
option(MTS_SINGLE_PRECISION "Build with SINGLE_PRECISION" ON)
set(MTS_SPECTRUM_SAMPLES 3 CACHE STRING "Spectrum sample count")

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# copy the generated compile_commands.json to the project root for better integration with IDEs
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_COMMANDS_OUTPUT "${CMAKE_BINARY_DIR}/compile_commands.json")
if(DEFINED CMAKE_CFG_INTDIR AND NOT "${CMAKE_CFG_INTDIR}" STREQUAL ".")
    set(CMAKE_COMMANDS_OUTPUT "${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}/compile_commands.json")
endif()
message("CMAKE_COMMANDS_OUTPUT: ${CMAKE_COMMANDS_OUTPUT}")

add_custom_target(COPY_COMPILE_COMMANDS ALL
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_COMMANDS_OUTPUT}"
        "${CMAKE_SOURCE_DIR}/build/compile_commands.json"
    DEPENDS ${CMAKE_COMMANDS_OUTPUT}
    COMMENT "Copying compile_commands.json to build folder"
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(GNUInstallDirs)
include(cmake/MitsubaPlugins.cmake)

set(MTS_RUNTIME_OUTPUT_DIR "${CMAKE_BINARY_DIR}/binaries")
set(MTS_LIBRARY_OUTPUT_DIR "${CMAKE_BINARY_DIR}/binaries")
set(MTS_PLUGIN_OUTPUT_DIR "${CMAKE_BINARY_DIR}/binaries/plugins")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${MTS_RUNTIME_OUTPUT_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${MTS_LIBRARY_OUTPUT_DIR}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

add_library(mitsuba_common_flags INTERFACE)
target_include_directories(mitsuba_common_flags INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_definitions(mitsuba_common_flags INTERFACE
    BOOST_ALL_NO_LIB=1
    SPECTRUM_SAMPLES=${MTS_SPECTRUM_SAMPLES}
)

if(MTS_SINGLE_PRECISION)
    target_compile_definitions(mitsuba_common_flags INTERFACE SINGLE_PRECISION)
else()
    target_compile_definitions(mitsuba_common_flags INTERFACE DOUBLE_PRECISION)
endif()

if(MTS_ENABLE_OPENMP)
    find_package(OpenMP)
    if(OpenMP_CXX_FOUND)
        target_link_libraries(mitsuba_common_flags INTERFACE OpenMP::OpenMP_CXX)
    else()
        target_compile_definitions(mitsuba_common_flags INTERFACE MTS_NO_OPENMP)
    endif()
else()
    target_compile_definitions(mitsuba_common_flags INTERFACE MTS_NO_OPENMP)
endif()

find_package(Boost CONFIG QUIET COMPONENTS filesystem system thread)
if(NOT Boost_FOUND)
    set(Boost_NO_BOOST_CMAKE ON)
    find_package(Boost REQUIRED COMPONENTS filesystem system thread)
endif()
find_package(Eigen3 REQUIRED)
find_package(PNG REQUIRED)
find_package(JPEG REQUIRED)
find_package(OpenEXR REQUIRED)
find_package(XercesC REQUIRED)
find_package(FFTW3)
find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)

if(MTS_BUILD_CONVERTER)
    find_path(COLLADA_INCLUDE_DIR dae.h)
    find_library(COLLADA_LIBRARY NAMES collada-dom2.5-dp collada-dom2.4-dp collada-dom2.4)
    if(COLLADA_INCLUDE_DIR AND COLLADA_LIBRARY)
        set(MTS_HAS_COLLADA ON)
    else()
        set(MTS_HAS_COLLADA OFF)
        message(WARNING "COLLADA DOM was not found, disabling mtsimport")
    endif()
else()
    set(MTS_HAS_COLLADA OFF)
endif()

if(MTS_BUILD_GUI)
    find_package(Qt5 COMPONENTS Core Gui Widgets OpenGL Xml XmlPatterns Network QUIET)
    if(Qt5_FOUND)
        if(APPLE)
            find_path(BWTOOLKIT_INCLUDE_DIR BWToolkitFramework/BWToolkitFramework.h)
            if(BWTOOLKIT_INCLUDE_DIR)
                set(MTS_HAS_QT ON)
            else()
                set(MTS_HAS_QT OFF)
                message(WARNING "BWToolkit framework was not found, disabling mtsgui on macOS")
            endif()
        else()
            set(MTS_HAS_QT ON)
        endif()
    else()
        set(MTS_HAS_QT OFF)
        message(WARNING "Qt5 was not found, disabling mtsgui")
    endif()
else()
    set(MTS_HAS_QT OFF)
endif()

if(MTS_BUILD_PYTHON)
    find_package(Python3 COMPONENTS Interpreter Development QUIET)
    if(Python3_Development_FOUND)
        set(MTS_HAS_PYTHON ON)
    else()
        set(MTS_HAS_PYTHON OFF)
        message(WARNING "Python3 development package was not found, disabling Python bindings")
    endif()
else()
    set(MTS_HAS_PYTHON OFF)
endif()

set(MTS_CORE_DEPENDENCIES
    Boost::filesystem
    Boost::system
    Boost::thread
    Eigen3::Eigen
    PNG::PNG
    JPEG::JPEG
)

if(TARGET OpenEXR::OpenEXR)
    list(APPEND MTS_CORE_DEPENDENCIES OpenEXR::OpenEXR)
elseif(TARGET OpenEXR::IlmImf)
    list(APPEND MTS_CORE_DEPENDENCIES OpenEXR::IlmImf)
endif()

if(TARGET FFTW3::fftw3)
    list(APPEND MTS_CORE_DEPENDENCIES FFTW3::fftw3)
endif()
if(TARGET FFTW3::fftw3_threads)
    list(APPEND MTS_CORE_DEPENDENCIES FFTW3::fftw3_threads)
endif()

if(APPLE)
    set(MTS_PLATFORM_GL_DEPS
        OpenGL::GL
        GLEW::GLEW
        "-framework Cocoa"
    )
elseif(WIN32)
    set(MTS_PLATFORM_GL_DEPS
        OpenGL::GL
        OpenGL::GLU
        GLEW::GLEW
    )
else()
    find_package(X11 REQUIRED)
    set(MTS_PLATFORM_GL_DEPS
        OpenGL::GL
        OpenGL::GLU
        GLEW::GLEW
        X11::X11
    )
endif()

add_subdirectory(src)
