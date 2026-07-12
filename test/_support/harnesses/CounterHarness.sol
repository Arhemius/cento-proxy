// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CounterStorage} from "support/oracles/ReferenceCounterStorage.sol";

abstract contract CounterHarness {

    bytes32 constant BASE_SLOT = keccak256(abi.encode(uint256(keccak256(bytes("counter.base.slot")
    )) - 1)) & ~bytes32(uint256(0xff));

    function CS() internal pure returns (CounterStorage storage cs) {
        bytes32 position = BASE_SLOT;
        assembly { cs.slot := position }
    }

    function getCount() external view returns (uint256) {
        return CS().count;
    }

    function setCount(uint256 count) external {
        CS().count = count;
    }

}