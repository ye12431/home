package house.springboot.Mapper;

import house.springboot.entity.HouseInfo;
import house.springboot.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UserMapper {
    List<User> selectAll(User user);

    List<User> selectUserByName(String username);

    @Select("select *from `user` where username = #{username}")
    User selectByUsername(String username);

    @Select("select *from `user` where id = #{id}")
    User selectById(Integer id);

    void insertUser(User user);

    void updatePassword(User user);

    void updateUserStatus(Integer id);

    void updateUserById(User user);

    List<HouseInfo> selectMyCollect(Integer userId);

    void deleteUser(Integer id);

    void deleteMyCollect(Integer id);
}
