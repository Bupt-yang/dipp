<template>
    <div class="main">
        <div class="header" >
            <img src="../../src/assets/images/header.jpg" alt="头部图片">
        </div>
        <div >
            <img src="../../src/assets/images/login.jpg" class="img" alt="登录图片">
        </div><br />
        <div class="footer">
            <div >北京邮电大学网络技术研究院</div>
            <div>CopyRight © 2020 Beijing University of Posts and Telecommunications All Rights Reserved.</div>
        </div>
        <div id="login">
            <div class="wrapper">
                <div class="login" >
                    <div class="from-wrap" v-show="isLogin" >
                        <Divider><h2>登录</h2></Divider>
                        <Form ref="form" :model="form" :rules="rules" >
                            <div id="owl-login" :class="{'password': isPassword}">
                                <div class="hand"></div>
                                <div class="hand hand-r"></div>
                                <div class="arms">
                                    <div class="arm"></div>
                                    <div class="arm arm-r"></div>
                                </div>
                            </div>
                            <FormItem prop="user">
                                <Input type="text" v-model="form.user" placeholder="请输入手机号" size="large">
                                    <Icon size="26" type="ios-person-outline" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                            <FormItem prop="password">
                                <Input type="password" password v-model="form.password" placeholder="请输入密码"
                                @on-focus="handleFocus" @on-blur="handleBlur" size="large">
                                    <Icon size="26" type="ios-lock-outline" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                            <FormItem>
                                <div class="">
                                     <Checkbox v-model="remember_password" style="float:left;">7天内免登录</Checkbox>
                                     <a href="#"style="float:right;" @click.prevent="handleRetrievePwd">忘记密码？</a>
                                </div>
                            </FormItem>
                            <FormItem>
                                <Button type="primary" @click="handleLogin('form') " style="width:344px">
                                    <span style="font-size:18px">登录</span>
                                </Button>
                            </FormItem>
                            <FormItem>
                                <div style="text-align:center">
                                    <span>没有账号？</span>
                                    <a href="#" @click.prevent="handleChange">立即注册</a>
                                </div>
                            </FormItem>
                        </Form>
                    </div>
                    <div class="from-wrap1" v-show="!isLogin" >
                        <Divider><h2>注册</h2></Divider>
                        <Form ref="form1" :model="form1" :rules="rules1" >
                            <div id="owl-login" :class="{'password': isPassword}">
                                <div class="hand"></div>
                                <div class="hand hand-r"></div>
                                <div class="arms">
                                    <div class="arm"></div>
                                    <div class="arm arm-r"></div>
                                </div>
                            </div>
                            <FormItem prop="username">
                                <Input type="text" v-model="form1.username" placeholder="请输入用户名" size="large">
                                    <Icon size="26" type="ios-person-outline" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                            <FormItem prop="phone">
                                <Input type="text" v-model="form1.phone" placeholder="请输入手机号" size="large">
                                    <Icon size="26" type="ios-phone-portrait" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                                <FormItem prop="verificationCode" style="display:inline-block;width:235px;">
                                        <Input type="text"  v-model="form1.verificationCode"
                                         placeholder="请输入验证码" size="large"  >
                                            <Icon size="26" type="ios-send-outline" slot="prepend"></Icon>
                                        </Input>
                                </FormItem>
                                <Button type="error" style="height:40px" :disabled="disabled" @click="handleSend">
                                    {{btnTitle}}
                                </Button>
                            <FormItem prop="password">
                                <Input type="password" password v-model="form1.password" placeholder="请输入密码"
                                @on-focus="handleFocus" @on-blur="handleBlur" size="large">
                                    <Icon size="26" type="ios-lock-outline" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                            <FormItem prop="passwordAgain">
                                <Input type="password" password v-model="form1.passwordAgain" placeholder="请再次输入密码"
                                @on-focus="handleFocus" @on-blur="handleBlur" size="large">
                                    <Icon size="26" type="ios-lock" slot="prepend"></Icon>
                                </Input>
                            </FormItem>
                            <FormItem>
                                <div class="">
                                     <Checkbox v-model="isAgree" >我已阅读并同意<router-link to="/protocol">《用户协议》</router-link></Checkbox>
                                </div>
                            </FormItem>
                            <FormItem>
                                <Button type="primary" @click="handleRegister('form1') " style="width:344px">
                                    <span style="font-size:18px">注册</span>
                                </Button>
                            </FormItem>
                            <FormItem>
                                <div style="text-align:center">
                                    <span>已有账号？</span>
                                    <a href="#" @click.prevent="handleChange">立即登录</a>
                                </div>
                            </FormItem>
                        </Form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>

    export default {
        data () {
                var validatePass = (rule, value, callback) => {
                    if (value === '') {
                        callback(new Error('确认密码不能为空'));
                    } else if (value !== this.form1.password) {
                        callback(new Error('两次输入密码不一致'));
                    } else {
                        callback();
                    }
                };
            var validateCode = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('验证码不能为空'));
                } else if (value !== this.verificationCode) {
                    callback(new Error('验证码错误'));
                } else {
                    callback();
                }
            };
            return {
                isPassword:false,
                remember_password: false,
                isAgree: false,
                isLogin: true,
                disabled: false,
                btnTitle: '发送验证码',
                verificationCode:'',
                form: {
                    user: '',
                    password: ''
                },
                rules: {
                    user: [
                        { required: true, message: '账号不能为空', trigger: 'blur' },
                    ],
                    password: [
                        { required: true, message: '密码不能为空', trigger: 'blur' },

                    ]
                },
                form1: {
                    username: '',
                    phone: '',
                    verificationCode: '',
                    password: '',
                    passwordAgain: ''
                },
                rules1: {
                    username: [
                         { required: true, message: '用户名不能为空', trigger: 'blur' },
                         { type: 'string', max: 8, message: '用户名长度不能高于8位', trigger: 'blur' }
                    ],
                    phone: [
                        { required: true, message: '账号不能为空', trigger: 'blur' },
                         { pattern:/^[1][3,4,5,7,8][0-9]{9}$/, message: '请输入有效的手机号', trigger: 'blur' }
                    ],
                    verificationCode:[
                         { validator: validateCode, trigger: 'blur' }
                    ],
                    password: [
                        { required: true, message: '密码不能为空', trigger: 'blur' },
                        { type: 'string', min: 6, message: '密码长度不能低于6位', trigger: 'blur' },
                        {pattern:/^[^\s]+$/,message: '密码中不能出现空白字符'}
                    ],
                    passwordAgain:[
                        { validator: validatePass, trigger: 'blur' }
                    ]
                }
            }
        },
        mounted() {
            this.getCookie();
        },
        methods: {
            setCookie(c_user, c_pwd, exdays) {
                var exdate = new Date();
                exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays); //保存的天数
                document.cookie = "user=" + c_user + ";path=/;expires=" + exdate.toLocaleString()
                document.cookie = "userPwd=" + c_pwd + ";path=/;expires=" + exdate.toLocaleString()
            },
          getCookie: function() {
                if (document.cookie.length > 0) {
                    var arr = document.cookie.split('; ');
                    for (var i = 0; i < arr.length; i++) {
                        var arr2 = arr[i].split('=');
                        if (arr2[0] == 'user') {
                            this.form.user = arr2[1];
                        } else if (arr2[0] == 'userPwd') {
                            this.form.password = arr2[1];
                        }
                    }
                }
            },
           clearCookie: function() {
                this.setCookie("", "", -1); //修改2值都为空，天数为负1天就好了
            },
            handleFocus() {
                this.isPassword = true;
            },
            handleBlur() {
                this.isPassword = false;
            },
            handleChange() {
                this.isLogin = ! this.isLogin;
            },
            handleSend() {
                //倒计时
                let num = 60;
                let timer = setInterval(() => {
                if(num == 0) {
                 clearInterval(timer);
                 this.disabled = false;
                 this.btnTitle = "发送验证码";
                } else {
                 this.btnTitle =num + '秒后重试';
                 this.verificationCode="1234";
                 this.disabled = true;
                 num--;
                }
            },1000);
            },
            handleRetrievePwd() {
                this.$router.push({ path: '/retrievePassword' })
            },
            handleLogin(name) {
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        if(this.remember_password == true){
                            this.setCookie(this.form.user, this.form.password, 7);//设置cookie
                        }
                        else{
                            this.clearCookie();//清除cookie
                        }
                        sessionStorage.setItem("userName","杨某");
                        this.$Message.success('登录成功!');
                        this.$router.push('/');
                    } else {
                        this.$Message.error('登录失败!');
                    }
                })
            },
            handleRegister(name) {
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        if(this.isAgree == false){
                            alert("必须先确认接受用户协议");
                        } else{
                            this.$Message.success('注册成功!');
                            this.isLogin = true;
                        }
                    } else {
                        this.$Message.error('注册失败!');
                    }
                })
            }
        }
    }
