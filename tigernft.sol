// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract tigernft is ERC721 {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 10;
    uint256 public totalSupply = 0;
    string private baseTokenURI;
    mapping(uint256 => address) private _tokenOwners;

    constructor() ERC721("Tiger", "TGR") {
        baseTokenURI = "ipfs://bafybeihrklb222sgiowrjceg76rmqqpzqiyujmnufv3cq57ssemdxbbe4u/";
    }

    function mint() external {
        require(totalSupply < MAX_SUPPLY, "All NFTs have been minted");
        uint256 tokenId = totalSupply + 1;
        totalSupply++;
        _safeMint(msg.sender, tokenId);
         _tokenOwners[tokenId] = msg.sender;  // Track token ownership
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_tokenOwners[tokenId] != address(0), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(baseTokenURI, tokenId.toString(), ".json"));
    }
}
