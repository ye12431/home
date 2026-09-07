package house.springboot.service;

import house.springboot.Mapper.CommentMapper;
import house.springboot.entity.Comment;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentService {
    @Resource
    private CommentMapper commentMapper;

    public void insertComment(Comment comment) {
        commentMapper.insertComment(comment);
    }

    public List<Comment> selectCommentById(Integer houseId) {
        return commentMapper.selectCommentById(houseId);
    }

    public List<Comment> selectComment() {
        return commentMapper.selectAllComment();
    }

    public void deleteCommentById(Integer Id) {
        commentMapper.deleteCommentById(Id);
    }
}
