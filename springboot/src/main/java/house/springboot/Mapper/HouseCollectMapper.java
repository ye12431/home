package house.springboot.Mapper;

import house.springboot.entity.HouseCollect;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface HouseCollectMapper {
    void insertHouseCollect(HouseCollect houseCollect);

    HouseCollect isCollect(Integer userId, Integer houseId);

    void deleteCollect(Integer userId, Integer houseId);
}
