// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProjectX.sol";
// Import Ownable from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/access/Ownable.sol";
// Import EnumerableMap from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";



contract ProjectXFactory is Ownable {

    using EnumerableSet for EnumerableSet.AddressSet;

    address private _owner;
    // Declare a set state variable
    EnumerableSet.AddressSet private _users;
    mapping(address => address) _userContractMap;

    constructor() {
        _owner = msg.sender;
    }


    function deployProjectX(bool withdrawable) public {
        require(!EnumerableSet.contains(_users, msg.sender), "The user already exists.");
        EnumerableSet.add(_users, msg.sender);
        address newContract = address(new ProjectX(msg.sender, withdrawable));
        _userContractMap[msg.sender] = newContract;
        emit NewProjectXDeployed(msg.sender, newContract);
    }

    event NewProjectXDeployed(address indexed caller, address contractAddress);

}
