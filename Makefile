# This project uses CMake and Git sub-modules. This Makefile is just in place
# to make common tasks easier.

.PHONY: run clean build

run: build
	./build/src/metalinfo

build: build/build.ninja
	cmake --build build

build/build.ninja:
	mkdir -p build
	cmake -G Ninja -B build

clean:
	rm -rf build

sync:
	git submodule update --init --recursive -j 8
