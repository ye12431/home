<template>
  <div class="house-list-container">
    <!-- 导航栏 -->
    <nav class="navbar">
      <div class="nav-brand">
        <el-icon class="brand-icon">
          <House />
        </el-icon>
        <span>房屋租赁系统</span>
      </div>
      <div class="nav-menu">
        <a href="/">首页</a>
        <a href="/house-list" class="active">房源大厅</a>
        <a href="/house" v-if="user.role === '房东'">我的房源</a>
      </div>
      <div class="nav-actions">
        <template v-if="!isLoggedIn">
          <el-button type="primary" @click="$router.push('/login')">登录</el-button>
          <el-button @click="$router.push('/register')">注册</el-button>
        </template>
        <template v-else>
          <el-dropdown @command="handleCommand">
            <span class="user-menu">
              <el-avatar :size="32" :src="userInfo.avatar" />
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

    <!-- 搜索栏 -->
    <div class="search-section">
      <div class="search-box">
        <h2>发现您的理想住所</h2>
        <div class="search-inputs">
          <el-input v-model="searchForm.address" placeholder="请输入房源位置" size="large" style="width: 400px;" />
          <el-select v-model="searchForm.price" placeholder="租金范围" size="large" style="width: 150px; margin-left: 10px;">
            <el-option label="不限" value="" />
            <el-option label="1000元以下" value="0-1000" />
            <el-option label="1000-2000元" value="1000-2000" />
            <el-option label="2000-3000元" value="2000-3000" />
            <el-option label="3000元以上" value="5000-" />
          </el-select>
          <el-select v-model="searchForm.roomNumber" placeholder="房型" size="large"
            style="width: 120px; margin-left: 10px;">
            <el-option label="不限" value="" />
            <el-option label="1室" value="1" />
            <el-option label="2室" value="2" />
            <el-option label="3室" value="3" />
            <el-option label="4室及以上" value="4" />
          </el-select>
          <el-button type="primary" size="large" style="margin-left: 10px;" @click="handleSearch">
            搜索
          </el-button>
        </div>
      </div>
    </div>

    <!-- 房源列表 -->
    <div class="list-content">
      <div class="filter-bar">
        <span>共找到 {{ total }} 套房源</span>
      </div>

      <div class="house-grid">
        <el-card v-for="item in houseList" :key="item.id" class="house-card" shadow="hover" @click="goDetail(item)">
          <div class="house-image">
            <img :src="item.urls && item.urls.length > 0 ? normalizeUrl(item.urls[0]) : '/default-house.jpg'"
              alt="房源图片" />
          </div>
          <div class="house-info">
            <h3 class="house-title">{{ item.title }}</h3>
            <p class="house-address">
              <el-icon>
                <Location />
              </el-icon>
              {{ item.address }}
            </p>
            <div class="house-features">
              <span>{{ item.area }}㎡</span>
              <span>|</span>
              <span>{{ item.roomNumber }}室</span>
            </div>
            <div class="house-footer">
              <span class="house-price">{{ item.price }}<span class="unit">元/月</span></span>
              <el-button type="primary" size="small" @click.stop="handleAppointment(item)">
                预约看房
              </el-button>
            </div>
          </div>
        </el-card>
      </div>

      <!-- 分页 -->
      <el-pagination style="margin-top: 30px; justify-content: center;" layout="prev, pager, next" :total="total"
        :page-size="pageSize" :current-page="currentPage" @current-change="handlePageChange" />
    </div>

    <!-- 预约对话框 -->
    <el-dialog title="预约看房" v-model="appointmentVisible" width="500px">
      <el-form :model="appointmentForm" :rules="appointmentRules" ref="appointmentFormRef" label-width="100px">
        <el-form-item label="预约房源">
          <span>{{ selectedHouse?.title }}</span>
        </el-form-item>
        <el-form-item label="预约时间" prop="appointmentTime">
          <el-date-picker v-model="appointmentForm.appointmentTime" type="datetime" placeholder="选择预约时间"
            :disabled-date="disablePastDate" style="width: 100%;" />
        </el-form-item>
        <el-form-item label="联系电话" prop="contactPhone">
          <el-input v-model="appointmentForm.contactPhone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="appointmentForm.remark" type="textarea" :rows="3" placeholder="请输入备注信息" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="appointmentVisible = false">取消</el-button>
        <el-button type="primary" @click="submitAppointment">提交预约</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import { House, Location } from "@element-plus/icons-vue";
import request from "@/utils/request.js";
import { normalizeUrl } from "@/utils/urlHelper.js";
import router from "@/router/index.js";

