// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV2Test} from "./Base.t.sol";

abstract contract CounterV2Assert is CounterV2Test {

    function then_StorageCountIs(uint256 expected) internal view {
        assertEq(ch.getCount(), expected);
    }
}