//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Escrow {
  address public payer;
  address payable public payee;
  address public escrowAccount;
  uint256 public totalAmount;

  modifier onlyPayer() {
    require(msg.sender == payer, "Only the payer can call this method");
    _;
  }

  modifier onlyEscrow() {
    require(msg.sender == escrowAccount, "Only the escrow account can call this method");
    _;
  }

  constructor (address _payer, address payable _payee, uint _amount) {
    payer = _payer;
    payee = _payee;
    escrowAccount = msg.sender;
    totalAmount = _amount;
  }

  receive() external payable onlyPayer {
    require(address(this).balance<= totalAmount, "Payer sent more ether than needed");
  }

  function release() public onlyEscrow {
    require(address(this).balance == totalAmount, 'Insufficent funds received by payer');
    payee.transfer(totalAmount);
  }

  function balanceOf() public view returns (uint256){
    return address(this).balance;
  }

}
