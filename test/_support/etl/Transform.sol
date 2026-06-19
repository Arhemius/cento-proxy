// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// import { Op } from "./Constants.sol";

library Transform {

    /*//////////////////////////////////////////////////////////////
                          CORE CONVERTERS
    //////////////////////////////////////////////////////////////*/

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

    // function fromU256(uint256[] memory arr) internal pure returns (bytes memory out) {
    //     out = new bytes(arr.length * 32);
    //     for (uint i; i < arr.length; i++) {
    //         assembly {
    //             mstore(
    //                 add(add(out, 0x20), mul(i, 0x20)),
    //                 mload(add(add(arr, 0x20), mul(i, 0x20)))
    //             )
    //         }
    //     }
    // }

    // !!!!!!!! Replace staticcall approach with direct calls to internal functions by using function types.


    // /*//////////////////////////////////////////////////////////////
    //                           DISPATCH
    // //////////////////////////////////////////////////////////////*/

    // function _call(Op op_, uint256 x, uint256 y, uint256 i) internal view returns (uint256 r) {
    //     (bool ok, bytes memory ret) = address(this).staticcall(
    //         abi.encodeWithSelector(Op.unwrap(op_), x, y, i));
    //     require(ok, "op failed");
    //     r = abi.decode(ret, (uint256));
    // }

    // function _callArr(Op op_, uint256 x, uint256 y, uint256 i) internal view returns (uint256[] memory r) {
    //     (bool ok, bytes memory ret) = address(this).staticcall(
    //         abi.encodeWithSelector(Op.unwrap(op_), x, y, i));
    //     require(ok, "op failed");
    //     r = abi.decode(ret, (uint256[]));
    // }

    // /*//////////////////////////////////////////////////////////////
    //                       TRANSFORMATIONS
    // //////////////////////////////////////////////////////////////*/

    // function map(bytes memory data, Op op_, uint256 arg) internal view returns (bytes memory) {
    //     uint256[] memory arr = u256(data);
    //     for (uint i; i < arr.length; i++) {
    //         arr[i] = _call(op_, arr[i], arg, i);
    //     }
    //     return fromU256(arr);
    // }

    // function filter(bytes memory data, Op op_, uint256 arg) internal view returns (bytes memory) {
    //     uint256[] memory arr = u256(data);
    //     uint len = arr.length;
    //     uint count;
    //     for (uint i; i < len; i++) {
    //         if (_call(op_, arr[i], arg, i) != 0) count++;
    //     }
    //     uint256[] memory out = new uint256[](count);
    //     uint j;
    //     for (uint i; i < len; i++) {
    //         if (_call(op_, arr[i], arg, i) != 0) {
    //             out[j++] = arr[i];
    //         }
    //     }
    //     return fromU256(out);
    // }

    // function reduce(bytes memory data, Op op_, uint256 acc) internal view returns (uint256) {
    //     uint256[] memory arr = u256(data);
    //     for (uint i; i < arr.length; i++) {
    //         acc = _call(op_, acc, arr[i], i);
    //     }
    //     return acc;
    // }

    // function flatMap(bytes memory data, Op op_) internal view returns (bytes memory) {
    //     uint256[] memory arr = u256(data);
    //     uint total;
    //     for (uint i; i < arr.length; i++) {
    //         uint256[] memory tmp = _callArr(op_, arr[i], 0, i);
    //         total += tmp.length;
    //     }
    //     uint256[] memory out = new uint256[](total);
    //     uint k;
    //     for (uint i; i < arr.length; i++) {
    //         uint256[] memory tmp = _callArr(op_, arr[i], 0, i);
    //         for (uint j; j < tmp.length; j++) {
    //             out[k++] = tmp[j];
    //         }
    //     }
    //     return fromU256(out);
    // }

    // function zipWith(bytes memory a, bytes memory b, Op op_) internal view returns (bytes memory) {
    //     uint256[] memory X = u256(a);
    //     uint256[] memory Y = u256(b);
    //     uint len = X.length < Y.length ? X.length : Y.length;
    //     uint256[] memory out = new uint256[](len);
    //     for (uint i; i < len; i++) {
    //         out[i] = _call(op_, X[i], Y[i], i);
    //     }
    //     return fromU256(out);
    // }

    // function project(bytes memory data, uint stride, uint field) internal pure returns (bytes memory) {
    //     uint256[] memory arr = word(data);
    //     uint len = arr.length / stride;
    //     uint256[] memory out = new uint256[](len);
    //     for (uint i; i < len; i++) {
    //         out[i] = arr[i * stride + field];
    //     }
    //     return fromU256(out);
    // }

    // function skip(bytes memory data, uint n) internal pure returns (bytes memory) {
    //     uint256[] memory arr = u256(data);
    //     if (n >= arr.length) return new bytes(0);
    //     uint len = arr.length - n;
    //     uint256[] memory out = new uint256[](len);
    //     for (uint i; i < len; i++) {
    //         out[i] = arr[i + n];
    //     }
    //     return fromU256(out);
    // }

    // function tap(bytes memory data, Op op_) internal view returns (bytes memory) {
    //     uint256[] memory arr = u256(data);
    //     for (uint i; i < arr.length; i++) {
    //         _call(op_, arr[i], 0, i);
    //     }
    //     return data;
    // }
}