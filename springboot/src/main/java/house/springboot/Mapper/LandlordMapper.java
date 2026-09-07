package house.springboot.Mapper;

import house.springboot.entity.Landlord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface LandlordMapper {
    void insertLandlord(Landlord landlord);

    List<Landlord> selectAllLandlord();

    void updateLandlordStatus(Landlord landlord);

    @Select("select username from `landlord` where id = #{id}")
    String selectUsername(int id);
}
