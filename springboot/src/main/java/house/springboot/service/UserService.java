package house.springboot.service;

import house.springboot.Mapper.UserMapper;
import house.springboot.entity.HouseInfo;
import house.springboot.entity.User;
import house.springboot.exception.CustomException;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service

public class UserService {
    @Resource
    private UserMapper userMapper;

    // 查询所有用户
    public List<User> selectAll(User user) {
        return userMapper.selectAll(user);
    }

    public User login(User user) {
        String username = user.getUsername();
        User dbUser = userMapper.selectByUsername(username);
        if (dbUser == null) {
            throw new CustomException("500", "账号不存在");
        }
        String password = user.getPassword();
        if (!dbUser.getPassword().equals(password)) {
            throw new CustomException("500", "密码错误");
        }
        int status = dbUser.getStatus();
        if (status == 1) {
            throw new CustomException("500", "账号已被封禁");
        }
        return dbUser;
    }

    public void Register(User user) {
        String username = user.getUsername();
        User dbUser = userMapper.selectByUsername(username);
        if (dbUser != null) {
            throw new CustomException("500", "账已存在");
        }
        userMapper.insertUser(user);
    }

    public List<HouseInfo> selectMyCollect(Integer userId) {
        return userMapper.selectMyCollect(userId);
    }

    public List<User> selectUserByUsername(String username) {
        return userMapper.selectUserByName(username);
    }

    public void updatePassword(User user) {
        Integer id = user.getId();
        User dbuser = this.userMapper.selectById(id);
        if (!dbuser.getPassword().equals(user.getPassword())) {
            throw new CustomException("500", "原密码错误");
        }
        userMapper.updatePassword(user);
    }

    public void Update(User user) {
        userMapper.updateUserById(user);
    }

    public void updateStatus(Integer id) {
        userMapper.updateUserStatus(id);
    }

    public void deleteUser(Integer id) {
        userMapper.deleteUser(id);
    }

    public void deleteMyCollect(Integer id) {
        userMapper.deleteMyCollect(id);
    }
}
