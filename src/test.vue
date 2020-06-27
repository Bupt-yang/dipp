<template>
    <div class="">
        <div class="">
            <Divider orientation="left" style="color:red">申请项目</Divider>
        </div>
        <div class="">
            <Row>
                <Col span="6" offset="9">
                    <div class="">
                        <Form ref="formInline" :model="formInline" :rules="ruleInline" >
                            <FormItem label="项目名称" prop="name">
                                <Input type="text" v-model="formInline.name" placeholder="ProjectName">
                                    <Icon type="ios-cube" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                            <FormItem label="目标金额" prop="targetAmount">
                                <Input type="number" v-model="formInline.targetAmount" placeholder="TargetAmount">
                                    <Icon type="logo-yen" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                            <FormItem label="持续时间(分钟)" prop="duration">
                                <Input type="number" v-model="formInline.duration" placeholder="Duration">
                                    <Icon type="ios-alarm" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                            <FormItem>
                                <Button type="primary" @click="handleSubmit('formInline')" >申请</Button>
                                <Button type="warning" @click="handleReset('formInline')" style="margin-left: 20px">取消</Button>
                            </FormItem>
                        </Form>
                    </div>
                </Col>
            </Row>
        </div>
        <div class="">
            <Divider orientation="left" style="color:red">权限管理</Divider>
        </div>
        <div class="">
            <div>
                <span style="font-size:18px">当前ceo地址：{{ceoAddress}} </span>
                <Button type="primary" style="margin-left: 20px">设置</Button>
            </div>
            <div>
                <span style="font-size:18px">当前cfo地址：{{cfoAddress}} </span>
                <Button type="primary" style="margin-left: 20px" >设置</Button>
            </div>
            <div>
                <span style="font-size:18px">当前coo地址：{{cooAddress}} </span>
                <Button type="primary" style="margin-left: 20px" @click="handleSetCOO">设置</Button>
            </div>
        </div>
        <div class="">
            <Divider orientation="left" style="color:red">项目管理</Divider>
        </div>
        <div class="">
            <Table  :columns="columns" :data="projectList">
                <template slot-scope="{ row, index }" slot="action">
                    <Button type="primary" size="small" style="margin-right: 5px" @click="handleApprove(index)">允许</Button>
                    <Button type="error" size="small" style="margin-right: 5px" @click="handleReject(index)">拒绝</Button>
                    <Button type="error" size="small" style="margin-right: 5px" @click="handleCancel(index)">终止</Button>
                    <Button type="success" size="small" style="margin-right: 5px" @click="handleFinalize(index)">结束</Button>
                </template>
            </Table>
        </div>
        <div class="">
            <Divider orientation="left" style="color:red">项目公示</Divider>
        </div>
        <div class="">
             <Table  :columns="columns1" :data="projectList">
                 <template slot-scope="{ row, index }" slot="action">
                     <Button type="info" size="small" style="margin-right: 5px" @click="handleShowDetail(row)">查看详情</Button>
                     <Button type="primary" size="small" style="margin-right: 5px" @click="handleDonate(index)" :disabled="isApproveDonate(row)">捐款</Button>
                     <Button type="error" size="small" style="margin-right: 5px" @click="handleRefund(index)" :disabled="isApproveRefund(row)">退款</Button>
                 </template>
             </Table>
        </div>
        <div class="">
            <Divider orientation="left" style="color:red">捐赠明细</Divider>
            <div class="">
                 <Table  :columns="columns2" :data="donationList">
                     <template slot-scope="{ row, index }" slot="action">

                     </template>
                 </Table>
            </div>
        </div>
    </div>
