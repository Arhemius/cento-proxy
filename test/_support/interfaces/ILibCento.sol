// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {bitmap256} from "src/cento/libraries/LibBitmap.sol";

interface ILibCento {

    // =========================================================================
    // Events
    // =========================================================================

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

    function setFacet(uint8 index, address facet, bitmap256 bitmap) external returns (bitmap256 out);
    function contractOwner() external view returns (address owner_);
    function enforceIsContractOwner() external view;
    function setContractOwner(address newOwner) external;
    function storageMigration(address migrator, bytes memory _calldata) external;
}