// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const FanTuneZArtistFactory = await hre.ethers.getContractFactory(
    "FanTuneZArtistFactory"
  );
  const ArtistContract = await hre.ethers.getContractFactory("FanTuneZArtist");

  // const fanTuneZArtistFactory = await FanTuneZArtistFactory.deploy();

  const factoryContract = await FanTuneZArtistFactory.attach("0x2c7974bade5adac329f6358fbae2f04e561a7d50");

  // await factoryContract.createArtist("pointer", "pointer", "uri");
  const artistAddress = await factoryContract.allArtists(0);
  const artistContract = ArtistContract.attach(artistAddress);
  await artistContract.createNft(5, "irr", 100000000000000);
  // await artistContract.flipSale();

  // await artistContract.buy(0, { value: 100000000000000 });
  console.log("ownerOf ",await artistContract.ownerOf(0))

  console.log("aristtt", await artistContract.totalSupply());

  // console.log(
  //   "FanTuneZArtistFactory deployed to:",
  //   fanTuneZArtistFactory.address
  // );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
