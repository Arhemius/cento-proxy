// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";

abstract contract SimpleActors is Test {

    address internal owner;
    address internal user;

    constructor() {
        owner = makeAddr("owner");
        user  = makeAddr("user");
    }
}