// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MultiPoolStaking {
    struct Pool {
        IERC20 token;
        uint256 rewardRate;
    }

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    Pool[] public pools;

    mapping(uint256 => mapping(address => Stake)) public stakes;

    function addPool(address token, uint256 rewardRate) external {
        pools.push(Pool(IERC20(token), rewardRate));
    }

    function stake(uint256 poolId, uint256 amount) external {
        Pool memory pool = pools[poolId];

        pool.token.transferFrom(msg.sender, address(this), amount);

        Stake storage user = stakes[poolId][msg.sender];
        user.amount += amount;
        user.timestamp = block.timestamp;
    }

    function withdraw(uint256 poolId) external {
        Stake memory user = stakes[poolId][msg.sender];
        Pool memory pool = pools[poolId];

        uint256 reward = (user.amount * pool.rewardRate) / 100;

        pool.token.transfer(msg.sender, user.amount + reward);

        delete stakes[poolId][msg.sender];
    }
}
