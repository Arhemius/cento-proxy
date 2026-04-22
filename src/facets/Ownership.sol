// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IERC173 } from "../interfaces/IERC173.sol";
import { DiamondLib } from "../libraries/DiamondLib.sol";

contract OwnershipFacet is IERC173{

    function owner() external override view returns (address owner_) {
        owner_ = DiamondLib.contractOwner();
    }

    function transferOwnership(address _newOwner) external override {
        DiamondLib.enforceIsContractOwner();
        DiamondLib.setContractOwner(_newOwner);
    }
}