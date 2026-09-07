package house.springboot.Mapper;

import house.springboot.entity.Comment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CommentMapper {
    void insertComment(Comment comment);

    List<Comment> selectCommentById(Integer houseId);

    @Select("select *from `comment`")
    List<Comment> selectAllComment();

    void deleteCommentById(Integer Id);
}
