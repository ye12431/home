<template>
  <div class="profile-container">
    <div class="profile-card">
      <div class="profile-header">
        <el-button type="text" class="back-btn" @click="goBack">
          <el-icon>
            <ArrowLeft />
          </el-icon>
          返回首页
        </el-button>
        <h2>个人信息管理</h2>
      </div>

      <el-tabs v-model="activeTab" class="profile-tabs">
        <!-- 基本信息 -->
        <el-tab-pane label="基本信息" name="info">
          <el-form :model="userForm" :rules="userRules" ref="userFormRef" label-width="100px" class="profile-form">
            <el-form-item label="头像">
              <el-upload class="avatar-uploader" action="http://localhost:9090/files/upload" :show-file-list="false"
                :on-success="handleAvatarSuccess">
                <img v-if="userForm.avatar" :src="normalizeUrl(userForm.avatar)" class="avatar" alt="无法显示" />
                <el-icon v-else class="avatar-uploader-icon">
                  <Plus />
                </el-icon>
              </el-upload>
            </el-form-item>
            <el-form-item label="用户名" prop="username">
              <el-input v-model="userForm.username" disabled />
            </el-form-item>
            <el-form-item label="姓名" prop="name">
              <el-input v-model="userForm.name" placeholder="请输入姓名" />
            </el-form-item>
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="userForm.phone" placeholder="请输入手机号" />
            </el-form-item>
            <el-form-item label="角色">
              <el-tag>{{ userForm.role }}</el-tag>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdateInfo">保存修改</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <!-- 修改密码 -->
        <el-tab-pane label="修改密码" name="password">
          <el-form :model="passwordForm" :rules="passwordRules" ref="passwordFormRef" label-width="120px"
            class="profile-form">
            <el-form-item label="原密码" prop="password">
              <el-input v-model="passwordForm.password" type="password" placeholder="请输入原密码" show-password />
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
              <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码" show-password />
            </el-form-item>
            <el-form-item label="确认新密码" prop="confirmPassword">
              <el-input v-model="passwordForm.confirmPassword" type="password" placeholder="请再次输入新密码" show-password />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdatePassword">修改密码</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <!-- 我的收藏 -->
        <el-tab-pane label="我的收藏" name="favorites">
          <div class="favorites-list">
            <el-empty v-if="favorites.length === 0" description="暂无收藏房源" />
            <el-card v-for="item in favorites" :key="item.id" class="favorite-card" shadow="hover">
              <div class="favorite-content">
                <img :src="normalizeUrl(item.url) || '/default-house.jpg'" class="favorite-img" />
                <div class="favorite-info">
                  <h4>{{ item.title }}</h4>
                  <p>{{ item.address }}</p>
                  <span class="favorite-price">{{ item.price }}元/月</span>
                </div>
                <el-button type="danger" size="small" @click="cancelFavorite(item.id)">取消收藏
                </el-button>
              </div>
            </el-card>
          </div>
        </el-tab-pane>

        <!-- 我的预约 -->
        <el-tab-pane label="我的预约" name="booking">
          <div class="booking-table-wrapper">
            <el-table :data="booking" style="width: 100%">
              <el-table-column prop="title" label="房源" min-width="200" />
              <el-table-column prop="time" label="预约时间" width="180">
                <template #default="scope">
                  {{ formatTime(scope.row.time) }}
                </template>
              </el-table-column>
              <el-table-column prop="phone" label="联系电话" width="150" />
              <el-table-column prop="status" label="状态" width="100">
                <template #default="scope">
                  <el-tag :type="getStatusType(scope.row.status)">
                    {{
                      scope.row.status === 0 ? '预约中' : (scope.row.status === 1 ? '已预约' : '未通过')
                    }}
                  </el-tag>
                </template>
              </el-table-column>
              <!--            0 待确认，1 已确认，2 已取消，3 已完成-->
              <el-table-column label="操作" width="120">
                <template #default="scope">
                  <el-button type="danger" size="small" @click="cancelAppointment(scope.row)">
                    删除预约
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>

        <el-tab-pane label="成为房东" name="landlord" v-if="user.role === '租客'">
          <el-form :model="landlordForm" label-width="100px" class="profile-form" :rules="landlordRules"
            ref="landlordFormRef">
            <el-form-item label="用户名" prop="username">
              <el-input v-model="landlordForm.username" disabled />
            </el-form-item>
            <el-form-item label="姓名" prop="name">
              <el-input v-model="landlordForm.name" placeholder="请输入真实姓名" />
            </el-form-item>
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="landlordForm.phone" placeholder="请输入手机号" />
            </el-form-item>
            <el-form-item label="身份证号" prop="cardId">
              <el-input v-model="landlordForm.cardId" placeholder="请输入身份证号" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="insertLandlord()">申请</el-button>
            </el-form-item>
            <el-form-item label="身份证照片" prop="photo">
              <el-upload class="avatar-uploader" action="http://localhost:9090/files/upload" :show-file-list="false"
                :on-success="handleLandlordPhotoSuccess">
                <img v-if="landlordForm.photo" :src="normalizeUrl(landlordForm.photo)" class="avatar" alt="身份证照片" />
                <el-icon v-else class="avatar-uploader-icon">
                  <Plus />
                </el-icon>
              </el-upload>
            </el-form-item>
          </el-form>
        </el-tab-pane>

      </el-tabs>


    </div>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";
