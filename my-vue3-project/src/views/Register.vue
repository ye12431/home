<template>
  <div class="register-container">
    <div class="register-card">
      <div class="register-header">
        <h2>用户注册</h2>
        <p>创建您的账号，开启租房之旅</p>
      </div>
      <el-form :model="form" :rules="rules" ref="registerForm" class="register-form"
               label-position="top">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" size="large"/>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" show-password
                    size="large"/>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="form.confirmPassword" type="password" placeholder="请再次输入密码"
                    show-password
                    size="large"/>
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="form.name" placeholder="请输入真实姓名" size="large"/>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" size="large"/>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" class="register-button" size="large" @click="handleRegister">
            注册
          </el-button>
        </el-form-item>
      </el-form>
      <div class="register-footer">
        <span>已有账号？</span>
        <el-link type="primary" @click="goToLogin">立即登录</el-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import {reactive, ref} from "vue";
import {ElMessage} from "element-plus";
import request from "@/utils/request.js";
import router from "@/router/index.js";

const registerForm = ref();
const form = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  name: '',
  phone: '',
  role: '租客'
});

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== form.password) {
    callback(new Error('两次输入的密码不一致'));
  } else {
    callback();
  }
};

const rules = {
  username: [{required: true, message: '请输入用户名', trigger: 'blur'}],
  phone: [{required: true, message: '请输入正确手机号', trigger: 'blur'},
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
  confirmPassword: [
    {required: true, message: '请确认密码', trigger: 'blur'},
    {validator: validateConfirmPassword, trigger: 'blur'}
  ],
  name: [{required: true, message: '请输入姓名', trigger: 'blur'}],
  role: [{required: true, message: '请选择角色', trigger: 'blur'}]
};

const handleRegister = () => {
  registerForm.value.validate((valid) => {
    if (valid) {
      request.post("/user/register", form).then(res => {
        if (res.code === "200") {
          ElMessage.success('注册成功');
          router.push('/login');
        } else {
          ElMessage.error(res.msg);
        }
      });
    } else {
      ElMessage.error('请检查输入信息');
    }
  });
};

const goToLogin = () => {
  router.push('/login');
};
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: url('/53031fcb-ad34-423c-a129-f4aec3061993.png') no-repeat center center/cover;
  padding: 20px;
}

.register-card {
  width: 100%;
  max-width: 480px;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  padding: 30px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.register-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
}

.register-header {
  text-align: center;
  margin-bottom: 30px;
}

.register-header h2 {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
}

.register-header p {
  font-size: 14px;
  color: #909399;
  margin: 0;
}

.register-form {
  width: 100%;
}

.register-button {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 500;
}

.register-footer {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
  color: #909399;
}

.register-footer el-link {
  margin-left: 4px;
}

/* 响应式设计 */
@media (max-width: 480px) {
  .register-card {
    padding: 20px;
  }

  .register-header h2 {
    font-size: 20px;
  }
}
</style>
