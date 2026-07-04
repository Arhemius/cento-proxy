// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {IDiamondCut} from "test/gas/cento/diamond-2/src/interfaces/IDiamondCut.sol";

import {Dummy1}  from "./Dummy1.sol";
import {Dummy2}  from "./Dummy2.sol";
import {Dummy3}  from "./Dummy3.sol";
import {Dummy4}  from "./Dummy4.sol";
import {Dummy5}  from "./Dummy5.sol";
import {Dummy6}  from "./Dummy6.sol";
import {Dummy7}  from "./Dummy7.sol";
import {Dummy8}  from "./Dummy8.sol";
import {Dummy9}  from "./Dummy9.sol";
import {Dummy10} from "./Dummy10.sol";

contract DummyCuts {

    IDiamondCut.FacetCut[] internal cuts;

    constructor() {
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy1()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy1.dummy1.selector,
                Dummy1.dummy2.selector,
                Dummy1.dummy3.selector,
                Dummy1.dummy4.selector,
                Dummy1.dummy5.selector,
                Dummy1.dummy6.selector,
                Dummy1.dummy7.selector,
                Dummy1.dummy8.selector,
                Dummy1.dummy9.selector,
                Dummy1.dummy10.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy2()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy2.dummy11.selector,
                Dummy2.dummy12.selector,
                Dummy2.dummy13.selector,
                Dummy2.dummy14.selector,
                Dummy2.dummy15.selector,
                Dummy2.dummy16.selector,
                Dummy2.dummy17.selector,
                Dummy2.dummy18.selector,
                Dummy2.dummy19.selector,
                Dummy2.dummy20.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy3()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy3.dummy21.selector,
                Dummy3.dummy22.selector,
                Dummy3.dummy23.selector,
                Dummy3.dummy24.selector,
                Dummy3.dummy25.selector,
                Dummy3.dummy26.selector,
                Dummy3.dummy27.selector,
                Dummy3.dummy28.selector,
                Dummy3.dummy29.selector,
                Dummy3.dummy30.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy4()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy4.dummy31.selector,
                Dummy4.dummy32.selector,
                Dummy4.dummy33.selector,
                Dummy4.dummy34.selector,
                Dummy4.dummy35.selector,
                Dummy4.dummy36.selector,
                Dummy4.dummy37.selector,
                Dummy4.dummy38.selector,
                Dummy4.dummy39.selector,
                Dummy4.dummy40.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy5()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy5.dummy41.selector,
                Dummy5.dummy42.selector,
                Dummy5.dummy43.selector,
                Dummy5.dummy44.selector,
                Dummy5.dummy45.selector,
                Dummy5.dummy46.selector,
                Dummy5.dummy47.selector,
                Dummy5.dummy48.selector,
                Dummy5.dummy49.selector,
                Dummy5.dummy50.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy6()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy6.dummy51.selector,
                Dummy6.dummy52.selector,
                Dummy6.dummy53.selector,
                Dummy6.dummy54.selector,
                Dummy6.dummy55.selector,
                Dummy6.dummy56.selector,
                Dummy6.dummy57.selector,
                Dummy6.dummy58.selector,
                Dummy6.dummy59.selector,
                Dummy6.dummy60.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy7()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy7.dummy61.selector,
                Dummy7.dummy62.selector,
                Dummy7.dummy63.selector,
                Dummy7.dummy64.selector,
                Dummy7.dummy65.selector,
                Dummy7.dummy66.selector,
                Dummy7.dummy67.selector,
                Dummy7.dummy68.selector,
                Dummy7.dummy69.selector,
                Dummy7.dummy70.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy8()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy8.dummy71.selector,
                Dummy8.dummy72.selector,
                Dummy8.dummy73.selector,
                Dummy8.dummy74.selector,
                Dummy8.dummy75.selector,
                Dummy8.dummy76.selector,
                Dummy8.dummy77.selector,
                Dummy8.dummy78.selector,
                Dummy8.dummy79.selector,
                Dummy8.dummy80.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy9()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy9.dummy81.selector,
                Dummy9.dummy82.selector,
                Dummy9.dummy83.selector,
                Dummy9.dummy84.selector,
                Dummy9.dummy85.selector,
                Dummy9.dummy86.selector,
                Dummy9.dummy87.selector,
                Dummy9.dummy88.selector,
                Dummy9.dummy89.selector,
                Dummy9.dummy90.selector
            ))
        }));
        cuts.push(IDiamondCut.FacetCut({
            facetAddress: address(new Dummy10()),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: B4_(abi.encode(
                Dummy10.dummy91.selector,
                Dummy10.dummy92.selector,
                Dummy10.dummy93.selector,
                Dummy10.dummy94.selector,
                Dummy10.dummy95.selector,
                Dummy10.dummy96.selector,
                Dummy10.dummy97.selector,
                Dummy10.dummy98.selector,
                Dummy10.dummy99.selector,
                Dummy10.dummy100.selector
            ))
        }));
    }

}