// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {ILibCento} from "support/interfaces/ILibCento.sol";
import {LibCentoAdapter} from "support/adapters/LibCentoAdapter.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";
import {LibBitmapTM} from "../../LibBitmap/AAA/_LibBitmapTM.sol";
import {Facet} from "cento/structs/Facet.sol";

abstract contract LibCentoTest is Test, LibBitmapTM {

    bytes4 constant EVT_FACET_ADDED                 = bytes4(ILibCento.FacetAdded.selector);
    bytes4 constant EVT_FACET_UPDATED               = bytes4(ILibCento.FacetUpdated.selector);
    bytes4 constant EVT_FACET_REMOVED               = bytes4(ILibCento.FacetRemoved.selector);
    bytes4 constant EVT_INTERFACE_ADDED             = bytes4(ILibCento.InterfaceAdded.selector);
    bytes4 constant EVT_INTERFACE_REMOVED           = bytes4(ILibCento.InterfaceRemoved.selector);
    bytes4 constant EVT_OWNERSHIP_TRANSFERRED       = bytes4(ILibCento.OwnershipTransferred.selector);
    bytes4 constant EVT_STORAGE_MIGRATION_SUCCEEDED = bytes4(ILibCento.StorageMigrationSucceeded.selector);

    bytes4 constant ERR_IS_7702_EOA                 = ILibCento.Is7702EOA.selector;
    bytes4 constant ERR_NO_CODE_OR_EOA              = ILibCento.NoCodeOrEOA.selector;
    bytes4 constant ERR_NOT_CONTRACT_OWNER          = ILibCento.NotContractOwner.selector;
    bytes4 constant ERR_ZEROFACET_FOR_EMPTY_SLOT    = ILibCento.ZeroFacetForEmptySlot.selector;
    bytes4 constant ERR_STORAGE_MIGRATION_FAILED    = ILibCento.StorageMigrationFailed.selector;
    bytes4 constant ERR_ROUTER_AS_FACET_FORBIDDEN   = ILibCento.RouterAsFacetForbidden.selector;


    LibCentoAdapter internal lc;
    LibCentoHarness internal h;

    // === Empty Value Builders ===

    function NO_FACETS()        internal pure returns (Facet[] memory)   {   return new Facet[](0);  }
    function NO_INTERFACES()    internal pure returns (bytes4[] memory)  {   return new bytes4[](0); }
    function NO_ADDRESS()       internal pure returns (address)          {   return     address(0);  }
    function NO_DATA()          internal pure returns (bytes memory)     {   return     "";          }

    // ===== Helper functions =====

    function toBytes32Array(uint8[] memory _arr) internal pure returns (bytes32[] memory arr) {
        assembly { arr := _arr }
    }

}