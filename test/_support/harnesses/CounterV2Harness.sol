// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Vm} from "forge-std/Vm.sol";

type $CounterV2 is address;
using CounterV2Harness for $CounterV2 global;

library CounterV2Harness {

    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    bytes32 constant BASE_SLOT = keccak256(abi.encode(uint256(keccak256(bytes("counter.base.slot")
    )) - 1)) & ~bytes32(uint256(0xff));

    uint256 constant COUNT = uint256(BASE_SLOT); // in further constants add offset indices

    function getCount($CounterV2 counterV2) external view returns (uint256) {
        return uint256(vm.load($CounterV2.unwrap(counterV2), bytes32(COUNT)));
    }

    function setCount($CounterV2 counterV2, uint256 count) external {
        vm.store($CounterV2.unwrap(counterV2), bytes32(COUNT), bytes32(count));
    }

}
