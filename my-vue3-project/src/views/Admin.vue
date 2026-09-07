<template>
  <div class="admin-container">
    <el-aside width="200px" class="admin-sidebar">
      <div class="sidebar-header">
        <h3>后台管理</h3>
      </div>
      <el-menu :default-active="activeMenu" class="admin-menu" background-color="#304156"
               text-color="#bfcbd9"
               active-text-color="#409eff" @select="handleMenuSelect">
        <el-menu-item index="dashboard">
          <el-icon>
            <DataLine/>
          </el-icon>
          <span>数据仪表盘</span>
        </el-menu-item>
        <el-menu-item index="users">
          <el-icon>
            <User/>
          </el-icon>
          <span>用户管理</span>
        </el-menu-item>
        <el-menu-item index="houses">
          <el-icon>
            <House/>
          </el-icon>
          <span>房源审核</span>
        </el-menu-item>
        <el-menu-item index="landlords">
          <el-icon>
            <UserFilled/>
          </el-icon>
          <span>房东审核</span>
        </el-menu-item>
        <el-menu-item index="comments">
          <el-icon>
            <ChatDotRound/>
          </el-icon>
          <span>评论管理</span>
        </el-menu-item>
        <el-menu-item index="house">
          <el-icon>
            <ChatDotRound/>
          </el-icon>
          <span>房源管理</span>
        </el-menu-item>
        <el-menu-item index="announcements">
          <el-icon>
            <Bell/>
          </el-icon>
          <span>公告管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <div class="admin-main">
      <!-- 顶部栏 -->
      <div class="admin-header">
        <div class="header-left">
          <span>房屋租赁系统后台管理</span>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              {{ userInfo.username }}
              <el-icon class="el-icon--right"><arrow-down/></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>

      <!-- 内容区 -->
      <div class="admin-content">
        <!-- 仪表盘 -->
        <div v-if="activeMenu === 'dashboard'">
          <el-row :gutter="20">
            <el-col :span="6">
              <el-card class="stat-card">
                <div class="stat-icon" style="background: #409eff;">
                  <el-icon>
                    <User/>
                  </el-icon>
                </div>
                <div class="stat-info">
                  <p class="stat-title">总用户数</p>
                  <p class="stat-value">{{ statistics.userCount }}</p>
                </div>
              </el-card>
            </el-col>
            <el-col :span="6">
              <el-card class="stat-card">
                <div class="stat-icon" style="background: #67c23a;">
                  <el-icon>
                    <House/>
                  </el-icon>
                </div>
                <div class="stat-info">
                  <p class="stat-title">房源总数</p>
                  <p class="stat-value">{{ statistics.houseCount }}</p>
                </div>
              </el-card>
            </el-col>
            <el-col :span="6">
              <el-card class="stat-card">
                <div class="stat-icon" style="background: #e6a23c;">
                  <el-icon>
                    <Calendar/>
                  </el-icon>
                </div>
                <div class="stat-info">
                  <p class="stat-title">预约订单</p>
                  <p class="stat-value">{{ statistics.appointmentCount }}</p>
                </div>
              </el-card>
            </el-col>
            <el-col :span="6">
              <el-card class="stat-card">
                <div class="stat-icon" style="background: #f56c6c;">
                  <el-icon>
                    <ChatDotRound/>
                  </el-icon>
                </div>
                <div class="stat-info">
                  <p class="stat-title">用户评论总数</p>
                  <p class="stat-value">{{ statistics.CommentCount }}</p>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </div>

        <!-- 用户管理 -->
        <div v-if="activeMenu === 'users'">
          <div class="table-header">
            <h3>用户列表</h3>
            <div>
              <el-input v-model="userSearch" placeholder="搜索用户名" style="width: 200px;"/>
              <button @click="getUserByNameList()">搜索</button>
            </div>
          </div>
          <el-table :data="userList" border>
            <el-table-column prop="id" label="ID" width="80"/>
            <el-table-column prop="username" label="用户名"/>
            <el-table-column prop="name" label="姓名"/>
            <el-table-column prop="role" label="角色"/>
            <el-table-column prop="phone" label="手机号"/>
            <el-table-column prop="status" label="状态">
              <template #default="scope">
                <el-tag :type="scope.row.status === 0 ? 'success' : 'danger'" style="width: 50px;">
                  {{
                    scope.row.status === 0 ? '正 常' : '已封禁'
                  }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="200">
              <template #default="scope">
                <el-button :type="scope.row.status === 0 ? 'danger' : 'success'" size="small"
                           @click="toggleUserStatus(scope.row)">
                  {{ scope.row.status === 0 ? '封禁' : '解封' }}
                </el-button>
                <el-button :type="'warning'" size="small" @click="deleteUser(scope.row)">删除
                </el-button>
              </template>

            </el-table-column>
          </el-table>
        </div>

        <!-- 房源审核 -->
        <div v-if="activeMenu === 'houses'">
          <div class="table-header">
            <h3>房源审核</h3>
          </div>
          <el-table :data="pendingHouses" border>
            <el-table-column prop="id" label="ID" width="80"/>
            <el-table-column prop="title" label="房源标题"/>
            <el-table-column prop="address" label="地址"/>
            <el-table-column prop="price" label="租金"/>
            <el-table-column prop="userId" label="房东id"/>
            <el-table-column label="操作" width="200">
              <template #default="scope">
                <el-button type="success" size="small" @click="auditHouse(scope.row, 1)">通过
                </el-button>
                <el-button type="danger" size="small" @click="auditHouse(scope.row, 2)">拒绝
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 房东审核 -->
        <div v-if="activeMenu === 'landlords'">
          <div class="table-header">
            <h3>房东身份审核</h3>
          </div>
          <el-table :data="pendingLandlords" border>
            <el-table-column prop="id" label="ID" width="80"/>
            <el-table-column prop="username" label="用户名"/>
            <el-table-column prop="name" label="真实姓名"/>
            <el-table-column prop="cardId" label="身份证号"/>
            <el-table-column prop="phone" label="联系电话"/>
            <el-table-column prop="photo" label="身份证照片" width="150" :resizable="false">
              <template #default="scope">
                <img v-if="scope.row.photo" :src="scope.row.photo" class="id-card-image"
                     @click="showImagePreview(scope.row.photo)" alt="身份证照片"/>
                <span v-else style="color: #909399;">未上传</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="200">
              <template #default="scope">
                <el-space v-if="scope.row.status === 0">
                  <el-button type="success" size="small" @click="auditLandlord(scope.row, 1)">通过
                  </el-button>
                  <el-button type="danger" size="small" @click="auditLandlord(scope.row, 2)">
                    拒绝
                  </el-button>
                </el-space>
                <el-tag v-else :type="scope.row.status === 1 ? 'success' : 'danger'">
                  {{ scope.row.status === 1 ? '已通过' : '已拒绝' }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 房源管理 -->
        <div v-if="activeMenu === 'house'">
          <div class="table-header">
            <h3>房源管理</h3>
          </div>
          <el-table :data="houseList" border>
            <el-table-column prop="id" label="ID" width="80"/>
            <el-table-column prop="title" label="房源标题" min-width="200"/>
            <el-table-column prop="address" label="地址" min-width="180"/>
            <el-table-column prop="price" label="租金" width="100"/>
            <el-table-column prop="name" label="房东" width="100"/>
            <el-table-column label="状态" width="100">
              <template #default="scope">
                <el-tag
                  :type="scope.row.status === 1 ? 'success' : (scope.row.status === 2 ? 'warning' : 'info')">
                  {{
                    scope.row.status === 1 ? '上架中' : (scope.row.status === 2 ? '已下架' : '待审核')
                  }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150">
              <template #default="scope">
                <el-button v-if="scope.row.status === 1" type="danger" size="small"
                           @click="toggleHouseListStatus(scope.row, 2)">下架
                </el-button>
                <el-button v-else type="success" size="small"
                           @click="toggleHouseListStatus(scope.row, 1)">上架
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 评论管理 -->
        <div v-if="activeMenu === 'comments'">
          <div class="table-header">
            <h3>评论管理</h3>
          </div>
          <el-table :data="commentList" border>
            <el-table-column prop="id" label="ID" width="80"/>
            <el-table-column prop="houseId" label="房源id"/>
            <el-table-column prop="userName" label="用户"/>
            <el-table-column prop="content" label="评论内容" show-overflow-tooltip/>
            <el-table-column label="操作" width="150">
              <template #default="scope">
                <el-button type="danger" size="small" @click="deleteComment(scope.row)">删除
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 公告管理 -->
        <div v-if="activeMenu === 'announcements'">
          <div class="table-header">
            <h3>公告管理</h3>
            <el-button type="primary" @click="showAddAnnouncement">发布公告</el-button>
          </div>
          <el-table :data="announcementList" border>
            <el-table-column prop="id" label="ID" width="80"/>
            <el-table-column prop="title" label="标题"/>
            <el-table-column prop="content" label="内容" show-overflow-tooltip/>
            <el-table-column prop="createTime" label="发布时间" width="180">
              <template #default="scope">
                {{ formatTime(scope.row.createTime) }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150">
              <template #default="scope">
                <el-button type="danger" size="small" @click="deleteAnnouncement(scope.row)">删除
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </div>
    </div>

    <!-- 发布公告对话框 -->
    <el-dialog title="发布公告" v-model="announcementVisible" width="600px">
      <el-form :model="announcementForm" :rules="announcementRules" ref="announcementFormRef"
               label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="announcementForm.title" placeholder="请输入公告标题"/>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input v-model="announcementForm.content" type="textarea" :rows="6"
                    placeholder="请输入公告内容"/>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="announcementVisible = false">取消</el-button>
        <el-button type="primary" @click="submitAnnouncement">发布</el-button>
      </template>
    </el-dialog>

    <!-- 图片预览对话框 -->
    <el-dialog v-model="imagePreviewVisible" :show-close="false" :modal="false"
               class="image-preview-dialog">
      <div class="image-preview-container">
        <button class="close-btn" @click="imagePreviewVisible = false">×</button>
        <img :src="currentImageUrl" class="preview-image" alt="身份证照片预览"/>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import {onMounted, reactive, ref} from "vue";
import {ElMessage, ElMessageBox} from "element-plus";
import {
  ArrowDown,
  Bell,
  Calendar,
  ChatDotRound,
  DataLine,
  House,
  User,
  UserFilled
} from "@element-plus/icons-vue";
import request from "@/utils/request.js";
import router from "@/router/index.js";

const activeMenu = ref('dashboard');
const userInfo = ref({});
const userSearch = ref('');
const announcementVisible = ref(false);
const announcementFormRef = ref();
const imagePreviewVisible = ref(false);
const currentImageUrl = ref('');

const statistics = reactive({
  userCount: 0,
  houseCount: 0,
  appointmentCount: 6,
  CommentCount: 0
});

const userList = ref([]);
const pendingHouses = ref([]);
const pendingLandlords = ref([]);
const commentList = ref([]);
const announcementList = ref([]);
const houseList = ref([]);
const announcementForm = reactive({
  title: '',
  content: ''
});

const announcementRules = {
  title: [{required: true, message: '请输入标题', trigger: 'change'}],
  content: [{required: true, message: '请输入内容', trigger: 'change'}]
};

// 获取用户列表
const getUserList = () => {
  request.get("/user/selectAll", {params: {keyword: userSearch.value}}).then(res => {
    if (res.code === "200") {
      userList.value = res.data;
      statistics.userCount = userList.value.length
    }

  });
};

//搜索用户名
const getUserByNameList = () => {
  request.get("user/selectUsername", {params: {username: userSearch.value}}).then(res => {
    if (res.code === "200") {
      userList.value = res.data;
    }
  })
  console.log(userSearch.value)
}

//删除用户
const deleteUser = (row) => {
  ElMessageBox.confirm("确定删除该用户吗？", '提示', {
    confirmButtonClass: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.delete("user/deleteUser", {params: {id: row.id}}).then(res => {
      if (res.code === "200") {
        ElMessage.success("删除成功")
        getUserList();
      }
    })
  }).catch(() => {

  })

}

// 切换用户状态
const toggleUserStatus = (row) => {
  const action = row.status === 0 ? '封禁' : '解封';
  ElMessageBox.confirm(`确定要${action}该用户吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.put("/user/updateStatus", row.id).then(res => {
      if (res.code === "200") {
        ElMessage.success(`${action}成功`);
        getUserList();
      }
    });
  });
};

// 获取待审核房源
const getPendingHouses = (row) => {
  request.get("/admin/selectHouseStatus").then(res => {
    if (res.code === "200") {
      pendingHouses.value = res.data
    }
    console.log(pendingHouses)
  })
}

//审核房源
const auditHouse = (row, status) => {
  request.put("/admin/updateHouseStatus", {id: row.id, status: status}).then(res => {
    if (res.code === "200") {
      ElMessage.success('审核完成');
      getPendingHouses();
    }
  });
};
//上/下架房源
const toggleHouseListStatus = (row, status) => {
  const action = row.status === 1 ? '下架' : '上架';
  ElMessageBox.confirm(`确定要${action}该房源吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.put("/admin/updateHouseStatus", {id: row.id, status: status}).then(res => {
      if (res.code === "200") {
        ElMessage.success('操作完成');
        getHouse();
      }
    });
  });
};
//获取房源
const getHouse = () => {
  request.get("/houseList/adminHouseList").then(res => {
    if (res.code === "200") {
      houseList.value = res.data
      console.log(houseList.value)
    }
    statistics.houseCount = res.data.length
  })

}

// 获取待审核房东
const getPendingLandlords = () => {
  request.get("/landlord/selectAll").then(res => {
    if (res.code === "200") {
      pendingLandlords.value = res.data;
      console.log(res.data)
    }
  });
};

// 审核房东
const auditLandlord = (row, status) => {
  request.put("/landlord/updateStatus", {id: row.id, status: status}).then(res => {
    console.log("发送了" + row.id)
    if (res.code === "200") {
      ElMessage.success('审核完成');
      getPendingLandlords();
    }
  });
};

// 格式化时间
const formatTime = (timeStr) => {
  if (!timeStr) return '';
  return timeStr.replace('T', ' ');
};

// 获取评论列表
const getCommentList = () => {
  request.get("/comment/selectComment").then(res => {
    if (res.code === "200") {
      commentList.value = res.data;
      statistics.CommentCount = res.data.length
    }
  });
};

// 删除评论
const deleteComment = (row) => {
  ElMessageBox.confirm('确定要删除该评论吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.delete("/comment/deleteCommentById", {params: {id: row.id}}).then(res => {
      if (res.code === "200") {
        ElMessage.success('删除成功');
        getCommentList();
      }
    });
  });
};