import { ArrowLeft, Plus } from "@element-plus/icons-vue";
import request from "@/utils/request.js";
import { normalizeUrl } from "@/utils/urlHelper.js";

const router = useRouter();

const activeTab = ref('info');
const userFormRef = ref();
const passwordFormRef = ref();
const landlordFormRef = ref();
const favorites = ref([]);
const booking = ref([]);
const user = JSON.parse(localStorage.getItem('user'));
const userForm = reactive({});

const passwordForm = reactive({
  password: '',
  newPassword: '',
  confirmPassword: ''
});

const landlordForm = reactive({
  username: user.username,
  name: user.name,
  cardId: '',
  phone: user.phone,
  userId: user.id,
  photo: ''
})
const userRules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'change' }],
  phone: [{ required: true, message: '请输入正确手机号', trigger: 'blur' },
  {
    pattern: /^1[3-9]\d{9}$/,
    message: '手机号格式错误',
    trigger: ['blur', 'change'],
    validator: (rule, value, callback) => {
      // 自定义校验逻辑：如果为空则不校验，不为空则校验格式
      if (!value) {
        callback(); // 空值直接通过
      } else {
        const reg = /^1[3-9]\d{9}$/;
        if (reg.test(value)) {
          callback(); // 格式正确通过
        } else {
          callback(new Error('请输入正确的手机号')); // 格式错误提示
        }
      }
    }
  }],

};

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== passwordForm.newPassword) {
    callback(new Error('两次输入的密码不一致'));
  } else {
    callback();
  }
};

const passwordRules = {
  password: [{ required: true, message: '请输入原密码', trigger: 'change' }],
  newPassword: [{ required: true, message: '请输入新密码', trigger: 'change' }],
  confirmPassword: [
    { required: true, message: '请确认新密码', trigger: 'change' },
    { validator: validateConfirmPassword, trigger: 'change' }
  ]
};

const landlordRules = {
  name: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
  cardId: [{ required: true, message: '请输入身份证号', trigger: 'blur' }],
  phone: [{ required: true, message: '请输入正确手机号', trigger: 'blur' },
  {
    pattern: /^1[3-9]\d{9}$/,
    message: '手机号格式错误',
    trigger: ['blur', 'change'],
    validator: (rule, value, callback) => {
      // 自定义校验逻辑：如果为空则不校验，不为空则校验格式
      if (!value) {
        callback(); // 空值直接通过
      } else {
        const reg = /^1[3-9]\d{9}$/;
        if (reg.test(value)) {
          callback(); // 格式正确通过
        } else {
          callback(new Error('请输入正确的手机号')); // 格式错误提示
        }
      }
    }
  }]

}

// 获取用户信息
const getUserInfo = () => {
  Object.assign(userForm, user);

};

// 更新用户信息
const handleUpdateInfo = () => {
  userFormRef.value.validate((valid) => {
    if (valid) {
      request.put("/user/update", userForm).then(res => {
        if (res.code === "200") {
          ElMessage.success('修改成功');
          localStorage.setItem('user', JSON.stringify(userForm));
        } else {
          ElMessage.error(res.msg);
        }
      });
    }
  });
};

// 修改密码
const handleUpdatePassword = () => {
  passwordFormRef.value.validate((valid) => {
    console.log(passwordForm)
    if (valid) {
      request.put("/user/updatePassword", {
        id: userForm.id,
        password: passwordForm.password,
        newPassword: passwordForm.newPassword
      }).then(res => {
        if (res.code === "200") {
          ElMessage.success('密码修改成功');
          passwordForm.password = '';
          passwordForm.newPassword = '';
          passwordForm.confirmPassword = '';
        } else {
          ElMessage.error(res.msg);
        }
      });
    }
  });
};

// 头像上传成功
const handleAvatarSuccess = (res) => {
  userForm.avatar = res.data;
};

// 身份证照片上传成功
const handleLandlordPhotoSuccess = (res) => {
  landlordForm.photo = res.data;
  ElMessage.success('身份证照片上传成功');
};

// 获取收藏列表
const getFavorites = () => {
  request.get("/user/myCollect", { params: { userId: user.id } }).then(res => {
    if (res.code === "200") {
      favorites.value = res.data;
    }
  });
};
// 查看详情


