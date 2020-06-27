<template>
    <div class="navigation-bar">
        <Menu mode="horizontal" :theme="theme" active-name="1" @on-select="handleSelect">
            <Row>
                <Col span="4" offset="2">
                    <img src="../assets/logo.jpg" height="60" alt="logo">
                </Col>
                <Col span="12" offset="4">
                    <MenuItem name="1">
                        <Icon type="ios-paper" size="20"/>
                        <span>浏览项目</span>
                    </MenuItem>
                    <Submenu name="2">
                        <template slot="title">
                            <Icon type="md-clipboard" size="20" />
                           <span> 项目公示</span>
                        </template>
                        <MenuItem name="2-1"><span>项目信息</span></MenuItem>
                        <MenuItem name="2-2"><span>进展追溯</span></MenuItem>
                        <MenuItem name="2-3"><span>捐赠明细</span></MenuItem>
                    </Submenu>
                    <Submenu name="3">
                        <template slot="title">
                            <Icon type="md-git-network" size="20" />
                           <span> 公益节点</span>
                        </template>
                        <MenuItem name="3-1"><span>已签约组织</span></MenuItem>
                        <MenuItem name="3-2"><span>加入我们</span></MenuItem>
                    </Submenu>
                    <Submenu name="4">
                        <template slot="title">
                            <Icon type="md-hand" size="20" />
                           <span> 我要求助</span>
                        </template>
                        <MenuItem name="4-1"><span>申请救助</span></MenuItem>
                        <MenuItem name="4-2"><span>发起项目</span></MenuItem>
                    </Submenu>
                    <Submenu name="5">
                        <template slot="title">
                            <Icon type="md-cart" size="20" />
                           <span> 购买服务</span>
                        </template>
                        <MenuItem name="5-1"><span>医疗服务</span></MenuItem>
                        <MenuItem name="5-2"><span>教育服务</span></MenuItem>
                        <MenuItem name="5-2"><span>物资服务</span></MenuItem>
                        <MenuItem name="5-2"><span>其他服务</span></MenuItem>
                    </Submenu>
                </Col>
                <Col span="2">
                    <div class="btn-login"  v-if="show">
                        <Avatar icon="ios-person"  style="margin-right:20px" size="large" />
                        <router-link to="/login" v-show="!isLogin" style="font-size:16px">登录</router-link>
                        <Dropdown @on-click="handleClick" v-show="isLogin">
                            <span style="font-size:18px">
                                {{userName}}
                                <Icon type="ios-arrow-down"></Icon>
                            </span>
                            <DropdownMenu slot="list" >
                                <DropdownItem name="1">个人中心</DropdownItem>
                                <DropdownItem name="2">我的消息</DropdownItem>
                                <DropdownItem name="3">注销</DropdownItem>
                            </DropdownMenu>
                        </Dropdown>
                    </div>
                </Col>

            </Row>
        </Menu>
    </div>

</template>

<script >
    export default {
        name: 'NavigationBar',
        data () {
            return {
                theme: 'light',
                avatarSrc: '',
                userName:'',
                show: true,
                isLogin:null,
            }
        },
        created() {
            this.userName = sessionStorage.getItem('userName');
            if(this.userName != null){
                this.isLogin = true;
            }
            else{
                this.isLogin = false;
            }
            //console.log( this.userName);
        },
        methods:{
            handleSelect(name) {
                switch(name){
                    case '5-3':
                        this.loginOut();
                        break;
                    default :
                    break;
                };
            },
            handleClick(name) {
                console.log(name);
                switch(name){
                    case '3':
                        this.loginOut();
                        break;
                    default :
                    break;
                };
            },
            loginOut() {
                this.$Message.success('注销成功');
                sessionStorage.removeItem('userName')
                this.$router.push('/login');
            }
        }
    }
</script>

<style scoped>

span{
    font-size:20px
}

.login img {
    margin-top: 5px;
     border-radius:50%
}

>>> .ivu-menu-light.ivu-menu-horizontal .ivu-menu-item-active, .ivu-menu-light.ivu-menu-horizontal .ivu-menu-item:hover, .ivu-menu-light.ivu-menu-horizontal .ivu-menu-submenu-active, .ivu-menu-light.ivu-menu-horizontal .ivu-menu-submenu:hover {
    color: red;
    border-bottom: 2px solid red;
    border-bottom-width: 2px;
    border-bottom-style: solid;
    border-bottom-color: red;
}

.ivu-btn {color: black}
.ivu-btn:hover {color: red}
>>> .ivu-dropdown-item:hover {color: red}
</style>
