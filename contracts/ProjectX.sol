// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CrontabInterface.sol";

contract ProjectX is CrontabInterface {
    address private _factory;
    address private _owner;
    bool private _withdrawAble;
    bool private _paused;
    mapping(uint => Job) private _jobs;
    mapping(uint => ConditionDefinition) private _conditions;
    mapping(uint => ActionDefinition) private _actions;
    uint private _nextJobId;
    uint private _nextConditionId;
    uint private _nextActionId;

    constructor(address owner, bool withdrawAble) {
        _factory = msg.sender;
        _owner = owner;
        _withdrawAble = withdrawAble;
        _paused = false;
    }

    modifier onlyFactory() {
        require(msg.sender == _factory, "This method is only for the factory.");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "This method is only for the owner.");
        _;
    }

    modifier notPaused() {
        require(!_paused, "The contract is paused.");
        _;
    }

    modifier existingValidJob(uint jobId) {
        require(jobId >= 0 && jobId < _nextJobId, "The jobId doesn't exist");
        // require(jobs[jobId] != 0, "job should exist");
        require(_jobs[jobId].isValid, "The job should be valid.");
        _;
    }

    function createCondition(
        ConditionType conditionType,
        uint256 timeInterval,
        uint256 blockNumberInterval
    ) external override onlyOwner notPaused returns (uint) {
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
    ) external override onlyOwner notPaused returns (uint) {
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
    ) external override onlyOwner notPaused returns (uint) {
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

    function deposit() external payable override notPaused {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        uint256 value
    ) external override onlyOwner notPaused returns (bool) {
        require(_withdrawAble, "It's not allowed to withdraw.");
        _requireSufficientBalance(value);
        payable(msg.sender).transfer(value);
        emit Withdraw(msg.sender, value);
        return true;
    }

    function _requireSufficientBalance(uint256 value) private view {
        address payable self = payable(address(this));
        uint256 balance = self.balance;
        require(value <= balance, "The balance is not sufficient.");
    }

    function getOwner() external view override returns (address) {
        return _owner;
    }

    function triggerJob(uint jobId) external override notPaused existingValidJob(jobId) {
        Job memory job = _jobs[jobId];
        _checkAllConditions(job);
        // TODO incentives
        // TODO fees
        _executeActions(job);
        emit JobExecuted(_owner, msg.sender, jobId);
    }

    function _executeActions(Job memory job) private {
        for(uint i = 0; i < job.actionList.length; i++) {
            ActionDefinition memory action = _actions[job.actionList[i]];
            _executeAction(action);
        }
    }

    function _executeAction(ActionDefinition memory action) private {
        if(action.actionType == ActionType.TRANSFER) {
            _executeTransferAction(action);
        } else {
            revert();
        }
    }

    function _executeTransferAction(ActionDefinition memory action) private {
        _requireSufficientBalance(action.value);
        payable(action.targetAddress).transfer(action.value);
    }

    function _checkAllConditions(Job memory job) private view {
        for (uint i = 0; i < job.conditionsList.length; i++) {
            ConditionDefinition memory condition = _conditions[
                job.conditionsList[i]
            ];
            _checkCondition(job, condition);
        }
    }

    function _checkCondition(
        Job memory job,
        ConditionDefinition memory condition
    ) private view {
        if (condition.conditionType == ConditionType.TIME_BASED) {
            _checkTimeBasedCondition(job, condition);
        } else if (condition.conditionType == ConditionType.BLOCK_BASED) {
            _checkBlockBasedCondition(job, condition);
        } else {
            // TODO support contract based condition later
            revert();
        }
    }

    function _checkTimeBasedCondition(
        Job memory job,
        ConditionDefinition memory condition
    ) private view {
        require(
            condition.conditionType == ConditionType.TIME_BASED,
            "It's not a time based condition."
        );
        require(
            block.timestamp - job.lastExecutionTime >= condition.timeInterval,
            "The time based condition is't met"
        );
    }

    function _checkBlockBasedCondition(
        Job memory job,
        ConditionDefinition memory condition
    ) private view {
        require(
            condition.conditionType == ConditionType.BLOCK_BASED,
            "It's not a block based condition."
        );
        require(
            block.number - job.lastExecutionBlock >=
                condition.blockNumberInterval,
            "The block based condition is't met"
        );
    }

    function pause() external onlyFactory {
        require(!_paused, "The contract is already paused.");
        _paused = true;
    }

    function resume() external onlyFactory {
        require(_paused, "The contract is not paused.");
        _paused = false;
    }
}
