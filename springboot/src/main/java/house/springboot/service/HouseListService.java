package house.springboot.service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import house.springboot.Mapper.HouseImageMapper;
import house.springboot.Mapper.HouseListMapper;
import house.springboot.entity.HouseInfo;
import house.springboot.entity.HouseList;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class HouseListService {
    @Resource
    private HouseListMapper houseListMapper;
    @Resource
    private HouseImageMapper houseImageMapper;

    public List<HouseList> selectAll(HouseList houseList) {
        return houseListMapper.selectAllHouseList(houseList);
    }

    public List<HouseInfo> adminHouseList(HouseInfo houseInfo) {
        return houseListMapper.adminHouseList(houseInfo);
    }

    // 查询精品房源
    public List<HouseList> exquisiteHouse(HouseList houseList) {
        List<HouseList> list = houseListMapper.exquisiteHouse(houseList);
        for (HouseList house : list) {
            List<house.springboot.entity.HouseImage> images = houseImageMapper.selectByHouseId(house.getId());
            if (images != null && !images.isEmpty()) {
                List<String> urls = new java.util.ArrayList<>();
                for (house.springboot.entity.HouseImage image : images) {
                    urls.add(image.getUrl());
                }
                house.setUrls(urls);
            }
        }
        return list;
    }

    //查询我的房源
    public List<HouseList> myHouseSearch(HouseList houseList) {
        return houseListMapper.myHouseSearch(houseList);
    }

    public List<HouseInfo> selectHouseListByUserId(Integer userId) {
        List<HouseInfo> houseInfos = houseListMapper.selectHouseListByUserId(userId);
        for (HouseInfo houseInfo : houseInfos) {
            if (houseInfo != null) {
                List<house.springboot.entity.HouseImage> images = houseImageMapper.selectByHouseId(houseInfo.getId());
                if (images != null && !images.isEmpty()) {
                    List<String> urls = new java.util.ArrayList<>();
                    for (house.springboot.entity.HouseImage image : images) {
                        urls.add(image.getUrl());
                    }
                    houseInfo.setUrls(urls);
                }
            }
        }
        return houseInfos;
    }

    public HouseInfo selectAllHouseListById(Integer houseId) {
        HouseInfo houseInfo = houseListMapper.selectAllHouseListById(houseId);
        if (houseInfo != null) {
            List<house.springboot.entity.HouseImage> images = houseImageMapper.selectByHouseId(houseId);
            if (images != null && !images.isEmpty()) {
                List<String> urls = new java.util.ArrayList<>();
                for (house.springboot.entity.HouseImage image : images) {
                    urls.add(image.getUrl());
                }
                houseInfo.setUrls(urls);
            }
        }
        return houseInfo;
    }

    public PageInfo<HouseList> selectPage(HouseList houseList, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<HouseList> list = houseListMapper.selectAllHouseList(houseList);
        for (HouseList house : list) {
            List<house.springboot.entity.HouseImage> images = houseImageMapper.selectByHouseId(house.getId());
            if (images != null && !images.isEmpty()) {
                List<String> urls = new java.util.ArrayList<>();
                for (house.springboot.entity.HouseImage image : images) {
                    urls.add(image.getUrl());
                }
                house.setUrls(urls);
            }
        }
        return PageInfo.of(list);
    }

    @Transactional
    public void insertHouseList(HouseList houseList) {
        houseListMapper.insertHouseList(houseList);
        Integer houseId = houseList.getId();
        List<String> urls = houseList.getUrls();
        if (urls != null && !urls.isEmpty()) {
            houseImageMapper.batchInsert(houseId, urls);
        }
    }

    @Transactional
    public void updateHouseList(HouseList houseList) {
        houseListMapper.updateHouseList(houseList);
        List<String> urls = houseList.getUrls();
        if (urls != null && !urls.isEmpty()) {
            houseImageMapper.deleteByHouseId(houseList.getId());
            houseImageMapper.batchInsert(houseList.getId(), urls);
        }
    }

    @Transactional
    public void deleteHouseList(Integer id) {
        houseImageMapper.deleteByHouseId(id);
        houseListMapper.deleteHouseList(id);
    }

}
