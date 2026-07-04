// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facet} from "cento/structs/Facet.sol";
import {LibCento as lc} from "cento/libraries/LibCento.sol";
import {bitmap256} from "cento/libraries/LibBitmap.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";
import {LibCentoDebugAdapter} from "./LibCentoDebugAdapter.sol";

contract LibCentoAdapter is LibCentoHarness, LibCentoDebugAdapter {

    function setFacets(Facet[] memory facets) external returns (bitmap256 out) {
        out = bitmap();
        for (uint256 i; i < facets.length; i++) {
            out = lc.setFacet(facets[i].index, facets[i].facet, out);
        }
    }
}