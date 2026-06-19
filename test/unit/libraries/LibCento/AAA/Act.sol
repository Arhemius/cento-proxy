// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTest} from "./Base.t.sol";
import {Facet} from "src/structs/Facet.sol";

/**
 * @title LibCento Act Layer
 * @notice WHEN clauses - function execution via interfaces
 */
abstract contract LibCentoAct is LibCentoTest {

    // === Public/Internal Functions ===

    function when_AtomicUpdate(
        Facet[] memory setF,
        bytes4[] memory addI, bytes4[] memory remI,
        address migrator_, bytes memory data
    ) internal {
        lc.atomicUpdate(setF, addI, remI, migrator_, data);
    }

    function when_SetContractOwner(address owner_) internal {
        lc.setContractOwner(owner_);
    }

    function when_EnforceIsContractOwner() internal view {
        lc.enforceIsContractOwner();
    }

    function when_GetContractOwner() internal view returns (address owner_) {
        owner_ = lc.contractOwner();
    }

    // === Private Branch Harnesses ===

    function when_SetFacet(uint8 index, address facet) internal {
        Facet[] memory setF = new Facet[](1);
        setF[0] = Facet({index: index, facet: facet});
        lc.atomicUpdate(
            setF, 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );
    }

    function when_AddInterface(bytes4 interfaceId) internal {
        bytes4[] memory addI = new bytes4[](1);
        addI[0] = interfaceId;
        lc.atomicUpdate(NO_FACETS(), 
            addI, 
            NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );
    }

    function when_RemoveInterface(bytes4 interfaceId) internal {
        bytes4[] memory remI = new bytes4[](1);
        remI[0] = interfaceId;
        lc.atomicUpdate(NO_FACETS(), NO_INTERFACES(), 
            remI, 
            NO_ADDRESS(), NO_DATA()
        );
    }

    function when_CheckNotEoa(address target) internal {
        if (target == address(0)) revert ("CheckNotEoa: address(0) bypasses isolated _isNotEoa branch");
        if (target == address(this)) revert ("CheckNotEoa: address(this) bypasses isolated _isNotEoa branch");
        uint8 index = 42;
        h.setFacetAtWithBitmap(index, target);
        Facet[] memory setF = new Facet[](1);
        setF[0] = Facet({index: index,  facet: target});
        lc.atomicUpdate(
            setF,
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );
    }

    function when_CallMigrator(address migrator, bytes memory data) internal {
        lc.atomicUpdate(NO_FACETS(), NO_INTERFACES(), NO_INTERFACES(), 
            migrator, 
            data
        );
    }

    // === Batch Helpers ===

    function when_SetFacets(Facet[] memory facets) internal {
        lc.atomicUpdate(
            facets,
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );
    }

    function when_AddInterfaces(bytes4[] memory interfaces_) internal {
        lc.atomicUpdate(NO_FACETS(),
            interfaces_,
            NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );
    }

    function when_RemoveInterfaces(bytes4[] memory interfaces_) internal {
        lc.atomicUpdate(NO_FACETS(), NO_INTERFACES(),
            interfaces_,
            NO_ADDRESS(), NO_DATA()
        );
    }
}