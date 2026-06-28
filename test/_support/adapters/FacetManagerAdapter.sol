// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {FacetManager} from "src/facets/FacetManager.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";
import {ValidContract} from "support/fixtures/ValidContract.sol";

contract FacetManagerAdapter is LibCentoHarness, FacetManager, ValidContract {

    function inspectCalldata() external pure returns (uint256 length, bytes memory data) {
        length = msg.data.length;
        data = msg.data;
    }

    function revertError() external pure {
        revert("FacetManager Reverted");
    }
}