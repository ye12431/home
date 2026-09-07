package house.springboot.Mapper;

import house.springboot.entity.HouseImage;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface HouseImageMapper {

    /**
     * 批量插入房源图片
     * 
     * @param houseId   房源ID
     * @param imageUrls 图片URL列表
     */
    void batchInsert(@Param("houseId") Integer houseId, @Param("imageUrls") List<String> imageUrls);

    /**
     * 根据房源ID查询图片列表
     * 
     * @param houseId 房源ID
     * @return 图片列表
     */
    @Select("select * from house_image where house_id = #{houseId}")
    List<HouseImage> selectByHouseId(Integer houseId);

    /**
     * 根据房源ID删除图片
     * 
     * @param houseId 房源ID
     */
    void deleteByHouseId(Integer houseId);
}
