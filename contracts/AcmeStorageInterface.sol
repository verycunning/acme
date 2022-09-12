pragma solidity ^0.8.9;
// SPDX-License-Identifier: MIT

interface AcmeStorage {

    /**
     * @dev return the unit price stored in location id
     */
    function unitPrice(uint256 id) external view returns (uint256);


    
}