// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTest} from "./Base.t.sol";
import {Facet} from "cento/structs/Facet.sol";
import {bitmap256} from "cento/libraries/LibBitmap.sol";
import "support/builtins/Builtins.sol";

/**
 * @title LibCento Act Layer
 * @notice WHEN clauses - function execution via interfaces
 */
abstract contract LibCentoAct is LibCentoTest {

    // === Public/Internal Functions ===

    function when_AtomicUpdate(
        uint8 config, 
        Facet[] memory setF,
        bytes4[] memory addI, bytes4[] memory remI,
        address migrator_, bytes memory data
    ) internal {
        Record(config);
        lc.atomicUpdate(setF, addI, remI, migrator_, data);
    }

    function when_SetContractOwner(uint8 config, address owner_) internal {
        Record(config);
        lc.setContractOwner(owner_);
    }

    function when_EnforceIsContractOwner(uint8 config) internal {
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.enforceIsContractOwner.selector));
        } else {
            lc.enforceIsContractOwner();
        }
    }

    function when_GetContractOwner() internal view returns (address owner_) {
        owner_ = lc.contractOwner();
    }

    // === Private Branch Harnesses ===

    function when_SetFacet(uint8 config, uint8 index, address facet) internal returns (bitmap256 bitmap) {
        Facet[] memory setF = new Facet[](1);
        setF[0] = Facet({index: index, facet: facet});
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.atomicUpdate.selector, 
                setF,
                NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
            ));
        } else {
            Record(config);
            lc.atomicUpdate(
                setF,
                NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
            );
        }
        bitmap = h.bitmap();
    }

    function when_AddInterface(uint8 config, bytes4 interfaceId) internal {
        Record(config);
        lc.atomicUpdate(NO_FACETS(), 
            B4_(abi.encode(interfaceId)), 
            NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );
    }
    
    function when_RemoveInterface(uint8 config, bytes4 interfaceId) internal {
        Record(config);
        lc.atomicUpdate(NO_FACETS(), NO_INTERFACES(),
            B4_(abi.encode(interfaceId)), 
            NO_ADDRESS(), NO_DATA()
        );
    }

    function when_CheckNotEoa(uint8 config, address target) internal {
        if (target == address(0)) revert ("CheckNotEoa: address(0) bypasses isolated _isNotEoa branch");
        if (target == address(this)) revert ("CheckNotEoa: address(this) bypasses isolated _isNotEoa branch");
        uint8 index = 42;
        h.setFacetAtWithBitmap(index, target);
        Facet[] memory setF = new Facet[](1);
        setF[0] = Facet({index: index,  facet: target});
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.atomicUpdate.selector, 
                setF,
                NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
            ));
        } else {
            lc.atomicUpdate(
                setF,
                NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
            );
        }
    }

    function when_CallMigrator(uint8 config, address migrator, bytes memory data) internal {
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.atomicUpdate.selector, 
                NO_FACETS(), NO_INTERFACES(), NO_INTERFACES(), 
                migrator, data
            ));
        } else {
            lc.atomicUpdate(NO_FACETS(), NO_INTERFACES(), NO_INTERFACES(), 
                migrator, data
            );
        }
    }

    // === Batch Helpers ===

    function when_SetFacets(uint8 config, Facet[] memory facets) internal returns (bitmap256 bitmap) {
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.atomicUpdate.selector, 
                facets,
                NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
            ));
        } else {
            Record(config);
            lc.atomicUpdate(
                facets,
                NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
            );
        }
        bitmap = h.bitmap();
    }

    function when_AddInterfaces(uint8 config, bytes4[] memory interfaces_) internal {
        Record(config);
        lc.atomicUpdate(NO_FACETS(),
            interfaces_,
            NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );
    }

    function when_RemoveInterfaces(uint8 config, bytes4[] memory interfaces_) internal {
        Record(config);
        lc.atomicUpdate(NO_FACETS(), NO_INTERFACES(),
            interfaces_,
            NO_ADDRESS(), NO_DATA()
        );
    }
}