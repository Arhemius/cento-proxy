// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

library CentoCall {

    function _call(address target, bytes memory data) internal returns (bytes memory) {
        (bool ok, bytes memory ret) = target.call(data);
        if (!ok) _revert(ret);
        return ret;
    }

    function _call(address target, uint256 value, bytes memory data) internal returns (bytes memory) {
        (bool ok, bytes memory ret) = target.call{value: value}(data);
        if (!ok) _revert(ret);
        return ret;
    }

    function _staticcall(address target, bytes memory data) internal view returns (bytes memory) {
        (bool ok, bytes memory ret) = target.staticcall(data);
        if (!ok) _revert(ret);
        return ret;
    }

    function _delegatecall(address target, bytes memory data) internal returns (bytes memory) {
        (bool ok, bytes memory ret) = target.delegatecall(data);
        if (!ok) _revert(ret);
        return ret;
    }

    function _tryCall(address target, bytes memory data) internal returns (bool ok, bytes memory ret) {
        (ok, ret) = target.call(data);
    }

    function _tryCall(address target, uint256 value, bytes memory data) internal returns (bool ok, bytes memory ret) {
        (ok, ret) = target.call{value: value}(data);
    }

    function _tryStaticcall(address target, bytes memory data) internal view returns (bool ok, bytes memory ret) {
        (ok, ret) = target.staticcall(data);
    }

    function _tryDelegatecall(address target, bytes memory data) internal returns (bool ok, bytes memory ret) {
        (ok, ret) = target.delegatecall(data);
    }

    // you must do abi.encodeCall when calling this function
    function _append(uint8 facet, bytes memory data) internal pure returns (bytes memory) {
        assembly {
            let len := mload(data)
            mstore8(add(add(data, 0x20), len), facet)
            mstore(data, add(len, 1))
        }
        return data;
    }

    function _revert(bytes memory returndata) private pure {
        assembly {
            revert(add(returndata, 32), mload(returndata))
        }
    }
}