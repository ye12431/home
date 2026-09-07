// 归一化图片URL：将后端返回的绝对URL（http://localhost:9090/files/...）转为相对路径（/files/...）
// 这样前端可以走 Vite 代理，避免跨域和 ORB 问题
const BACKEND_BASE = 'http://localhost:9090';

export function normalizeUrl(url) {
  if (!url) return '';
  if (url.startsWith(BACKEND_BASE)) {
    return url.substring(BACKEND_BASE.length);
  }
  return url;
}

export function normalizeUrls(urls) {
  if (!urls || !Array.isArray(urls)) return [];
  return urls.map(normalizeUrl);
}
