// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCento as lc} from "cento/libraries/LibCento.sol";
import {ILibCento} from "support/interfaces/ILibCento.sol";
import {CentoStorage} from "cento/structs/CentoStorage.sol";
import {bitmap256} from "cento/types/bitmap256.sol";

// === pure contract implementation without storage harness tooling inheritance ===

contract LibCentoDebugAdapter is ILibCento {

    function _cs() private pure returns (CentoStorage storage cs) {
        cs = lc._cs();
    }

    function setFacet(uint8 index, address facet, bitmap256 bitmap) external override returns (bitmap256 out) {
        out = lc.setFacet(index, facet, bitmap);
    }

    // ===========

    function contractOwner() external view override returns (address owner_) {
        owner_ = lc.contractOwner();
    }

    function enforceIsContractOwner() external view override {
        lc.enforceIsContractOwner();
    }

    function setContractOwner(address newOwner) external override {
        lc.setContractOwner(newOwner);
    }

    function storageMigration(address migrator, bytes memory _calldata) external override {
        lc.storageMigration(migrator, _calldata);
    }
}