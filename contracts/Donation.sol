pragma solidity ^0.5.16;

/// @title AccessControl
/// @author yang
/// @dev 实现核心角色的权限管理

contract AccessControl {
    /**
     * 按照职能设计了以下三个角色，避免权力过于集中。
     * CEO：能够调整其他角色和修改协议地址，协议暂停后只有它能够重启协议，保证安全性
     *CFO：控制代币的发行及兑换工作
     *COO：负责审核各类信息及其他需要权限进行的操作
     */

    // 执行每个角色的协议地址
    address public ceoAddress;
    address public cfoAddress;
    address public cooAddress;

    // 管理协议是否被暂定，暂停时大多数行动都会被阻塞
    bool public paused = false;

    // 协议升级时的事件
    event ContractUpgrade(address newContract);

    // 提供只有CEO能够使用的功能的权限检查
    modifier onlyCEO() {
        require(msg.sender == ceoAddress,"只有CEO能使用此功能");
        _;
    }

    // 提供只有CFO能够使用的功能的权限检查
    modifier onlyCFO() {
        require(msg.sender == cfoAddress,"只有CFO能使用此功能");
        _;
    }

    // 提供只有COO能够使用的功能的权限检查
    modifier onlyCOO() {
        require(msg.sender == cooAddress,"只有COO能使用此功能");
        _;
    }

    // 提供这三种角色都能够使用的功能的权限检查
    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress,"只有核心角色能使用此功能");
            _;
    }

    // 提供没有被暂停的状态检查
    modifier whenNotPaused() {
        require(!paused,"协议已经暂停");
        _;
    }

    // 提供已被暂停的状态检查
    modifier whenPaused {
        require(paused,"协议尚未暂停");
        _;
    }

    // 构造函数，默认该合约的创建者为第一任CEO
   constructor() public {
       ceoAddress = msg.sender;
   }

    /// @dev 让当前CEO指派一名新的CEO
    /// @param _newCEO 新的CEO的地址

    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));
        ceoAddress = _newCEO;
    }

    /// @dev 让CEO指派一名新的CFO
    /// @param _newCFO 新的CFO的地址
    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0));
        cfoAddress = _newCFO;
    }

    /// @dev 让CEO指派一名新的COO
    /// @param _newCOO 新的COO的地址
    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0));
        cooAddress = _newCOO;
    }

    /// @dev 三种角色都能够启动暂定操作，用以应对潜在的bug和缺陷，以降低损失
    function pause() external onlyCLevel whenNotPaused {
        paused = true;
    }

    /// @dev 只有CEO能够取消暂停状态，用来规避当CFO或COO被攻破的情况
    function unPause() public onlyCEO whenPaused {
        paused = false;
    }
}

/// @title Base
/// @author yang
/// @dev 保存公用的结构体、事件、基本变量

contract Base is AccessControl {
    // 捐赠者信息
    struct Donator {
        address addr; // 捐赠者地址
        uint amount; // 捐赠金额
        string name; // 捐赠者名称
    }

    // 捐款活动所包含的信息
    struct Campaign {
        string name; // 捐款活动的名称
        uint targetAmount; // 捐赠活动的目标金额
        uint durationInMinutes; // 捐赠活动以分钟为单位的持续时间
        uint deadline; // 捐赠活动的截止时间
        address recipient; // 接收方地址
        uint raisedAmount; // 捐赠活动已筹集的金额
        uint donatorAccount; // 已捐赠人数
        uint8 status; // 捐赠活动所处状态
        mapping (address => uint) donatorToID; // 捐赠者地址到id的映射
        //mapping (uint => Donator) donators; // 该项目的所有捐款者
        address[] donatorAddresses; // 该项目的所有捐款者地址
        uint[] donatorAmounts; // 该项目的所有捐款者的捐款金额
        string[] progresses; // 该项目的进展情况
    }

    // 每笔捐赠记录的信息
    struct DonationRecord {
        address donator; // 捐赠者地址
        address recipient; // 受益者地址
        uint amount; // 捐赠金额
        uint timestamp; // 捐赠时间戳
    }

    uint public ethExchangeRate = 1600; // 以太币和人民币的汇率，1 ether = ¥1600

     event Donate(address from, address to,  uint amount, uint timestamp);
     event UseDonation(address from, address to,  uint amount, uint timestamp);
     event WithdrawDonation(address recipient, uint amount, uint timestamp);
     event Refund(address from, address to,  uint amount, uint timestamp);
}

