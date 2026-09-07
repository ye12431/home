package house.springboot.service;

import house.springboot.Mapper.NoticeMapper;
import house.springboot.entity.Notice;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoticeService {
    @Resource
    private NoticeMapper noticeMapper;
    public List<Notice> selectAllNoticeList(Notice notice) {
        return noticeMapper.selectAllNoticeList(notice);
    }
    public void deleteByNoticeId(Integer noticeId) {
        noticeMapper.deleteByNoticeId(noticeId);
    }
    public void insertNotice(Notice notice) {
        noticeMapper.insert(notice);
    }
}
