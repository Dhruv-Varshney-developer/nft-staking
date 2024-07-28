// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./myERC721.sol";
import "./MyERC20.sol";

contract Minter is Ownable {
    MyERC20Token public immutable paymentToken;
    MyERC721 public immutable nftContract;
    uint256 public constant PRICE = 10 * 10 ** 18; // 10 tokens with 18 decimals

    constructor(
        MyERC20Token _paymentToken,
        MyERC721 _nftContract
    ) Ownable(msg.sender) {
        paymentToken = _paymentToken;
        nftContract = _nftContract;
    }

    function mint() external {
        require(
            nftContract.totalSupply() < nftContract.MAX_SUPPLY(),
            "All NFTs have been minted"
        );

        // Transfer ERC20 tokens to this contract
        require(
            paymentToken.transferFrom(msg.sender, address(this), PRICE),
            "Payment failed"
        );

        // Mint the NFT to the sender
        nftContract.mint(msg.sender);
    }

    function withdrawTokens(address to, uint256 amount) external onlyOwner {
        require(paymentToken.transfer(to, amount), "Transfer failed");
    }
}
