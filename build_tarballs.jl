# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "HybridLambda"
version = v"0.6.2-beta"

# Collection of sources required to build HybridLambda
sources = [
    "https://github.com/hybridLambda/hybrid-Lambda.git" =>
    "de99ef39c87e67f78796489ef38e03ed9d363df8",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd hybrid-Lambda/src/
sed -i.bak 's/g++/${CXX}/' Makefile
make
mkdir ${prefix}/bin
mv hybrid-Lambda ${prefix}/bin/


"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "hybrid-Lambda", :hybridlambda)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

