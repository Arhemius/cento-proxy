// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {ErrorContext} from "./ErrorContext.sol";

abstract contract ErrorBuildersBasic is ErrorContext {

    function $Error(string memory _error) internal pure returns (Error memory) {
        return Error({
            selector: bytes4(0x08c379a0),
            data: abi.encode(_error)
        });
    }

    function $Panic(uint256 _errorCode) internal pure returns (Error memory) {
        return Error({
            selector: bytes4(0x4e487b71),
            data: abi.encode(_errorCode)
        });
    }

    function $Empty() internal pure returns (Error memory) {
        return Error({
            selector: bytes4(0),
            data: ""
        });
    }

}

