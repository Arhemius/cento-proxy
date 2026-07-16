// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/**
 * @title Counter V2
 * @author Artem Buchikhin *(@Arhemius)*
 * @notice Second version of the example protocol.
 * @dev Demonstrates storage-preserving upgrades using Solidity's `layout at` syntax.
 * @dev This approach changes testing and harnessing techniques compared
 *      to explicit ERC-7201 storage accessors:
 *      - It prevents this contract from being inherited by test harnesses,
 *        requiring storage initialization through `vm.store`.
 *      - Harnessing internal functions becomes as difficult as harnessing private ones,
 *        so write them in other contracts without custom storage layout to harness them through inheritance.
 *      - `forge inspect` is now able to see the storage layout of your facet.
 */
// erc7201("counter.base.slot") - currently just paste the derived value (convert to number), because forge doc fails to parse it
contract CounterV2 layout at 39518324394806213189260563987892299317935672749922310793294473007566452181504 {

    /// @notice Current counter value.
    uint256 count; 

    /// @notice Increments the counter.
    function inc() external {
        count += 1;
    }

    /// @notice Decrements the counter.
    function dec() external {
        count -= 1;
    }
}