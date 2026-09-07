package house.springboot.controller;

import house.springboot.com.Result;
import house.springboot.entity.Notice;
import house.springboot.service.NoticeService;
import jakarta.annotation.Resource;
import org.apache.ibatis.annotations.Delete;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/notice")
public class NoticeController {
    @Resource
    private NoticeService noticeService;
    @GetMapping("/selectAll")
    public Result selectAll(Notice notice){
       List<Notice> list = noticeService.selectAllNoticeList(notice);
       return Result.success(list);
    }
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id){
        noticeService.deleteByNoticeId(id);
        return Result.success();
    }
    @PutMapping("/insert")
    public Result insert(@RequestBody Notice notice){
        noticeService.insertNotice(notice);
        return Result.success();
    }
}
