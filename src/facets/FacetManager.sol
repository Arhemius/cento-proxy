// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IFacetManager } from "../interfaces/IFacetManager.sol";
import { LibCento as lc } from "../libraries/LibCento.sol";
import { Facet } from "../structs/Facet.sol";

contract FacetManager is IFacetManager { 

    function atomicUpdate(
        Facet[] calldata toUpdate, 
        bytes4[] calldata addI, 
        bytes4[] calldata removeI,
        address migrator, 
        bytes calldata _calldata
    ) external override {
        lc.enforceIsContractOwner();
        lc.atomicUpdate(toUpdate, addI, removeI, migrator, _calldata);
    }
}