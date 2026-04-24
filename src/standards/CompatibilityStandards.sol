// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { DiamondLib } from "../libraries/DiamondLib.sol";

contract CompatibilityStandards {

    function delegate(uint8 index) internal {
        bytes32 start = DiamondLib.BASE_SLOT;
        assembly {
            let facet := sload(add(start, index))
            if iszero(facet) { revert(0, 0) }
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) } 
        }
    }

    function supportsInterface(bytes4) external returns (bool) { delegate(0); }
}