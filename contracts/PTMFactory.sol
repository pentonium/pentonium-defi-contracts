pragma solidity >=0.7.0 <0.8.0;

import "./interface/IERC20.sol";
import "./PTMSwap.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PTMFactory{

    mapping(address => mapping(address => address)) public pairs;

    function createAPair(address tokenA, address tokenB) public {
        PTMSwap swap = new PTMSwap(tokenA, tokenB);
        pairs[tokenA][tokenB] = address(swap);
        pairs[tokenB][tokenA] = address(swap);
    }
}