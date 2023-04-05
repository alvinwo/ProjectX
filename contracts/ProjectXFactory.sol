// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0.0;

import "./ProjectX.sol";
import "./ProjectXToken.sol";
// Import Ownable from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/access/Ownable.sol";
// Import EnumerableMap from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";



contract ProjectXFactory is Ownable {

    using EnumerableSet for EnumerableSet.AddressSet;

    address private _owner;
    ProjectXToken private _tokenContract;
    // Declare a set state variable
    EnumerableSet.AddressSet private _users;
    mapping(address => address) _userContractMap;

    constructor() {
        _owner = msg.sender;
        address[] memory defaultOperators;
        _tokenContract = new ProjectXToken(1000, defaultOperators);
    }


    function deployProjectX(bool withdrawable) public {
        require(!EnumerableSet.contains(_users, msg.sender), "The user already exists.");
        EnumerableSet.add(_users, msg.sender);
        address newContract = address(new ProjectX(msg.sender, withdrawable));
        _userContractMap[msg.sender] = newContract;
        emit NewProjectXDeployed(msg.sender, newContract);
    }

    function mintForTrigger(address trigger, uint256 amount) public {
        require(EnumerableSet.contains(_users, msg.sender), "The caller doesn't have access to this method.");
        _tokenContract.mint(trigger, amount, "", "");
    }

    function getTokenContract() public view returns (address) {
        return address(_tokenContract);
    }

    event NewProjectXDeployed(address indexed caller, address contractAddress);

}
