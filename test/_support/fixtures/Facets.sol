// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {ValidContract} from "./ValidContract.sol";
import {Facet} from "src/structs/Facet.sol";

abstract contract Facets {

    ValidContract internal FacetA;
    ValidContract internal FacetB;
    address internal facetA;
    address internal facetB;

    constructor() {
        FacetA      = new ValidContract();
        FacetB      = new ValidContract();
        facetA      = address(FacetA);
        facetB      = address(FacetB);
    }
}