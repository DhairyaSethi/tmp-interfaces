// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IStakeManager {
    function stakeFor(
        address staker,
        uint256 amount,
        bytes calldata extraData
    ) external;

    function userCumalativeRunningSum(
        address user,
        bytes12 requestSalt
    ) external pure returns (int256);

    function totalStakedFor(address addr) external view returns (int256 amt);
}
