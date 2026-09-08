-- MySQL dump 10.13  Distrib 5.5.62, for Win64 (AMD64)
--
-- Host: localhost    Database: house
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_croatian_ci DEFAULT NULL COMMENT '名字',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_croatian_ci DEFAULT NULL COMMENT '密码',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'admin','123456');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `time` datetime DEFAULT NULL COMMENT '预约时间',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `house_id` bigint(20) DEFAULT NULL COMMENT '房源id',
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '预约人电话',
  `note` text COLLATE utf8_unicode_ci COMMENT '预约备注',
  `status` int(11) DEFAULT NULL COMMENT '预约状态',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (18,'2026-03-19 08:00:00',2,20,'我是本人','qqq',0),(15,'2026-03-05 05:07:10',5,20,'5982','我是userid5的用户，我要看李四sss的房子',1),(14,'2026-03-04 04:57:30',3,20,'发撒大点','伟大的党',2),(10,'2026-03-19 08:00:00',5,20,'11111111','1111111111111111',0),(17,'2026-03-04 08:00:00',2,20,'141414','我是李四我要看自己的房子',2),(19,'2026-03-04 21:06:00',13,20,'15609784567','预约看房',0),(22,'2026-03-10 08:00:00',13,24,'15467872343','我要看房',0),(21,'2026-03-20 23:01:02',11,22,'13565791352','预约看房',0),(23,'2026-03-06 08:00:00',13,26,'15643678964','kanfang',0),(24,'2026-03-13 08:00:00',13,23,'15643678964','预约看房',0),(25,'2026-04-14 08:00:00',13,36,'130495861234','我王伟要看房',2),(37,'2026-09-08 13:52:42',12,20,'13086767075','预约看房',0);
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `house_id` bigint(20) DEFAULT NULL COMMENT '房源id',
  `user_id` bigint(20) DEFAULT NULL COMMENT '评论人id',
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '评论人用户名',
  `content` text COLLATE utf8_unicode_ci COMMENT '评论内容',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `rating` int(11) DEFAULT '5',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (21,24,13,'王伟','222','2026-03-31 22:22:37',5),(18,20,12,'李四','这个房子很好','2026-03-21 20:51:17',5),(19,20,11,'张三','3213123','2026-03-28 17:02:07',5),(20,24,13,'王伟','1111','2026-03-31 21:39:08',5),(17,22,11,'张三','1111','2026-03-14 23:26:49',5),(23,23,12,'李四','1111','2026-04-15 17:01:49',5),(24,23,12,'李四','2222','2026-04-15 17:01:57',5),(25,36,12,'李四','111','2026-04-21 23:17:02',5);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `house_collect`
--

DROP TABLE IF EXISTS `house_collect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `house_collect` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `house_id` bigint(20) DEFAULT NULL COMMENT '房源id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `house_collect`
--

LOCK TABLES `house_collect` WRITE;
/*!40000 ALTER TABLE `house_collect` DISABLE KEYS */;
INSERT INTO `house_collect` VALUES (73,12,23,'2026-04-22 07:55:47'),(70,12,24,'2026-04-22 00:48:08'),(66,11,20,'2026-03-28 17:02:51'),(65,13,24,'2026-03-24 17:43:49'),(64,13,20,'2026-03-24 17:43:46'),(63,13,22,'2026-03-24 17:43:42'),(61,12,21,'2026-03-15 13:13:49'),(60,12,22,'2026-03-15 13:13:40'),(56,2,17,'2026-03-05 22:59:58'),(55,2,16,'2026-03-05 21:36:41'),(54,3,6,'2026-03-03 20:57:37'),(53,5,8,'2026-03-03 12:36:08'),(52,5,4,'2026-03-03 12:27:27'),(44,2,2,'2026-03-02 18:38:30'),(47,5,3,'2026-03-02 18:58:12'),(48,5,1,'2026-03-02 18:58:25'),(50,5,7,'2026-03-02 18:58:50'),(45,2,1,'2026-03-02 18:44:17');
/*!40000 ALTER TABLE `house_collect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `house_image`
--

