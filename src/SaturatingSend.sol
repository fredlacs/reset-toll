// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SaturatingSend {
    /// @notice contract owner that receives funds and is able to set spreads of an asset to be deducted
    address public owner;

    /// @notice tracks the spread for each given asset
    mapping(address => uint256) public spread;

    /// @dev ether can be represented through an address as defined in ERC-7528
    address internal constant ETHER_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
    event SpreadUpdate(address indexed asset, uint256 newSpread);

    modifier onlyOwner() virtual {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
        emit OwnershipTransferred(msg.sender, newOwner);
    }

    function setSpread(address asset, uint256 newSpread) external onlyOwner {
        spread[asset] = newSpread;
        emit SpreadUpdate(asset, newSpread);
    }

    function sendFunds() external {
        
    }
}
