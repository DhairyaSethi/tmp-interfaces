// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

interface IStateSender {
    function syncState(address receiver, bytes calldata data) external;
}
