// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {OwnershipTest} from "./Base.t.sol";

abstract contract OwnershipAct is OwnershipTest {

    function when_GetContractOwner() internal view returns (address owner_) {
        owner_ = o.owner();
    }

    function when_TransferOwnership(uint8 config, address _newOwner) internal {
        if (Errors(config)) {
            Execute(address(o), abi.encodeWithSelector(o.transferOwnership.selector, _newOwner));
        } else {
            o.transferOwnership(_newOwner);
        }
    }
}