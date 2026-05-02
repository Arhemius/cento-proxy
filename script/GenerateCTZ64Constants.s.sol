// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// forge-lint: disable-next-line(unaliased-plain-import)
import {console2, Script} from "../lib/forge-std/src/Script.sol";

contract GenerateCTZ64Constants is Script {
    uint64 internal constant MAGIC = 0x03f79d71b4cb0a89;

    function run() external pure {
        require(_isValidMagic(MAGIC), "invalid magic");
        (bytes32 table0, bytes32 table1) = _buildTables(MAGIC);
        console2.log("MAGIC:");
        console2.logBytes32(bytes32(uint256(MAGIC)));
        console2.log("TABLE_0:");
        console2.logBytes32(table0);
        console2.log("TABLE_1:");
        console2.logBytes32(table1);
    }

    function _isValidMagic(uint64 magic) internal pure returns (bool) {
        bool[64] memory seen;
        unchecked {
            for (uint8 i = 0; i < 64; i++) {
                uint64 v = uint64(1) << i;
                uint64 prod = v * magic; // 64-bit wrap is the key
                // forge-lint: disable-next-line(unsafe-typecast)
                uint8 idx = uint8(prod >> 58);
                if (seen[idx]) return false;
                seen[idx] = true;
            }
        }
        return true;
    }

    function _buildTables(uint64 magic) internal pure returns (bytes32 t0, bytes32 t1) {
        uint8[64] memory table;
        unchecked {
            for (uint8 i = 0; i < 64; i++) {
                uint64 v = uint64(1) << i;
                uint64 prod = v * magic; // 64-bit wrap
                // forge-lint: disable-next-line(unsafe-typecast)
                uint8 idx = uint8(prod >> 58);
                table[idx] = i;
            }
        }
        for (uint256 i = 0; i < 32; i++) {
            t0 |= bytes32(uint256(table[i]) << (i * 8));
        }
        for (uint256 i = 0; i < 32; i++) {
            t1 |= bytes32(uint256(table[i + 32]) << (i * 8));
        }
    }
}