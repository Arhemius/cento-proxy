// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Facet} from "cento/structs/Facet.sol";
import {$CentoProxyV2} from "interaction/CentoV2.sol";
import {$Execute} from "support/helpers/errors/_Execute.sol";
import {ErrorAssertions} from "support/helpers/errors/ErrorAssertions.sol";
import {ErrorBuilders} from "test/unit/libraries/cento/LibCento/AAA/ErrorBuilders.sol";

abstract contract CentoTest is Test, ErrorAssertions, $Execute, ErrorBuilders {

    address internal facetManager;
    address internal observability;
    address internal ownership;

    $CentoProxyV2 internal CentoProxy;
    address internal cento;

    function NO_FACETS()        internal pure returns (Facet[] memory)   {   return new Facet[](0);  }
    function NO_INTERFACES()    internal pure returns (bytes4[] memory)  {   return new bytes4[](0); }
    function NO_ADDRESS()       internal pure returns (address)          {   return     address(0);  }
    function NO_DATA()          internal pure returns (bytes memory)     {   return     "";          }

}