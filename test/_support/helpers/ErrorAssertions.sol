// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {ErrorContext} from "./ErrorContext.sol";

abstract contract ErrorAssertions is Test, ErrorContext {

    function then_Reverted() internal view {
        if (!Err.captured) {
            revert(
                "Expected revert.\n"
                "Received: successful execution."
            );
        }
    }

    function then_MatchesError(Error memory expected) internal view {
        then_Reverted();
        if (Err.selector != expected.selector) {
            mismatch(
                "Unexpected error selector.", 
                vm.toString(abi.encodePacked(expected.selector)), 
                decodeActual()
            );
        }
        if (Err.data.length != expected.data.length) {
            mismatch(
                "Unexpected error data length.", 
                vm.toString(expected.data.length), 
                vm.toString(Err.data.length)
            );
        }
        if (keccak256(Err.data) != keccak256(expected.data)) {
            mismatch(
                "Unexpected error data.", 
                vm.toString(expected.data), 
                vm.toString(Err.data)
            );
        }
    }

    function mismatch(string memory reason, string memory expected, string memory received) private pure {
        revert(string.concat(
            reason,
            "\n\n  Expected:\n  ", expected,
            "\n\n  Received:\n  ", received
        ));
    }

    function decodeActual() internal view returns (string memory) {
        if (Err.selector == 0x08c379a0) return string.concat("Error\n  ", vm.toString(Err.data));
        if (Err.selector == 0x4e487b71) return string.concat("Panic\n  ", vm.toString(Err.data));
        if (Err.selector == bytes4(0))  return "Raw/Unknown";
        return vm.toString(abi.encodePacked(Err.selector));
    }
}