// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {LibCentoTM} from "test/unit/libraries/cento/LibCento/AAA/_LibCentoTM.sol";
import {ObservabilityAdapter} from "support/adapters/ObservabilityAdapter.sol";

abstract contract ObservabilityTest is Test, LibCentoTM {

    ObservabilityAdapter internal o;

}