// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {IDiamondCut} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondCut.sol";

import {Dummy1v1} from "./Dummy1v1.sol";
import {Dummy2v1} from "./Dummy2v1.sol";
import {Dummy3v1} from "./Dummy3v1.sol";
import {Dummy4v1} from "./Dummy4v1.sol";
import {Dummy5v1} from "./Dummy5v1.sol";
import {Dummy1v2} from "./Dummy1v2.sol";
import {Dummy2v2} from "./Dummy2v2.sol";
import {Dummy3v2} from "./Dummy3v2.sol";
import {Dummy4v2} from "./Dummy4v2.sol";
import {Dummy5v2} from "./Dummy5v2.sol";

contract DummyCuts {

    address internal dummy1v1;
    address internal dummy2v1;
    address internal dummy3v1;
    address internal dummy4v1;
    address internal dummy5v1;
    address internal dummy1v2;
    address internal dummy2v2;
    address internal dummy3v2;
    address internal dummy4v2;
    address internal dummy5v2;

    IDiamondCut.FacetCut[] internal Add1Cut;
    IDiamondCut.FacetCut[] internal Upd1Cut;
    IDiamondCut.FacetCut[] internal Rem1Cut;
    IDiamondCut.FacetCut[] internal Add2Cuts;
    IDiamondCut.FacetCut[] internal Upd2Cuts;
    IDiamondCut.FacetCut[] internal Rem2Cuts;
    IDiamondCut.FacetCut[] internal Add5Cuts;
    IDiamondCut.FacetCut[] internal Upd5Cuts;
    IDiamondCut.FacetCut[] internal Rem5Cuts;

    bytes4[] internal dummy1Sigs;
    bytes4[] internal dummy2Sigs;
    bytes4[] internal dummy3Sigs;
    bytes4[] internal dummy4Sigs;
    bytes4[] internal dummy5Sigs;

    constructor() {
        createDummies();
        createSigs();
        create1Cuts();
        create2Cuts();
        create5Cuts();
    }

    function createDummies() private {
        dummy1v1 = address(new Dummy1v1());
        dummy2v1 = address(new Dummy2v1());
        dummy3v1 = address(new Dummy3v1());
        dummy4v1 = address(new Dummy4v1());
        dummy5v1 = address(new Dummy5v1());
        dummy1v2 = address(new Dummy1v2());
        dummy2v2 = address(new Dummy2v2());
        dummy3v2 = address(new Dummy3v2());
        dummy4v2 = address(new Dummy4v2());
        dummy5v2 = address(new Dummy5v2());
    }

    function create1Cuts() private {
        Add1Cut.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v1,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: dummy1Sigs
        }));

        Upd1Cut.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v2,
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: dummy1Sigs
        }));

        Rem1Cut.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v2,
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: dummy1Sigs
        }));
    }

    function create2Cuts() private {
        Add2Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v1,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: dummy1Sigs
        }));
        Add2Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy2v1,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: dummy2Sigs
        }));

        Upd2Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v2,
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: dummy1Sigs
        }));
        Upd2Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy2v2,
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: dummy2Sigs
        }));

        Rem2Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v2,
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: dummy1Sigs
        }));
        Rem2Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy2v2,
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: dummy2Sigs
        }));
    }

    function create5Cuts() private {
        Add5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v1,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: dummy1Sigs
        }));
        Add5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy2v1,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: dummy2Sigs
        }));
        Add5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy3v1,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: dummy3Sigs
        }));
        Add5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy4v1,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: dummy4Sigs
        }));
        Add5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy5v1,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: dummy5Sigs
        }));


        Upd5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v2,
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: dummy1Sigs
        }));
        Upd5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy2v2,
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: dummy2Sigs
        }));
        Upd5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy3v2,
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: dummy3Sigs
        }));
        Upd5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy4v2,
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: dummy4Sigs
        }));
        Upd5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy5v2,
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: dummy5Sigs
        }));

        Rem5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy1v2,
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: dummy1Sigs
        }));
        Rem5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy2v2,
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: dummy2Sigs
        }));
        Rem5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy3v2,
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: dummy3Sigs
        }));
        Rem5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy4v2,
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: dummy4Sigs
        }));
        Rem5Cuts.push(IDiamondCut.FacetCut({
            facetAddress: dummy5v2,
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: dummy5Sigs
        }));
    }

    function createSigs() private {
        dummy1Sigs = B4_(abi.encode(
            Dummy1v1.dummy1.selector,
            Dummy1v1.dummy2.selector,
            Dummy1v1.dummy3.selector,
            Dummy1v1.dummy4.selector,
            Dummy1v1.dummy5.selector,
            Dummy1v1.dummy6.selector,
            Dummy1v1.dummy7.selector,
            Dummy1v1.dummy8.selector,
            Dummy1v1.dummy9.selector,
            Dummy1v1.dummy10.selector
        ));
        dummy2Sigs = B4_(abi.encode(
            Dummy2v1.dummy11.selector,
            Dummy2v1.dummy12.selector,
            Dummy2v1.dummy13.selector,
            Dummy2v1.dummy14.selector,
            Dummy2v1.dummy15.selector,
            Dummy2v1.dummy16.selector,
            Dummy2v1.dummy17.selector,
            Dummy2v1.dummy18.selector,
            Dummy2v1.dummy19.selector,
            Dummy2v1.dummy20.selector
        ));
        dummy3Sigs = B4_(abi.encode(
            Dummy3v1.dummy21.selector,
            Dummy3v1.dummy22.selector,
            Dummy3v1.dummy23.selector,
            Dummy3v1.dummy24.selector,
            Dummy3v1.dummy25.selector,
            Dummy3v1.dummy26.selector,
            Dummy3v1.dummy27.selector,
            Dummy3v1.dummy28.selector,
            Dummy3v1.dummy29.selector,
            Dummy3v1.dummy30.selector
        ));
        dummy4Sigs = B4_(abi.encode(
            Dummy4v1.dummy31.selector,
            Dummy4v1.dummy32.selector,
            Dummy4v1.dummy33.selector,
            Dummy4v1.dummy34.selector,
            Dummy4v1.dummy35.selector,
            Dummy4v1.dummy36.selector,
            Dummy4v1.dummy37.selector,
            Dummy4v1.dummy38.selector,
            Dummy4v1.dummy39.selector,
            Dummy4v1.dummy40.selector
        ));
        dummy5Sigs = B4_(abi.encode(
            Dummy5v1.dummy41.selector,
            Dummy5v1.dummy42.selector,
            Dummy5v1.dummy43.selector,
            Dummy5v1.dummy44.selector,
            Dummy5v1.dummy45.selector,
            Dummy5v1.dummy46.selector,
            Dummy5v1.dummy47.selector,
            Dummy5v1.dummy48.selector,
            Dummy5v1.dummy49.selector,
            Dummy5v1.dummy50.selector
        ));
    }
}