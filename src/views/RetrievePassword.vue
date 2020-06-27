<template>
    <div >
        <div >
            <img src="../../src/assets/images/header.jpg" alt="头部图片">
            <router-link to="/login" style="float:right;margin-top:30px;margin-right:100px;font-size:18px">返回登录</router-link>
        </div>
        <div >
            <img src="../../src/assets/images/login.jpg" class="img" alt="登录图片">
        </div>
        <div class="main">
            <Divider><h2>重置密码</h2></Divider>
            <div class="steps">
                <Steps :current="current" >
                    <Step title="身份验证" icon="ios-man"></Step>
                    <Step title="密码重置" icon="md-refresh"></Step>
                    <Step title="重置完成" icon="ios-checkmark-circle"></Step>
                </Steps>
            </div>
            <div class="form"  v-show="current == 0">
                <Form ref="form" :model="form" :rules="rules" >
                    <div>
                        <FormItem prop="phone">
                            <Input type="text" v-model="form.phone" placeholder="请输入手机号" size="large">
                                <Icon size="26" type="ios-phone-portrait" slot="prepend"></Icon>
                            </Input>
                        </FormItem>
                        <FormItem prop="verificationCode" style="display:inline-block;width:295px;">
                                <Input type="text"  v-model="form.verificationCode"
                                 placeholder="请输入验证码" size="large"  >
                                    <Icon size="26" type="ios-send-outline" slot="prepend"></Icon>
                                </Input>
                        </FormItem>
                    <Button type="error" style="height:40px" :disabled="btndisabled" @click="handleSend">
                        {{btnTitle}}
                    </Button>
                </div>
            </Form>
            <div class="btn">
                <Button type="primary" @click="handleNext('form')" :disabled="disabled" style="float:left">下一步</Button>
                <Button type="primary"  @click="handleReset('form')" style="float:right">重置</Button>
           </div>
        </div>
        <div class="form"  v-show="current == 1">
            <Form ref="form1" :model="form1" :rules="rules1" >
                <div>
                    <FormItem prop="password">
                        <Input type="password" password v-model="form1.password" placeholder="请输入新密码" size="large">
                            <Icon size="26" type="ios-lock-outline" slot="prepend"></Icon>
                        </Input>
                    </FormItem>
                    <FormItem prop="passwordAgain">
                        <Input type="password" password v-model="form1.passwordAgain" placeholder="请再次输入密码" size="large">
                            <Icon size="26" type="ios-lock" slot="prepend"></Icon>
                        </Input>
                    </FormItem>
                </div>
            </Form>
            <div class="btn">
                <Button type="primary" @click="handleNext('form1')" :disabled="disabled" style="float:left">下一步</Button>
                <Button type="primary"  @click="handleReset('form1')" style="float:right">重置</Button>
           </div>
        </div>
        <div class="form"  v-show="current == 2">
            <div style="font-size:18px;text-align:center;width:500px;">新的登录密码已重置成功，请重新登录！</div>
            <div style="margin-top:40px;width:500px;height:100px;text-align:center;">
                <Button type="primary"  size="large" @click="handleLogin" >重新登录</Button>
            </div>
        </div>
    </div>
    </div>
</template>
<script>
    export default {
        data () {
            var validateCode = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('验证码不能为空'));
                } else if (value !== this.verificationCode) {
                    callback(new Error('验证码错误'));
                } else {
                    callback();
                }
            };
            var validatePass = (rule, value, callback) => {
                if (value !== this.form1.password) {
                    callback(new Error('两次输入密码不一致'));
                } else {
                    callback();
                }
            };
            return {
                current: 0,
                btnTitle: '发送验证码',
                verificationCode: '',
                disabled: false,
                btndisabled:false,
                form: {
                    phone: '',
                    verificationCode:''
                },
                rules: {
                    phone: [
                        { required: true, message: '手机号不能为空', trigger: 'blur' },
                    ],
                    verificationCode:[
                         { validator: validateCode, trigger: 'blur' }
                    ],
                },
                form1:{
                    password: '',
                    passwordAgain:''
                },
                rules1:{
                    password: [
                        { required: true, message: '密码不能为空', trigger: 'blur' },
                        { type: 'string', min: 6, message: '密码长度不能低于6位', trigger: 'blur' },
                        {pattern:/^[^\s]+$/,message: '密码中不能出现空白字符'}
                    ],
                    passwordAgain:[
                        { validator: validatePass, trigger: 'blur' }
                    ]
                },
            }
        },
        methods: {
            handleNext (name) {
                this.$refs[name].validate((valid) => {
                    if (valid) {
                        this.current += 1;
                        if(this.current==2){
                            this.disabled = true;
                        }
                        //this.$Message.success('注册成功!');
                    } else {
                        this.$Message.error('验证失败!');
                    }
                })
            },
            handleSend() {
                //倒计时
                let num = 60;
                let timer = setInterval(() => {
                if(num == 0) {
                 clearInterval(timer);
                 this.btndisabled = false;
                 this.btnTitle = "发送验证码";
                } else {
                 this.btnTitle =num + '秒后重试';
                 this.verificationCode="1234";
                 this.btndisabled = true;
                 num--;
                }
            },1000);
            },
            handleReset(name) {
                this.$refs[name].resetFields();
            },
            handleLogin() {
                this.$router.push('/login');
            }
        }
    }
</script>
<style scoped>
.img{
     background-repeat: no-repeat;
     width: 100%;
     height:800px;
}
.main {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 600px;
    height:400px;
    transform: translate(-50%, -50%);
    background-color: white;
}
.steps {
    margin-top:20px;
    margin-left:50px;
    margin-right:50px;
}
.form{
    margin-top:50px;
    margin-left:50px;
    width:400px;
    height:400px;
}
.btn{
    margin-left:150px;
    width:200px;
}
>>> .ivu-btn-error[disabled] {
    color: white;
    background-color:red;
}
>>> .ivu-steps .ivu-steps-title{
    font-size:18px;
}

</style>
