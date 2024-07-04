// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ERC20T3 is ERC20 {
    constructor() ERC20("ERC20T3", "T3") {}

    function mint(address to, uint256 amount) external  {
        _mint(to, amount * 10**decimals());
    }
}
