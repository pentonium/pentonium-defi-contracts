pragma solidity >=0.7.0 <0.8.0;

import "./interface/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PTMSwap{

    using SafeMath for uint;

    // Defining tokens for the swap
    IERC20 tokenA;
    IERC20 tokenB;

    address vault;


    // set token for the smart contract
    constructor(address _tokenA, address _tokenB){
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // funciton that will facilitate swap
    function swap(address token, uint amountIn, uint amountOut, uint slippage) public{

        IERC20 _tokenA = IERC20(token);
        IERC20 _tokenB = (token == tokenA)? tokenB : tokenA;

        uint balance0 = _tokenA.balanceOf(address(this));
        uint balance1 = _tokenB.balanceOf(address(this));

        uint _amountOut = getAmountOut(token, amountIn);

        require(amountOut <= _amountOut, "Failed as the price from swap doesn't match");

        _tokenA.transferFrom(msg.sender, address(this), amountIn);
        _tokenB.transfer(msg.sender, _amountOut);

    }


    // function that gets amount of token you will get
    function getAmountOut(address token, uint amountIn) public view returns (uint amountOut) {

        IERC20 _tokenA = IERC20(token);
        IERC20 _tokenB = (token == tokenA)? tokenB : tokenA;

        uint balance0 = _tokenA.balanceOf(address(this));
        uint balance1 = _tokenB.balanceOf(address(this));

        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(balance1);
        uint denominator = balance0.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }


    // function getReserve
    function getReserve() public view returns (uint balance0, uint balance1){

        uint balance0 = tokenA.balanceOf(address(this));
        uint balance1 = tokenB.balanceOf(address(this));
    }

}