// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

abstract contract ErrorContext {

    struct Error {
        bytes4 selector;
        bytes data;
    }

    struct ErrorCapture {
        bool captured;
        bytes4 selector;
        bytes data;
    }

    ErrorCapture internal Err;
}