// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {FacetManager} from "src/facets/FacetManager.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";

contract FacetManagerAdapter is LibCentoHarness, FacetManager {}