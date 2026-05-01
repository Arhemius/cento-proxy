// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IERC173 } from "../interfaces/IERC173.sol";
import { LibCento } from "../libraries/LibCento.sol";

contract OwnershipFacet is IERC173{

    function owner() external override view returns (address owner_) {
        owner_ = LibCento.contractOwner();
    }

    function transferOwnership(address _newOwner) external override {
        LibCento.enforceIsContractOwner();
        LibCento.setContractOwner(_newOwner);
    }
}