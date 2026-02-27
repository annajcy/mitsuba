from conan import ConanFile
from conan.tools.cmake import CMake, CMakeDeps, CMakeToolchain, cmake_layout


class MitsubaConan(ConanFile):
    name = "mitsuba"
    version = "0.0.1"
    package_type = "application"

    settings = "os", "compiler", "build_type", "arch"
    def requirements(self):
        self.requires("boost/1.86.0")
        self.requires("eigen/3.4.0")
        self.requires("libpng/1.6.44")
        self.requires("libjpeg/9e")
        self.requires("openexr/3.2.4")
        self.requires("xerces-c/3.2.5")
        self.requires("fftw/3.3.10")
        self.requires("glew/2.2.0")

    def layout(self):
        cmake_layout(self)

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()

        tc = CMakeToolchain(self)
        tc.variables["CMAKE_CXX_STANDARD"] = 23
        tc.variables["MTS_BUILD_APPS"] = True
        tc.variables["MTS_BUILD_CORE_LIBS"] = True
        tc.variables["MTS_BUILD_BSDF_PLUGINS"] = True
        tc.variables["MTS_BUILD_PLUGIN_GROUPS"] = True
        tc.variables["MTS_BUILD_TEST_PLUGINS"] = True
        tc.variables["MTS_BUILD_CONVERTER"] = True
        tc.variables["MTS_BUILD_GUI"] = True
        tc.variables["MTS_BUILD_PYTHON"] = True
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
