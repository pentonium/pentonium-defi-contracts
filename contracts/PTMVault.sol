pragma solidity >=0.7.0 <0.8.0;

import "./interface/IERC20.sol";
import "./interface/IDateTime.sol";
import "./lib/Math.sol"
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";


contract PTMVault is  ERC20, ERC20PresetMinterPauser{
    using SafeMath for uint;

    IERC20 token;

    IDateTime DateTime;

    address public factory;
    address public swap;

    uint public gap;
    constructor(address _swap, uint _gap) ERC20PresetMinterPauser("PTMVault", "PTM-V"){
        swap = swap;

        DateTime = DateTime(0xa24D5608e17200B117CF984258a87fe885cc3999);
        gap = _gap;
    }

    function depositLPToken(uint amount) public{
        IERC20(swap).transferFrom(msg.sender, address(this), amount);
        mint(msg.sender, amount);
    }

    function withdrawLPToken(uint amount) public{
        transferFrom(msg.sender, address(this), amount);

        uint month = DateTime.getMonth(block.timestamp);
        uint date = DateTime.getDay(block.timestamp);

        if((month + gap) % 3 == 0){
            uint time_diff = block.timestamp - _endTime;

            uint balance = IERC20(token).balanceOf(address(this));

            uint reward_based_on_amount = (amount * balance) / totalSupply();

            uint reward = (date * reward_based_on_amount / 30);

            IERC20(token).transfer(msg.sender, reward);
        }

        burn(amount);
        IERC20(swap).transfer(msg.sender,  amount);
    }
    
}