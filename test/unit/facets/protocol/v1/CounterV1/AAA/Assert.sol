// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV1Test} from "./Base.t.sol";

abstract contract CounterV1Assert is CounterV1Test {

    function then_StorageCountIs(uint256 expected) internal view {
        assertEq(ch.getCount(), expected);
    }
}