// 获取公告列表
const getAnnouncementList = () => {
  request.get("/notice/selectAll").then(res => {
    if (res.code === "200") {
      announcementList.value = res.data;
    }
  });
};

// 显示发布公告对话框
const showAddAnnouncement = () => {
  announcementForm.title = '';
  announcementForm.content = '';
  announcementVisible.value = true;
};

// 发布公告
const submitAnnouncement = () => {
  announcementFormRef.value.validate((valid) => {
    if (valid) {
      request.put("/notice/insert", announcementForm).then(res => {
        if (res.code === "200") {
          ElMessage.success('发布成功');
          announcementVisible.value = false;
          getAnnouncementList();
        }
      });
    }
  });
};

// 删除公告
const deleteAnnouncement = (row) => {
  ElMessageBox.confirm('确定要删除该公告吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.delete(`/notice/delete/${row.id}`).then(res => {
      if (res.code === "200") {
        ElMessage.success('删除成功');
        getAnnouncementList();
      }
    });
  });
};

// 菜单选择
const handleMenuSelect = (index) => {
  activeMenu.value = index;
  switch (index) {
    case 'users':
      getUserList();
      break;
    case 'houses':
      getPendingHouses();
      break;
    case 'landlords':
      getPendingLandlords();
      break;
    case 'comments':
      getCommentList();
      break;
    case 'announcements':
      getAnnouncementList();
      break;
  }
};

