<template>
    <div class="">
        <Tabs type="card">
            <TabPane label="爱心助学" icon="md-school">
                <div class="projects">
                    <div class="project-card" v-for="item in projectList">
                        <a :href="item.href" target="_blank">
                            <Card  >
                                <img :src="item.src" width="300" height="250">
                                <Tag  color="error"  slot="extra">{{item.type}}</Tag>
                                <h2>{{item.title}}</h2>
                                <span class="text">筹款目标</span><span class="number">{{item.total}}元</span><br />
                                <span class="text">已筹金额</span><span class="number">{{item.amount}}元</span>
                            </Card>
                        </a>
                    </div>
                </div>
            </TabPane>
            <TabPane label="扶贫助残" icon="md-walk"><h1>看啥看，我还在编数据呢</h1></TabPane>
            <TabPane label="医疗救助" icon="md-medkit"><h1>看啥看，我还在编数据呢</h1></TabPane>
            <TabPane label="环保/其他" icon="ios-leaf"><h1>看啥看，我还在编数据呢</h1></TabPane>
        </Tabs>
        <br />
        <div class="content-pagination">
            <Row>
                <Col span="10" offset="8" >
                      <Page :total="5" :page-size="4" show-total show-elevator @on-change="handleChange"/>
                </Col>
            </Row>
        </div>
    </div>
</template>
<script>
    import data from "./data.js";
    export default {
        name: 'MyTabs',
        data() {
            return {
                projectList: [],
                pageIndex: 0,
            }
        },
        created() {
            this.getData();
        },
        methods:{
            getData() {
                this.projectList = [];
                var j = this.pageIndex * 4;
                var k = (this.pageIndex+1)* 4 ;
                var len = data.projects.length;
                var num = 0;
                for(let i= j;i < k && i < len;i++){
                    this.projectList[num++] = data.projects[i];
                }
                console.log(this.projectList);
            },
            handleChange(val) {
                //console.log(val);
                this.pageIndex = val -1;
                this.getData();
            }
        }
    }
</script>

<style scoped>
>>>div.ivu-tabs-tab{
    font-size:20px;
    height:50px !important;
    margin-right: 20px!important;
}

>>>div.ivu-tabs-tab:hover{
    color:red;
}

>>>div.ivu-tabs-tab.ivu-tabs-tab-active.ivu-tabs-tab-focused{
    color:red;
    border-color:red;
}

>>>div.ivu-tabs-nav-container:focus .ivu-tabs-tab-focused {
    border-color: red!important;
    border-top-color: red !important;
    border-right-color: red !important;
    border-bottom-color: red !important;
    border-left-color: red !important;
}
.project-card {
    width:50;
    float:left;
    margin-right: 18px;
}
.project-card h2{
    color:black;
}
.project-card span {
    font-size:16px;
    color:black;
}
.project-card .text {
    display: inline-block;
    width:150px;
}
.project-card .number {
    display: inline-block;
    width:140px;
    color:red;
    text-align:right;
}
>>>.ivu-card-body {
    padding: 0px;

}

</style>
