// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCento} from "cento/libraries/LibCento.sol";
import {ILibCento} from "support/interfaces/ILibCento.sol";
import {CentoStorage} from "cento/structs/CentoStorage.sol";
import {bitmap256} from "src/cento/libraries/LibBitmap.sol";

// === pure contract implementation without storage harness tooling inheritance ===

contract LibCentoDebugAdapter is ILibCento {

    function _cs() private pure returns (CentoStorage storage cs) {
        return LibCento._cs();
    }

    function setFacet(uint8 index, address facet, bitmap256 bitmap) external override returns (bitmap256 out) {
        out = LibCento.setFacet(index, facet, bitmap);
    }

    function contractOwner() external view override returns (address owner_) {
        owner_ = LibCento.contractOwner();
    }

    function enforceIsContractOwner() external view override {
        LibCento.enforceIsContractOwner();
    }

    function setContractOwner(address newOwner) external override {
        LibCento.setContractOwner(newOwner);
    }

    function storageMigration(address migrator, bytes memory _calldata) external override {
        LibCento.storageMigration(migrator, _calldata);
    }
}