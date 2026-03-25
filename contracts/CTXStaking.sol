// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CTXStaking is Ownable {
    IERC20 public token;

    uint256 public rewardRate = 15; // % APR

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;

    event Staked(address user, uint256 amount);
    event Withdrawn(address user, uint256 amount, uint256 reward);

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Invalid amount");

        token.transferFrom(msg.sender, address(this), amount);

        Stake storage user = stakes[msg.sender];

        user.amount += amount;
        user.timestamp = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function calculateReward(address userAddr) public view returns (uint256) {
        Stake memory user = stakes[userAddr];

        if (user.amount == 0) return 0;

        uint256 timeDiff = block.timestamp - user.timestamp;

        return (user.amount * rewardRate * timeDiff) / (365 days * 100);
    }

    function withdraw() external {
        Stake memory user = stakes[msg.sender];
        require(user.amount > 0, "Nothing staked");

        uint256 reward = calculateReward(msg.sender);

        uint256 total = user.amount + reward;

        delete stakes[msg.sender];

        token.transfer(msg.sender, total);

        emit Withdrawn(msg.sender, user.amount, reward);
    }
}
