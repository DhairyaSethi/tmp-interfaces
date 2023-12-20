// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

interface IAddressList {
    function readAddressList(address account) external view returns (uint256);
}
