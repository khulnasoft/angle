#! /usr/bin/env bash

if [[ "$(wasm-pack --version)" != "wasm-pack 0.10.3" ]] ; then
    echo "wasm-pack version 0.10.3 is not installed"
    # We are using the version from git due to the bug: https://github.com/khulnasoft/angle/pull/16060#issuecomment-1428429602
    echo "running cargo install --git https://github.com/rustwasm/wasm-pack.git --rev e3582b7 wasm-pack"
    cargo install --git https://github.com/rustwasm/wasm-pack.git --rev e3582b7 wasm-pack
else
    echo "wasm-pack version 0.10.3 is installed already"
fi

brew install llvm
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
