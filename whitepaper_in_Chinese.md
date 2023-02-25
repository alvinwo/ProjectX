# 去中心化交易平台

## 项目介绍
本项目是一个基于以太坊区块链的自动交易执行系统。用户可以部署自己的交易执行合约，并提交交易规则和执行条件。当条件满足时，系统会自动执行交易，无需用户一直守在设备旁边或依赖中心化的交易所。用户拥有完全控制权，可以开启自己的去中心化自动交易系统，相当于拥有自己的自动化投资交易引擎、信托基金、去中心化遗嘱执行程序等。

此外，本系统是开放的自动化交易系统，用户可以自行开发更多高效、便捷、安全的使用场景。

## 使用流程
在本平台上部署属于你自己的自动交易合约。合约的后续所有管理操作只能由合约的创建人执行。
将钱包中的资金转账到合约中。
创建自动化交易任务，并设置触发条件。条件可以基于时间、区块高度或与其他合约的交互数据设置。
当条件满足时，外部的矿工与你的合约进行交互，作为触发器执行特定的交易任务。
实现原理
本系统的自动交易智能合约将成为以太坊上ERC的一个标准。矿工们通过平台提供的程序接口或扫描以太坊上的合约接口，可以得到所有自动化交易合约及其自动化交易任务的信息。当自动化交易任务的条件满足时，矿工们通过竞争的方式提交触发执行交易的请求。合约会执行收到的第一个交易请求，并奖励提交交易的矿工。

## 费用
用户在以太坊上部署自动化交易合约及在合约中管理自动化交易任务时，平台不收取任何费用。用户只需要支付gas fee（或者平台可以考虑支付gas fee）。每次自动化交易，平台将从中收取一部分交易费用，用于奖励社区的参与者，包括用户、矿工和开发者们。交易费用支持ETH和稳定币两种方式，费用的价格与交易的类型有关。

## 代币模型
我们的去中心化自动化交易平台将采用两种代币：wrap token和管理代币。Wrap token用于方便用户在钱包中了解其自动化交易合约的投资组合情况。管理代币则用于支付交易费用、社区治理以及项目方向的投票治理。

### Wrap token
Wrap token是一种 ERC-20 token，每一个Wrap token代表一个特定的资产类型。用户在部署合约时，会自动创建一个Wrap token，用于记录其投资组合在该自动化交易合约中的权益。用户可以在钱包中查看其所有Wrap token的总价值，并了解其投资组合的情况。Wrap token的价值会随着该自动化交易合约中投资组合的变化而变化。

### 管理代币
管理代币是一种可替代代币（fungible token），用于支付交易费用、社区治理以及项目方向的投票治理。用户在部署自动化交易合约、管理自动化交易时，均会获得一定数量的管理代币。此外，在每次执行满足条件的自动化交易时，与合约交互出发交易执行的前三名矿工也会获得管理代币。

#### 治理
我们将通过社区投票来管理代币的发放规则和数量，以及交易费用的分配。每个持有管理代币的人都有投票权，可以参与项目方向的决策，如修改代币模型、增加新的功能等。在社区投票中，每个管理代币的持有者拥有一票，社区成员可以通过多数原则进行决策。我们将为社区提供一个去中心化的投票平台，确保投票过程的公正和透明。