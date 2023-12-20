// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IStateReceiver {
    function onStateReceive(uint256 counter, address sender, bytes calldata data) external;
}

struct ValidatorInit {
    address addr;
    uint256 stake;
}

struct Epoch {
    uint256 startBlock;
    uint256 endBlock;
    bytes32 epochRoot;
}

/**
    @title IValidatorSet
    @author Polygon Technology (@gretzke)
    @notice Manages voting power for validators and commits epochs for child chains
    @dev Voting power is synced between the stake manager on root on stake and unstake actions
 */
interface IValidatorSet is IStateReceiver {
    event NewEpoch(uint256 indexed id, uint256 indexed startBlock, uint256 indexed endBlock, bytes32 epochRoot);
    event WithdrawalRegistered(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    /// @notice commits a new epoch
    /// @dev system call
    function commitEpoch(uint256 id, Epoch calldata epoch) external;

    /// @notice allows a validator to announce their intention to withdraw a given amount of tokens
    /// @dev initializes a waiting period before the tokens can be withdrawn
    function unstake(uint256 amount) external;

    /// @notice allows a validator to complete a withdrawal
    /// @dev calls the bridge to release the funds on root
    function withdraw() external;

    /// @notice amount of blocks in an epoch
    /// @dev when an epoch is committed a multiple of this number of blocks must be committed
    // slither-disable-next-line naming-convention
    function EPOCH_SIZE() external view returns (uint256);

    /// @notice total amount of blocks in a given epoch
    function totalBlocks(uint256 epochId) external view returns (uint256 length);

    /// @notice returns a validator balance for a given epoch
    function balanceOfAt(address account, uint256 epochNumber) external view returns (uint256);

    /// @notice returns the total supply for a given epoch
    function totalSupplyAt(uint256 epochNumber) external view returns (uint256);

    /**
     * @notice Calculates how much can be withdrawn for account in this epoch.
     * @param account The account to calculate amount for
     * @return Amount withdrawable (in MATIC wei)
     */
    function withdrawable(address account) external view returns (uint256);

    /**
     * @notice Calculates how much is yet to become withdrawable for account.
     * @param account The account to calculate amount for
     * @return Amount not yet withdrawable (in MATIC wei)
     */
    function pendingWithdrawals(address account) external view returns (uint256);
}

struct Uptime {
    address validator;
    uint256 signedBlocks;
}

/**
    @title IRewardPool
    @author Polygon Technology (@gretzke)
    @notice Distributes rewards to validators for committed epochs
 */
interface IRewardPool {
    event RewardDistributed(uint256 indexed epochId, uint256 totalReward);

    /// @notice distributes reward for the given epoch
    /// @dev transfers funds from sender to this contract
    /// @param uptime uptime data for every validator
    function distributeRewardFor(uint256 epochId, Uptime[] calldata uptime) external;

    /// @notice withdraws pending rewards for the sender (validator)
    function withdrawReward() external;

    /// @notice returns the total reward paid for the given epoch
    function paidRewardPerEpoch(uint256 epochId) external view returns (uint256);

    /// @notice returns the pending reward for the given account
    function pendingRewards(address account) external view returns (uint256);
}
