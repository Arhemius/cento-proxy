// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title Counter Storage
/// @notice Storage layout for the example counter protocol.
struct CounterStorage {
    /// @dev Current counter value.
    uint256 count;
}

/// @title Counter V1
/// @author Artem Buchikhin *(@Arhemius)*
/// @notice Example protocol using an ERC-7201 storage namespace.
/// @dev Used as the initial version in the migration example.
contract CounterV1 {
    
    // if not linter, could be written as (needs ^0.8.35): bytes32(erc7201("counter.base.slot"));
    /// @dev ERC-7201 namespace backing `CounterStorage`.
    bytes32 private constant BASE_SLOT = keccak256(abi.encode(uint256(keccak256(bytes("counter.base.slot")
    )) - 1)) & ~bytes32(uint256(0xff));

    /// @dev Returns the example storage layout.
    function _cs() private pure returns (CounterStorage storage cs) {
        bytes32 position = BASE_SLOT;
        assembly { cs.slot := position }
    }

    /// @notice Increments the counter.
    function inc() external {
        _cs().count += 1;
    } 
}