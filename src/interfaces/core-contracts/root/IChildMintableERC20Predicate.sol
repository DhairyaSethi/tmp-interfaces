// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
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

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20MetadataUpgradeable is IERC20Upgradeable {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

/**
 * @dev Interface of IChildERC20
 */
interface IChildERC20 is IERC20MetadataUpgradeable {
    /**
     * @dev Sets the values for {rootToken}, {name}, {symbol} and {decimals}.
     *
     * All these values are immutable: they can only be set once during
     * initialization.
     */
    function initialize(address rootToken_, string calldata name_, string calldata symbol_, uint8 decimals_) external;

    /**
     * @notice Returns predicate address controlling the child token
     * @return address Returns the address of the predicate
     */
    function predicate() external view returns (address);

    /**
     * @notice Returns predicate address controlling the child token
     * @return address Returns the address of the predicate
     */
    function rootToken() external view returns (address);

    /**
     * @notice Mints an amount of tokens to a particular address
     * @dev Can only be called by the predicate address
     * @param account Account of the user to mint the tokens to
     * @param amount Amount of tokens to mint to the account
     * @return bool Returns true if function call is successful
     */
    function mint(address account, uint256 amount) external returns (bool);

    /**
     * @notice Burns an amount of tokens from a particular address
     * @dev Can only be called by the predicate address
     * @param account Account of the user to burn the tokens from
     * @param amount Amount of tokens to burn from the account
     * @return bool Returns true if function call is successful
     */
    function burn(address account, uint256 amount) external returns (bool);
}

interface IL2StateReceiver {
    /**
     * @notice Called by exit helper when state is received from L2
     * @param sender Address of the sender on the child chain
     * @param data Data sent by the sender
     */
    function onL2StateReceive(uint256 id, address sender, bytes calldata data) external;
}

interface IChildMintableERC20Predicate is IL2StateReceiver {
    event MintableERC20Deposit(
        address indexed rootToken,
        address indexed childToken,
        address sender,
        address indexed receiver,
        uint256 amount
    );
    event MintableERC20Withdraw(
        address indexed rootToken,
        address indexed childToken,
        address sender,
        address indexed receiver,
        uint256 amount
    );
    event MintableTokenMapped(address indexed rootToken, address indexed childToken);

    function initialize(
        address newL2StateSender,
        address newStateReceiver,
        address newRootERC20Predicate,
        address newChildTokenTemplate
    ) external;

    function withdraw(IChildERC20 childToken, uint256 amount) external;

    function withdrawTo(IChildERC20 childToken, address receiver, uint256 amount) external;
}
