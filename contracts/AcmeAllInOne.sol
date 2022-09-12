//SPDX-License-Identifier: UNLICENSED
// v0001

pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract AcmeAllInOne {
    // Global state variable

    enum orderStatusEnum {
        ORDERED,
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

    globalStateStruct private _globalState;

    /*
     *
     * Modifiers
     *
     */
    modifier onlyTreasurer() {
        if (msg.sender != _globalState.treasurer) {
            revert Unauthorized();
        }
        _;
    }
    modifier onlyAdmin() {
        if (msg.sender != _globalState.admin) {
            revert Unauthorized();
        }
        _;
    }

    modifier onlyManagers() {
        if (_globalState.managers[msg.sender] != true) {
            revert Unauthorized();
        }
        _;
    }

    modifier nonReentrant() {
        // re-entrancyy check
        require(!_globalState.lock, "Reentrancy not allowed");

        _globalState.lock = true;
        _;
    }

    function endReentrancyGuard() private {
        _globalState.lock = false;
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

    event ChangeAdmin(address admin);
    event ChangeTreasurer(address treasurer);
    event NewManager(address manager);
    event CancelManager(address manager);

    constructor(address treasurer, uint256 widgetPrice) {
        require(widgetPrice > 0);
        // grant admin to sender
        _globalState.admin = msg.sender;
        _globalState.treasurer = treasurer;

        // initialise index

        _globalState.numberOfManagers = 0;
        _globalState.lock = false;

        _globalState.widgetPrice = widgetPrice;
    }

    function grantAdminRole(address admin) public onlyAdmin {
        _globalState.admin = admin;
        emit ChangeAdmin(admin);
    }

    function grantTreasurerRole(address treasurer) public onlyAdmin {
        _globalState.treasurer = treasurer;
        emit ChangeTreasurer(treasurer);
    }

    function registerManager(address manager) public onlyAdmin {
        _globalState.managers[manager] = true;
        _globalState.numberOfManagers++;
        emit NewManager(manager);
    }

    function cancelManager(address manager) public onlyAdmin {
        if (_globalState.managers[manager] != true) {
            revert Unauthorized();
        }
        _globalState.managers[manager] = false;
        _globalState.numberOfManagers--;
        emit CancelManager(manager);
    }

    function setPrice(uint256 price) public onlyTreasurer {}

    function makeWidgets(uint256 _quantity) public onlyManagers nonReentrant {
        if (_quantity < 0) {
            revert Unauthorized();
        }
        _globalState.widgets[_globalState.treasurer] += _quantity;
        endReentrancyGuard();
    }

    function buyWidgets(uint256 _quantity) public payable nonReentrant {}
} // End Contract
