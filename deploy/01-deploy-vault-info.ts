import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const DeployVaultInfo: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { getNamedAccounts, deployments } = hre;
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    const vault = await deploy("VaultInfo", {
        from: deployer,
        args: [],
        log: true,
    });
    console.log(`Vault contract is deployed to: ${vault.address}`);
}

export default DeployVaultInfo;
DeployVaultInfo.tags = ["all", "vault"]