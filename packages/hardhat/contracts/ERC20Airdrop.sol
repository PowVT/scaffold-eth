pragma solidity 0.8.18;

//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title ERC20Airdrop
 * This contract is used to airdrop ERC20 tokens to a list of addresses.
 * The owner of the contract can pre-populate user balances and then after a specified timestamp
 * users with a balance of tokens can transfer them. The main purpose of this contract is to
 * allow users to obtain airdropped tokens without having to pay gas fees to claim them.
 * 
 * @dev This contract is not efficient for large token airdrops. It is only intended to be used
 * for small airdrops of a few recipients. For the following reasons this method is ineffienct compared
 * to a merkle trie airdrop:
 * 1. The gas cost of such a transaction can become quite big and if one mint transfer fails a lot of gas is wasted.
 * 2. This method of airdropping is a 'push' method, meaning that the contract is pushing tokens to the users.
 *    A merkle trie airdrop is a 'pull' method, meaning that the users are pulling tokens from the contract.
 */
contract ERC20Airdrop is ERC20, Ownable {

  uint160 public constant AIRDROP_DATE = 1676480808; // Wednesday, February 15, 2023 12:06:48 PM GMT-05:00

  constructor(address[] memory _addresses, uint256[] memory _amounts) ERC20("ERC20Airdrop", "ERC20Airdrop") {
    require(_addresses.length == _amounts.length, "ERC20Airdrop: addresses and amounts must be the same length");
    for (uint256 i = 0; i < _addresses.length; i++) {
      _mint(_addresses[i], _amounts[i]);
    }
  }

  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
    super.transfer(recipient, amount);
    require(block.timestamp > AIRDROP_DATE, "ERC20Airdrop: token transfers are not allowed before airdrop date");
  }

  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
    super.transferFrom(sender, recipient, amount);
    require(block.timestamp > AIRDROP_DATE, "ERC20Airdrop: token transfers are not allowed before airdrop date");
  }

  function mint(address[] memory _addresses, uint256[] memory _amounts) public onlyOwner {
    for (uint256 i = 0; i < _addresses.length; i++) {
      _mint(_addresses[i], _amounts[i]);
    }
  }
}
