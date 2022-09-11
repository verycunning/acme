//SPDX-License-Identifier: UNLICENSED
// v0001

pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract AcmeAllInOne {
    // Global state variable

    enum orderStatusEnum {
        ONORDER,
        PAID,
        DELIVERED,
        CANCELLED
    }
    struct orderRecordStruct {
        address customer;
        uint256 quantity;
        uint256 price;
        orderStatusEnum status;
    }

    struct globalStateStruct {
        // accesss control
        address admin;
        address treasurer;
        uint32 numberOfManagers; // allow multiple managers
        mapping(address => bool) managers;
        // reentrancy lock
        bool lock;
        //Stock Balances
        mapping(address => uint256) widgets;
        mapping(address => uint256) onOrder;
        mapping(address => uint256) delivered;
        uint256 widgetPrice;
        // orders
        mapping(uint32 => orderRecordStruct) orders;
        uint32 orderNum;
    }

    globalStateStruct private globalState;

    /*
     *
     * Modifiers
     *
     */
    modifier onlyTreasurer() {
        if (msg.sender != globalState.treasurer) {
            revert Unauthorized();
        }
        _;
    }
    modifier onlyAdmin() {
        if (msg.sender != globalState.admin) {
            revert Unauthorized();
        }
        _;
    }

    modifier onlyManagers() {
        if (globalState.managers[msg.sender] != true) {
            revert Unauthorized();
        }
        _;
    }

    modifier nonReentrant() {
        // re-entrancyy check
        require(!globalState.lock, "Reentrancy not allowed");

        globalState.lock = true;
        _;
    }

    function endReentrancyGuard() private {
        globalState.lock = false;
    }

    /*
     *
     * errors
     *
     */

    error Unauthorized();
    error AlreadyRegistered(address account);

    /*
     *
     * events
     *
     */

    event ChangeAdmin(address newAdmin);
    event ChangeTreasurer(address newTreasurer);
    event NewManager(address newManager);
    event CancelManager(address oldManager);

    constructor(address _treasurer, uint256 widgetPrice) {
        require(widgetPrice > 0);
        // grant admin to sender
        globalState.admin = msg.sender;
        globalState.treasurer = _treasurer;

        // initialise index

        globalState.numberOfManagers = 0;
        globalState.lock = false;

        globalState.widgetPrice = widgetPrice;
    }

    function grantAdminRole(address newAdmin) public onlyAdmin {
        globalState.admin = newAdmin;
        emit ChangeAdmin(newAdmin);
    }

    function grantTreasurerRole(address newTreasurer) public onlyAdmin {
        globalState.treasurer = newTreasurer;
        emit ChangeTreasurer(newTreasurer);
    }

    function registerManager(address newManager) public onlyAdmin {
        globalState.managers[newManager] = true;
        globalState.numberOfManagers++;
        emit NewManager(newManager);
    }

    function cancelManager(address Manager) public onlyAdmin {
        if (globalState.managers[Manager] != true) {
            revert Unauthorized();
        }
        globalState.managers[Manager] = false;
        globalState.numberOfManagers--;
        emit CancelManager(Manager);
    }

    function setPrice(uint256 newPrice) public onlyTreasurer {}

    function makeWidgets(uint256 _quantity) public onlyManagers nonReentrant {
        if (_quantity < 0) {
            revert Unauthorized();
        }
        globalState.widgets[globalState.treasurer] += _quantity;
        endReentrancyGuard();
    }

    function buyWidgets(uint256 _quantity) public payable nonReentrant {}
} // End Contract
