<template>
  <div id="home">
      <Affix>
          <div class="header">
              <div class="header-navigation">
                  <Row>
                      <my-navigation-bar></my-navigation-bar>
                  </Row>
              </div>
          </div>
      </Affix>
      <br />
      <div class="content">
          <div class="content-notice">
              <Row>
                  <Col span="10" offset="2">
                      <my-carousel-figure></my-carousel-figure>
                  </Col>
                  <Col span="6"offset="1" style="width:400px;height:350px">
                      <my-notice-board></my-notice-board>
                  </Col>
              </Row>
          </div>
          <div class="content-search">
              <Row>
                  <Col span="6" offset="13">
                      <div class="search" style="width:400px">
                             <Input search enter-button placeholder="搜索公益项目" @on-search="handleSearch"/>
                      </div>
                  </Col>
              </Row>
          </div>
          <div class="content-information">
              <Row>
                  <Col span="17" offset="2" >
                      <my-tabs></my-tabs>
                  </Col>
              </Row>
          </div>
          <br />
          <div class="footer">
              <div>北京邮电大学网络技术研究院</div>
              <div>CopyRight © 2020 Beijing University of Posts and Telecommunications All Rights Reserved.</div>
          </div>
      </div>
  </div>
</template>

<script>

import MyNavigationBar from '@/components/NavigationBar.vue'
import MyCarouselFigure from '@/components/CarouselFigure.vue'
import MyNoticeBoard from '@/components/NoticeBoard.vue'
import MyTabs from '@/components/Tabs.vue'

export default {
  name: 'App',
  components: {
      MyNavigationBar,
      MyCarouselFigure,
      MyNoticeBoard,
      MyTabs
  },
  data() {
      return {

      }
  },
  methods: {
      handleSearch(val) {
          //console.log(val);
          const title = '搜索结果';
          const content ="对不起，没有找到名为\'"+val+"\'的项目相关信息!";
          this.$Modal.error({
              title: title,
              content: content
          });
      }
  }
}
</script>


<style scoped>
.footer div{
    font-size: 15px;
    text-align: center;
}
</style>
