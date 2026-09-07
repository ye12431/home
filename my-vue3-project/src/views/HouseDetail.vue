<template>
  <div class="house-detail-container">
    <div class="detail-header">
      <el-page-header @back="goBack" title="返回列表" />
    </div>

    <div class="detail-content">
      <el-row :gutter="20">
        <!-- 左侧：图片和信息 -->
        <el-col :span="16">
          <el-card class="detail-card">
            <div class="house-gallery">
              <img :src="house.urls && house.urls.length > 0 ? house.urls[0] : '/default-house.jpg'" alt="房源图片" />
            </div>
            <div class="house-main-info">
              <h1>{{ house.title }}</h1>
              <p class="price">
                <span class="amount">{{ house.price }}</span>
                <span class="unit">元/月</span>
              </p>
              <div class="tags">
                <el-tag>{{ house.roomNumber }}室</el-tag>
                <el-tag>{{ house.area }}㎡</el-tag>
                <el-tag :type="house.status === '上架' ? 'success' : 'info'">{{
                  house.status
                }}
                </el-tag>
              </div>
            </div>
          </el-card>

          <el-card class="detail-card">
            <template #header>
              <span>房源信息</span>
            </template>
            <div class="info-grid">
              <div class="info-item">
                <span class="label">地址：</span>
                <span class="value">{{ house.address }}</span>
              </div>
              <div class="info-item">
                <span class="label">房型：</span>
                <span class="value">{{ house.roomNumber }}室</span>
              </div>
              <div class="info-item">
                <span class="label">面积：</span>
                <span class="value">{{ house.area }}㎡</span>
              </div>
            </div>
            <div class="description">
              <h4>房源描述</h4>
              <p>{{ house.details || '暂无描述' }}</p>
            </div>
          </el-card>

          <!-- 评论列表 -->
          <el-card class="detail-card">
            <template #header>
              <span>用户评价</span>
            </template>
            <div class="comment-list">
              <div v-for="item in comments" :key="item.id" class="comment-item">
                <div class="comment-header">
                  <span class="username">{{ item.userName }}</span>
                  <el-rate v-model="item.rating" disabled />
                  <span class="time">{{ item.createTime?.replace('T', ' ') }}</span>
                </div>
                <p class="comment-content">{{ item.content }}</p>
              </div>
              <el-empty v-if="comments.length === 0" description="暂无评论" />
            </div>
          </el-card>
        </el-col>

        <!-- 右侧：房东信息和操作 -->
        <el-col :span="8">
          <el-card class="detail-card">
            <template #header>
              <span>房东信息</span>
            </template>
            <div class="landlord-info">
              <el-avatar :size="60" :src="house.avatar" />
              <h4>{{ house.name }}</h4>
              <p>手机号：{{ house.phone }}</p>
            </div>
          </el-card>

          <el-card class="detail-card action-card">
            <el-button type="primary" size="large" class="action-btn" @click="handleAppointment">
              <el-icon>
                <Calendar />
              </el-icon>
              预约看房
            </el-button>
            <el-button :type="isFavorited ? 'danger' : 'default'" size="large" class="action-btn" @click="toggleFavorite">
              <el-icon>
                <Star />
              </el-icon>
              {{ isFavorited ? '取消收藏' : '收藏房源' }}
            </el-button>
          </el-card>

          <!-- 发表评论 -->
          <el-card class="detail-card">
            <template #header>
              <span>发表评价</span>
            </template>
            <el-form :model="commentForm" ref="commentFormRef">
              <el-form-item>
                <el-rate v-model="commentForm.rating" show-score />
              </el-form-item>
              <el-form-item>
                <el-input v-model="commentForm.content" type="textarea" :rows="4" placeholder="分享您的租房体验..." />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="submitComment">提交评价</el-button>
              </el-form-item>
            </el-form>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 预约对话框 -->
    <el-dialog title="预约看房" v-model="appointmentVisible" width="500px">
      <el-form :model="appointmentForm" :rules="appointmentRules" ref="appointmentFormRef" label-width="100px">
        <el-form-item label="预约时间" prop="appointmentTime">
          <el-date-picker v-model="appointmentForm.appointmentTime" type="datetime" placeholder="选择预约时间"
            style="width: 100%;" />
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
import { useRoute, useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { Calendar, Star } from "@element-plus/icons-vue";
import request from "@/utils/request.js";

const route = useRoute();
const router = useRouter();
const houseId = route.params.id;

const house = ref({});
const comments = ref([]);
const isFavorited = ref(false);
const appointmentVisible = ref(false);
const appointmentFormRef = ref();
const commentFormRef = ref();

const appointmentForm = reactive({
  houseId: houseId,
  appointmentTime: '',
  contactPhone: '',
  remark: ''
});

const commentForm = reactive({
  houseId: houseId,
  rating: 5,
  content: ''
});

const appointmentRules = {
  appointmentTime: [{ required: true, message: '请选择预约时间', trigger: 'change' }],
  contactPhone: [{ required: true, message: '请输入联系电话', trigger: 'change' }]
};

// 获取房源详情
const getHouseDetail = () => {
  request.get(`/houseList/selectById/${houseId}`).then(res => {
    if (res.code === "200") {
      house.value = res.data;
    }
  });
  console.log(houseId)
};

// 获取评论列表
const getComments = () => {
  request.get("/comment/selectCommentById", { params: { houseId } }).then(res => {
    if (res.code === "200") {
      comments.value = res.data;
    }
  });
};

// 检查是否已收藏
const checkFavorite = () => {
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  if (!user.id) return;
  request.get("/houseCollect/isCollect", { params: { userId: user.id, houseId } }).then(res => {
    if (res.code === "200") {
      isFavorited.value = res.data;
    }
  });
};

// 返回列表
const goBack = () => {
  router.push('/house-list');
};

// 预约看房
const handleAppointment = () => {
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

// /取消收藏
const toggleFavorite = () => {
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  if (!user.id) {
    ElMessage.warning('请先登录');
    router.push('/login');
    return;
  }
  if (isFavorited.value) {
    request.delete("/houseCollect/deleteCollect", { params: { userId: user.id, houseId } }).then(res => {
      if (res.code === "200") {
        isFavorited.value = false;
        ElMessage.success('取消收藏成功');
      }
    });
  } else {
    request.post("/houseCollect/insertCollect", { userId: user.id, houseId }).then(res => {
      if (res.code === "200") {
        isFavorited.value = true;
        ElMessage.success('收藏成功');
      }
    });
  }
};

// 提交评论
const submitComment = () => {
  if (!commentForm.content) {
    ElMessage.warning('请输入评论内容');
    return;
  }
  request.put("/comment/insertComment", commentForm).then(res => {
    if (res.code === "200") {
      ElMessage.success('评论成功');
      commentForm.content = '';
      commentForm.rating = 5;
      getComments();
    }
  });
};

onMounted(() => {
  getHouseDetail();
  getComments();
  checkFavorite();
});
</script>

<style scoped>
.house-detail-container {
  min-height: 100vh;
  background: #f5f7fa;
}

.detail-header {
  background: #fff;
  padding: 15px 20px;
  border-bottom: 1px solid #e4e7ed;
}

.detail-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.detail-card {
  margin-bottom: 20px;
}

.house-gallery {
  height: 400px;
  overflow: hidden;
  border-radius: 8px;
  margin-bottom: 20px;
}

.house-gallery img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.house-main-info h1 {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 15px;
}

.price {
  margin-bottom: 15px;
}

.price .amount {
  font-size: 36px;
  font-weight: 600;
  color: #f56c6c;
}

.price .unit {
  font-size: 16px;
  color: #909399;
  margin-left: 5px;
}

.tags .el-tag {
  margin-right: 10px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
  margin-bottom: 20px;
}

.info-item .label {
  color: #909399;
}

.info-item .value {
  color: #303133;
  font-weight: 500;
}

.description h4 {
  margin-bottom: 10px;
  color: #303133;
}

.description p {
  color: #606266;
  line-height: 1.8;
}

.landlord-info {
  text-align: center;
}

.landlord-info h4 {
  margin: 15px 0 10px;
  color: #303133;
}

.landlord-info p {
  color: #606266;
}

.action-card {
  display: flex;
  justify-content: space-between;
  padding: 12px 20px;
}

.action-card .action-btn {
  height: 42px;
  border-radius: 8px;
  font-size: 14px;
  letter-spacing: 0.5px;
}

.comment-list {
  padding: 10px 0;
}

.comment-item {
  padding: 15px 0;
  border-bottom: 1px solid #e4e7ed;
}

.comment-item:last-child {
  border-bottom: none;
}

.comment-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 10px;
}

.comment-header .username {
  font-weight: 600;
  color: #303133;
}

.comment-header .time {
  color: #909399;
  font-size: 13px;
}

.comment-content {
  color: #606266;
  line-height: 1.6;
  margin: 0;
}

@media (max-width: 768px) {
  .detail-content {
    padding: 10px;
  }

  .house-gallery {
    height: 250px;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }
}
</style>
