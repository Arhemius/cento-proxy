// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {LibCentoTM} from "test/unit/libraries/cento/LibCento/AAA/_LibCentoTM.sol";
import {OwnershipAdapter} from "support/adapters/OwnershipAdapter.sol";

abstract contract OwnershipTest is Test, LibCentoTM {

    OwnershipAdapter internal o;

}