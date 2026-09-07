package house.springboot.controller;

import house.springboot.com.Result;
import house.springboot.entity.Landlord;
import house.springboot.service.LandlordService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/landlord")
public class LandlordController {
    @Resource
    private LandlordService landlordService;

    @GetMapping("/selectAll")
    public Result selectAll() {
        List<Landlord> list = landlordService.selectAllLandlord();
        return Result.success(list);
    }

    @PutMapping("/insertLandlord")
    public Result insertLandlord(@RequestBody Landlord landlord) {
        landlordService.insertLandlord(landlord);
        return Result.success();
    }

    @PutMapping("/updateStatus")
    public Result updateStatus(@RequestBody Landlord landlord) {
        landlordService.updateLandlordStatus(landlord);
        return Result.success();
    }

}
