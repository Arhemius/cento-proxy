// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract FacetManager layout at 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00 { 

    // ---------------------------
    // Storage
    // ---------------------------
    address[] internal facets;
    uint256[] internal emptySlots;

    // ---------------------------
    // Events (DiamondCut-like traceability)
    // ---------------------------
    event FacetAdded(uint256 indexed index, address facet);
    event FacetRemoved(uint256 indexed index);
    event FacetUpdated(uint256 indexed index, address oldFacet, address newFacet);

    // ============================================================
    // CORE OPERATIONS
    // ============================================================

    // ---------------------------
    // Add facet (reuse slot if available)
    // ---------------------------
    function addFacet(address facet) external returns (uint256 index) {
        require(facet != address(0), "Invalid facet");

        if (emptySlots.length > 0) {
            index = emptySlots[emptySlots.length - 1];
            emptySlots.pop();

            facets[index] = facet;
        } else {
            index = facets.length;
            facets.push(facet);
        }

        emit FacetAdded(index, facet);
    }

    // ---------------------------
    // Get length (Loupe-style)
    // ---------------------------
    function facetsLength() external view returns (uint256) {
        return facets.length;
    }

    // ---------------------------
    // Get facet at index
    // ---------------------------
    function facetAt(uint256 index) external view returns (address) {
        require(index < facets.length, "Out of bounds");
        return facets[index];
    }

    // ---------------------------
    // Get all facets (includes empty slots)
    // ---------------------------
    function getAllFacets() external view returns (address[] memory) {
        return facets;
    }

    // ---------------------------
    // Check if slot is empty
    // ---------------------------
    function isEmpty(uint256 index) external view returns (bool) {
        require(index < facets.length, "Out of bounds");
        return facets[index] == address(0);
    }

    // ============================================================
    // UPDATE / REMOVE
    // ============================================================

    // ---------------------------
    // Update facet (DiamondCut-like replace)
    // ---------------------------
    function updateFacet(uint256 index, address newFacet) external {
        require(index < facets.length, "Out of bounds");
        require(newFacet != address(0), "Invalid facet");
        require(facets[index] != address(0), "Empty slot");

        address old = facets[index];
        facets[index] = newFacet;

        emit FacetUpdated(index, old, newFacet);
    }

    // ---------------------------
    // Remove facet (tombstone model)
    // ---------------------------
    function removeFacet(uint256 index) external {
        require(index < facets.length, "Out of bounds");
        require(facets[index] != address(0), "Already empty");

        facets[index] = address(0);
        emptySlots.push(index);

        emit FacetRemoved(index);
    }

    // ============================================================
    // DIAMOND-CUT STYLE BATCH OPERATION
    // ============================================================

    struct FacetUpdate {
        uint256 index;
        address newFacet;
    }

    function applyBatch(
        uint256[] calldata toRemove,
        address[] calldata toAdd,
        FacetUpdate[] calldata toUpdate
    ) external {
        // ---------------------------
        // REMOVE (mark + free slot)
        // ---------------------------
        for (uint256 i = 0; i < toRemove.length; i++) {
            uint256 index = toRemove[i];

            require(index < facets.length, "OOB");
            require(facets[index] != address(0), "Empty");

            facets[index] = address(0);
            emptySlots.push(index);

            emit FacetRemoved(index);
        }

        // ---------------------------
        // UPDATE (replace in-place)
        // ---------------------------
        for (uint256 i = 0; i < toUpdate.length; i++) {
            uint256 index = toUpdate[i].index;
            address newFacet = toUpdate[i].newFacet;

            require(index < facets.length, "OOB");
            require(newFacet != address(0), "Invalid");
            require(facets[index] != address(0), "Empty");

            address old = facets[index];
            facets[index] = newFacet;

            emit FacetUpdated(index, old, newFacet);
        }

        // ---------------------------
        // ADD (reuse slots first)
        // ---------------------------
        for (uint256 i = 0; i < toAdd.length; i++) {
            address facet = toAdd[i];
            require(facet != address(0), "Invalid");

            uint256 index;

            if (emptySlots.length > 0) {
                index = emptySlots[emptySlots.length - 1];
                emptySlots.pop();

                facets[index] = facet;
            } else {
                index = facets.length;
                facets.push(facet);
            }

            emit FacetAdded(index, facet);
        }
    }

    // ============================================================
    // LOUPE EXTENSIONS (optional but useful)
    // ============================================================

    function getFacetIndices() external view returns (uint256[] memory indices) {
        uint256 count;

        for (uint256 i = 0; i < facets.length; i++) {
            if (facets[i] != address(0)) {
                count++;
            }
        }

        indices = new uint256[](count);

        uint256 j;
        for (uint256 i = 0; i < facets.length; i++) {
            if (facets[i] != address(0)) {
                indices[j++] = i;
            }
        }
    }

    function getActiveFacets() external view returns (address[] memory active) {
        uint256 count;

        for (uint256 i = 0; i < facets.length; i++) {
            if (facets[i] != address(0)) {
                count++;
            }
        }

        active = new address[](count);

        uint256 j;
        for (uint256 i = 0; i < facets.length; i++) {
            if (facets[i] != address(0)) {
                active[j++] = facets[i];
            }
        }
    }
}