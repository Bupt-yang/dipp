<template>
   <div class="carousel-figure">
       <Carousel autoplay dots='inside'>
           <Carousel-item>
             <div class="demo-carousel">
                 <img class="demo-img" src="../assets/images/zhuxue.jpg" />>
             </div>
           </Carousel-item>
           <Carousel-item>
              <div class="demo-carousel">
                <img class="demo-img" src="../assets/images/fupin.jpg" />>
              </div>
          </Carousel-item>
          <Carousel-item>
              <div class="demo-carousel">
                <img class="demo-img" src="../assets/images/yiliao.jpg">
              </div>
          </Carousel-item>
      </Carousel>
  </div>
</template>

<script>
export default {
  name: 'CarouselFigure'
}
</script>

<style scoped>
.demo-img{
    width:800px;
    height:350px
}

</style>
