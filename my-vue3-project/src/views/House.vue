<template>
  <div class="house-container">
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
        <a href="/house-list">房源大厅</a>
        <a href="/house" v-if="user.role === '房东'" class="active">我的房源</a>
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

    <div class="house-header">
      <h2>房源信息管理</h2>
      <div>
        <el-button type="success" @click="showAppointmentDialog">查看预约</el-button>
        <el-button type="primary" @click="showAddDialog">发布房源</el-button>
      </div>
    </div>
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input v-model="searchForm.title" placeholder="请输入房源标题" style="width: 200px; margin-right: 10px;" />
      <el-select v-model="searchForm.status" placeholder="房源状态" style="width: 150px; margin-right: 10px;">
        <el-option label="全部" value="" />
        <el-option label="上架中" value="1" />
        <el-option label="已下架" value="2" />
      </el-select>
      <el-button type="primary" @click="getMyHouseList(searchForm.title, searchForm.status)">搜索
      </el-button>
      <el-button @click="resetSearch">重置</el-button>
      <!-- 房源列表 -->
      <el-table :data="houseList" style="width: 100%; margin-top: 20px;" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="房源标题" min-width="200" />
        <el-table-column prop="address" label="地址" min-width="200" />
        <el-table-column prop="price" label="租金(元/月)" width="120" />
        <el-table-column prop="area" label="面积(㎡)" width="100" />
        <el-table-column prop="roomNumber" label="房间数" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : (scope.row.status === 2 ? 'warning' : 'info')">
              {{
                scope.row.status === 1 ? '上架中' : (scope.row.status === 2 ? '已下架' : '待审核')
              }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button type="primary" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(scope.row)">删除</el-button>
            <el-button v-if="scope.row.status === 1" type="warning" size="small"
              @click="toggleHouseListStatus(scope.row, 2)">下架
            </el-button>
            <el-button v-else type="success" size="small" :disabled="scope.row.status === 0"
              @click="toggleHouseListStatus(scope.row, 0)">上架
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>


    <!-- 分页 -->
    <el-pagination style="margin-top: 20px; justify-content: flex-end;" layout="total, sizes, prev, pager, next"
      :total="total" :page-size="pageSize" :current-page="currentPage" @current-change="handlePageChange"
      @size-change="handleSizeChange" />
    <!-- 新增/编辑对话框 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form :model="form" :rules="rules" ref="houseForm" label-width="100px">
        <el-form-item label="房源标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入房源标题" />
        </el-form-item>
        <el-form-item label="详细地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入详细地址" />
        </el-form-item>
        <el-form-item label="租金" prop="price">
          <el-input-number v-model="form.price" :min="0" style="width: 200px;" />
          <span style="margin-left: 10px;">元/月</span>
        </el-form-item>
        <el-form-item label="面积" prop="area">
          <el-input-number v-model="form.area" :min="0" style="width: 200px;" />
          <span style="margin-left: 10px;">㎡</span>
        </el-form-item>
        <el-form-item label="房间数" prop="roomNumber">
          <el-input-number v-model="form.roomNumber" :min="1" :max="10" style="width: 200px;" />
        </el-form-item>
        <el-form-item label="房源描述" prop="details">
          <el-input v-model="form.details" type="textarea" :rows="4" placeholder="请输入房源描述" />
        </el-form-item>
        <el-form-item label="房源图片" prop="urls">
          <el-upload action="/files/upload" list-type="picture-card" :file-list="fileList"
            :on-success="handleUploadSuccess" :on-remove="handleRemove">
            <el-icon>
              <Plus />
            </el-icon>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 预约列表对话框 -->
    <el-dialog title="我的预约列表" v-model="appointmentDialogVisible" width="1200px">
      <el-table :data="appointmentList" style="width: 100%;" border align="center">
        <el-table-column prop="id" label="预约 ID" width="80" />
        <el-table-column prop="title" label="房源标题" min-width="250" />
        <el-table-column prop="userId" label="用户 ID" width="100" />
        <el-table-column prop="phone" label="联系电话" width="150" />
        <el-table-column label="预约时间" width="180">
          <template #default="scope">
            {{ formatTime(scope.row.time) }}
          </template>
        </el-table-column>
        <el-table-column prop="note" label="备注" min-width="200" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getBookingStatusType(scope.row.status)">
              {{ getBookingStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button v-if="scope.row.status === 0" type="success" size="small"
              @click="handleConfirmBooking(scope.row)">确认
            </el-button>
            <el-button v-if="scope.row.status === 0" type="danger" size="small" @click="handleCancelBooking(scope.row)">拒绝
            </el-button>

          </template>
        </el-table-column>
      </el-table>
      <template #footer>
        <el-button @click="appointmentDialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>


  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { House, Plus } from "@element-plus/icons-vue";
import request from "@/utils/request.js";
import { normalizeUrl } from "@/utils/urlHelper.js";
import router from "@/router/index.js";

const houseList = ref([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);
const dialogVisible = ref(false);
const dialogTitle = ref('发布房源');
const isEdit = ref(false);
const fileList = ref([]);
const user = JSON.parse(localStorage.getItem('user'));//把字符串转成对象，不然无法直接调用
const searchForm = reactive({
  title: '',
  status: ''
});
const isLoggedIn = ref(false);
const userInfo = ref({});
// 预约相关变量
const appointmentDialogVisible = ref(false);
const appointmentList = ref([]);

const form = reactive({
  id: null,
  title: '',
  region: '',
  address: '',
  price: 0,
  area: 0,
  roomNumber: 1,
  details: '',
  urls: [],
  status: 1,
  userId: user.id,
});

const rules = {
  title: [{ required: true, message: '请输入房源标题', trigger: 'change' }],
  region: [{ required: true, message: '请选择所在地区', trigger: 'change' }],
  address: [{ required: true, message: '请输入详细地址', trigger: 'change' }],
  price: [{ required: true, message: '请输入租金', trigger: 'change' }],
  area: [{ required: true, message: '请输入面积', trigger: 'change' }],
  roomNumber: [{ required: true, message: '请输入房间数', trigger: 'change' }]
};

const houseForm = ref();

// 获取房源列表
const getHouseList = () => {
  request.get("/houseList/selectByUserId", {
    params: {
      pageSize: pageSize.value,
      pageNum: currentPage.value,
      userId: user.id
    }
  }).then(res => {
    if (res.code === "200") {
      houseList.value = res.data;
      total.value = res.data.total;
    }
  });
};
//搜索自有房源
const getMyHouseList = (title, status) => {
  request.get("/houseList/myHouseList", { params: { title, status } }).then(res => {
    if (res.code === '200') {
      houseList.value = res.data;
      total.value = res.data.total;
    }
  })
}
//上/下架房源
const toggleHouseListStatus = (row, status) => {
  const action = row.status === 1 ? '下架' : '上架';
  ElMessageBox.confirm(`确定要${action}该房源吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.put("/admin/updateHouseStatus", { id: row.id, status: status }).then(res => {
      if (res.code === "200") {
        ElMessage.success('操作完成');
      }
      getHouseList();
    });
  });
};
// 搜索
const handleSearch = () => {
  currentPage.value = 1;
  getHouseList();
};

// 重置搜索
const resetSearch = () => {
  searchForm.title = '';
  searchForm.status = '';
  handleSearch();
};

// 显示新增对话框
const showAddDialog = () => {
  isEdit.value = false;
  dialogTitle.value = '发布房源';
  resetForm();
  dialogVisible.value = true;
};

// 编辑
const handleEdit = (row) => {
  isEdit.value = true;
  dialogTitle.value = '编辑房源';
  Object.assign(form, row);
  // 清空图片列表，防止显示其他房源的图片
  fileList.value = [];
  // 如果有图片URL，设置到 fileList
  if (row.urls) {
    // 判断是数组还是字符串
    if (Array.isArray(row.urls)) {
      fileList.value = row.urls.map(url => ({ url: normalizeUrl(url), name: url }));
    } else {
      const urls = row.urls.split(',');
      fileList.value = urls.map(url => ({ url: normalizeUrl(url), name: url }));
    }
  }
  dialogVisible.value = true;
};

// 上架/下架
const handleToggleStatus = (row) => {
  const newStatus = row.status === 1 ? 0 : 1;
  request.post("/house/updateStatus", { id: row.id, status: newStatus }).then(res => {
    if (res.code === "200") {
      ElMessage.success('操作成功');
      getHouseList();
    }
  });
};

// 删除
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该房源吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.delete(`/houseList/delete/${row.id}`).then(res => {
      if (res.code === "200") {
        ElMessage.success('删除成功');
        getHouseList();
      }
    });
  });
};

// 提交表单
const handleSubmit = () => {
  houseForm.value.validate((valid) => {
    if (valid) {
      // 处理地区数据，将数组转换为字符串
      const formData = { ...form };
      if (Array.isArray(formData.region)) {
        formData.region = formData.region.join(',');
      }

      if (isEdit.value) {
        request.put("/houseList/update", formData).then(res => {
          if (res.code === "200") {
            ElMessage.success('修改成功');
            dialogVisible.value = false;
            getHouseList();
          } else {
            ElMessage.error(res.msg);
          }
        });
      } else {
        request.post("/houseList/insert", formData).then(res => {
          if (res.code === "200") {
            ElMessage.success('发布成功');
            dialogVisible.value = false;
            getHouseList();
          } else {
            ElMessage.error(res.msg);
          }
        });
      }
    }
  });
};

// 重置表单
const resetForm = () => {
  form.id = null;
  form.title = '';
  form.region = '';
  form.address = '';
  form.price = 0;
  form.area = 0;
  form.roomNumber = 1;
  form.details = '';
  form.urls = [];
  form.status = 0;  // 新房源默认待审核状态
  fileList.value = [];
};

// 图片上传成功
const handleUploadSuccess = (response) => {
  if (!form.urls) {
    form.urls = [];
  }
  form.urls.push(response.data);
};

// 删除图片
const handleRemove = (file) => {
  const url = file.response ? file.response.data : file.url;
  const index = form.urls.indexOf(url);
  if (index > -1) {
    form.urls.splice(index, 1);
  }
};

// 分页
const handlePageChange = (page) => {
  currentPage.value = page;
  getHouseList();
};

const handleSizeChange = (size) => {
  pageSize.value = size;
  getHouseList();
};

// 显示预约列表对话框
const showAppointmentDialog = () => {
  getLandlordAppointments();
  appointmentDialogVisible.value = true;
};

// 获取房东的所有预约
const getLandlordAppointments = () => {
  request.get("/booking/selectBookingByLandlordId", {
    params: {
      landlordId: user.id
    }
  }).then(res => {
    if (res.code === "200") {
      appointmentList.value = res.data;
    }
    console.log(res.data);
    console.log(appointmentList)
  });
};

// 格式化时间
const formatTime = (timeStr) => {
  if (!timeStr) return '';
  // 使用 Date 对象格式化时间，保留到秒
  const date = new Date(timeStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

// 获取预约状态标签类型
const getBookingStatusType = (status) => {
  const map = {
    0: 'warning',  // 待确认
    1: 'success',  // 已确认
    2: 'danger',   // 已取消
  };
  return map[status] || 'info';
};

// 获取预约状态文本
const getBookingStatusText = (status) => {
  const map = {
    0: '待确认',
    1: '已确认',
    2: '已拒绝',
  };
  return map[status] || '未知';
};

// 确认预约
const handleConfirmBooking = (row) => {
  ElMessageBox.confirm('确定要确认该预约吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.put("/booking/updateStatus", { id: row.id, status: 1 }).then(res => {
      if (res.code === "200") {
        ElMessage.success('确认成功');
        getLandlordAppointments();
      }
    });
  });
};

// 取消预约
const handleCancelBooking = (row) => {
  ElMessageBox.confirm('确定要拒绝该预约吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.put("/booking/updateStatus", {
      id: row.id,
      status: 2
    }).then(res => {
      if (res.code === "200") {
        ElMessage.success('取消成功');
        getLandlordAppointments();
      }
    });
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
.house-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
  margin-top: 70px;
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

.house-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.house-header h2 {
  margin: 0;
  color: #303133;
}

.search-bar {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
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

.house-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.house-header h2 {
  margin: 0;
  color: #303133;
}

.search-bar {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
}

@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }
}
</style>
