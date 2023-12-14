// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IStakeManager {
    function stakeFor(
        address staker,
        uint256 amount,
        bytes calldata extraData
    ) external;

    function userCumalativeRunningSum(
        address user
    ) external view returns (uint256);
}
