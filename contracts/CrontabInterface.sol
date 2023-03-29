// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface CrontabInterface {
    struct Job {
        bool isValid;
        string title;
        string description;
        uint256 reward;
        uint256 expiration;
        uint256 lastExecutionTime;
        uint256 lastExecutionBlock;
        uint[] conditionsList;
        uint[] actionList;
    }

    struct ConditionDefinition {
        ConditionType conditionType;
        // should only be used for the TIME_BASED conditions and CONTRACT_INTERACTION_BASED conditions
        uint256 timeInterval;
        // should only be used for the BLOCK_BASED conditions and CONTRACT_INTERACTION_BASED conditions
        uint256 blockNumberInterval;
        // TODO support contract condition later
    }

    enum ConditionOperator {
        AND,
        OR
    }

    enum ConditionType {
        TIME_BASED,
        BLOCK_BASED,
        CONTRACT_INTERACTION_BASED
    }

    struct ActionDefinition {
        ActionType actionType;
        address targetAddress;
        uint256 value;
    }

    enum ActionType {
        TRANSFER
    }

    // function getAllJobs() external view virtual returns (Job[] memory);

    // function getJob(uint jobId) external view returns (Job memory);

    function createCondition(
        ConditionType conditionType,
        uint256 timeInterval,
        uint256 blockNumberInterval
    ) external returns (uint);

    function createAction(
        ActionType actionType,
        address targetAddress,
        uint256 value
    ) external returns (uint);

    function createJob(
        string memory title,
        string memory description,
        uint256 reward,
        uint256 expiration,
        uint[] memory conditions,
        uint[] memory actions
    ) external returns (uint);

    // function manageJob(
    //     uint jobId,
    //     Job memory job,
    //     ConditionOperator operator,
    //     ConditionDefinition[] memory conditions
    // ) external;

    function deposit() external payable;

    // the onwer could withdraw the deposited assets
    function withdraw(uint256 value) external returns (bool);

    function getOwner() external view returns (address);

    // function triggerJob(uint jobId) external;

    event Deposit(address indexed owner, uint256 value);
    event Withdraw(address indexed owner, uint256 value);
    event ActionAdded(address indexed owner, uint actionId, ActionDefinition action);
    event ConditionAdded(address indexed owner, uint conditionId, ConditionDefinition condition);
    // event JobAdded(address indexed _owner, Job job);
    // event JobModified(address indexed _owner, Job job);
    // event JobRemoved(address indexed _owner, Job job);
    // event JobExecuted(address indexed _owner, address indexed trigger, Job job);
}
