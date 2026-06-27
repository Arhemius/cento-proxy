// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleActors} from "support/actors/SimpleActors.sol";
import {OwnershipAdapter} from "support/adapters/OwnershipAdapter.sol";
import {OwnershipAct} from "./Act.sol";

abstract contract OwnershipTestSetup is OwnershipAct, SimpleActors {

    function lc_create() internal virtual override {
        o = new OwnershipAdapter();
        target(address(o));
    }

}