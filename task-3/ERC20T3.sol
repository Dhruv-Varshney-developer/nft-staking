// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20T3 is ERC20, Ownable {
    constructor() ERC20("ERC20T3", "T3") Ownable(msg.sender){}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount * 10**decimals());
    }
}
