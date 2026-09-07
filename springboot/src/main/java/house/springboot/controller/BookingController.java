package house.springboot.controller;

import house.springboot.com.Result;
import house.springboot.entity.Booking;
import house.springboot.entity.HouseInfo;
import house.springboot.service.BookingService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/booking")
public class BookingController {
    @Resource
    private BookingService bookingService;

    @PutMapping("/insertBooking")
    public Result insertBooking(@RequestBody Booking booking) {
        bookingService.insertBooking(booking);
        return Result.success();
    }

    @GetMapping("selectBookingByLandlordId")
    public Result selectBookingByLandlordId(@RequestParam Integer landlordId) {
        List<HouseInfo> list = bookingService.selectBookingByLandlordId(landlordId);
        return Result.success(list);
    }

    @GetMapping("/selectMyBooking")
    public Result selectMyBooking(@RequestParam Integer userId) {
        List<HouseInfo> list = bookingService.selectMyBooking(userId);
        return Result.success(list);
    }

    @DeleteMapping("/deleteMyBooking")
    public Result deleteMyBooking(@RequestParam Integer id) {
        bookingService.deleteMyBooking(id);
        return Result.success();
    }

    @PutMapping("/updateStatus")
    public Result updateStatus(@RequestBody Booking booking) {
        bookingService.updateStatus(booking);
        return Result.success();
    }
}

