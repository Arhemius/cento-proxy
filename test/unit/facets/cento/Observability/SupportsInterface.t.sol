// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;


import "support/builtins/Builtins.sol";
import {ObservabilityTestSetup} from "./AAA/Setup.sol";

contract GetFacetStateTest is ObservabilityTestSetup {

    function test_Supports_ReturnsBool() public {
        arrange_Interfaces(B4_(abi.encode(i1, i2)));
        bool first = when_SupportsInterface(i1);
        bool second = when_SupportsInterface(i2);
        then_SupportStatusMatches(first, true);
        then_SupportStatusMatches(second, true);
    }

}