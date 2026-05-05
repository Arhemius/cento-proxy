// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

type Op is bytes4;

/*//////////////////////////////////////////////////////////////
                        OP SELECTORS
//////////////////////////////////////////////////////////////*/

Op constant add     = Op.wrap(bytes4(keccak256("_add(uint256,uint256,uint256)")));
Op constant mul     = Op.wrap(bytes4(keccak256("_mul(uint256,uint256,uint256)")));
Op constant sub     = Op.wrap(bytes4(keccak256("_sub(uint256,uint256,uint256)")));

Op constant gt      = Op.wrap(bytes4(keccak256("_gt(uint256,uint256,uint256)")));
Op constant lt      = Op.wrap(bytes4(keccak256("_lt(uint256,uint256,uint256)")));
Op constant eq      = Op.wrap(bytes4(keccak256("_eq(uint256,uint256,uint256)")));

Op constant and     = Op.wrap(bytes4(keccak256("_and(uint256,uint256,uint256)")));
Op constant or      = Op.wrap(bytes4(keccak256("_or(uint256,uint256,uint256)")));
Op constant shl     = Op.wrap(bytes4(keccak256("_shl(uint256,uint256,uint256)")));
Op constant shr     = Op.wrap(bytes4(keccak256("_shr(uint256,uint256,uint256)")));

Op constant diff    = Op.wrap(bytes4(keccak256("_diff(uint256,uint256,uint256)")));

Op constant expand  = Op.wrap(bytes4(keccak256("_expand(uint256,uint256,uint256)")));
Op constant sum     = Op.wrap(bytes4(keccak256("_sum(uint256,uint256,uint256)")));

Op constant split   = Op.wrap(bytes4(keccak256("_split(uint256,uint256,uint256)")));
Op constant dup     = Op.wrap(bytes4(keccak256("_duplicate(uint256,uint256,uint256)")));