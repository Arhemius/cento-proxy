// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Test } from "forge-std/Test.sol";
import { Debug } from "src/libraries/LibDebug.sol";
import { console } from "forge-std/console.sol";

abstract contract DebugErasureAssert is Test {
    using {_stripMetadata} for bytes;

    function then_DebugModifiersAreErased(address plain, address instrumented) internal view {
        bytes memory plainCode = address(plain).code._stripMetadata();
        bytes memory instrumentedCode = address(instrumented).code._stripMetadata();
        console.log("Plain code length: %s", plainCode.length);
        console.log("Instrumented code length: %s", instrumentedCode.length);
        assertEq(
            keccak256(plainCode),
            keccak256(instrumentedCode),
            "Debug modifiers were not fully compiled away"
        );
    }

    function _shouldSkipDebugErasure() internal returns (bool) {
        string memory profile = vm.envOr("FOUNDRY_PROFILE", string("default"));
        bool release = keccak256(bytes(profile)) == keccak256(bytes("release"));
        if (release) {
            assertFalse(Debug.ON, "Release profile requires Debug.ON == false");
            return false;
        }
        if (Debug.ON) return true;
        fail("Debug erasure tests require release profile (optimizer enabled)." 
            " Run: 'release forge test' or 'FOUNDRY_PROFILE=release forge test'");
        return true;
    }
}

function _stripMetadata(bytes memory code) pure returns (bytes memory) {
    uint256 len = code.length;
    uint256 metadataLen = (uint8(code[len - 2]) << 8) | uint8(code[len - 1]);
    uint256 strippedLen = len - metadataLen - 2;
    bytes memory out = new bytes(strippedLen);
    for (uint256 i; i < strippedLen; i++) out[i] = code[i];
    return out;
}