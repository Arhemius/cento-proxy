// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IFacetManager } from "../interfaces/IFacetManager.sol";
import { LibCento } from "../libraries/LibCento.sol";
import { Facet } from "../structs/Facet.sol";

contract FacetManager is IFacetManager { 

    function atomicUpdate(Facet[] memory toUpdate, bytes4[] memory addI, bytes4[] memory removeI) external override {
        LibCento.enforceIsContractOwner();
        LibCento.atomicUpdate(toUpdate, addI, removeI);
    }
}