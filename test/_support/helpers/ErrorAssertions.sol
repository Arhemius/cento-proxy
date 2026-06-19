// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";

abstract contract ErrorAssertions is Test {
    
    function then_RevertIsExpected(bytes4 selector) internal {
        vm.expectRevert(selector);
    }

    function then_RevertIsExpected(bytes4 selector, bytes memory data) internal {
        vm.expectRevert(bytes.concat(selector, data));
    }
}