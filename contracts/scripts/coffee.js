const hre = require("hardhat");

async function main() {
  const [owner, tipper, tipper2, tipper3] = await hre.ethers.getSigners();
  //Get the contract to deploy
  const BuyMeACoffee = await hre.ethers.getContractFactory("BuyMeACoffee");
  const buyMeACoffee = await BuyMeACoffee.deploy();
  await buyMeACoffee.deployed();
  console.log("BuyMeACoffee deployed at:", buyMeACoffee.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
