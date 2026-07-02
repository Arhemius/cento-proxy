// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

struct CounterStorage {
    uint256 count;
}

contract CounterV2 {
    
    bytes32 private constant BASE_SLOT = keccak256(abi.encode(uint256(keccak256(bytes("counter.base.slot")
    )) - 1)) & ~bytes32(uint256(0xff));

    function _cs() private pure returns (CounterStorage storage cs) {
        bytes32 position = BASE_SLOT;
        assembly { cs.slot := position }
    }

    function inc() external {
        _cs().count += 1;
    }

    function dec() external {
        _cs().count -= 1;
    }
}