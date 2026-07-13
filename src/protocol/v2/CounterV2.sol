// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/**
 * @notice Second version of example Counter with new approach to 
 *      storage layout and additional function
 * @dev Given approach to storage layout prevents this contract from being inherited by other 
 *      contracts in tests, which makes storage harnessing require a different approach (vm.store).
 *      You also cannot restrict the storage layout in tests the same way.
 */
contract CounterV2 layout at erc7201("counter.base.slot") {

    uint256 count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}