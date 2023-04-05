require('@openzeppelin/test-helpers/configure')({ provider: web3.currentProvider, environment: 'truffle' });
const { singletons } = require("@openzeppelin/test-helpers");

const ProjectX = artifacts.require("ProjectX");
const ProjectXFactory = artifacts.require("ProjectXFactory");
const ProjectXToken = artifacts.require("ProjectXToken");
module.exports = async function (deployer, network, accounts) {
    if(network === 'development') {
        await singletons.ERC1820Registry(accounts[0]);
    }
    await deployer.deploy(ProjectXToken, 1000, [accounts[0], accounts[1]]);
    await deployer.deploy(ProjectXFactory);
    await deployer.deploy(ProjectX, accounts[0], true);
};
