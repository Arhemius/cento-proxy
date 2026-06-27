// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {LibCentoTM} from "test/unit/libraries/LibCento/AAA/_LibCentoTM.sol";
import {FacetManagerAdapter} from "support/adapters/FacetManagerAdapter.sol";

abstract contract FacetManagerTest is Test, LibCentoTM {

    FacetManagerAdapter internal fm;

}