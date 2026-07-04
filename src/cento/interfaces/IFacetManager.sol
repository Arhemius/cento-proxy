// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Facet } from "../structs/Facet.sol";

interface IFacetManager {
    
    function atomicUpdate(
        Facet[] calldata setF, 
        bytes4[] calldata addI, 
        bytes4[] calldata remI,
        address migrator, 
        bytes calldata _calldata
    ) external;

    event AtomicUpdate(Facet[] setF, bytes4[] addI, bytes4[] remI, address migrator, bytes _calldata);
}