const user = JSON.parse(localStorage.getItem("user") || '{}');
const houseList = ref([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(12);
const appointmentVisible = ref(false);
const selectedHouse = ref(null);
const appointmentFormRef = ref();
const isLoggedIn = ref(false);
const userInfo = ref({});

const searchForm = reactive({
  address: '',
  price: '',
  roomNumber: ''
});

const appointmentForm = reactive({
  houseId: null,
  appointmentTime: '',
  contactPhone: '',
  remark: ''
});

const disablePastDate = (date) => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return date.getTime() < today.getTime();
};

const appointmentRules = {
  appointmentTime: [{ required: true, message: '请选择预约时间', trigger: 'change' }],
  contactPhone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的11位手机号码', trigger: 'blur' }
  ]
};

// 获取房源列表
const getHouseList = () => {
  request.get("/houseList/selectPage", {
    params: {
      ...searchForm,
      pageSize: pageSize.value,
      pageNum: currentPage.value
    }
  }).then(res => {
    if (res.code === "200") {
      console.log(res.data.list)
      houseList.value = res.data.list;
      total.vue = res.data.total;
      total.value = res.data.total;
    }
    console.log(searchForm)
  });
};

// 搜索
const handleSearch = () => {
  currentPage.value = 1;
  getHouseList();
};

// 分页
const handlePageChange = (page) => {
  currentPage.value = page;
  getHouseList();
};

// 查看详情
const goDetail = (item) => {
  // 检查是否登录
  const user = localStorage.getItem('user');
  if (!user) {
    ElMessage.warning('请先登录后再查看详情');
    router.push('/login');
    return;
  }
  router.push(`/house/detail/${item.id}`);
};

// 预约看房
const handleAppointment = (item) => {
  // 检查是否登录
  const user = localStorage.getItem('user');
  if (!user) {
    ElMessage.warning('请先登录后再预约');
    router.push('/login');
    return;
  }
  selectedHouse.value = item;
  appointmentForm.houseId = item.id;
  appointmentVisible.value = true;
};

// 提交预约
const submitAppointment = () => {
  appointmentFormRef.value.validate((valid) => {
    if (valid) {
      request.post("/appointment/add", appointmentForm).then(res => {
        if (res.code === "200") {
          ElMessage.success('预约成功');
          appointmentVisible.value = false;
          appointmentForm.appointmentTime = '';
          appointmentForm.contactPhone = '';
          appointmentForm.remark = '';
        } else {
          ElMessage.error(res.msg);
        }
      });
    }
  });
};

// 检查登录状态
const checkLoginStatus = () => {
  const user = localStorage.getItem('user');
  if (user) {
    isLoggedIn.value = true;
    userInfo.value = JSON.parse(user);
  }
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
  }
};

onMounted(() => {
  checkLoginStatus();
  getHouseList();
});
</script>

<style scoped>
.house-list-container {
  min-height: 100vh;
  background: #f5f7fa;
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

/* 搜索栏 */
.search-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 130px 20px 60px;
  text-align: center;
  margin-top: 70px;
}

.search-box h2 {
  color: #fff;
  font-size: 32px;
  margin-bottom: 30px;
}

.search-inputs {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.list-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px 20px;
}

.filter-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  color: #606266;
}

.house-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.house-card {
  cursor: pointer;
  transition: transform 0.3s ease;
}

.house-card:hover {
  transform: translateY(-5px);
}

.house-image {
  position: relative;
  height: 180px;
  overflow: hidden;
  border-radius: 4px;
}

.house-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.house-tag {
  position: absolute;
  top: 10px;
  left: 10px;
  background: rgba(102, 126, 234, 0.9);
  color: #fff;
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 12px;
}

.house-info {
  padding: 15px 0 0;
}

.house-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.house-address {
  font-size: 13px;
  color: #909399;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.house-features {
  font-size: 13px;
  color: #606266;
  margin-bottom: 12px;
}

.house-features span {
  margin-right: 8px;
}

.house-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.house-price {
  font-size: 20px;
  font-weight: 600;
  color: #f56c6c;
}

.house-price .unit {
  font-size: 12px;
  font-weight: normal;
  color: #909399;
}

@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }

  .search-box h2 {
    font-size: 24px;
  }

  .search-inputs {
    flex-direction: column;
    width: 100%;
  }

  .search-inputs .el-input,
  .search-inputs .el-select {
    width: 100% !important;
    margin-left: 0 !important;
  }
}
</style>
