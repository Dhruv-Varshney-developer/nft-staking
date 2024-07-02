// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable(msg.sender) {
    uint256 public constant MAX_SUPPLY = 10;
    uint256 public totalSupply = 0;
    string private baseTokenURI;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        baseTokenURI = "ipfs://bafybeihrklb222sgiowrjceg76rmqqpzqiyujmnufv3cq57ssemdxbbe4u/";
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function mintNFT(address to, uint256 tokenId) external onlyOwner {
        require(totalSupply < MAX_SUPPLY, "All NFTs have been minted");
        totalSupply++;
        _safeMint(to, tokenId);
    }
}
