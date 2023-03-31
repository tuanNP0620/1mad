--3. Yêu cầu thực hành
--a. Xử lý chuỗi, ngày giờ
--1. Cho biết NGAYTD, TENCLB1, TENCLB2, KETQUA các trận đấu diễn ra vào tháng 3 trên sân  nhà mà không bị thủng lưới.
select NGAYTD, CLB1.TENCLB as TENCLB1, CLB2.TENCLB as TENCLB2, KETQUA
from TRANDAU, CAULACBO CLB1, CAULACBO CLB2
where KETQUA LIKE '%-0'
AND (MACLB1 = CLB1.MACLB AND MACLB2 = CLB2.MACLB)

--2. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ lót là “Công”.
select MACT, HOTEN, NGAYSINH 
from CAUTHU
where HOTEN like N'%_Công_%'

--3. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ không phải là họ “Nguyễn “.
select MACT, HOTEN, NGAYSINH
from CAUTHU
where HOTEN NOT LIKE N'Nguyễn_%'

--4. Cho biết mã huấn luyện viên, họ tên, ngày sinh, đ ịa chỉ của những huấn luyện viên Việt Nam có tuổi nằm trong khoảng 35-40.
select MAHLV, TENHLV, NGAYSINH, DIACHI, (year(getdate()) - year(NGAYSINH)) as TUOI
from HUANLUYENVIEN, QUOCGIA
where HUANLUYENVIEN.MAQG = QUOCGIA.MAQG
AND TENQG = N'Việt Nam'
AND (((year(getdate()) - year(NGAYSINH)) >= 35 and (year(getdate()) - year(NGAYSINH)) <= 40))

--5. Cho biết tên câu lạc bộ có huấn luyện viên trưởng sinh vào ngày 20 tháng 8 năm 2019
select TENCLB
from CAULACBO, HUANLUYENVIEN, HLV_CLB
where (day(NGAYSINH) = 20 and month(NGAYSINH) = 5)
AND HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
AND CAULACBO.MACLB = HLV_CLB.MACLB

--6. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có số bàn thắng nhiều nhất tính đến hết vòng 3 năm 2009.
select top 1 TENCLB, TENTINH
from BANGXH, CAULACBO, TINH
where VONG = 3
AND BANGXH.MACLB = CAULACBO.MACLB
AND CAULACBO.MATINH = TINH.MATINH
order by HIEUSO desc

