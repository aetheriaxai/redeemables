// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC1155} from "solady/src/tokens/ERC1155.sol";
import {IRedemptionMintable} from "../interfaces/IRedemptionMintable.sol";
import {ConsiderationItem} from "seaport-types/src/lib/ConsiderationStructs.sol";

contract ERC1155RedemptionMintable is ERC1155, IRedemptionMintable {
    address internal immutable _REDEEMABLE_CONTRACT_OFFERER;
    address internal immutable _REDEEM_TOKEN;

    /// @dev Revert if the sender of mintRedemption is not the redeemable contract offerer.
    error InvalidSender();

    /// @dev Revert if the redemption spent is not the required token.
    error InvalidRedemption();

    constructor(address redeemableContractOfferer, address redeemToken) {
        _REDEEMABLE_CONTRACT_OFFERER = redeemableContractOfferer;
        _REDEEM_TOKEN = redeemToken;
    }

    function mintRedemption(uint256 campaignId, address recipient, ConsiderationItem[] memory consideration) external {
        if (msg.sender != _REDEEMABLE_CONTRACT_OFFERER) revert InvalidSender();

        ConsiderationItem memory spentItem = consideration[0];
        if (spentItem.token != _REDEEM_TOKEN) revert InvalidRedemption();

        // Mint the same token ID redeemed and same amount redeemed.
        _mint(recipient, spentItem.identifierOrCriteria, spentItem.startAmount, "");
    }

    function uri(uint256 id) public pure override returns (string memory) {
        return string(abi.encodePacked("https://example.com/", id));
    }
}
