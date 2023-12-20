// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

interface IStateReceiver {
    function onStateReceive(uint256 counter, address sender, bytes calldata data) external;
}
