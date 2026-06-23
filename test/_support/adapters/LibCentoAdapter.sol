// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";
import {LibCentoDebugAdapter} from "./LibCentoDebugAdapter.sol";

contract LibCentoAdapter is LibCentoHarness, LibCentoDebugAdapter {}