DROP TABLE IF EXISTS `house_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `house_image` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `house_id` int(11) NOT NULL COMMENT '房源id',
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '图片路径',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=102 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `house_image`
--

LOCK TABLES `house_image` WRITE;
/*!40000 ALTER TABLE `house_image` DISABLE KEYS */;
INSERT INTO `house_image` VALUES (1,8,'http://localhost:9090/files/download/1772281445407_mmexport1757414601441.jpg'),(2,11,'http://localhost:9090/files/download/1772281653027_mmexport1757414615909.jpg'),(3,12,'http://localhost:9090/files/download/1772289506013_mmexport1757414601441.jpg'),(4,12,'http://localhost:9090/files/download/1772289508583_mmexport1757414615909.jpg'),(14,7,'http://localhost:9090/files/download/1772613240621_mmexport1757414615909.jpg'),(13,1,'http://localhost:9090/files/download/1772609235440_mmexport1757414606250.jpg'),(15,14,'http://localhost:9090/files/download/1772629899835_mmexport1757414615909.jpg'),(16,15,'http://localhost:9090/files/download/1772716538434_mmexport1757414615909.jpg'),(17,16,'http://localhost:9090/files/download/1772717615200_mmexport1757414606250.jpg'),(18,17,'http://localhost:9090/files/download/1772721276570_屏幕截图 2026-02-09 204807.png'),(19,18,'http://localhost:9090/files/download/1773131518807_mmexport1757414615909.jpg'),(20,18,'http://localhost:9090/files/download/1773131520867_mmexport1757414606250.jpg'),(21,19,'http://localhost:9090/files/download/1773132867163_mmexport1757414615909.jpg'),(22,19,'http://localhost:9090/files/download/1773132868924_mmexport1757414606250.jpg'),(23,20,'http://localhost:9090/files/download/1773411060923_38b9bafd-4f0d-4964-87dc-72e826ec71fa.png'),(24,20,'http://localhost:9090/files/download/1773411062814_738ae982-3d57-4efb-b91c-62e3030253a3.png'),(25,20,'http://localhost:9090/files/download/1773411064864_65519beb-1b2e-47f1-952c-9c03bdd9b65a.png'),(54,26,'http://localhost:9090/files/download/1774966823964_d62c6068-bb4f-49a5-9f00-46a35ac540fb.png'),(53,26,'http://localhost:9090/files/download/1774966822038_7625d505-a036-4f62-b721-74248044c2e4.png'),(52,26,'http://localhost:9090/files/download/1774966820212_16f4f61c-b5af-4614-bd4b-c792a84edad3.png'),(29,22,'http://localhost:9090/files/download/1773418262455_3de6cca3-1f58-4161-a9e6-42df36f2e6ee.png'),(30,22,'http://localhost:9090/files/download/1773418264786_4bc90f55-a241-406e-9438-7617d13599b4.png'),(31,22,'http://localhost:9090/files/download/1773418267719_912cea6b-7769-46fa-9429-5a3db481d125.png'),(32,22,'http://localhost:9090/files/download/1773418270214_7498f807-a936-4af8-97e0-fca9dd9bc130.png'),(51,23,'http://localhost:9090/files/download/1773554816895_71d0da89-fe34-483b-ba6e-93a191ba574f.png'),(50,23,'http://localhost:9090/files/download/1773554819021_92a24c3a-e29e-4128-949c-59a08f18706e.png'),(49,23,'http://localhost:9090/files/download/1773554823015_316e8778-387e-405e-9c36-b9f7a9bc0559.png'),(48,23,'http://localhost:9090/files/download/1773554825736_a40bd4f6-3f70-4277-bad3-b2f05fb4e271.png'),(37,24,'http://localhost:9090/files/download/1773555027476_7667ac66-3d14-4169-ba14-ca80057b9fd0.png'),(38,24,'http://localhost:9090/files/download/1773555029608_a341553c-df66-4b07-8697-00b2adc1249d.png'),(39,24,'http://localhost:9090/files/download/1773555031881_e549fe8d-13d4-46e3-b570-f60dc06615cc.png'),(40,24,'http://localhost:9090/files/download/1773555033988_ee9e7323-109f-45c7-a0ec-ceb8d1c73575.png'),(41,25,'http://localhost:9090/files/download/1774094422146_3a8e468e-2196-48b3-92e7-1994f4ae7495.png'),(42,25,'http://localhost:9090/files/download/1774094424419_a1046156-a2cf-4f66-a9e2-cc77ac482174.png'),(43,25,'http://localhost:9090/files/download/1774094426953_f1481c79-290c-470b-b78c-9c560842eef5.png'),(55,27,'http://localhost:9090/files/download/1776778390107_1dfbaeec79b6ad4bae515a11979ca08f.png'),(56,27,'http://localhost:9090/files/download/1776778397052_b6428570cc2324e3efd6c2b3d188ecf2.png'),(57,27,'http://localhost:9090/files/download/1776778403444_b6428570cc2324e3efd6c2b3d188ecf2.png'),(58,28,'http://localhost:9090/files/download/1776778613322_4ddf12c2-1407-43fa-8824-c65bc6304ba8.png'),(59,28,'http://localhost:9090/files/download/1776778615095_a74af95a-03bc-4752-9fa1-65b93f625141.png'),(60,28,'http://localhost:9090/files/download/1776778617057_a8da7252-1d77-4d28-b53f-1ab36a3aabe0.png'),(68,30,'http://localhost:9090/files/download/1776780045248_0af5fd87-df3f-41d1-9833-5b50924a07af.png'),(67,29,'http://localhost:9090/files/download/1776778945097_fa2ee5909587bb4080c5d6c8d11675b2.png'),(66,29,'http://localhost:9090/files/download/1776778943305_6e489433883ff6624b03a56ff85a618f.png'),(65,29,'http://localhost:9090/files/download/1776778940777_6bbc2bc48db663917c94cab83d1375f9.png'),(69,30,'http://localhost:9090/files/download/1776780047212_bea1f7c1-9695-4f33-95c7-ece571de9496.png'),(70,30,'http://localhost:9090/files/download/1776780049176_cbe9ae8e-9488-46a1-8678-8689dcf4d81b.png'),(71,31,'http://localhost:9090/files/download/1776780341326_0cf9ef2f-5a9c-4a3c-9f12-de2ebb4095cf.png'),(72,31,'http://localhost:9090/files/download/1776780343116_5c9c4735-4cc2-4e86-9793-e901bf7d1bde.png'),(73,31,'http://localhost:9090/files/download/1776780344921_5812f666-2474-41bb-af1a-860e92fde98d.png'),(74,32,'http://localhost:9090/files/download/1776780488865_0c933fdf-1e9f-4010-99df-bdb00a6dac83.png'),(75,32,'http://localhost:9090/files/download/1776780491239_0de3a581-24e6-4a27-b3ec-a28ebed24068.png'),(76,33,'http://localhost:9090/files/download/1776780983428_3b30eb00-5baf-4c73-a058-8ac0ae3e2670.png'),(77,33,'http://localhost:9090/files/download/1776780985782_c14f688a-5a91-462e-b60a-3c1de298e3d7.png'),(78,33,'http://localhost:9090/files/download/1776780987699_c4268e8e-07de-4a9b-93c9-6c0d696025bc.png'),(79,36,'http://localhost:9090/files/download/1776783571453_4c30d94d-10c1-4e7b-b847-6fb7d1283f6c.png'),(80,36,'http://localhost:9090/files/download/1776783573917_698cac48-aba1-4fbd-a2bb-a301352bca58.png'),(81,36,'http://localhost:9090/files/download/1776783575847_8322af74-d715-4df1-b233-a0cbc5aa8a1a.png'),(101,49,'http://localhost:9090/files/download/1788846741102_698cac48-aba1-4fbd-a2bb-a301352bca58.png'),(100,49,'http://localhost:9090/files/download/1788846739265_4c30d94d-10c1-4e7b-b847-6fb7d1283f6c.png');
/*!40000 ALTER TABLE `house_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `house_list`
--

