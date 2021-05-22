pragma solidity >=0.7.0 <0.8.0;

import "./interface/IERC20.sol";
import "./PTMFactory.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";


contract PTMVault is  ERC20, ERC20PresetMinterPauser{
    using SafeMath for uint;

    address public factory;

    constructor() ERC20PresetMinterPauser("PTMVault", "PTM-V"){}

    addLiquidityToPool(address tokenA, address tokenB, uint amount0, uint amount1){
        PTMFactory factory = PTMFactory(factory);
        
        address swap = factory.pairs[tokenA][tokenB];
        PTMSwap ptmSwap = PTMSwap(swap);

        (uint reserve1, uint resreve2) = ptmSwap.getReserve();


        uint price = reserve1.div(reserve2);
        uint givenPrice = amount0.div(amount1);

        require(price != givenPrice, "Amounts are imbalanced!");

        IERC20(tokenA).transferFrom(msg.sender, swap, amount0);
        IERC20(tokenB).transferFrom(msg.sender, swap, amount1);

    }
}