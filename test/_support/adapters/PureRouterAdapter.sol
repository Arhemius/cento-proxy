// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract PureRouterAdapter {

    address immutable router;

    constructor(address _router) {
        router = _router;
    }

    function owner(bytes memory _calldata) external view returns (address) {
        (bool ok, bytes memory ret) = router.staticcall(_calldata);
        if (!ok) _revert(ret);
        return abi.decode(ret, (address));
    }

    function _revert(bytes memory returndata) private pure {
        assembly {
            revert(add(returndata, 32), mload(returndata))
        }
    }
}