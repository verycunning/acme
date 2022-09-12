// SPDX-License-Identifier: MIT

/**
 * Customer Order Contract
 * 
 * Allows manager to register/deregister a customer address
 * Allows registered customers to order stock, check on order status 
 * 
 */
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./AcmeStorageInterface.sol";

/*
 * @dev

*/

contract AcmeCustomerOrder is AccessControl, ReEntrancyGuard {
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");

    constructor () {

    }

    function customerOrder(uint256 quantity)  public payable nonReentrant returns (bool ) {
        
    }


} 