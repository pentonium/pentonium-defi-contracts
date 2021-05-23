pragma solidity >=0.7.0 <0.8.0;

import "./interface/IERC20.sol";
import "./lib/Math.sol"
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract PTMSwap is  ERC20, ERC20PresetMinterPauser{

    using SafeMath for uint;

    // Defining tokens for the swap
    IERC20 tokenA;
    IERC20 tokenB;

    address vaultA;
    address vaultB;
    address vaultC;
    address activeVault;

    address shockAbsorber;

    uint public reserve0;
    uint public reserve1;


    // set token for the smart contract
    constructor(address _tokenA, address _tokenB) ERC20PresetMinterPauser("PTMLP", "PTMLP"){
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function setActiveVault(address _vault) public{
        activeVault = _vault;
    }


    function setShockAbsorber(address token){
        shockAbsorber = token;
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

        uint fee = (2 * amountIn / 1000);

        (token == tokenA)? reserve0 -= fee : reserve1 -= fee;

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

    function addLiquidityToPool(uint amount0, uint amount1){
        
        PTMSwap ptmSwap = PTMSwap(swap);

        uint price = reserve0.div(reserve1);
        uint givenPrice = amount0.div(amount1);

        require(price == givenPrice, "Amounts are imbalanced!");

        IERC20(tokenA).transferFrom(msg.sender, swap, amount0);
        IERC20(tokenB).transferFrom(msg.sender, swap, amount1);


        reserve0 += amount0;
        reserve1 += amount1;


        uint tokenToMint = Math.sqrt(amount0 * amount1);

        mint(address(this), tokenToMint);
    }

    function removeLiquidity(uint _amount){

        uint amount0 = _amount * reserve0 / totalSupply();
        uint amount1 = _amount * resreve1 / totalSupply();

        transferFrom(msg.sender, address(this), _amount);
        IERC20(tokenA).transferFrom(swap, msg.sender, amount0);
        IERC20(tokenB).transferFrom(swap, msg.sender, amount1);

        reserve0 -= amount0;
        reserve1 -= amount1;

        burn(_amount);
    }

}