// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

interface IVersioned {
    /// @return The version of the contract
    function version() external pure returns (string memory);
}
