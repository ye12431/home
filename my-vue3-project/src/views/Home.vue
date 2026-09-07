<template>
  <div class="home-container">
    <!-- 导航栏 -->
    <nav class="navbar">
      <div class="nav-brand">
        <el-icon class="brand-icon">
          <House />
        </el-icon>
        <span>房屋租赁系统</span>
      </div>
      <div class="nav-menu">
        <a href="/" class="active">首页</a>
        <a href="/house-list">房源大厅</a>
        <a href="/house" v-if="userInfo.role === '房东'">我的房源</a>
      </div>
      <div class="nav-actions">
        <template v-if="!isLoggedIn">
          <el-button type="primary" @click="$router.push('/login')">登录</el-button>
          <el-button @click="$router.push('/register')">注册</el-button>
        </template>
        <template v-else>
          <el-dropdown @command="handleCommand">
            <span class="user-menu">
              <el-avatar :size="32" :src="normalizeUrl(userInfo.avatar)" />
              <span>{{ userInfo.name }}</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>
      </div>
    </nav>

    <!-- 公告栏 -->
    <div class="notice-bar">
      <el-icon class="notice-icon">
        <Bell />
      </el-icon>
      <div class="notice-text">
        <span class="notice-label">公告：</span>
        <span class="notice-content">{{ noticeText }}</span>
      </div>
    </div>

    <!-- Hero 区域 -->
    <section class="hero-section">
      <div class="hero-content">
        <h1>找到您的理想住所</h1>
        <p>海量真实房源，专业租房服务，让找房变得简单</p>
      </div>
    </section>

    <!-- 精选房源 -->
    <section class="featured-section">
      <div class="section-header">
        <h2>精选房源</h2>
        <p>为您推荐优质好房</p>
      </div>
      <div class="houses-grid">
        <el-card v-for="house in featuredHouses" :key="house.id" class="house-card" shadow="hover"
          @click="goDetail(house)">
          <div class="house-image">
            <img :src="house.urls && house.urls.length > 0 ? normalizeUrl(house.urls[0]) : '/default-house.jpg'"
              alt="房源图片" />
            <div class="house-price">{{ house.price }}元/月</div>
          </div>
          <div class="house-content">
            <h4 class="house-title">{{ house.title }}</h4>
            <p class="house-location">
              <el-icon>
                <Location />
              </el-icon>
              {{ house.address }}
            </p>
            <div class="house-tags">
              <el-tag size="small">{{ house.roomNumber }}室</el-tag>
              <el-tag size="small">{{ house.area }}㎡</el-tag>
            </div>
          </div>
        </el-card>
      </div>
      <div class="view-more">
        <el-button type="primary" size="large" @click="$router.push('/house-list')">
          查看更多房源
        </el-button>
      </div>
    </section>

    <!-- 功能特色 -->
    <section class="features-section">
      <div class="section-header">
        <h2>为什么选择我们</h2>
        <p>专业的租房服务平台，为您提供全方位的租房体验</p>
      </div>
      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon" style="background: #e3f2fd;">
            <el-icon>
              <Search />
            </el-icon>
          </div>
          <h3>海量房源</h3>
          <p>覆盖全城优质房源，真实可靠，每日更新</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon" style="background: #f3e5f5;">
            <el-icon>
              <Location />
            </el-icon>
          </div>
          <h3>精准定位</h3>
          <p>基于地理位置智能推荐，找房更便捷</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon" style="background: #e8f5e9;">
            <el-icon>
              <Calendar />
            </el-icon>
          </div>
          <h3>在线预约</h3>
          <p>一键预约看房，省时省力，快速响应</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon" style="background: #fff3e0;">
            <el-icon>
              <Lock />
            </el-icon>
          </div>
          <h3>安全保障</h3>
          <p>实名认证房东，房源审核，租房更安心</p>
        </div>
      </div>
    </section>

    <!-- 租房流程 -->
    <section class="process-section">
      <div class="section-header">
        <h2>租房流程</h2>
        <p>简单三步，轻松租房</p>
      </div>
      <div class="process-steps">
        <div class="step-item">
          <div class="step-num">1</div>
          <h4>搜索房源</h4>
          <p>浏览海量真实房源</p>
        </div>
        <div class="step-arrow">
          <el-icon>
            <ArrowRight />
          </el-icon>
        </div>
        <div class="step-item">
          <div class="step-num">2</div>
          <h4>预约看房</h4>
          <p>在线预约看房时间</p>
        </div>
        <div class="step-arrow">
          <el-icon>
            <ArrowRight />
          </el-icon>
        </div>
        <div class="step-item">
          <div class="step-num">3</div>
          <h4>实地看房</h4>
          <p>现场查看房屋情况</p>
        </div>
      </div>
    </section>

    <!-- 关于我们 -->
    <section id="about" class="about-section">
      <div class="about-content">
        <div class="about-text">
          <h2>关于房屋租赁系统</h2>
          <p>
            我们致力于为租客和房东搭建一个安全、便捷的租房平台。通过严格的房源审核机制和完善的用户服务体系，让每一次租房都变得简单放心。</p>
        </div>
        <div class="about-image">
          <div class="image-placeholder">
            <el-icon>
              <House />
            </el-icon>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer">
      <p>房屋租赁系统</p>
    </footer>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { ArrowRight, Bell, Calendar, House, Location, Lock, Search } from "@element-plus/icons-vue";
