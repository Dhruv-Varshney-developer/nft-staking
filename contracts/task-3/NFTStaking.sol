// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20T3.sol";
import "./TigernftT3.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

abstract contract NFTStaking is ReentrancyGuard, Ownable, IERC721Receiver {
    ERC20T3 public immutable rewardToken;
    TigerNFTT3 public immutable stakableNFT;
    uint256 public constant rewardRate = 10; // 10 ERC20 tokens per day

    struct StakeInfo {
        uint256 tokenId;
        uint256 lastClaimTime;
    }

    mapping(address => StakeInfo) public stakes;

    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(
        ERC20T3 _rewardToken,
        TigerNFTT3 _stakableNFT
    ) Ownable(msg.sender) {
        rewardToken = _rewardToken;
        stakableNFT = _stakableNFT;
    }

    // Note: block.timestamp has risks due to potential miner manipulation but used to keep the code simple.
    function stake(uint256 tokenId) external nonReentrant {
        require(stakes[msg.sender].tokenId == 0, "Already staking");
        require(tokenId >= 1 && tokenId <= 10, "Invalid tokenId range");

        stakableNFT.safeTransferFrom(msg.sender, address(this), tokenId);

        stakes[msg.sender] = StakeInfo({
            tokenId: tokenId,
            lastClaimTime: block.timestamp
        });

        emit Staked(msg.sender, tokenId);
    }

    function unstake() external nonReentrant {
        StakeInfo memory stakeInfo = stakes[msg.sender];
        require(stakeInfo.tokenId != 0, "No token staked");

        _claimReward(msg.sender);

        stakableNFT.safeTransferFrom(
            address(this),
            msg.sender,
            stakeInfo.tokenId
        );

        delete stakes[msg.sender];

        emit Unstaked(msg.sender, stakeInfo.tokenId);
    }

    function claimReward() external nonReentrant {
        _claimReward(msg.sender);
    }

    // Note: block.timestamp has risks due to potential miner manipulation but used to keep the code simple.
    function _claimReward(address user) internal {
        StakeInfo storage stakeInfo = stakes[user];
        require(stakeInfo.tokenId != 0, "No token staked");

        uint256 rewardAmount = _calculateReward(stakeInfo);
        stakeInfo.lastClaimTime = block.timestamp;

        if (rewardAmount > 0) {
            rewardToken.mint(user, rewardAmount);
            emit RewardClaimed(user, rewardAmount);
        }
    }

    // Note: block.timestamp has risks due to potential miner manipulation but used to keep the code simple.
    function _calculateReward(
        StakeInfo memory stakeInfo
    ) internal view returns (uint256) {
        uint256 stakingDuration = block.timestamp - stakeInfo.lastClaimTime;
        uint256 rewardAmount = (stakingDuration * rewardRate) / 1 days;
        return rewardAmount;
    }

    function checkReward(address user) external view returns (uint256) {
        StakeInfo memory stakeInfo = stakes[user];
        if (stakeInfo.tokenId == 0) {
            return 0;
        }
        return _calculateReward(stakeInfo);
    }

    // Implementing ERC721 receiver function
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
