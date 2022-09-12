pragma solidity ^0.8.9;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AcmeStorage is AccessControl {


    struct globalStateStruct {
        mapping (uint256 => uint256) price;

    } 
    globalStateStruct private _state;
    /**
     * @dev returnd the unit price stored in location id
     */

    constructor () {
        
    }

    function unitPrice(uint256 id) external view returns (uint256) {
        return 1;
    }


    
}