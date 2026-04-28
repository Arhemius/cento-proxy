// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import { Facet } from "../structs/Facet.sol";

interface IFacetManager {
    
    function atomicUpdate(Facet[] memory toUpdate, bytes4[] memory addI, bytes4[] memory removeI) external;
}