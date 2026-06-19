// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {ValidContract} from "./ValidContract.sol";
import {Facet} from "src/structs/Facet.sol";

abstract contract Facets {

    Facet internal facetZero;
    Facet internal facetMid;
    Facet internal facetMax;
    ValidContract internal FacetA;
    ValidContract internal FacetB;
    address internal facetA;
    address internal facetB;

    constructor() {
        FacetA      = new ValidContract();
        FacetB      = new ValidContract();
        facetA      = address(FacetA);
        facetB      = address(FacetB);
        facetZero   = Facet({index: 0,    facet: facetA});
        facetMid    = Facet({index: 127,  facet: facetA});
        facetMax    = Facet({index: 255,  facet: facetA});
    }
}