// SPDX-License-Identifier: MIT

/**
 * protect against re-entrancy by using  a global flag
 */
pragma solidity ^0.8.9;

import "./IReEntrancyGuard.sol";


abstract contract ReEntrancyGuard is IReEntrancyGuard {

    struct reentrantStateStruct {
        bool lock;
    }

    reentrantStateStruct private _reentrantState;

    modifier nonReentrant() {
        // re-entrancyy check
        require(!detected(), "Reentrancy not allowed");

        begin();
        _;
    }
    
    function detected() public override      returns (bool) {
        return _reentrantState.lock;
    }

    function begin() public override {
        _reentrantState.lock = true;
    }

    function end() public override {
        _reentrantState.lock = false;
    }

}