--b. Truy vấn con
--1. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài (Có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài.
select CAULACBO.MACLB, TENCLB, TENSAN, SANVD.DIACHI, count(MACT) as [SO CT NUOC NGOAI]
from CAULACBO, SANVD, CAUTHU, QUOCGIA
where CAULACBO.MACLB = CAUTHU.MACLB 
AND SANVD.MasAN = CAULACBO.MasAN
AND CAUTHU.MAQG = QUOCGIA.MAQG AND TENQG != N'Việt Nam'
group by CAULACBO.MACLB, TENCLB, TENSAN, SANVD.DIACHI
having (count(MACT) >= 2)

--2. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có hiệu số bàn thắng bại cao nhất năm 2009.
select TENCLB, TENTINH
from CAULACBO, TINH, BANGXH, (select max(vong) as vongcuoi from BANGXH) v

where VONG = v.vongcuoi
AND CAULACBO.MACLB = BANGXH.MACLB
AND CAULACBO.MATINH = TINH.MATINH
AND (cast(left(HIEUSO, charindex('-', HIEUSO)-1) as int) 
		- cast(right(HIEUSO, len(HIEUSO) - charindex('-', HIEUSO)) as int)) = 
 (select MAX(cast(left(HIEUSO, charindex('-', HIEUSO)-1) as int) 
				- cast(right(HIEUSO, len(HIEUSO) - charindex('-', HIEUSO)) as int))
	from BANGXH where VONG = v.vongcuoi)

select * from BANGXH where vong = 4

--3. Cho biết danh sách các trận đấu ( NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009.
select NGAYTD, TENSAN, C1.TENCLB as TENCLB1, C2.TENCLB as TENCLB2, KETQUA
from TRANDAU, SANVD, CAULACBO C1, CAULACBO C2, BANGXH
where BANGXH.VONG = 3 
AND HANG >= ALL (select HANG from BANGXH where VONG = 3)
AND (TRANDAU.MACLB1 = BANGXH.MACLB OR TRANDAU.MACLB2 = BANGXH.MACLB)
AND TRANDAU.MACLB1 = C1.MACLB AND TRANDAU.MACLB2 = C2.MACLB
AND TRANDAU.MasAN = SANVD.MasAN

--4. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại (kể cả sân nhà và sân khách) trong mùa giải năm 2009.
select MACLB, TENCLB
from CAULACBO
where MACLB IN 
(select MACLB from CAULACBO as C1 where 
(select count(MATRAN) from TRANDAU where TRANDAU.MACLB1 = C1.MACLB or TRANDAU.MACLB2 = C1.MACLB) = 
(select count(CAULACBO.MACLB) from CAULACBO) - 1
)


select distinct MACLB
from CAULACBO c
where not exists (select MACLB from CAULACBO c1 
	except ((select MACLB1 as MACLB from TRANDAU t1 where t1.MACLB2 = c.MACLB)
			union (select MACLB2 as MACLB from TRANDAU t2 where t2.MACLB1 = c.MACLB)
			union (select MACLB from CAULACBO c2 where c2.MACLB = c.MACLB)))

--5. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại ( chỉ tính sân nhà) tro ng mùa giải năm 2009.
select MACLB, TENCLB
from CAULACBO
where MACLB IN 
(select MACLB from CAULACBO as C1 where 
(select count(MATRAN) from TRANDAU where TRANDAU.MACLB1 = C1.MACLB) = 
(select count(CAULACBO.MACLB) from CAULACBO) - 1
)

select distinct MACLB1 
from TRANDAU t1
where not exists (select MACLB from CAULACBO c1 
	except ((select MACLB2 from TRANDAU t2 where t1.MACLB1 = t2.MACLB1) union (select MACLB from CAULACBO c2 where MACLB = t1.MACLB1)))


--c. Bài tập về Rule
--1. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cầu thủ chỉ thuộc một trong các vị trí sau: Thủ môn, tiền đạo, tiền vệ, trung vệ, hậu vệ.
alter table CAUTHU
drop constraint CHK_VITRI
GO

alter table CAUTHU
add constraint CHK_VITRI check (VITRI IN (N'Thủ môn', N'Tiền đạo', N'Tiền vệ', N'Trung vệ', N'Hậu vệ'));
GO

--2. Khi phân công huấn luyện viên, kiểm tra vai trò của huấn luyện vi ên chỉ thuộc một trong các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn.
alter table HLV_CLB
drop constraint CHK_VAITRO
GO

alter table HLV_CLB
add constraint CHK_VAITRO check (VAITRO IN (N'HLV chính', N'HLV phụ', N'HLV thể lực', N'HLV thủ môn'));
GO

--3. Khi thêm cầu thủ mới, kiểm tra cầu thủ đó có tuổi phải đủ 18 trở lên (chỉ tính năm sinh)
alter table CAUTHU
drop constraint CHK_NGAYSINH

alter table CAUTHU
add constraint CHK_NGAYSINH check (year(getdate()) - year(NGAYSINH) >= 18)

--4. Kiểm tra kết quả trận đấu có dạng số_bàn_thắng- số_bàn_thua.
alter table TRANDAU
drop constraint CHK_KETQUA

alter table TRANDAU
add constraint CHK_KETQUA check (KETQUA LIKE '%-%')

--d. Bài tập về View
--1. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bón g “SHB Đà Nẵng” có quốc tịch “Bra-xin”.
	create view view1
	as
	select ct.MACT, ct.HOTEN, ct.NGAYSINH, ct.DIACHI, ct.VITRI
	from CAULACBO as clb, CAUTHU as ct, QUOCGIA as qg
	where ct.MAQG= qg.MAQG
	AND qg.TENQG=N'Bra-xin'
	AND ct.MACLB= clb.MACLB
	AND clb.TENCLB=N'SHB Đà Nẵng'
	select * from view1

--2. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 3 của mùa bóng năm 2009.
	create view view2
	as
	select td.MATRAN, td.NGAYTD, svd.TENSAN, clb1.TENCLB as TENCLB1, clb2.TENCLB as TENCLB2, td.KETQUA
	from TRANDAU as td , SANVD as svd , CAULACBO as clb1 , CAULACBO as clb2
	where td.MasAN = svd.MasAN
	  AND td.MACLB1 = clb1.MACLB
	  AND td.MACLB2 = clb2.MACLB
	  AND td.VONG = 2
	  AND td.NAM = 2009  ;
	select * from view2

--3. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “Việt Nam”.
	create view view3
	as
	select hlv.MAHLV, hlv.TENHLV, hlv.NGAYSINH, hlv.DIACHI, HLV_CLB.VAITRO, clb.TENCLB, qg.TENQG
	from HUANLUYENVIEN as hlv , HLV_CLB , CAULACBO as clb , QUOCGIA as qg
	where hlv.MAHLV = HLV_CLB.MAHLV
	  AND hlv.MAQG = qg.MAQG
	  AND HLV_CLB.MACLB = clb.MACLB
	  AND qg.TENQG = N'Việt Nam'  ;
	select * from view3

--4. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ nhiều hơn 2 cầu thủ nước ngoài.
	create view view4
	as
	select clb.MACLB, clb.TENCLB, svd.TENSAN, svd.DIACHI, count(ct.MACT) as [số lượng cầu thủ nước ngoài]
	from CAULACBO as clb , SANVD as svd , CAUTHU as ct
	where clb.MasAN = svd.MasAN
	  AND clb.MACLB = ct.MACLB
	  AND ct.MAQG not like 'VN'
	group by clb.MACLB, clb.TENCLB, svd.TENSAN, svd.DIACHI
	having count(ct.MACT) > 2  ;
	select * from view4

--5. Cho biết tên tỉnh, số lượng câu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lý.
	create view view5
	as
	select TINH.TENTINH , count(ct.MACT) as [số lượng cầu thủ]
	from TINH , CAULACBO as clb , CAUTHU as ct
	where TINH.MATINH = clb.MATINH
	  AND clb.MACLB = ct.MACLB
	  AND ct.VITRI = N'Tiền đạo'
	group by TINH.TENTINH  ;
	select * from view5

--6. Cho biết tên câu lạc bộ,tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng của vòng 3 năm 2009.
	create view view6
	as
	select top 1 clb.TENCLB , TINH.TENTINH
	from CAULACBO as clb , TINH , BANGXH as bxh
	where clb.MATINH = TINH.MATINH
	  AND clb.MACLB = bxh.MACLB
	  AND bxh.VONG = 3 AND bxh.NAM = 2009
	order by bxh.DIEM desc  ;
	select * from view6

--7. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong 1 câu lạc bộ mà chưa có số điện thoại.
	create view view7
	as
	select TENHLV
	from HUANLUYENVIEN
	where DIENTHOAI IS NULL  ;
	select * from view7

--8. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ
	create view view8
	as
	select hlv.TENHLV
	from HUANLUYENVIEN as hlv , QUOCGIA as qg , HLV_CLB
	where hlv.MAQG = qg.MAQG
	  AND qg.TENQG = N'Việt Nam'
	  AND hlv.MAHLV = HLV_CLB.MAHLV
	  AND HLV_CLB.VAITRO IS NULL  ;
	select *from view8
--9. Cho biết kết quả các trận đấu đã diễn ra (MACLB1, MACLB2, NAM, VONG, SOBANTHANG,SOBANTHUA).
	create view view9
	as
	select MACLB1, MACLB2, NAM, VONG, KETQUA
	from TRANDAU as td
	select * from view9
--10. Cho biết kết quả các trận đấu trên sân nhà (MACLB, NAM, VONG, SOBANTHANG, SOBANTHUA).
	create view view10
	as
	select td.MACLB1 as MACLB, NAM, VONG, KETQUA
	from TRANDAU as td
	select *from view10
--11. Cho biết kết quả các trận đấu trên sân khách (MACLB, NAM, VONG, SOBANTHANG,SOBANTHUA).
	create view view11
	as
	select td.MACLB2 as MACLB, NAM, VONG, KETQUA
	from TRANDAU as td
	select * from view11
--12. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của câu lạc bộ CLB đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009.
	create view view12
	as
	select td.NGAYTD, svd.TENSAN, clb1.TENCLB as TENCLB1, clb2.TENCLB as TENCLB2, td.KETQUA
	from TRANDAU as td , SANVD as svd , BANGXH as bxh , CAULACBO as clb1 , CAULACBO as clb2
	where (clb1.MACLB = bxh.MACLB OR clb2.MACLB = bxh.MACLB)
	  AND bxh.HANG = 1
	  AND td.MasAN = svd.MasAN
	  AND td.MACLB1 = clb1.MACLB
	  AND td.MACLB2 = clb2.MACLB
	  AND (bxh.VONG = 3 AND bxh.NAM = 2009)  ;
	  select * from view12
--13. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009
	create view view13
	as
	select td.NGAYTD, svd.TENSAN, clb1.TENCLB as TENCLB1, clb2.TENCLB as TENCLB2, td.KETQUA
	from TRANDAU as td , SANVD as svd , BANGXH as bxh , CAULACBO as clb1 , CAULACBO as clb2
	where (clb1.MACLB = bxh.MACLB OR clb2.MACLB = bxh.MACLB)
	  AND bxh.HANG =  ( select max(HANG) 
					   from BANGXH
					   where VONG = 3 AND NAM = 2009 )
	  AND td.MasAN = svd.MasAN
	  AND td.MACLB1 = clb1.MACLB
	  AND td.MACLB2 = clb2.MACLB
	  AND (bxh.VONG = 3 AND bxh.NAM = 2009)  ;
	  select * from view13