package house.springboot.Mapper;

import house.springboot.entity.HouseInfo;
import house.springboot.entity.HouseList;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface HouseListMapper {

    List<HouseList> selectAllHouseList(HouseList houseList);

    List<HouseList> myHouseSearch(HouseList houseList);

    List<HouseInfo> adminHouseList(HouseInfo houseInfo);

    List<HouseList> exquisiteHouse(HouseList houseList);

    List<HouseInfo> selectHouseListByUserId(Integer userId);

    HouseInfo selectAllHouseListById(Integer houseId);

    void insertHouseList(HouseList houseList);

    void updateHouseList(HouseList houseList);

    void deleteHouseList(Integer id);

    List<HouseList> selectByStatus();

    void updateByHouseStatus(HouseList houseList);
}
