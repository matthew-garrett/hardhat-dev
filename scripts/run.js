const { utils } = require("ethers");
const hre = require("hardhat");
const ethers = hre.ethers;

// TERMINAL INSTRUCTIONS
// - deploy for TestNFT: npx hardhat verify --network rinkeby 0xb4EE068E8943549b6ECF5E090C9137E59cf2E1e1 "TestNFT" "TNFT" "Not a uri" "Not a uri"
// - when testing with NFT data from pinita replay "Not a Uri"s with appropriate baseTokenURIs

async function main() {
  await hre.run("compile");

  // Get owner/deployer's wallet address
  const [owner] = await hre.ethers.getSigners();

  // Get contract that we want to deploy
  const contractFactory = await hre.ethers.getContractFactory("TestNFT");

  // Deploy contract with the correct constructor arguments
  const testNFT = await contractFactory.deploy(
    "TestNFT",
    "TNFT",
    "Not a uri",
    "Not a uri"
  );

  // Wait for this transaction to be mined
  await testNFT.deployed();

  // Get contract address
  console.log("Contract deployed to:", testNFT.address);

  // Reserve NFTs
  //   let txn = await contract.reserveNFTs();
  //   await txn.wait();
  //   console.log("10 NFTs have been reserved");

  // Mint 3 NFTs by sending 0.03 ether
  //   txn = await contract.mintNFTs(3, { value: utils.parseEther("0.03") });
  //   await txn.wait();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
