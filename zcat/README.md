# zcat

A `cat` clone implemented in zig.

## Build

`zig build -Drelease-safe`

## Usage

Compiled file can be found in `zig-out/bin/zcat`.

`./zcat [file] ...`

If no arguments are given, it defaults to STDIN. Otherwise use `-` to declare STDIN.
