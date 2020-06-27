<template>
    <div  >
        <Card class="notice-board">
            <br /><br />
            <span class="title">捐赠次数</span><br />
            <span class="data">{{times | fomatData}}&nbsp;次</span><br />
            <span class="title">捐赠总额</span><br />
            <span class="data" style="color:#FF0000">{{total | fomatData}}&nbsp;元</span><br />
            <span class="title">实时捐款数据</span><br />
            <div class="scroll-wrap">
              <div class="scroll-content" :style="{ top }" @mouseenter="Stop()" @mouseleave="Up()">
                <div v-for="item in messageList" class="msg">
                     <span class="name">{{item.name}}</span><span class="time">{{item.time}}</span><span class="amount">￥{{item.amount  | fomatData}}</span>
                </div>
              </div>
            </div>
            <br>
        </Card>

    </div>
</template>

<script>
    import data from "./data.js";
    export default {
        name: 'NoticeBoard',
        data() {
           return {
                times: 1314,
                total: 31522,
                messageList: [],
                activeIndex: 0,
                num: ''
           }
       },
       filters: {
           fomatData(n) {
               let num = n.toString().split('.');
               num[0] = num[0].replace(/\B(?=(\d{3})+(?!\d))/g,',');
               return num.join('.');
           }
       },
       computed: {
           top(){
               return -this.activeIndex * 19 + 'px'
           }
       },
       created () {
           this.getData();
           this.ScrollUp();
       },
       methods: {
           getData() {
               this.messageList = data.msgList;
           },
           ScrollUp () {
               this.num = setInterval(_ => {
                   if (this.activeIndex < this.messageList.length -5) {
                       this.activeIndex += 1
                   } else {
                       this.getData();
                       this.activeIndex = 0
                   }
               }, 1000)
            },
             Stop () {
               clearInterval(this.num)
             },
             Up () {
               this.ScrollUp()
             }
       }
    }
</script>

<style scoped>
    .notice-board{
        background-image: url('https://i.loli.net/2020/06/15/WGX7S6LbjAPhUyt.jpg');
         background-repeat:no-repeat;

    }
    .title {
        font-size:18px ;
        font-family: 'Serif';
        font-weight:bold;
    }
    .data{
        font-size:25px ;
        color:#FF6600
    }
    .scroll-wrap {
      height: 100px;
      overflow: hidden;
    }
    .scroll-content {
      position: relative;
      transition: top 0.5s;
    }
    .scroll-content p {
      line-height: 20px;
      text-align: center;
    }
    .msg{
        color:#FF0000;
        font-size:13px ;
    }
    .name {
        margin-left:10px;
        display:inline-block;
        width:120px;
    }
    .time {
        display:inline-block;
         width:120px;
    }
    .amount {

    }

</style>
