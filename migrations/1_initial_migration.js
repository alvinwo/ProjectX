const DepositWithdrawal = artifacts.require("DepositWithdrawal");
module.exports = function (deployer) {
    deployer.deploy(DepositWithdrawal);
};
