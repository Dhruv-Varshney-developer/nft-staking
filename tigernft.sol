// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract tigernft is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 10;
    uint256 public totalSupply = 0;
    string private baseTokenURI;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) Ownable(msg.sender){
        baseTokenURI = "ipfs://bafybeihrklb222sgiowrjceg76rmqqpzqiyujmnufv3cq57ssemdxbbe4u/";
    }

    function mint() external {
        require(totalSupply < MAX_SUPPLY, "All NFTs have been minted");
        uint256 tokenId = totalSupply + 1;
        totalSupply++;
        _safeMint(msg.sender, tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_owners[tokenId] != address(0), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(baseTokenURI, tokenId.toString(), ".json"));
    }

    
}