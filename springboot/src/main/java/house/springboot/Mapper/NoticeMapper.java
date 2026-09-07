package house.springboot.Mapper;

import house.springboot.entity.Notice;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface NoticeMapper {
    @Select("select * from notice order by id")
    List<Notice> selectAllNoticeList(Notice notice);

    @Delete("delete from notice where id = #{id}")
    void deleteByNoticeId(Integer id);

    @Insert("insert into notice (id, title, content) " +
            "VALUE (#{id},#{title},#{content})")
    void insert(Notice notice);
}
