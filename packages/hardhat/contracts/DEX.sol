pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT
// import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DEX {
  using SafeMath for uint256;
  
  IERC20 token;

  constructor(address token_addr) {
    token = IERC20(token_addr);
  }

  uint256 public totalLiquidity;
  mapping (address => uint256) public liquidity;

  function init(uint256 tokens) public payable returns (uint256) {
    require(totalLiquidity==0,"DEX:init - already has liquidity");
    totalLiquidity = address(this).balance;
    liquidity[msg.sender] = totalLiquidity;
    require(token.transferFrom(msg.sender, address(this), tokens));
    return totalLiquidity;
  }

  function price(uint256 input_amount, uint256 input_reserve, uint256 output_reserve) public view returns (uint256) {
    uint256 input_amount_with_fee = input_amount.mul(997);
    uint256 numerator = input_amount_with_fee.mul(output_reserve);
    uint256 denominator = input_reserve.mul(1000).add(input_amount_with_fee);
    return numerator / denominator;
  }

}