import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import '@nomicfoundation/hardhat-ethers';
import 'hardhat-deploy';
import 'hardhat-deploy-ethers';
import "dotenv/config";

const MAINNET_RPC_URL = process.env.MAINNET_RPC_URL;


const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.24",
      },
      {
        version: "0.6.0",
      },
    ]
  },
  networks: {
    hardhat: {
      chainId: 31337,
      forking: {
        url: MAINNET_RPC_URL!,
      }

    },
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
    },
  },
};

export default config;
