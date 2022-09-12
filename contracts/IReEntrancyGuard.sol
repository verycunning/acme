// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;



interface IReEntrancyGuard {

 

    function detected() external returns(bool);

    function begin() external; 
    function end() external; 

}