</template>
<script>
import Web3 from "web3";
import contract from "truffle-contract";
import donationArtifact from '../build/contracts/Donation.json';

    export default {
        data () {
            return {
                modal1:false,
                formInline: {
                    name: '',
                    targetAmount: '',
                    duration: ''
                },
                columns: [
                    {
                        title: '项目名称',
                        key: 'name'
                    },
                    {
                        title: '目标金额',
                        key: 'targetAmount'
                    },
                    {
                        title: '持续时间',
                        key: 'durationInMinutes'
                    },
                    {
                        title: '截止时间',
                        key: 'times'
                    },
                    {
                        title: '善款接收方地址',
                        key: 'recipient'
                    },
                    {
                        title: '操作',
                        slot: 'action',
                        width: 400,
                        align: 'center'
                    }
                ],
                columns1:[
                    {
                        title: '项目名称',
                        key: 'name'
                    },
                    {
                        title: '区块hash',
                        key: 'blockHash'
                    },
                    {
                        title: '交易hash',
                        key: 'txHash'
                    },
                    {
                        title: '项目状态',
                        key: 'status'
                    },
                    {
                        title: '操作',
                        slot: 'action',
                        width: 400,
                        align: 'center'
                    }
                ],
                columns2:[
                    {
                        title: '捐赠者',
                        key: 'donator'
                    },
                    {
                        title: '接收者',
                        key: 'recipient'
                    },
                    {
                        title: '捐赠金额',
                        key: 'amount'
                    },
                    {
                        title: '捐赠时间',
                        key: 'times'
                    },
                ],
                projectList:[],
                donationList:[],
                ceoAddress: '',
                cfoAddress: '',
                cooAddress: '',
                totalCampaigns: 0,
                totalDonationRecords:0,
                ruleInline: {
                    name: [
                        { required: true, message: 'Please fill in the ProjectName', trigger: 'blur' }
                    ],
                    targetAmount: [
                        { required: true, message: 'Please fill in the TargetAmount.', trigger: 'blur' },
                    ],
                    duration: [
                        { required: true, message: 'Please fill in the Duration.', trigger: 'blur' },
                    ]
                }
            }
        },
        async created() {
            await this.initWeb3();
            await this.initAccount();
            await this.initContract();
            await this.getInfo();
           //console.log(new Date());
        },
        computed:{
            isApproveDonate(){
                return(row) => {
                    if(row.status === "活跃"){
                        return false;
                    }
                    else{
                        return true;
                    }
                }
            },
            isApproveRefund(){
                return(row) => {
                    if(row.status === "终止"){
                        return false;
                    }
                    else{
                        return true;
                    }
                }
            },
        },
        methods: {
            timeConvert(timestamp){
                    timestamp = timestamp+'';
                    timestamp = timestamp.length==10?timestamp*1000:timestamp;
                    var date = new Date(timestamp);
                    var y = date.getFullYear();  
                    var m = date.getMonth() + 1;  
                    m = m < 10 ? ('0' + m) : m;  
                    var d = date.getDate();  
                    d = d < 10 ? ('0' + d) : d;  
                    var h = date.getHours();
                    h = h < 10 ? ('0' + h) : h;
                    var minute = date.getMinutes();
                    var second = date.getSeconds();
                    minute = minute < 10 ? ('0' + minute) : minute;  
                    second = second < 10 ? ('0' + second) : second; 
                    return y + '-' + m + '-' + d +' '+ h +':'+ minute +':' + second;  
                },
            async initWeb3() {
                //var Web3 = require('web3');
                if (typeof web3 !== 'undefined') {
                    this.web3Provider = web3.currentProvider;
                    this.web3 = new Web3(this.web3Provider);
                } else {
                    this.web3Provider = new Web3.providers.HttpProvider("http://localhost:7545");
                    this.web3 = new Web3(this.web3Provider);
                }
                /*this.web3.eth.getAccounts().then(accs => {
                    this.account = accs[0];
                    console.log(accs);
                })*/
            },
            async  initContract() {
                //var contract = require("@truffle/contract");
                //var donationArtifact = require("../build/contracts/Donation.json");
                this.donationContract = contract(donationArtifact);
                this.donationContract.setProvider(this.web3Provider);
                this.donationInstance = await this.donationContract.deployed();
                //console.log(this.donationInstance);
            },
            async initAccount() {
                this.web3.eth.getAccounts().then(accs => {
                    this.account = accs[0];
                })
            },
            async handleSetCOO() {
                var res = await this.donationInstance.setCOO("0xA5d6A0Ed0Dd8254c4367d1c4AbF2fE5192f10D16",
                {
                    from:this.account
                },
                );
                //console.log(res);
            },
            async createCampaign() {
                var res = await this.donationInstance.createCampaign(this.formInline.name, this.formInline.targetAmount,
                    this.formInline.duration,{from:this.account});
                    //this.projectList[this.num].txHash = res.tx;
                   // this.projectList[this.num].blockHash = res.blockHash;
                   var key = this.formInline.name + "tx";
                   var key1 = this.formInline.name + "block";
                   sessionStorage.setItem(key, res.tx);
                   sessionStorage.setItem(key1,res.receipt.blockHash);
                   //console.log(res.tx);
                  // console.log(res.receipt.blockHash);
            },
            async getInfo() {
                this.donationInstance.ceoAddress().then(
                    r => this.ceoAddress = r,
                );
                this.donationInstance.cfoAddress().then(
                    r => this.cfoAddress = r,
                );
                this.donationInstance.cooAddress().then(
                    r => this.cooAddress = r,
                );
                this.donationInstance.totalCampaigns().then(
                    r =>{
                        this.totalCampaigns = Number(r);
                        var maps = new Map();
                        maps.set(0,'待审核');
                        maps.set(1,'拒绝');
                        maps.set(2,'活跃');
                        maps.set(3,'终止');
                        maps.set(4,'结束');
                         for(let i=0;i<this.totalCampaigns;i++){
                             var res =this.donationInstance.campaigns(i).then(
                                 r => {
                                     var b = r;
                                     b.txHash=sessionStorage.getItem(b.name+'tx');
                                     b.blockHash=sessionStorage.getItem(b.name+'block');
                                     b.times= this.timeConvert(b.deadline);
                                     b.status = maps.get(Number(b.status));
                                     this.projectList.push(b);
                                 }
                             );
                         }
                    }
                );

                this.donationInstance.totalDonationRecords().then(
                     r=>{
                         this.totalDonationRecords = Number(r);
                         for(let i=0;i<this.totalDonationRecords;i++){
                             var res =this.donationInstance.donationRecords(i).then(
                                 r => {
                                     var b = r;
                                     b.times= this.timeConvert(b.timestamp);
                                     this.donationList.push(b);
                                 }
                             );
                         }
                     }
                 );
            },
            handleSubmit(name) {
                this.createCampaign();
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        this.$Message.success('Success!');
                    } else {
                        this.$Message.error('Fail!');
                    }
                })
            },
            async handleApprove(index){
                var res = await this.donationInstance.approveCampaign(index,
                {
                    from:this.account
                },
            );
            },
            async handleReject(index){
                var res = await this.donationInstance.rejectCampaign(index,
                {
                    from:this.account
                },
            );
            },
            async handleCancel(index){
                var res = await this.donationInstance.cancelCampaign(index,
                {
                    from:this.account
                },
            );
            },
            async handleFinalize(index){
                var res = await this.donationInstance.finalizeCampaign(index,
                {
                    from:this.account
                },
            );
            },
            handleShowDetail(row){
                const title = '项目详细信息';
                //const content = '<p>'row.name'</p>';
                if(row.progresses==null) row.progresses='暂无'
                this.$Modal.info({
                    render: (h) => {
                         return h('div',[
                             h('p','项目名称：'+row.name),
                             h('p','项目筹款目标：'+row.targetAmount+'元'),
                             h('p','项目截止时间：'+row.times),
                             h('p','项目收款人地址：'+row.recipient),
                             h('p','项目已筹款项：'+row.raisedAmount+'元'),
                              h('p','项目捐赠人数：'+row.donatorAccount+'人'),
                             h('p','项目进展：'+row.progresses),
                             h('p','项目状态：'+row.status)
                         ])
                     }
                        });
            },
            async handleDonate(index){
                //500000000000000000
                var res = await this.donationInstance.donate(index,
                {
                    from:this.account,
                    value: this.web3.utils.toWei('10','ether')
                },
                );
            },
            async handleRefund(index){
                var res = await this.donationInstance.refund(index,
                {
                    from:this.account,
                },
                );
            },
            handleReset(name) {
                this.$refs[name].resetFields();
            }
        }
    }
</script>
