package house.springboot.controller;

import house.springboot.com.Result;
import house.springboot.entity.HouseCollect;
import house.springboot.service.HouseCollectService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/houseCollect")
public class HouseCollectController {
    @Resource
    private HouseCollectService houseCollectService;

    @PostMapping("/insertCollect")
    public Result insertCollect(@RequestBody HouseCollect houseCollect) {
        houseCollectService.insertCollect(houseCollect);
        return Result.success();
    }

    @GetMapping("/isCollect")
    public Result isCollect(@RequestParam Integer userId, @RequestParam Integer houseId) {
        return Result.success(houseCollectService.isCollect(userId, houseId));
    }

    @DeleteMapping("/deleteCollect")
    public Result deleteCollect(@RequestParam Integer userId, @RequestParam Integer houseId) {
        houseCollectService.deleteCollect(userId, houseId);
        return Result.success();
    }
}
