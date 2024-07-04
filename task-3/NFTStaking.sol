// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTStaking is ReentrancyGuard, Ownable {
    IERC20 public rewardToken;
    IERC721 public stakableNFT;
    uint256 public rewardRate = 10; // 10 ERC20 tokens per day

    struct StakeInfo {
        uint256 tokenId;
        uint256 stakeTime;
        uint256 lastClaimTime;
    }

    mapping(address => StakeInfo) public stakes;

    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(IERC20 _rewardToken, IERC721 _stakableNFT) Ownable(msg.sender){
        rewardToken = _rewardToken;
        stakableNFT = _stakableNFT;
    }

    function stake(uint256 tokenId) external nonReentrant {
        require(stakes[msg.sender].tokenId == 0, "Already staking");

        stakableNFT.transferFrom(msg.sender, address(this), tokenId);

        stakes[msg.sender] = StakeInfo({
            tokenId: tokenId,
            stakeTime: block.timestamp,
            lastClaimTime: block.timestamp
        });

        emit Staked(msg.sender, tokenId);
    }

    function unstake() external nonReentrant {
        StakeInfo memory stakeInfo = stakes[msg.sender];
        require(stakeInfo.tokenId != 0, "No token staked");

        _claimReward(msg.sender);

        stakableNFT.transferFrom(address(this), msg.sender, stakeInfo.tokenId);

        delete stakes[msg.sender];

        emit Unstaked(msg.sender, stakeInfo.tokenId);
    }

    function claimReward() external nonReentrant {
        _claimReward(msg.sender);
    }

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

    function _calculateReward(StakeInfo memory stakeInfo) internal view returns (uint256) {
        uint256 stakingDuration = block.timestamp - stakeInfo.lastClaimTime;
        uint256 rewardAmount = (stakingDuration / 1 days) * rewardRate;
        return rewardAmount;
    }
}
