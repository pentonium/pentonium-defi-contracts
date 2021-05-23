pragma solidity >=0.7.0 <0.8.0;

import "./interface/IERC20.sol";
import "./PTMSwap.sol";
import "./PTMVault.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PTMFactory{

    mapping(address => mapping(address => address)) public pairs;
    mapping (address => address) public vault;

    function createAPair(address tokenA, address tokenB) public {

        require(pairs[tokenA][tokenB] == address(0), "Pair already exist");

        PTMSwap swap = new PTMSwap(tokenA, tokenB);
        pairs[tokenA][tokenB] = address(swap);
        pairs[tokenB][tokenA] = address(swap);
        PTMVault _vault = new PTMVault(tokenA, tokenB);
        vault[swap] = _vault;
    }
}