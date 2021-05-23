pragma solidity >=0.7.0 <0.8.0;

import "./interface/IERC20.sol";
import "./lib/Math.sol"
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";


contract PTMVault is  ERC20, ERC20PresetMinterPauser{
    using SafeMath for uint;

    // Defining tokens for the swap
    IERC20 tokenA;
    IERC20 tokenB;

    address public factory;
    address public swap;

    mapping (address => bool) whiteListedTokens;
    mapping (address => uint) rewardDeadline;

    constructor(address _tokenA, address _tokenB) ERC20PresetMinterPauser("PTMVault", "PTM-V"){
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }



    
}