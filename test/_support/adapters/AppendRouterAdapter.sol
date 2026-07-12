// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract AppendRouterAdapter {

    address immutable router;

    constructor(address _router) {
        router = _router;
    }

    function owner(bytes memory data) external view returns (address) {
        assembly {
            let len := mload(data)
            mstore8(add(add(data, 0x20), len), 1) // 1 is index of Observability facet
            mstore(data, add(len, 1))
        }
        (bool ok, bytes memory ret) = router.staticcall(data);
        if (!ok) _revert(ret);
        return abi.decode(ret, (address));
    }

    function _revert(bytes memory returndata) private pure {
        assembly {
            revert(add(returndata, 32), mload(returndata))
        }
    }
}