// 取消收藏
const cancelFavorite = (item) => {
  ElMessageBox.confirm('确定要取消收藏该房源吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.delete("/user/deleteMyCollect", { params: { id: item } }).then(res => {
      if (res.code === "200") {
        ElMessage.success('取消收藏成功');
        getFavorites();
      }
    });
  });
  console.log(item)
};

// 格式化时间
const formatTime = (timeStr) => {
  if (!timeStr) return '';
  // 替换 T 为空格，去掉 Z 和毫秒部分，保留到秒
  const date = new Date(timeStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

// 获取我的预约
const getBooking = () => {
  request.get("/booking/selectMyBooking", { params: { userId: user.id } }).then(res => {
    if (res.code === "200") {
      // 格式化时间
      booking.value = res.data.map(item => ({
        ...item,
        time: formatTime(item.time)
      }));
    }
  });
};

// 返回首页
const goBack = () => {
  router.push('/');
};

// 取消预约
const cancelAppointment = (item) => {
  ElMessageBox.confirm('确定要取消该预约吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.delete("/booking/deleteMyBooking", { params: { id: item.id } }).then(res => {
      if (res.code === "200") {
        ElMessage.success('取消预约成功');
        getBooking();
      }
    });
  });
};

// 状态标签类型
const getStatusType = (status) => {
  const map = {
    '0': 'warning',
    '1': 'success',
    '2': 'danger',
    '3': 'info'
  };
  return map[status] || 'info';
};

const insertLandlord = () => {
  landlordFormRef.value.validate((valid) => {
    if (valid) {
      // 验证通过，提交申请
      request.put("/landlord/insertLandlord", landlordForm).then(res => {
        if (res.code === "200") {
          ElMessage.success("申请发送成功")
          // 清空表单
          landlordForm.cardId = ''
          landlordForm.photo = ''
        } else {
          ElMessage.error(res.msg)
        }
      })
    } else {
      // 验证失败，提示用户
      ElMessage.warning('请填写完整的申请信息')
    }
  })
}


onMounted(() => {
  getUserInfo();
  getFavorites();
  getBooking();
});
</script>

<style scoped>
.profile-container {
  min-height: 100vh;
  background: url('/53031fcb-ad34-423c-a129-f4aec3061993.png') no-repeat center center/cover;
  padding: 40px 20px;
}

.profile-card {
  max-width: 900px;
  margin: 0 auto;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  padding: 30px;
}

.profile-header {
  text-align: center;
  margin-bottom: 30px;
  position: relative;
}

.profile-header h2 {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
}

.back-btn {
  position: absolute;
  left: 0;
  top: 0;
  font-size: 14px;
  color: #409eff;
  display: flex;
  align-items: center;
  gap: 5px;
  cursor: pointer;
  transition: color 0.3s;
}

.back-btn:hover {
  color: #66b1ff;
}

.back-btn .el-icon {
  font-size: 16px;
}

.profile-tabs {
  margin-top: 20px;
}

.profile-form {
  max-width: 500px;
  margin: 20px auto;
}

.avatar-uploader {
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 120px;
  height: 120px;
  border: 2px dashed #d9d9d9;
  border-radius: 6px;
  background: #fafafa;
}

.avatar-uploader:hover {
  border-color: #c0c4cc;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  text-align: center;
  line-height: 120px;
}

.avatar {
  width: 120px;
  height: 120px;
  display: block;
  object-fit: cover;
}

.favorites-list {
  padding: 20px 0;
  height: 400px;
  overflow-y: auto;
}

.favorites-list::-webkit-scrollbar {
  width: 6px;
}

.favorites-list::-webkit-scrollbar-thumb {
  background: #c0c4cc;
  border-radius: 3px;
}

.favorites-list::-webkit-scrollbar-thumb:hover {
  background: #909399;
}

.favorite-card {
  margin-bottom: 15px;
}

.booking-table-wrapper {
  height: 400px;
  overflow-y: auto;
}

.booking-table-wrapper::-webkit-scrollbar {
  width: 6px;
}

.booking-table-wrapper::-webkit-scrollbar-thumb {
  background: #c0c4cc;
  border-radius: 3px;
}

.booking-table-wrapper::-webkit-scrollbar-thumb:hover {
  background: #909399;
}

.favorite-content {
  display: flex;
  align-items: center;
  gap: 15px;
}

.favorite-img {
  width: 100px;
  height: 75px;
  object-fit: cover;
  border-radius: 4px;
}

.favorite-info {
  flex: 1;
}

.favorite-info h4 {
  margin: 0 0 8px;
  font-size: 16px;
  color: #303133;
}

.favorite-info p {
  margin: 0 0 8px;
  font-size: 13px;
  color: #909399;
}

.favorite-price {
  font-size: 16px;
  font-weight: 600;
  color: #f56c6c;
}

@media (max-width: 768px) {
  .profile-card {
    padding: 20px;
  }

  .favorite-content {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
