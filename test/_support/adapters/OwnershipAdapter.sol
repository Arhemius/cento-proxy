// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Ownership} from "src/facets/Ownership.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";
import {ValidContract} from "support/fixtures/ValidContract.sol";

contract OwnershipAdapter is LibCentoHarness, Ownership, ValidContract {}