// 显示图片预览
const showImagePreview = (imageUrl) => {
  currentImageUrl.value = imageUrl;
  imagePreviewVisible.value = true;
};

// 下拉菜单
const handleCommand = (command) => {
  if (command === 'logout') {
    localStorage.removeItem('user');
    router.push('/login');
  }
};

onMounted(() => {
  // 检查是否登录管理员账号
  const admin = localStorage.getItem('admin');
  if (!admin) {
    ElMessage.warning('请登录管理员账号');
    router.push('/login');
    return;
  }

  userInfo.value = JSON.parse(admin);
  getUserList();
  getHouse();
  getCommentList();
  getHouse();
});
</script>

<style scoped>
.admin-container {
  display: flex;
  min-height: 100vh;
}

.admin-sidebar {
  background-color: #304156;
  position: fixed;
  height: 100vh;
}

.sidebar-header {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  border-bottom: 1px solid #1f2d3d;
}

.sidebar-header h3 {
  margin: 0;
}

.admin-menu {
  border-right: none;
}

.admin-main {
  flex: 1;
  margin-left: 200px;
  background: #f0f2f5;
  min-height: 100vh;
}

.admin-header {
  height: 60px;
  background: #fff;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
}

.header-left {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
}

.user-info {
  cursor: pointer;
  color: #606266;
}

