package house.springboot.entity;

import java.time.LocalDateTime;

public class HouseCollect {
    private Integer id;
    private Integer userId;
    private Integer houseId;
    private LocalDateTime createTime;

    @Override
    public String toString() {
        return "HouseCollect{" +
                "id=" + id +
                ", userId=" + userId +
                ", houseId=" + houseId +
                ", createTime=" + createTime +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getHouseId() {
        return houseId;
    }

    public void setHouseId(Integer houseId) {
        this.houseId = houseId;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
}
