// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Observability} from "src/facets/Observability.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";
import {ValidContract} from "support/fixtures/ValidContract.sol";

contract ObservabilityAdapter is LibCentoHarness, Observability, ValidContract {}