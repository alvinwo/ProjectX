// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CrontabInterface.sol";

contract ProjectX is CrontabInterface {
    address public _owner;
    bool _withdrawAble;
    mapping(uint => Job) _jobs;
    mapping(uint => ConditionDefinition) _conditions;
    mapping(uint => ActionDefinition) _actions;
    uint _nextJobId;
    uint _nextConditionId;
    uint _nextActionId;

    constructor(bool withdrawAble) {
        _owner = msg.sender;
        _withdrawAble = withdrawAble;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, 'This method is only for the owner.');
        _;
    }

    // modifier existingValidJob(uint jobId) {
    //     require(jobId >= 0, "jobId should be non-negative");
    //     // require(jobs[jobId] != 0, "job should exist");
    //     require(jobs[jobId].isValid, "job should be valid");
    //     _;
    // }

    function createCondition(
        ConditionType conditionType,
        uint256 timeInterval,
        uint256 blockNumberInterval
    ) external override onlyOwner returns (uint) {
        ConditionDefinition memory condition = ConditionDefinition(
            conditionType,
            timeInterval,
            blockNumberInterval
        );
        _conditions[_nextConditionId] = condition;
        emit ConditionAdded(msg.sender, _nextConditionId, condition);
        return _nextConditionId++;
    }

    function createAction(
        ActionType actionType,
        address targetAddress,
        uint256 value
    ) external override onlyOwner returns (uint) {
        ActionDefinition memory action = ActionDefinition(
            actionType,
            targetAddress,
            value
        );
        _actions[_nextActionId] = action;
        emit ActionAdded(msg.sender, _nextActionId, action);
        return _nextActionId++;
    }

    function createJob(
        string memory title,
        string memory description,
        uint256 reward,
        uint256 expiration,
        uint[] memory conditions,
        uint[] memory actions
    ) external override onlyOwner returns (uint) {
        Job memory job = Job(
            true,
            title,
            description,
            reward,
            expiration,
            0,
            0,
            conditions,
            actions
        );
        _jobs[_nextJobId] = job;
        emit JobAdded(_owner, _nextJobId, job);
        return _nextJobId++;
    }

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

    function deposit() external payable override {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        uint256 value
    ) external override onlyOwner returns (bool) {
        require(_withdrawAble, "It's not allowed to withdraw.");
        address payable self = payable(address(this));
        uint256 balance = self.balance;
        require(value <= balance, "The balance is not sufficient.");
        payable(msg.sender).transfer(value);
        emit Withdraw(msg.sender, value);
        return true;
    }

    function getOwner() external view override returns (address) {
        return _owner;
    }

    // function triggerJob(uint jobId) external existingValidJob(jobId) {
    //     Job memory job = jobs[jobId];
    // }
}
