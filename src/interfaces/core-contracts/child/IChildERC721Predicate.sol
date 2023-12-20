// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)

// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)

// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165Upgradeable {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721Upgradeable is IERC165Upgradeable {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721MetadataUpgradeable is IERC721Upgradeable {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

/**
 * @dev Interface of IChildERC721
 */
interface IChildERC721 is IERC721MetadataUpgradeable {
    /**
     * @dev Sets the values for {rootToken}, {name}, and {symbol}.
     *
     * All these values are immutable: they can only be set once during
     * initialization.
     */
    function initialize(address rootToken_, string calldata name_, string calldata symbol_) external;

    /**
     * @notice Returns predicate address controlling the child token
     * @return address Returns the address of the predicate
     */
    function predicate() external view returns (address);

    /**
     * @notice Returns address of the token on the root chain
     * @return address Returns the address of the predicate
     */
    function rootToken() external view returns (address);

    /**
     * @notice Mints an NFT token to a particular address
     * @dev Can only be called by the predicate address
     * @param account Account of the user to mint the tokens to
     * @param tokenId Index of NFT to mint to the account
     * @return bool Returns true if function call is successful
     */
    function mint(address account, uint256 tokenId) external returns (bool);

    /**
     * @notice Mints multiple NFTs in one transaction
     * @dev address and tokenId arrays must match in length
     * @param accounts Array of addresses to mint each NFT to
     * @param tokenIds Array of NFT indexes to mint
     * @return bool Returns true if function call is successful
     */
    function mintBatch(address[] calldata accounts, uint256[] calldata tokenIds) external returns (bool);

    /**
     * @notice Burns an NFT tokens from a particular address
     * @dev Can only be called by the predicate address
     * @param account Address to burn the NFTs from
     * @param tokenId Index of NFT to burn
     * @return bool Returns true if function call is successful
     */
    function burn(address account, uint256 tokenId) external returns (bool);

    /**
     * @notice Burns multiple NFTs in one transaction
     * @param account Address to burn the NFTs from
     * @param tokenIds Array of NFT indexes to burn
     * @return bool Returns true if function call is successful
     */
    function burnBatch(address account, uint256[] calldata tokenIds) external returns (bool);
}

interface IStateReceiver {
    function onStateReceive(uint256 counter, address sender, bytes calldata data) external;
}

interface IChildERC721Predicate is IStateReceiver {
    function initialize(
        address newL2StateSender,
        address newStateReceiver,
        address newRootERC721Predicate,
        address newChildTokenTemplate
    ) external;

    function onStateReceive(uint256 /* id */, address sender, bytes calldata data) external;

    function withdraw(IChildERC721 childToken, uint256 tokenId) external;

    function withdrawTo(IChildERC721 childToken, address receiver, uint256 tokenId) external;

    function withdrawBatch(IChildERC721 childToken, address[] calldata receivers, uint256[] calldata tokenIds) external;
}
