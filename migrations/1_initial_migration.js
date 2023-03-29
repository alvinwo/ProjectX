const DepositWithdrawal = artifacts.require("DepositWithdrawal");
const ProjectX = artifacts.require("ProjectX");
module.exports = function (deployer) {
    deployer.deploy(DepositWithdrawal);
    deployer.deploy(ProjectX, true);
};
