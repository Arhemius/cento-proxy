// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facet} from "src/structs/Facet.sol";
import {LibCento} from "src/libraries/LibCento.sol";
import {ILibCento} from "support/interfaces/ILibCento.sol";
import {CentoStorage} from "src/structs/CentoStorage.sol";

// === pure contract implementation without storage harness tooling inheritance ===

contract LibCentoDebugAdapter is ILibCento {

    function _cs() private pure returns (CentoStorage storage cs) {
        return LibCento._cs();
    }

    function atomicUpdate(
        Facet[] memory setF, 
        bytes4[] memory addI, bytes4[] memory remI, 
        address migrator, bytes memory _calldata
    ) external override {
        LibCento.atomicUpdate(setF, addI, remI, migrator, _calldata);
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
}