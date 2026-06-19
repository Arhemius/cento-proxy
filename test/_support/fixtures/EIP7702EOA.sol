// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {ValidContract} from "./ValidContract.sol";

abstract contract EIP7702EOA is Test {

    uint256 private privateKey = 0xabc123;
    address internal eip7702Eoa;

    constructor() {
        eip7702Eoa = vm.addr(privateKey);
        vm.signAndAttachDelegation(address(new ValidContract()), privateKey);
    }
}