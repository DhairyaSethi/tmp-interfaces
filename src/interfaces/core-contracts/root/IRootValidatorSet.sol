// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

interface IRootValidatorSet {
    struct Validator {
        address _address;
        uint256[4] blsKey;
    }

    function addValidators(Validator[] calldata newValidators) external;

    function getValidatorBlsKey(uint256 id) external view returns (uint256[4] memory);

    function activeValidatorSetSize() external returns (uint256);
}
