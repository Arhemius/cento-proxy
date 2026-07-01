// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

library Word {

    function word(bytes memory data) internal pure returns (uint256[] memory out) {
        uint len = data.length / 32;
        out = new uint256[](len);
        for (uint i; i < len; i++) {
            assembly {
                mstore(
                    add(add(out, 0x20), mul(i, 0x20)),
                    mload(add(add(data, 0x20), mul(i, 0x20)))
                )
            }
        }
    }
    
}