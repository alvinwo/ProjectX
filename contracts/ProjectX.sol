// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CrontabInterface.sol";

contract ProjectX is CrontabInterface {
    address public _owner;
    bool _withdrawAble;

    constructor(bool withdrawAble) {
        _owner = msg.sender;
        _withdrawAble = withdrawAble;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    // modifier existingValidJob(uint jobId) {
    //     require(jobId >= 0, "jobId should be non-negative");
    //     // require(jobs[jobId] != 0, "job should exist");
    //     require(jobs[jobId].isValid, "job should be valid");
    //     _;
    // }

    // function createJob(
    //     JobData memory data,
    //     ConditionOperator operator,
    //     ConditionDefinition[] memory conditions
    // ) external override onlyOwner returns (uint) {
    //     uint jobId = jobNum + 1;
    //     ConditionSet memory conditionSet = ConditionSet({conditionSize: 0});
    //     Job memory job = Job(jobId, data, conditions, true, 0, 0);
    //     jobs[jobId] = job;
    //     // emit JobAdded(msg.sender, job);
    //     return jobId;
    // }

    // function manageJob(
    //     uint jobId,
    //     JobData memory data,
    //     ConditionOperator operator,
    //     ConditionDefinition[] memory conditions
    // ) external override onlyOwner existingValidJob(jobId) {
    //     Job memory job = Job(jobId, data, conditions, true, 0, 0);
    //     jobs[jobId] = job;
    //     // emit JobModified(msg.sender, job);
    // }

    function deposit() external override payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 value) external override onlyOwner returns (bool) {
        require(_withdrawAble, "It's not allowed to withdraw.");
        address payable self = payable(address(this));
        uint256 balance = self.balance;
        require(value <= balance, "The balance is not sufficient.");
        payable(msg.sender).transfer(value);
        emit Withdraw(msg.sender, value);
        return true;
    }

    function getOwner() external override view returns (address) {
        return _owner;
    }

    // function triggerJob(uint jobId) external existingValidJob(jobId) {
    //     Job memory job = jobs[jobId];
    // }
}
