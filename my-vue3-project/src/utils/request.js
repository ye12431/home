import axios from "axios";
import { ElMessage } from "element-plus";
import router from "@/router/index.js";

const request = axios.create({
    baseURL: 'http://localhost:9090',
    timeout: 30000
})
request.interceptors.request.use(config => {
    config.headers['Content-Type'] = 'application/json;charset=utf-8';
    return config
}, error => {
    return Promise.reject(error)
});
request.interceptors.response.use(
    response => {
        let res = response.data;
        if (typeof res === 'string') {
            try {
                res = res ? JSON.parse(res) : res
            } catch (e) {
                // 如果 JSON 解析失败，直接返回原始字符串
            }
        }
        return res;
    },
    error => {
        if (error.response && error.response.status === 404) {
            ElMessage.error('系统异常，请查看后端控制台报错')
        } else {
            console.log(error.message)
        }
        return Promise.reject(error)
    }
)
export default request