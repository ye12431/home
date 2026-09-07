package house.springboot.controller;
import cn.hutool.core.io.FileUtil;
import house.springboot.com.Result;
import house.springboot.exception.CustomException;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@RequestMapping("/files")
@RestController//返回 JSON 数据

public class FileController {
    // 使用项目根目录的 files/，不管从哪个子目录启动都能正确定位
    private static final String filePath = new File(System.getProperty("user.dir")).getParent() + File.separator + "files" + File.separator;
    @PostMapping("/upload")
    public Result upload (MultipartFile file) {
        String originalFilename = file.getOriginalFilename();
        if (!FileUtil.isDirectory(filePath)){
            FileUtil.mkdir(filePath);
        }
        String fileName = System.currentTimeMillis()+"_"+originalFilename;
        String realPath = filePath +fileName;
        try {
            FileUtil.writeBytes(file.getBytes(),realPath);
        }catch (Exception e){
            e.printStackTrace();
            throw new CustomException("500","文件上传失败");
        }
        String url = "http://localhost:9090/files/download/"+fileName;
        return Result.success(url);
    }
    @GetMapping("download/{fileName}")
    public void  download (@PathVariable String fileName, HttpServletResponse response) {
        try {
            String realPath = filePath + fileName;
            File file = new File(realPath);
            if (!file.exists()) {
                throw new CustomException("404","文件不存在");
            }
            // 根据文件扩展名设置正确的 Content-Type，让浏览器直接显示图片
            String contentType = getContentType(fileName);
            response.setContentType(contentType);
            OutputStream os = response.getOutputStream();
            byte[] bytes = FileUtil.readBytes(realPath);
            os.write(bytes);
            os.flush();
            os.close();
        }catch (CustomException e){
            throw e;
        }catch (Exception e){
            e.printStackTrace();
            throw new CustomException("500","文件下载失败");
        }
    }

    private String getContentType(String fileName) {
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".png")) return "image/png";
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
        if (lower.endsWith(".gif")) return "image/gif";
        if (lower.endsWith(".webp")) return "image/webp";
        if (lower.endsWith(".bmp")) return "image/bmp";
        if (lower.endsWith(".svg")) return "image/svg+xml";
        if (lower.endsWith(".mp4")) return "video/mp4";
        if (lower.endsWith(".pdf")) return "application/pdf";
        return "application/octet-stream";
    }

}
