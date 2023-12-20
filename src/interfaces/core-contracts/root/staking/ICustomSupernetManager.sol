// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

/**
 * NOT_STARTED - child chain is not live, genesis validators can be added
 * IN_PROGRESS - no longer accepting genesis validators, child chain is created
 * COMPLETED - child chain is live, validators can stake normally
 */
enum GenesisStatus {
    NOT_STARTED,
    IN_PROGRESS,
    COMPLETED
}

struct GenesisValidator {
    address addr;
    uint256 initialStake;
}

struct GenesisSet {
    GenesisValidator[] genesisValidators;
    GenesisStatus status;
    mapping(address => uint256) indices;
}

library GenesisLib {
    /**
     * @notice inserts a validator into the genesis set
     * @param self GenesisSet struct
     * @param validator address of the validator
     * @param stake amount to add to the validators genesis stake
     */
    function insert(GenesisSet storage self, address validator, uint256 stake) internal {
        assert(self.status == GenesisStatus.NOT_STARTED);
        uint256 index = self.indices[validator];
        if (index == 0) {
            // insert into set
            // use index starting with 1, 0 is empty by default
            index = self.genesisValidators.length + 1;
            self.indices[validator] = index;
            self.genesisValidators.push(GenesisValidator(validator, stake));
        } else {
            // update values
            uint256 idx = _indexOf(self, validator);
            GenesisValidator storage genesisValidator = self.genesisValidators[idx];
            genesisValidator.initialStake += stake;
        }
    }

    /**
     * @notice finalizes the current genesis set
     */
    function finalize(GenesisSet storage self) internal {
        require(self.status == GenesisStatus.NOT_STARTED, "GenesisLib: already finalized");
        self.status = GenesisStatus.IN_PROGRESS;
    }

    /**
     * @notice enables staking after the genesis set has been finalized
     */
    function enableStaking(GenesisSet storage self) internal {
        GenesisStatus status = self.status;
        if (status == GenesisStatus.NOT_STARTED) revert("GenesisLib: not finalized");
        if (status == GenesisStatus.COMPLETED) revert("GenesisLib: already enabled");
        self.status = GenesisStatus.COMPLETED;
    }

    /**
     * @notice returns the current genesis set
     * @param self GenesisSet struct
     * @return genesisValidators array of genesis validators and their initial stake
     */
    function set(GenesisSet storage self) internal view returns (GenesisValidator[] memory) {
        return self.genesisValidators;
    }

    function gatheringGenesisValidators(GenesisSet storage self) internal view returns (bool) {
        return self.status == GenesisStatus.NOT_STARTED;
    }

    function completed(GenesisSet storage self) internal view returns (bool) {
        return self.status == GenesisStatus.COMPLETED;
    }

    /**
     * @notice returns index of a specific validator
     * @dev indices returned from this function start from 0
     * @param self the GenesisSet struct
     * @param validator address of the validator whose index is being queried
     * @return index the index of the validator in the set
     */
    function _indexOf(GenesisSet storage self, address validator) private view returns (uint256 index) {
        index = self.indices[validator];
        assert(index != 0); // currently index == 0 is unreachable
        return index - 1;
    }
}

struct Validator {
    uint256[4] blsKey;
    uint256 stake;
    bool isWhitelisted;
    bool isActive;
}

/**
    @title ICustomSupernetManager
    @author Polygon Technology (@gretzke)
    @notice Manages validator access and syncs voting power between the stake manager and validator set on the child chain
    @dev Implements the base SupernetManager contract
 */
interface ICustomSupernetManager {
    event AddedToWhitelist(address indexed validator);
    event RemovedFromWhitelist(address indexed validator);
    event ValidatorRegistered(address indexed validator, uint256[4] blsKey);
    event ValidatorDeactivated(address indexed validator);
    event GenesisBalanceAdded(address indexed account, uint256 indexed amount);
    event GenesisFinalized(uint256 amountValidators);
    event StakingEnabled();

    error Unauthorized(string message);
    error InvalidSignature(address validator);

    /// @notice Allows to whitelist validators that are allowed to stake
    /// @dev only callable by owner
    function whitelistValidators(address[] calldata validators_) external;

    /// @notice registers the public key of a validator
    function register(uint256[2] calldata signature, uint256[4] calldata pubkey) external;

    /// @notice finalizes initial genesis validator set
    /// @dev only callable by owner
    function finalizeGenesis() external;

    /// @notice enables staking after successful initialisation of the child chain
    /// @dev only callable by owner
    function enableStaking() external;

    /// @notice called by the exit helpers to either release the stake of a validator or slash it
    /// @dev can only be synced from child after genesis
    function onL2StateReceive(uint256 /*id*/, address sender, bytes calldata data) external;

    /// @notice returns the genesis validator set with their balances
    function genesisSet() external view returns (GenesisValidator[] memory);

    /// @notice returns validator instance based on provided address
    function getValidator(address validator_) external view returns (Validator memory);

    /// @notice addGenesisBalance is used to specify genesis balance information for genesis accounts on the Supernets.
    /// It is applicable only in case Supernets native contract is mapped to a pre-existing rootchain ERC20 token.
    /// @param amount represents the amount to be premined in the genesis.
    function addGenesisBalance(uint256 amount) external;
}