import request from "@/utils/request.js";
import { normalizeUrl } from "@/utils/urlHelper.js";

const router = useRouter();
const searchKeyword = ref('');
const isLoggedIn = ref(false);
const userInfo = ref({});
const featuredHouses = ref([]);
const noticeText = ref('暂无公告');

// 检查登录状态
const checkLoginStatus = () => {
  const user = localStorage.getItem('user');
  if (user) {
    isLoggedIn.value = true;
    userInfo.value = JSON.parse(user);
    console.log(userInfo.value.role)
  }
};

// 获取精选房源
const getFeaturedHouses = () => {
  request.get("/houseList/exquisiteHouse").then(res => {
    if (res.code === "200") {
      featuredHouses.value = res.data;
    }
  });
};

// 获取公告
const getNotice = () => {
  request.get("/notice/selectAll").then(res => {
    if (res.code === "200" && res.data && res.data.length > 0) {
      // 取最后一条公告（最新的）
      noticeText.value = res.data[res.data.length - 1].title;
    }
  });
};
// 查看详情
const goDetail = (house) => {
  router.push(`/house/detail/${house.id}`);
};

// 用户菜单
const handleCommand = (command) => {
  if (command === 'profile') {
    router.push('/profile');
  } else if (command === 'logout') {
    localStorage.removeItem('user');
    isLoggedIn.value = false;
    userInfo.value = {};
    ElMessage.success('已退出登录');
    router.push('/login');
  }
};

onMounted(() => {
  checkLoginStatus();
  getFeaturedHouses();
  getNotice();
});
</script>

<style scoped>
.home-container {
  min-height: 100vh;
}

/* 导航栏 */
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 70px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 50px;
  z-index: 1000;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

