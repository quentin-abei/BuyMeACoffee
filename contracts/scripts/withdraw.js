const hre = require("hardhat");
require("dotenv").config({ path: ".env" });
const GOERLI_API = process.env.GOERLI_API;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const abi = require("../artifacts/contracts/BuyMeACoffee.sol/BuyMeACoffee.json");

async function getBalance(provider, address) {
  const balanceBigInt = await provider.getBalance(address);
  return hre.ethers.utils.formatEther(balanceBigInt);
}

async function main() {
  /// contract that has been deployed to goerli
  const contractAddress = "0x1830Bd47d9F3C6a8450aB6579129a80207F2eD9f";
  const contractAbi = abi.abi;

  /// node connection and wallet connection
  const provider = new hre.ethers.providers.AlchemyProvider(
    "goerli",
    GOERLI_API
  );

  const signer = new hre.ethers.Wallet(PRIVATE_KEY, provider);
  const buyMeACoffee = new hre.ethers.Contract(
    contractAddress,
    contractAbi,
    signer
  );

  console.log(
    "current balance of owner: ",
    await getBalance(provider, signer.address),
    "ETH"
  );
  console.log(
    "current balance of contract :",
    await getBalance(provider, buyMeACoffee.address),
    "ETH"
  );
  const contractBalance = await getBalance(provider, buyMeACoffee.address);

  console.log("====WITHDRAWING TO OWNER===");
  if (contractBalance !== "0.0") {
    console.log("withdrawing Funds...");
    const withdraw = await buyMeACoffee.withdraw(signer.address);
    await withdraw.wait();
  } else {
    console.log("Ooops 0 Eth inside contract");
  }
  console.log(
    "current balance of owner: ",
    await getBalance(provider, signer.address),
    "ETH"
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
