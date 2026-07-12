// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";

abstract contract DiamondTest is Test {

    address internal diamond;

    function NO_ADDRESS()       internal pure returns (address)          {   return     address(0);  }
    function NO_DATA()          internal pure returns (bytes memory)     {   return     "";          }

}