DROP TABLE IF EXISTS `house_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `house_list` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '标题',
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '⁮详细地址',
  `area` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '面积',
  `room_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '房间数',
  `details` text COLLATE utf8_unicode_ci COMMENT '房源详情',
  `status` int(11) DEFAULT '0' COMMENT '状态',
  `user_id` bigint(20) DEFAULT NULL COMMENT '房东id',
  `price` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '月租金',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `house_list`
--

LOCK TABLES `house_list` WRITE;
/*!40000 ALTER TABLE `house_list` DISABLE KEYS */;
INSERT INTO `house_list` VALUES (23,'叠彩区站前路 国奥城铂湾 精装三房两卫 温馨舒适 随时看房','桂林叠彩山水阳光城','105','5','房子图片和视频都是本人去实拍，真实存在，可实地看房！\n1.小区有物业管理，保安24小时服务。\n2.房子里面家具都齐全，干净整洁，随时入住！\n3.本人手上有很多房源，有兴趣的可以随时联系我',1,12,'2050'),(26,'沃尔玛 2室2厅1卫 ','桂林叠彩沃尔玛','60','3','无',1,12,'800'),(27,'桂北农贸市场住宅楼3室2厅2卫','桂北农贸市场住宅楼','125','3','大马路边精装修楼房位于2楼，三房两厅两卫宽长无比，无停车费物业费，南北通透正对阳光，白天阳光洒落很温馨看图就知道。附近300米内小卖部、菜市场、幼儿园等等，钟即有诊所医院等，生活便利。楼下即为公交车可直接乘坐10路。我们一家不在兴安发展所以租出去，水电便宜，各种家具电器齐全拎包入住',1,12,'950'),(22,'叠彩万达春天里旁电梯四房两厅两卫家电齐全拎包入住','桂林叠彩沃尔玛','135','5','四房两厅两卫，家电家具齐全拎包入住，三台空调，电梯6楼，停车方便，周边配套设施齐全',1,12,'2277'),(20,'桂林租房 接看万达 和平新城二期精装三房二厅家电具齐免费停车','桂林七星区和平村','90','2','真实图片，看房方便，欢迎随时来电\n1.桂林精品楼盘，*物业，小区配套齐全，环境优美，居住舒适，小区保安，停车方便，安静，舒适\n2.该房户型方正，南北通透，采光很好，空气对流，老少皆宜，性价比非常高，\n3.房子配套：空调，冰箱，洗衣机，电视，宽带，时尚沙发，双人大床，热水器，衣柜，餐桌，茶几，书柜，鞋柜等等\n4.小区周边配套齐全、医院、公园、漓江、购物广场、菜市、公车站、火车站等，生活便利！',1,11,'1800'),(24,'近北站，近桂林中医院，自住房，4台空调，新家电家具','桂林叠彩中山北路','105','5','1.房子图片和视频是本人去实地拍摄的，房子真实纯在！可实地看房。\n2.小区园林绿化环境好，有物业管理，保安24小时执勤。\n3.好说话，家电家具齐全，户型方正采光好。',1,12,'2100'),(25,'怡鑫苑 八里街城北附近精装两房 带空调 家具齐全停车方便','桂林灵川八里街城区','70','3','有空调 有网络 有2床 1个衣柜 有天然气 有超市米粉店 公司有大量房源出租 有1房 2房3房 4房 5房 可以随时约看房佳，周边有菜市 家电齐全拎包入住',1,12,'750'),(28,'阳朔乌布小镇街一房一卫 ','阳朔乌布小镇街','44','1','40平米，1房0厅1卫，每个房间都有独立卫生间。电梯楼3楼，酒店公寓式装修，不可做饭，晾衣服方便。',2,12,'1300'),(29,'金辉广场 精装电梯1房 近万象城 桂林站 东安街铁西 ','桂林象山','55','1','1.民用水电： 电（5-6角/度）水（2-3元）\n2.家电家具：空调 冰箱 洗衣机 热水器 床 沙发 衣柜\n3.明火方式：煤气和电\n4.物业：停车方便\n5.楼层：电梯14楼',1,12,'1300'),(30,'象山区！龙光普罗旺斯北精装三房两厅两卫电梯中层拎包入住 ','桂林象山万福广场','89','3','房屋推荐特点：1、户型特点：中层、户型方正、采光视野好，适宜居住。2、室内精装修，拎包入住，客厅宽敞大方，使用率高；卧室温馨舒适，搭配心怡；厨房设施齐全，让美味来得更加轻松。3、环境优雅，低密度社区，小区绿化率高，让你每天生活在空气清新的环境下。',1,12,'1400'),(31,'南溪山公园旁万象城益佳苑电梯房单间配套出租1000元月 ','桂林象山万象城','40','1','南溪山公园附近万象城.益佳苑小区电梯房单间配套出租1000元/月实价 精装修带家电拎包入住 小区物业管理 停车方便安全 比较适合附近朋友入住 先到先得',1,12,'1400'),(32,'桂林租房 接看万达 兴进漓江悦府臻品山景精装三房二厅家电具齐','桂林燕山姐妹桥','126','3','真实图片，看房方便，欢迎随时来电\n1.桂林精品楼盘，*物业，小区配套齐全，环境优美，居住舒适，小区保安，停车方便，安静，舒适\n2.该房户型方正，南北通透，采光很好，空气对流，老少皆宜，非常高，\n3.房子配套：空调，冰箱，洗衣机，电视，宽带，时尚沙发，双人大床，热水器，衣柜，餐桌，茶几，书柜，鞋柜等等\n4.小区周边配套齐全、医院、公园、漓江、购物广场、菜市、公车站、火车站等，生活便利！',1,12,'3000'),(33,'二附高中旁 雁山新城 利森红郡大2房 ',' 桂林 雁山 愚自乐园利森红郡 ','90','3','利森红郡电梯房，2室2厅1卫，精装修拎包入住',1,12,'1600'),(36,'虎山路 精装电梯房 配套齐全 安全卫生 拎包入住 免物业 ',' 桂林临桂 虎山','32','1','本人虎山路有房出租，精装修，干净卫生，有监控，有电动车停车场。交通生活便利，周边超市餐饮俱全。居住安全。',1,12,'700'),(49,'新房源','详细地址','40','1','房源描述',1,12,'700');
/*!40000 ALTER TABLE `house_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `landlord`
--

DROP TABLE IF EXISTS `landlord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `landlord` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '用户名',
  `name` varbinary(255) DEFAULT NULL COMMENT '真实姓名',
  `card_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '身份证',
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '手机号',
  `user_id` int(11) DEFAULT NULL COMMENT '用户id',
  `status` int(11) DEFAULT '0' COMMENT '申请状态',
  `photo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '身份证照片',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `landlord`
--

LOCK TABLES `landlord` WRITE;
/*!40000 ALTER TABLE `landlord` DISABLE KEYS */;
INSERT INTO `landlord` VALUES (15,'danhuangpai','蛋黄派','345143561124398','19147651423',14,0,'http://localhost:9090/files/download/1774099460899_a646d3dd-65d5-410d-a509-ab70fca62dac.png'),(13,'lisi','李四','412423123','15643678964',12,1,'http://localhost:9090/files/download/1773409187289_8310bd3c-fc13-4859-b058-92fe4ff5c2c0.png'),(14,'wangwei','王伟','546785200312041121','15135516436',13,2,'http://localhost:9090/files/download/1773554173815_c195368b-63f3-4afd-8fe9-1f78711e29a0.png');
/*!40000 ALTER TABLE `landlord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '公告标题',
  `content` text COLLATE utf8_unicode_ci COMMENT '公告内容',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '公告时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (4,'33','333','2026-03-21 17:00:05'),(5,'666','666','2026-03-01 17:01:53'),(7,'欢迎来到房屋租赁系统','欢迎来到房屋租赁系统','2026-04-01 13:43:36');
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '姓名',
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '账号',
  `role` varchar(255) COLLATE utf8_unicode_ci DEFAULT '租客' COMMENT '角色',
  `avatar` varbinary(255) DEFAULT NULL COMMENT '头像',
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '手机号',
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '密码',
  `status` int(11) DEFAULT '0' COMMENT '0正常,1封禁',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (14,'蛋黄派','danhuangpai','租客','http://localhost:9090/files/download/1774099443873_a646d3dd-65d5-410d-a509-ab70fca62dac.png','19147651423','111',0),(13,'王伟','wangwei','租客','http://localhost:9090/files/download/1773415440855_c195368b-63f3-4afd-8fe9-1f78711e29a0.png','15135516436','111',1),(12,'李四','lisi','房东','http://localhost:9090/files/download/1773397129925_8310bd3c-fc13-4859-b058-92fe4ff5c2c0.png','15643678964','111',0),(11,'张三','zhangsan','房东','http://localhost:9090/files/download/1773396494537_1a10b73e83225c4d9659928360ddc865.png','15245875450','111',0),(15,'迪迦','迪迦','租客',NULL,'13413515432','123',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'house'
--

--
-- Dumping routines for database 'house'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-08 13:54:29
