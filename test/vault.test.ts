import { deployments, ethers } from "hardhat";
import { assert, expect } from "chai";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { VaultInfo } from "../typechain-types";

describe("Wallet", async function () {
  let vault: VaultInfo;
  let deployer: SignerWithAddress;



  beforeEach(async function () {
    const accounts = await ethers.getSigners();
    deployer = accounts[0];

    await deployments.fixture("all");
    vault = await ethers.getContract("VaultInfo", deployer);
  })
  describe("Debt with interest", async function () {
    it("debtWithInterest should be eq to 31214 vault debt from DefiSaver", async function () {
      let debtWithInterest: bigint;
      const vaultInfo = await vault.getCdpInfo(31214);
      console.log(`Ilk is: ${vaultInfo.ilk}`)

      debtWithInterest = vaultInfo.debtWithInterest;
      const debtValue = Number(debtWithInterest) / (10 ** 18);
      
      console.log(`Debt with interest: ${debtWithInterest}`)
      assert.equal(127373976.479616494087942364, debtValue)


    })
  })
})