/// @title DonationProject
/// @author yang
/// @dev 提供了捐赠项目的管理功能，例如新建、审核、完成等功能。

contract DonationCampaign is Base {
    //address public owner;
    Campaign[] public  campaigns;
    uint public totalCampaigns;
    uint public activeCampaigns;

    event CampaignChange(uint campaignID, address recipient, string description);

    function createCampaign(
         string memory _name,
         uint _targetAmount,
         uint _durationInMinutes
    )   public {
        require(
            msg.sender != ceoAddress &&
            msg.sender != cfoAddress &&
            msg.sender != cooAddress,"管理人员不能创建项目"
        );
        address[] memory _donatorAddresses;
        uint[] memory _donatorAmounts;
        string[] memory _progresses;
        Campaign memory newCampaign = Campaign({
            name: _name,
            targetAmount: _targetAmount,
            durationInMinutes: _durationInMinutes,
            deadline: now + (_durationInMinutes * 1 minutes),
            recipient: msg.sender,
            raisedAmount: 0,
            donatorAccount: 0,
            status: 0,
            donatorAddresses: _donatorAddresses,
            donatorAmounts: _donatorAmounts,
            progresses:_progresses
        });
        campaigns.push(newCampaign);
        totalCampaigns++;
        emit CampaignChange(campaigns.length-1, newCampaign.recipient, "创建项目");
    }

    function updateStatus(uint campaignID,uint8 _status) private onlyCOO {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(_status >= 0 && _status <=4, "状态变量不合理");
        campaigns[campaignID].status = _status;
    }

    function rejectCampaign(uint campaignID) public onlyCOO {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(campaigns[campaignID].status == 0, "项目不处于审核期间");
        //delete campaigns[campaignID];
        updateStatus(campaignID, 1);
        emit CampaignChange(campaignID, campaigns[campaignID].recipient, "拒绝项目");
    }

     function approveCampaign(uint campaignID) public onlyCOO {
         require(campaignID < campaigns.length, "项目索引超出范围");
         require(campaigns[campaignID].status == 0, "项目不处于审核期间");
         updateStatus(campaignID, 2);
         activeCampaigns++;
         //totalCampaigns++;
         emit CampaignChange(campaignID, campaigns[campaignID].recipient, "发布项目");
     }

    function cancelCampaign(uint campaignID) public onlyCOO {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(campaigns[campaignID].status == 2, "项目不处于运行期间");
        updateStatus(campaignID, 3);
        activeCampaigns--;
        emit CampaignChange(campaignID, campaigns[campaignID].recipient, "意外终止项目");
    }

    function finalizeCampaign(uint campaignID) public onlyCOO {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(campaigns[campaignID].status == 2, "项目不处于运行期间");
        require(now > campaigns[campaignID].deadline,"项目还未到截止时间");
        require(campaigns[campaignID].raisedAmount >= campaigns[campaignID].targetAmount,"还未筹集到足够资金");
        uint amount = campaigns[campaignID].raisedAmount;
        campaigns[campaignID].raisedAmount = 0;
        address payable recipient = address(uint160(campaigns[campaignID].recipient));
        recipient.transfer(amount * 1 ether / ethExchangeRate);
        emit WithdrawDonation(campaigns[campaignID].recipient, amount, now);
        updateStatus(campaignID, 4);
        activeCampaigns--;
        emit CampaignChange(campaignID, campaigns[campaignID].recipient, "项目顺利完成");
    }

     function delayCampaign(uint campaignID, uint durationInMinutes) public onlyCOO {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(campaigns[campaignID].status == 2, "项目不处于运行期间");
        campaigns[campaignID].deadline += (durationInMinutes * 1 minutes);
        emit CampaignChange(campaignID, campaigns[campaignID].recipient, "延迟项目");
    }

     function updateCampaign(uint campaignID, string memory progress) public onlyCOO {
         campaigns[campaignID].progresses.push(progress);
         emit CampaignChange(campaignID, campaigns[campaignID].recipient, "更新项目进展");
     }
}

