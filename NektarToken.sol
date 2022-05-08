// SPDX-License-Identifier: MIT LICENSE

pragma solidity >=0.8.9 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract NektarToken is ERC20, ERC20Burnable, Ownable {
  using SafeMath for unit256;

  mapping(address => unit256) private _balances;
  mapping(address => bool) controllers;

  unit256 public _totalSupply;
  unit256 constant _maxSupply=900000000*10**18;

  constructor() ERC20("NektarToken", "NEKTAR") {
    _mint(msg.sender, 100000000*10**18);
  }

  function mint(address to, uint256 amount) external {
    require(controllers[msg.sender], "Only controllers can mint");
    require((_totalSupply+amount)<=_maxSupply,"Maximum supply has been reached");
    _totalSupply = _totalSupply.add(amount);
    _balances[to] = _balnces[to].add(amount);
    _mint(to, amount);
  }

  function burnFrom(address account, uint256 amount) public override {
      if (controllers[msg.sender]) {
          _burn(account, amount);
      }
      else {
          super.burnFrom(account, amount);
      }
  }

  function addController(address controller) external onlyOwner {
    controllers[controller] = true;
  }

  function removeController(address controller) external onlyOwner {
    controllers[controller] = false;
  }

  function totalSupply() public override view returns (unit256) {
    return _totalSupply;
  }

  function maxSupply() pure returns (unit256) {
    return _maxSupply;
  }
}
