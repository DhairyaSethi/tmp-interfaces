// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IService {
    function onSubscribe(address subscriber, bytes32 topic) external;

    function onUnsubscribe(address subscriber, bytes32 topic) external;

    function hub() external view returns (address);
}
