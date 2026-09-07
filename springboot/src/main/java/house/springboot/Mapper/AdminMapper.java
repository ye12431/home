package house.springboot.Mapper;

import house.springboot.entity.Admin;
import jakarta.annotation.Resource;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface AdminMapper {
    @Select("select *from `admin` where username = #{username}")
    Admin selectAdminByName(String name);

}
