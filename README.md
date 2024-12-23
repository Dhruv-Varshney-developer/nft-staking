# NFT Staking Platform

## Overview
A comprehensive NFT platform that combines ERC721 token minting, ERC20 token integration, and NFT staking mechanics. The platform features a collection of unique NFTs that can be minted either freely or using custom ERC20 tokens, with additional staking capabilities for earning rewards.

## Features

### Free NFT Collection
- Collection of 10 unique NFTs with distinct traits and artwork
- Free minting capability through Etherscan
- Full OpenSea integration
- Verifiable traits and metadata

### Token-Based NFT Minting
- Mint exclusive NFTs using custom ERC20 tokens
- Cost: 10 ERC20 tokens per NFT
- Automated approval and minting process
- Secure token transfer mechanics

### NFT Staking System
- Stake NFTs to earn ERC20 token rewards
- Reward rate: 10 ERC20 tokens per 24 hours
- Flexible withdrawal system
- Secure staking mechanics with anti-exploitation measures

## Technical Architecture

### Smart Contracts
1. **ERC721 Token Contract**
   - Implements NFT standard
   - Manages NFT minting and transfers
   - Handles metadata and traits

2. **ERC20 Token Contract**
   - Custom token for NFT purchases and rewards
   - 18 decimal places precision
   - Standard transfer and approval mechanics

3. **Staking Contract**
   - Manages NFT deposits and withdrawals
   - Handles reward distribution
   - Implements time-lock mechanics
   - Security measures against re-staking exploitation

## Security Features
- Time-locked staking rewards
- Secure contract interactions
- Protected withdrawal mechanisms
- Anti-exploitation measures
- Slither-verified security
- Solhint-compliant code

## Quality Assurance
- Static analysis with Slither
- Code style enforcement with Solhint
- Prettier formatting
- Comprehensive testing suite
- Security audit recommendations implemented

## Getting Started

### Minting Free NFTs
1. Visit the contract on Sepolia Etherscan
2. Connect your wallet
3. Use the `mint` function
4. View your NFT on OpenSea

### Token-Based Minting
1. Acquire platform ERC20 tokens
2. Approve token spending for the minting contract
3. Execute minting transaction
4. Receive your exclusive NFT

### Staking Process
1. Hold a platform NFT
2. Approve NFT transfer to staking contract
3. Deposit NFT through staking function
4. Collect ERC20 rewards (10 tokens/24h)
5. Withdraw NFT at any time

## Contract Addresses (Sepolia)
- ERC721 Token: `0xD57Fc3d6C1C4B5d368eC50aE3807DB43d636c318`.


## Technical Stack
- Solidity for smart contracts
- OpenZeppelin contract standards
- Hardhat development environment
- Ethers.js for testing
- IPFS for metadata storage

## Local Development
```bash
# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy contracts
npx hardhat run scripts/deploy.js --network sepolia
```

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.