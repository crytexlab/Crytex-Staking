const hre = require("hardhat");

async function main() {
  const tokenAddress = process.env.TOKEN_ADDRESS;

  const Staking = await hre.ethers.getContractFactory("CTXStaking");
  const staking = await Staking.deploy(tokenAddress);

  await staking.waitForDeployment();

  console.log("Staking deployed to:", await staking.getAddress());
}

main();
