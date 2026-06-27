// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Observability} from "src/facets/Observability.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";

contract ObservabilityAdapter is LibCentoHarness, Observability {}