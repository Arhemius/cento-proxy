// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract DiamondRouter { 

    bytes32 constant FACET_START = 0x9470400c7fdb8128f3aa363e8652b960f10660822a80861e4d57916224d30600;
    
    fallback() external payable { 
        assembly {
            let index := byte(0, calldataload(sub(calldatasize(), 1)))
            let facet := sload(add(FACET_START, index))
            calldatacopy(0, 0, sub(calldatasize(), 1))
            let result := delegatecall(gas(), facet, 0, sub(calldatasize(), 1), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) } 
        }
    }
}
