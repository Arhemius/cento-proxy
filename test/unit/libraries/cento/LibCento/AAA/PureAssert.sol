// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facet} from "cento/structs/Facet.sol";
import {Test} from "forge-std/Test.sol";

abstract contract LibCentoPureAssert is Test {

    function then_FacetAddressesMatch(address actual, address expected) internal pure {
        assertEq(actual, expected);
    }

    function then_FacetArrayAddressesMatch(address[] memory actual, address[] memory expected) internal pure {
        require(actual.length == expected.length, "Facet address array length mismatch");
        for (uint256 i; i < actual.length; ++i) {
            assertEq(actual[i], expected[i]);
        }
    }

    function then_FacetArraysMatch(Facet[] memory actual, Facet[] memory expected) internal pure {
        require(actual.length == expected.length, "Facet array length mismatch");
        for (uint256 i; i < actual.length; ++i) {
            assertEq(actual[i].facet, expected[i].facet);
            assertEq(actual[i].index, expected[i].index);
        }
    }

    function then_SupportStatusMatches(bool actual, bool expected) internal pure {
        assertEq(actual, expected);
    }

    function then_ValueIs(uint256 actual, uint256 expected) internal pure {
        assertEq(actual, expected);
    }
}