// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facet} from "src/structs/Facet.sol";
import { CentoStorage as CS } from "src/structs/CentoStorage.sol";

interface ILibCento {

    // =========================================================================
    // Events
    // =========================================================================

    event InterfaceAdded(bytes4 interfaceType);
    event InterfaceRemoved(bytes4 interfaceType);
    event FacetAdded(uint8 indexed index, address facet);
    event FacetRemoved(uint8 indexed index, address old);
    event FacetUpdated(uint8 indexed index, address oldFacet, address newFacet);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event StorageMigrationSucceeded(address indexed migrator);

    // =========================================================================
    // Errors
    // =========================================================================

    error ZeroFacetForEmptySlot();
    error RouterAsFacetForbidden();
    error NotContractOwner(address caller);
    error NoCodeOrEOA(address target);
    error Is7702EOA(address account);
    error StorageMigrationFailed(address migrator);

    // =========================================================================
    // Functions
    // =========================================================================

    function atomicUpdate(
        Facet[] memory setF, 
        bytes4[] memory addI, bytes4[] memory remI, 
        address migrator, bytes memory _calldata
    ) external;
    function contractOwner() external view returns (address owner_);
    function enforceIsContractOwner() external view;
    function setContractOwner(address newOwner) external;
}