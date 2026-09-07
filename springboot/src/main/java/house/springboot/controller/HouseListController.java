package house.springboot.controller;

import com.github.pagehelper.PageInfo;
import house.springboot.com.Result;
import house.springboot.entity.HouseInfo;
import house.springboot.entity.HouseList;
import house.springboot.service.HouseListService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("/houseList")
@RestController
public class HouseListController {
    @Resource
    private HouseListService houseListService;

    @GetMapping("/selectAll")
    public Result selectAll(HouseList houseList) {
        List<HouseList> list = houseListService.selectAll(houseList);
        return Result.success(list);
    }

    //查精品房源
    @GetMapping("/exquisiteHouse")
    public Result exquisiteHouse(HouseList houseList) {
        List<HouseList> list = houseListService.exquisiteHouse(houseList);
        return Result.success(list);
    }

    @GetMapping("/selectByUserId")
    public Result selectByUserId(@RequestParam Integer userId) {
        List<HouseInfo> list = houseListService.selectHouseListByUserId(userId);
        return Result.success(list);
    }

    @GetMapping("/myHouseList")
    public Result myHouseSearch(HouseList houseList) {
        List<HouseList> list = houseListService.myHouseSearch(houseList);
        return Result.success(list);
    }

    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        HouseInfo houseList = houseListService.selectAllHouseListById(id);
        return Result.success(houseList);
    }

    @GetMapping("/selectPage")
    public Result selectPage(HouseList houseList, @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<HouseList> pageInfo = houseListService.selectPage(houseList, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    @GetMapping("/adminHouseList")
    public Result adminHouseList(HouseInfo houseInfo) {
        List<HouseInfo> list = houseListService.adminHouseList(houseInfo);
        return Result.success(list);
    }

    @PostMapping("/insert")
    public Result insert(@RequestBody HouseList houseList) {
        houseListService.insertHouseList(houseList);
        return Result.success();
    }

    @PutMapping("/update")
    public Result update(@RequestBody HouseList houseList) {
        houseListService.updateHouseList(houseList);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        houseListService.deleteHouseList(id);
        return Result.success();
    }
}
