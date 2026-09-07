package house.springboot.Mapper;

import house.springboot.entity.Booking;
import house.springboot.entity.HouseInfo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BookingMapper {
    void insertBooking(Booking booking);

    List<HouseInfo> selectMyBooking(Integer userId);

    List<HouseInfo> selectBookingByLandlordId(Integer landlordId);

    void deleteMyBooking(Integer id);

    void updateStatus(Booking booking);
}
