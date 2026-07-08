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

    function when_SetFacet(uint8 config, uint8 index, address facet) internal returns (bitmap256 bitmap) {
        bitmap = h.bitmap();
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.setFacet.selector, index, facet, bitmap));
        } else {
            bitmap = lc.setFacet(index, facet, bitmap);
        }
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

    function when_CallMigrator(uint8 config, address migrator, bytes memory data) internal {
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.storageMigration.selector, migrator, data));
        } else {
            lc.storageMigration(migrator, data);
        }
    }

    // === Private Branch Harnesses ===

    function when_CheckNotEoa(uint8 config, address target) internal {
        if (target == address(0)) revert ("CheckNotEoa: address(0) bypasses isolated _isNotEoa branch");
        if (target == address(this)) revert ("CheckNotEoa: address(this) bypasses isolated _isNotEoa branch");
        uint8 index = 42;
        h.setFacetAtWithBitmap(index, target);
        bitmap256 bitmap = h.bitmap();
        Facet[] memory setF = new Facet[](1);
        setF[0] = Facet({index: index,  facet: target});
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.setFacet.selector, index, target, bitmap));
        } else {
            Record(config);
            lc.setFacet(index, target, bitmap);
        }
    }

    // === Batch Helpers ===

    function when_SetFacets(uint8 config, Facet[] memory facets) internal returns (bitmap256 bitmap) {
        if (Errors(config)) {
            Execute(address(lc), abi.encodeWithSelector(lc.setFacets.selector, facets));
            bitmap = h.bitmap();
        } else {
            bitmap = lc.setFacets(facets);
        }
    }

}