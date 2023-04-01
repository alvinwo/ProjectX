const { accounts } = require("@openzeppelin/test-environment");

const ProjectX = artifacts.require("ProjectX");
const ProjectXFactory = artifacts.require("ProjectXFactory");
module.exports = function (deployer) {
    deployer.deploy(ProjectXFactory);
    deployer.deploy(ProjectX, accounts[0], true);
};
