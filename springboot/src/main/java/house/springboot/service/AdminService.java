package house.springboot.service;

import house.springboot.Mapper.AdminMapper;
import house.springboot.Mapper.HouseListMapper;
import house.springboot.entity.Admin;
import house.springboot.entity.HouseList;
import house.springboot.exception.CustomException;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminService {
    @Resource
    private AdminMapper adminMapper;
    @Resource
    private HouseListMapper houseListMapper;

    public Admin login(Admin admin) {
        String username = admin.getUsername();
        Admin dbnAdmin = adminMapper.selectAdminByName(username);
        if (dbnAdmin == null) {
            throw new CustomException("500", "账号不存在");
        }
        String password = admin.getPassword();
        if (!dbnAdmin.getPassword().equals(password)) {
            throw new CustomException("500", "密码输入错误");
        }
        return dbnAdmin;
    }

    public List<HouseList> selectByStatus() {
        return houseListMapper.selectByStatus();
    }

    public void updateHouseStatus(HouseList houseList) {
        houseListMapper.updateByHouseStatus(houseList);
    }
}
