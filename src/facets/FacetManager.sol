// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IFacetManager } from "../interfaces/IFacetManager.sol";
import { DiamondLib } from "../libraries/DiamondLib.sol";
import { Facet } from "../structs/Facet.sol";

contract FacetManager is IFacetManager { 

    function atomicUpdate(
        uint256[] memory toRemove, 
        Facet[] memory toUpdate, 
        Facet[] memory toRestore,
        address[] memory toAdd, 
        bytes4[] memory addI,
        bytes4[] memory removeI
    ) external override {
        DiamondLib.enforceIsContractOwner();
        DiamondLib.atomicUpdate(toRemove, toUpdate, toRestore, toAdd, addI, removeI);
    }

}