/* 公告栏 */
.notice-bar {
  position: fixed;
  top: 70px;
  left: 20px;
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  padding: 10px 20px;
  border-radius: 20px;
  z-index: 99;
  max-width: 300px;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.notice-icon {
  font-size: 18px;
  color: #ff9800;
  margin-right: 10px;
  flex-shrink: 0;
}

.notice-text {
  display: flex;
  align-items: center;
  overflow: hidden;
}

.notice-label {
  font-size: 12px;
  color: #ff9800;
  font-weight: 600;
  flex-shrink: 0;
}

.notice-content {
  font-size: 13px;
  color: #606266;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-left: 5px;
}

.nav-brand {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 20px;
  font-weight: 600;
  color: #667eea;
}

.brand-icon {
  font-size: 28px;
}

.nav-menu {
  display: flex;
  gap: 40px;
}

.nav-menu a {
  text-decoration: none;
  color: #606266;
  font-size: 15px;
  transition: color 0.3s;
}

.nav-menu a:hover,
.nav-menu a.active {
  color: #667eea;
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-menu {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 5px 10px;
  border-radius: 20px;
}


.hero-section {
  background: url('/53031fcb-ad34-423c-a129-f4aec3061993.png') no-repeat center center/cover;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.hero-content h1 {
  font-size: 48px;
  font-weight: 700;
  color: #ffffff;
  margin-bottom: 16px;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.5);
}

.hero-content p {
  font-size: 18px;
  color: #ffffff;
  margin-bottom: 40px;
  text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
}

.search-box {
  max-width: 600px;
  margin: 0 auto;
}

/* 精选房源 */
.featured-section {
  padding: 60px 20px;
  background: #f5f7fa;
}

.section-card {
  max-width: 1200px;
  margin: 0 auto;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  padding: 50px;
}

.section-header {
  text-align: center;
  margin-bottom: 50px;
}

.section-header h2 {
  font-size: 36px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 15px;
}

.section-header p {
  font-size: 16px;
  color: #909399;
}

.houses-grid {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.house-card {
  cursor: pointer;
  transition: transform 0.3s;
}

.house-card:hover {
  transform: translateY(-5px);
}

.house-image {
  position: relative;
  height: 180px;
  overflow: hidden;
}

.house-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.house-price {
  position: absolute;
  bottom: 10px;
  left: 10px;
  background: rgba(245, 108, 108, 0.9);
  color: #fff;
  padding: 5px 12px;
  border-radius: 4px;
  font-weight: 600;
}

.house-content {
  padding: 15px;
}

.house-title {
  font-size: 16px;
  color: #303133;
  margin-bottom: 10px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.house-location {
  font-size: 13px;
  color: #909399;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.house-tags .el-tag {
  margin-right: 5px;
}

.view-more {
  text-align: center;
  margin-top: 40px;
}

/* 功能特色 */
.features-section {
  padding: 60px 20px;
  background: #fff;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 30px;
}

.feature-card {
  text-align: center;
  padding: 40px 20px;
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s, box-shadow 0.3s;
}

.feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.feature-icon {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 20px;
  font-size: 36px;
  color: #667eea;
}

.feature-card h3 {
  font-size: 20px;
  color: #303133;
  margin-bottom: 10px;
}

.feature-card p {
  color: #909399;
  font-size: 14px;
  line-height: 1.6;
}

/* 租房流程 */
.process-section {
  padding: 60px 20px;
  background: #f5f7fa;
}

.process-steps {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
}

.step-item {
  text-align: center;
  flex: 1;
}

.step-num {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  font-size: 24px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 15px;
}

.step-item h4 {
  font-size: 18px;
  color: #303133;
  margin-bottom: 8px;
}

.step-item p {
  color: #909399;
  font-size: 14px;
}

.step-arrow {
  color: #c0c4cc;
  font-size: 24px;
}

/* 关于我们 */
.about-section {
  padding: 60px 20px;
  background: #fff;
}

.about-content {
  display: flex;
  align-items: center;
  gap: 60px;
}

.about-text {
  flex: 1;
}

.about-text h2 {
  font-size: 36px;
  color: #303133;
  margin-bottom: 20px;
}

.about-text>p {
  color: #606266;
  line-height: 1.8;
  margin-bottom: 30px;
}

.about-features {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.about-item {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #303133;
}

.about-item .el-icon {
  color: #67c23a;
  font-size: 20px;
}

.about-image {
  flex: 1;
  display: flex;
  justify-content: center;
}

.image-placeholder {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 100px;
  color: rgba(255, 255, 255, 0.3);
}

/* 页脚 */
.footer {
  background: #304156;
  color: #bfcbd9;
  padding: 30px;
  text-align: center;
}

/* 响应式 */
@media (max-width: 1200px) {

  .houses-grid,
  .features-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }

  .hero-content h1 {
    font-size: 32px;
  }

  .houses-grid,
  .features-grid {
    grid-template-columns: 1fr;
  }

  .process-steps {
    flex-direction: column;
  }

  .step-arrow {
    transform: rotate(90deg);
  }

  .about-content {
    flex-direction: column;
  }
}

@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }

  .hero-content h1 {
    font-size: 32px;
  }

  .houses-grid {
    grid-template-columns: 1fr;
  }
}
</style>
