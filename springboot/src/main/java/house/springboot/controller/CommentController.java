package house.springboot.controller;

import house.springboot.com.Result;
import house.springboot.entity.Comment;
import house.springboot.service.CommentService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/comment")
public class CommentController {
    @Resource
    private CommentService commentService;

    @PutMapping("/insertComment")
    public Result insertComment(@RequestBody Comment comment) {
        commentService.insertComment(comment);
        return Result.success();
    }

    @GetMapping("/selectCommentById")
    public Result selectCommentById(@RequestParam Integer houseId) {
        List<Comment> list = commentService.selectCommentById(houseId);
        return Result.success(list);
    }

    @GetMapping("/selectComment")
    public Result selectComment() {
        List<Comment> list = commentService.selectComment();
        return Result.success(list);
    }

    @DeleteMapping("/deleteCommentById")
    public Result deleteCommentById(@RequestParam Integer id) {
        commentService.deleteCommentById(id);
        return Result.success();
    }
}
