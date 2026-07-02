// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterV2Test} from "./Base.t.sol";

abstract contract CounterV2Arrange is CounterV2Test {

    function arrange_StorageCount(uint256 count) internal {
        ch.setCount(count);
    }
}