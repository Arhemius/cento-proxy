// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Facet} from "cento/structs/Facet.sol";
import {LibCentoTM} from "test/unit/libraries/cento/LibCento/AAA/_LibCentoTM.sol";
import {FacetManagerAdapter} from "support/adapters/FacetManagerAdapter.sol";

abstract contract FacetManagerTest is Test, LibCentoTM {

    FacetManagerAdapter internal fm;
    
    // === Empty Value Builders ===

    function NO_FACETS()        internal pure returns (Facet[] memory)   {   return new Facet[](0);  }
    function NO_INTERFACES()    internal pure returns (bytes4[] memory)  {   return new bytes4[](0); }
    function NO_ADDRESS()       internal pure returns (address)          {   return     address(0);  }
    function NO_DATA()          internal pure returns (bytes memory)     {   return     "";          }

}