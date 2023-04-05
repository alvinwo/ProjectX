// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ProjectXToken is ERC777, Ownable {
    constructor(
        uint256 initialSupply,
        address[] memory defaultOperators
    ) ERC777("PXToken", "PXT", defaultOperators) {
        _mint(msg.sender, initialSupply, "", "");
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * If a send hook is registered for `account`, the corresponding function
     * will be called with the caller address as the `operator` and with
     * `userData` and `operatorData`.
     *
     * See {IERC777Sender} and {IERC777Recipient}.
     *
     * Emits {Minted} and {IERC20-Transfer} events.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - if `account` is a contract, it must implement the {IERC777Recipient}
     * interface.
     */
    function mint(
        address account,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData
    ) public onlyOwner {
        _mint(account, amount, userData, operatorData, true);
    }

    /**
     * @dev See {IERC777-authorizeOperator}.
     */
    function authorizeOperator(address operator) public override onlyOwner {
        super.authorizeOperator(operator);
    }

    /**
     * @dev See {IERC777-revokeOperator}.
     */
    function revokeOperator(address operator) public override onlyOwner {
        super.revokeOperator(operator);
    }
}
