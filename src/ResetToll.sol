// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @notice A toll that the fees resets to 0 after each time it is charged
contract ResetToll is Ownable {
    /// @notice gets sent funds after fee is deducted
    address public receiver;

    /// @notice tracks the fee for each given asset. resets to 0 after charged
    /// @dev asset addr => tax
    mapping(address => uint256) public fee;

    /// @dev ether can be represented through an address as defined in ERC-7528
    address internal constant ETHER_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    event ReceiverUpdated(address indexed oldReceived, address indexed newReceiver);
    event FeeUpdated(address indexed asset, uint256 newFee);
    event AssetSent(address indexed asset, uint256 amountSent, uint256 feeCharged);

    constructor(address initialRecipient) Ownable(msg.sender) {
        setReceiver(initialRecipient);
    }

    /// @notice receives fees
    function setReceiver(address newReceiver) public onlyOwner {
        require(newReceiver != address(0), "receiver can't be zero");
        receiver = newReceiver;
        emit ReceiverUpdated(address(0), newReceiver);
    }

    /// @notice fee is exclusive to given asset and is reset after each time it is charged
    function setFee(address asset, uint256 newFee) external onlyOwner {
        fee[asset] = newFee;
        emit FeeUpdated(asset, newFee);
    }

    /// @notice anyone can trigger funds to be sent through, with the fee enforced by the owner. Fee gets reset to zero for the given asset
    function sendFunds(address asset) external {
        uint256 feeToDeduct = fee[asset];
        fee[asset] = 0;

        uint256 balance = asset == ETHER_ADDR ? address(this).balance : IERC20(asset).balanceOf(address(this));
        require(balance > feeToDeduct, "not enough funds");

        uint256 remaining = balance - feeToDeduct;

        safeTransferAsset(asset, owner(), feeToDeduct);
        safeTransferAsset(asset, receiver, remaining);

        emit AssetSent(asset, remaining, feeToDeduct);
    }

    function safeTransferAsset(address asset, address destination, uint256 amount) internal {
        if(asset == ETHER_ADDR) {
            (bool success, ) = payable(destination).call{ value: amount}("");
            require(success, "fail send ether");
        } else {
            SafeERC20.safeTransfer(IERC20(asset), destination, amount);
        }
    }
}
