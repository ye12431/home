package house.springboot.service;

import house.springboot.Mapper.BookingMapper;
import house.springboot.entity.Booking;
import house.springboot.entity.HouseInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookingService {
    @Resource
    private BookingMapper bookingMapper;

    public void insertBooking(Booking booking) {
        bookingMapper.insertBooking(booking);
    }

    public List<HouseInfo> selectMyBooking(Integer userId) {
        return bookingMapper.selectMyBooking(userId);
    }

    public List<HouseInfo> selectBookingByLandlordId(Integer landlordId) {
        return bookingMapper.selectBookingByLandlordId(landlordId);
    }

    public void deleteMyBooking(Integer id) {
        bookingMapper.deleteMyBooking(id);
    }

    public void updateStatus(Booking booking) {
        bookingMapper.updateStatus(booking);
    }
}