.admin-content {
  padding: 20px;
}

.stat-card {
  display: flex;
  align-items: center;
  padding: 20px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 30px;
  margin-right: 15px;
}

.stat-info {
  flex: 1;
}

.stat-title {
  font-size: 14px;
  color: #909399;
  margin: 0 0 8px;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin: 0;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.table-header h3 {
  margin: 0;
}

.id-card-image {
  width: 100px;
  height: 60px;
  border-radius: 4px;
  cursor: pointer;
  transition: transform 0.3s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: block;
  flex-shrink: 0;
}

.id-card-image:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
}

.image-error {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100px;
  height: 60px;
  background: #f5f7fa;
  color: #909399;
  font-size: 20px;
  border-radius: 4px;
  border: 1px dashed #d9d9d9;
  flex-shrink: 0;
}

/* 图片预览对话框样式 */
.image-preview-dialog {
  max-width: 90vw;
  max-height: 90vh;
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
}

.image-preview-dialog .el-dialog__header {
  display: none;
}

.image-preview-dialog .el-dialog__body {
  padding: 0;
  background: transparent;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 80vh;
}

.image-preview-dialog .el-dialog {
  background: transparent !important;
  box-shadow: none !important;
}

.image-preview-container {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  max-width: 90vw;
  max-height: 90vh;
}

.preview-image {
  max-width: 90vw;
  max-height: 90vh;
  object-fit: contain;
  border-radius: 4px;
}

.close-btn {
  position: absolute;
  top: -40px;
  right: 0;
  background: rgba(255, 255, 255, 0.3);
  border: none;
  color: #fff;
  font-size: 32px;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  z-index: 1000;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.5);
  transform: rotate(90deg);
}
</style>