</script>

<style scoped>
html,body {
    width: 100%;
    height: 100%;
    background-color: white;
    overflow:hidden
}
.main {
    height:950px;
}
.img{
     background-repeat: no-repeat;
     width: 100%;
     height:800px;
}
.login {
    width: 100%;
    height: 100%;
    background-color: white;
    position: relative;
}
#login .login {
    height: 0px;
    margin-top: 100px;
}
.login .from-wrap{
    position: fixed;
    left: 50%;
    margin-left: 460px;
    top: 50%;
    margin-top: -200px;
    width: 400px;
    height: 420px;
    border-radius: 10px;
    background-color: #fff;
    padding: 20px 30px;
}
.login .from-wrap1{
    position: fixed;
    left: 50%;
    margin-left: 460px;
    top: 50%;
    margin-top: -200px;
    width: 400px;
    height: 580px;
    border-radius: 10px;
    background-color: #fff;
    padding: 20px 30px;
}
.login h2 {
    text-align: center;
    margin-bottom: 20px;
}
.login FormItem {
    margin-bottom: 15px;
}
.login .form-footer {
    text-align: right;
}
.ivu-form-item-required .ivu-form-item-label:before {
    display: none;
}
.footer {
    text-align:center;
}
>>> .ivu-btn-error[disabled] {
    color: white;
    background-color:red;
}
</style>
