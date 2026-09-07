package house.springboot.service;

import house.springboot.Mapper.HouseCollectMapper;
import house.springboot.entity.HouseCollect;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

@Service
public class HouseCollectService {
    @Resource
    private HouseCollectMapper houseCollectMapper;

    public void insertCollect(HouseCollect houseCollect) {
        houseCollectMapper.insertHouseCollect(houseCollect);
    }

    public HouseCollect isCollect(Integer userId, Integer houseId) {
        return houseCollectMapper.isCollect(userId, houseId);
    }

    public void deleteCollect(Integer userId, Integer houseId) {
        houseCollectMapper.deleteCollect(userId, houseId);
    }
}
