package house.springboot.service;

import house.springboot.Mapper.LandlordMapper;
import house.springboot.entity.Landlord;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LandlordService {
    @Resource
    private LandlordMapper landlordMapper;

    public List<Landlord> selectAllLandlord() {
        return landlordMapper.selectAllLandlord();
    }

    public void insertLandlord(Landlord landlord) {
        landlordMapper.insertLandlord(landlord);
    }

    public void updateLandlordStatus(Landlord landlord) {
        landlordMapper.updateLandlordStatus(landlord);
    }
}