contract Donate is DonationCampaign {
    uint public minimumContribution;
    //Donator[] public donators;
    DonationRecord[] public donationRecords;
    uint public totalDonationRecords;
    uint public totalRaisedAmount;

    constructor() public {
        minimumContribution = 1 * 1 ether / ethExchangeRate;
    }

    function() external payable {

    }

    function donate(uint campaignID) public payable {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(campaigns[campaignID].status == 2, "项目不处于运行期间");
        require(msg.value >= minimumContribution,"捐款不得低于1块钱");
        Campaign storage campaign = campaigns[campaignID];
        address addr = address(msg.sender);
        uint amount = (ethExchangeRate * msg.value) / 1 ether;
        //Donator memory donator = Donator({addr: addr, amount: amount});
        uint id = campaign.donatorToID[addr];
        if(id > 0){
            //campaign.donators[id].amount += amount;
            campaign.donatorAmounts[id - 1] += amount;
        } else{
            campaign.donatorAccount++;
            //campaign.donatorAddresses[campaign.donatorAccount] = addr;
            //campaign.donatorAmounts[campaign.donatorAccount] = amount;
            campaign.donatorAddresses.push(addr);
            campaign.donatorAmounts.push(amount);
           // campaign.donators[campaign.donatorAccount] = donator;
            campaign.donatorToID[addr] = campaign.donatorAccount;
        }
        campaign.raisedAmount += amount;
        DonationRecord memory donationRecord = DonationRecord({
            donator: addr,
            recipient: campaign.recipient,
            amount: amount,
            timestamp:now
        });
        donationRecords.push(donationRecord);
        totalDonationRecords++;
        totalRaisedAmount += amount;
        emit Donate(msg.sender, campaign.recipient, amount, now);
    }

    function getDonatorByID(uint campaignID, uint donatorID) public view returns (address , uint) {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(campaigns[campaignID].status == 2 || campaigns[campaignID].status == 4, "项目异常");
        require(donatorID < campaigns[campaignID].donatorAccount, "捐赠者索引超出范围");
        //Donator memory donator = campaigns[campaignID].donators[donatorID];
        Campaign memory campaign = campaigns[campaignID];
        return (campaign.donatorAddresses[donatorID], campaign.donatorAmounts[donatorID]);
    }

    function getAllDonators(uint campaignID) public view returns(address[] memory, uint[] memory) {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(campaigns[campaignID].status == 2, "项目不处于运行期间");
        Campaign memory campaign = campaigns[campaignID];
        return (campaign.donatorAddresses, campaign.donatorAmounts);
    }

    function refund(uint campaignID) public {
        require(campaignID < campaigns.length, "项目索引超出范围");
        require(campaigns[campaignID].status == 3, "项目没有被提前终止");
        Campaign storage campaign = campaigns[campaignID];
        //address addr = msg.sender;
        uint id = campaign.donatorToID[msg.sender];
        require(id > 0,"你没为该项目捐过款");
        uint amount = campaign.donatorAmounts[id - 1];
        campaign.donatorAmounts[id - 1] = 0;
        msg.sender.transfer((amount * 1 ether) / ethExchangeRate);
        emit Refund(campaign.recipient,msg.sender,amount,now);
    }
}

contract Donation is Donate {

}
