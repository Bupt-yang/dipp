import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../views/Login.vue'
import RetrievePassword from '../views/RetrievePassword.vue'
import Protocol from '../views/Protocol.vue'
import Home from '../views/Home.vue'


Vue.use(VueRouter)

  const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/',
    name: 'Home',
    // route level code-splitting
    // this generates a separate chunk (home.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import('../views/Home.vue'),
    meta:{requireAuth:true}
},
{
    path: '/retrievePassword',
    name: 'RetrievePassword',
    component: () => import('../views/RetrievePassword.vue')
},
{
    path: '/protocol',
    name: 'Protocol',
    component: () => import('../views/Protocol.vue'),
    meta:{requireAuth:true}
},
]

const router = new VueRouter({
  mode: 'history',
  routes
})

export default router
