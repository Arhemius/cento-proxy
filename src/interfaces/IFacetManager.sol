// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Facet } from "../structs/Facet.sol";

interface IFacetManager {
    
    function atomicUpdate(
        uint256[] memory toRemove, 
        Facet[] memory toUpdate, 
        Facet[] memory toRestore,
        address[] memory toAdd, 
        bytes4[] memory addI,
        bytes4[] memory removeI
    ) external;
}