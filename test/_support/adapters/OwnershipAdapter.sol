// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Ownership} from "src/facets/Ownership.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";

contract OwnershipAdapter is LibCentoHarness, Ownership {}