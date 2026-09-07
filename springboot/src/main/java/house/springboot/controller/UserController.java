package house.springboot.controller;

import house.springboot.Mapper.UserMapper;
import house.springboot.com.Result;
import house.springboot.entity.User;
import house.springboot.service.UserService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("/user")
@RestController
public class UserController {
    @Resource
    private UserMapper userMapper;
    @Resource
    private UserService userService;

    @GetMapping("/selectAll")
    public Result selectAll(User user) {
        List<User> list = userService.selectAll(user);
        return Result.success(list);
    }

    @GetMapping("/selectUsername")
    public Result selectUserByName(@RequestParam String username) {
        return Result.success(userService.selectUserByUsername(username));
    }

    @GetMapping("/myCollect")
    public Result MyCollect(@RequestParam Integer userId) {
        return Result.success(userService.selectMyCollect(userId));
    }

    @PostMapping("/login")
    public Result login(@RequestBody User user) {
        // SpringBoot 的 @PostMapping 默认接收 form-data，但前端发送的是 JSON。需要改成 @RequestBody 接收
        // JSON：!!!!!
        return Result.success(userService.login(user));
    }

    @PostMapping("/register")
    public Result register(@RequestBody User user) {
        userService.Register(user);
        return Result.success();
    }

    @PutMapping("/update")
    public Result update(@RequestBody User user) {
        userService.Update(user);
        return Result.success();
    }

    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody User user) {
        userService.updatePassword(user);
        return Result.success();
    }

    @PutMapping("/updateStatus")
    public Result updateStatus(@RequestBody Integer id) {
        userService.updateStatus(id);
        return Result.success();
    }

    @DeleteMapping("/deleteUser")
    public Result deleteUser(@RequestParam Integer id) {
        userService.deleteUser(id);
        return Result.success();
    }

    @DeleteMapping("/deleteMyCollect")
    public Result deleteMyCollect(@RequestParam Integer id) {
        userService.deleteMyCollect(id);
        return Result.success();
    }

}
