<template>
  <div class="login-container">
    <div class="login-card">
      <div class="login-header">
        <h2>房屋租赁系统</h2>
        <p>欢迎回来，请登录您的账号</p>
      </div>
      <el-form :model="form" :rules="rules" ref="loginForm" class="login-form" label-position="top">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" prefix-icon="el-icon-user" size="large" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" prefix-icon="el-icon-lock" show-password
            size="large" />
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-radio-group v-model="form.role">
            <el-radio value="user">租客</el-radio>
            <el-radio value="admin">管理员</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" class="login-button" size="large" @click="handleLogin">
            登录
          </el-button>
        </el-form-item>
      </el-form>
      <div class="login-footer">
        <span>还没有账号？</span>
        <el-link type="primary" href="register">立即注册</el-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import request from "@/utils/request.js";
import router from "@/router/index.js";

const loginForm = ref();
const form = reactive({
  username: '',
  password: '',
  role: 'user',
});

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'change' },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'change' },
  ]
};

const handleLogin = () => {
  loginForm.value.validate((valid) => {
    if (valid) {
      if (form.role === "user") {
        request.post("/user/login", form).then(res => {
          if (res.code === "200") {
            ElMessage.success('登录成功');
            localStorage.setItem('user', JSON.stringify(res.data));
            router.push('/');
          } else {
            ElMessage.error(res.msg);
          }
        })
      }
      if (form.role === "admin") {
        request.post("/admin/login", form).then(res => {
          if (res.code === "200") {
            ElMessage.success('登录成功');
            localStorage.setItem('admin', JSON.stringify(res.data));
            router.push('/admin');
          } else {
            ElMessage.error(res.msg);
          }
        })
      }
    } else {
      ElMessage.error('请检查输入信息');
    }
  });
  return false;
};
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: url('/53031fcb-ad34-423c-a129-f4aec3061993.png') no-repeat center center/cover;
  padding: 20px;
}

.login-card {
  width: 100%;
  max-width: 420px;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  padding: 30px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.login-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-header h2 {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
}

.login-header p {
  font-size: 14px;
  color: #909399;
  margin: 0;
}

.login-form {
  width: 100%;
}

.login-form-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.login-button {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 500;
}

.login-footer {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
  color: #909399;
}

.login-footer el-link {
  margin-left: 4px;
}

/* 响应式设计 */
@media (max-width: 480px) {
  .login-card {
    padding: 20px;
  }

  .login-header h2 {
    font-size: 20px;
  }
}
</style>
