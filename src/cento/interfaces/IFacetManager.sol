// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Facet } from "../structs/Facet.sol";

interface IFacetManager {
    
    function atomicUpdate(
        Facet[] calldata toUpdate, 
        bytes4[] calldata addI, 
        bytes4[] calldata removeI,
        address migrator, 
        bytes calldata _calldata
    ) external;
}