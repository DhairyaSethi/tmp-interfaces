// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

interface IVersioned {
    /// @return The version of the contract
    function version() external pure returns (string memory);
}

interface ICounter is IVersioned {
    /// @return The current number
    function number() external view returns (uint256);

    /// @notice Sets the number
    /// @param newNumber The new number
    function setNumber(uint256 newNumber) external;

    /// @notice Increments the number by 1
    function increment() external;
}
