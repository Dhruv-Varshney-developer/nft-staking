// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "module-2/task-2/myERC721.sol";
import "module-2/task-2/MyERC20.sol";

contract minter is Ownable {
    MyERC20Token public paymentToken;
    tigernft public nftContract;
    uint256 public constant PRICE = 10 * 10 ** 18; // 10 tokens with 18 decimals


    constructor(MyERC20Token _paymentToken, tigernft _nftContract) Ownable(msg.sender)  {
        paymentToken = _paymentToken;
        nftContract = _nftContract;
    }

    function mint() external {
        require(nftContract.totalSupply() < nftContract.MAX_SUPPLY(), "All NFTs have been minted");

        // Transfer ERC20 tokens to this contract
        require(paymentToken.transferFrom(msg.sender, address(this), PRICE), "Payment failed");

        // Mint the NFT to the sender
        nftContract.mint(msg.sender);
    }

    function withdrawTokens(address to, uint256 amount) external onlyOwner {
        require(paymentToken.transfer(to, amount), "Transfer failed");
    }
}
