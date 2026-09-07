package house.springboot.controller;

import house.springboot.com.Result;
import house.springboot.entity.Admin;
import house.springboot.entity.HouseList;
import house.springboot.service.AdminService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/admin")
public class AdminController {
    @Resource
    private AdminService adminService;

    @PostMapping("/login")
    public Result login(@RequestBody Admin admin) {
        return Result.success(adminService.login(admin));
    }

    @GetMapping("/selectHouseStatus")
    public Result selectHouseStatus() {
        List<HouseList> list = adminService.selectByStatus();
        return Result.success(list);
    }

    @PutMapping("/updateHouseStatus")
    public Result updateHouseStatus(@RequestBody HouseList houseList) {
        adminService.updateHouseStatus(houseList);
        return Result.success();
    }
}
