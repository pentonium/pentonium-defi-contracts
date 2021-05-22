pragma solidity >=0.7.0 <0.8.0;

import "./interface/IERC20.sol";
import "./PTMFactory.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";


contract PTMVault is  ERC20, ERC20PresetMinterPauser{
    using SafeMath for uint;

    // Defining tokens for the swap
    IERC20 tokenA;
    IERC20 tokenB;

    address public factory;
    address public swap;

    constructor(address _tokenA, address _tokenB) ERC20PresetMinterPauser("PTMVault", "PTM-V"){
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidityToPool(uint amount0, uint amount1){
        
        PTMSwap ptmSwap = PTMSwap(swap);

        (uint reserve1, uint resreve2) = ptmSwap.getReserve();


        uint price = reserve1.div(reserve2);
        uint givenPrice = amount0.div(amount1);

        require(price != givenPrice, "Amounts are imbalanced!");

        IERC20(tokenA).transferFrom(msg.sender, swap, amount0);
        IERC20(tokenB).transferFrom(msg.sender, swap, amount1);


        uint tokenToMint = amount0 * amount1;

        mint(address(this), tokenToMint);
    }

    function removeLiquidity(uint _amount){

        (uint reserve1, uint resreve2) = ptmSwap.getReserve();

        uint amount0 = _amount * reserve1 / totalSupply();
        uint amount1 = _amount * resreve2 / totalSupply();


        transferFrom(msg.sender, address(this), _amount);
        IERC20(tokenA).transferFrom(swap, msg.sender, amount0);
        IERC20(tokenB).transferFrom(swap, msg.sender, amount1);

        burn(_amount);
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
    
}