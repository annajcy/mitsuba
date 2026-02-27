Mitsuba — Physically Based Renderer
===================================

http://mitsuba-renderer.org/

## About

Mitsuba is a research-oriented rendering system in the style of PBRT, from which it derives much inspiration. It is written in portable C++, implements unbiased as well as biased techniques, and contains heavy optimizations targeted towards current CPU architectures. Mitsuba is extremely modular: it consists of a small set of core libraries and over 100 different plugins that implement functionality ranging from materials and light sources to complete rendering algorithms.

In comparison to other open source renderers, Mitsuba places a strong emphasis on experimental rendering techniques, such as path-based formulations of Metropolis Light Transport and volumetric modeling approaches. Thus, it may be of genuine interest to those who would like to experiment with such techniques that haven't yet found their way into mainstream renderers, and it also provides a solid foundation for research in this domain.

The renderer currently runs on Linux, MacOS X and Microsoft Windows and makes use of SSE2 optimizations on x86 and x86_64 platforms. So far, its main use has been as a testbed for algorithm development in computer graphics, but there are many other interesting applications.

Mitsuba comes with a command-line interface as well as a graphical frontend to interactively explore scenes. While navigating, a rough preview is shown that becomes increasingly accurate as soon as all movements are stopped. Once a viewpoint has been chosen, a wide range of rendering techniques can be used to generate images, and their parameters can be tuned from within the program.

## Documentation

For compilation, usage, and a full plugin reference, please see the [official documentation](http://mitsuba-renderer.org/docs.html).

## Releases and scenes

Pre-built binaries, as well as example scenes, are available on the [Mitsuba website](http://mitsuba-renderer.org/download.html).

## Experimental CMake + Conan bootstrap

An initial CMake-based build path is now available for migration work.

Current scope:
- Core shared libraries (`mitsuba-core`, `mitsuba-render`, `mitsuba-hw`, `mitsuba-bidir`)
- Main binaries (`mitsuba`, `mtssrv`, `mtsutil`)
- BSDF plugin group (`src/bsdfs`)
- Test plugins (`src/tests/test_*.cpp` as loadable modules)

### Configure dependencies with Conan (Conan 2.x)

```bash
conan profile detect --force
conan install . --build=missing -s build_type=Release
```

### Configure and build with CMake presets

```bash
cmake --preset conan-release
cmake --build --preset conan-release
```

Artifacts are emitted under `out/build/<preset>/binaries` and plugins under `out/build/<preset>/binaries/plugins`.

This path is intentionally incremental and coexists with the legacy SCons build until full migration is complete.
