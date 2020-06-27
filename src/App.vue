<template>
  <div id="app">
    <router-view/>
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
