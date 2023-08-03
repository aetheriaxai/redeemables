// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OfferItem, ConsiderationItem, SpentItem, AdvancedOrder, OrderParameters, CriteriaResolver, FulfillmentComponent} from "seaport-types/src/lib/ConsiderationStructs.sol";

interface IRedeemableContractOfferer {
    /* Events */
    event CampaignUpdated(
        uint256 indexed campaignId,
        CampaignParams params,
        string URI
    );
    event Redemption(uint256 indexed campaignId, bytes32 redemptionHash);

    /* Structs */
    struct CampaignParams {
        uint32 startTime;
        uint32 endTime;
        uint32 maxTotalRedemptions;
        address manager; // the address that can modify the campaign
        address signer; // null address means no EIP-712 signature required
        OfferItem[] offer; // items to be minted, empty for off chain redeemable
        ConsiderationItem[] consideration; // the items you are transferring to recipient
    }
    struct TraitRedemption {
        uint8 substandard;
        address token;
        uint256 identifier;
        bytes32 traitKey;
        bytes32 traitValue;
        bytes32 maxOrMinOrRequiredPriorValue;
    }

    /* Getters */
    function getCampaign(
        uint256 campaignId
    )
        external
        view
        returns (
            CampaignParams memory params,
            string memory uri,
            uint256 totalRedemptions
        );

    /* Setters */
    function createCampaign(
        CampaignParams calldata params,
        string calldata uri
    ) external returns (uint256 campaignId);

    function updateCampaign(
        uint256 campaignId,
        CampaignParams calldata params,
        string calldata uri
    ) external;
}
