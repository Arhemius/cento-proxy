// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IFacetManager } from "../interfaces/IFacetManager.sol";
import { DiamondLib } from "../libraries/DiamondLib.sol";
import { Facet } from "../structs/Facet.sol";

contract FacetManager is IFacetManager { 

    function atomicUpdate(
        Facet[] memory toUpdate,
        bytes4[] memory addI,
        bytes4[] memory removeI
    ) external override {
        DiamondLib.enforceIsContractOwner();
        DiamondLib.atomicUpdate(toUpdate, addI, removeI);
    }

}