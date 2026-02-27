$ErrorActionPreference = "Stop"

$buildType = if ($args.Count -gt 0) { $args[0] } else { "Release" }

conan profile detect --force
conan install . --build=missing -s build_type=$buildType

$jobs = if ($env:NUMBER_OF_PROCESSORS) { $env:NUMBER_OF_PROCESSORS } else { "2" }
cmake --build build/$buildType --parallel $jobs
