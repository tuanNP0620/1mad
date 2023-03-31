--1. Cho biết thông tin (mã cầu thủ, họ tên, số áo, vị trí, ngày sinh, địa chỉ) của tất cả các cầu thủ

SELECT * FROM CAUTHU

--2. Hiển thị thông tin tất cả các cầu thủ có số áo là 7 chơi ở vị trí Tiền vệ.

SELECT * FROM CAUTHU
WHERE SO=7 AND (VITRI LIKE N'Tiền vệ')

--3. Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cả các huấn luyện viên.

SELECT TENHLV, NGAYSINH, DIACHI, DIEMTHOAI FROM HUANLUYENVIEN

--4. Hiển thi thông tin tất cả các cầu thủ có quốc tịch Việt Nam thuộc câu lạc bộ Becamex Bình Dương

SELECT c.HOTEN, c.VITRI,c.SO,c.NGAYSINH,c.DIACHI  
FROM CAUTHU c
JOIN CAULACBO ON c.MACLB = CAULACBO.MACLB
JOIN QUOCGIA ON c.MAQG=QUOCGIA.MAQG
WHERE TENQG LIKE N'việt nam' AND  TENCLB LIKE N'Becamex Bình Dương'

--5. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng 'SHB Đà Nẵng’ có quốc tịch “Bra-xin”

SELECT c.MACT,c.HOTEN, c.VITRI,c.NGAYSINH,c.DIACHI 
FROM CAUTHU c, QUOCGIA, CAULACBO
WHERE c.MAQG = QUOCGIA.MAQG AND c.MACLB=CAULACBO.MACLB
AND TENQG LIKE N'brazil' AND  TENCLB LIKE N'SHB Đà Nẵng'

--6. Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ có sân nhà là “Long An”

SELECT * 
FROM CAUTHU, CAULACBO, SANVD
WHERE CAULACBO.MACLB=CAUTHU.MACLB AND CAULACBO.MASAN=SANVD.MASAN
AND SANVD.TENSAN LIKE N'Long An'

--7. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 2 của mùa bóng năm 2009

SELECT tr.MATRAN, tr.NGAYTD, s.TENSAN, c1.TENCLB, c2.TENCLB, tr.KETQUA  
FROM TRANDAU tr, SANVD s, CAULACBO c1, CAULACBO c2
WHERE VONG=2 AND NAM = 2009
	 AND tr.MACLB1=c1.MACLB AND tr.MACLB1=c2.MACLB
	 AND tr.MASAN = s.MASAN

--8. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “ViệtNam”

SELECT hlv.MAHLV, hlv.TENHLV, hlv.NGAYSINH, hlv.DIACHI, hc.VAITRO, c.TENCLB 
FROM HUANLUYENVIEN hlv, HLV_CLB hc, CAULACBO c, QUOCGIA q
WHERE (hlv.MAHLV = hc.MAHLV AND hc.MACLB = c.MACLB)  AND hlv.MAQG = q.MAQG
AND q.TENQG LIKE N'Việt nam'

--9. Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3 năm 2009

SELECT TOP(3) CAULACBO.TENCLB 
FROM CAULACBO
JOIN BANGXH ON CAULACBO.MACLB = BANGXH.MACLB
WHERE BANGXH.VONG = 3
ORDER BY BANGXH.HANG

--b. Các phép toán trên nhóm
--1. Thống kê số lượng cầu thủ của mỗi câu lạc bộ

SELECT CAULACBO.TENCLB, COUNT(CAULACBO.MACLB) AS 'SỐ LƯỢNG CẦU THỦ'
FROM CAUTHU JOIN CAULACBO ON CAULACBO.MACLB= CAUTHU.MACLB
GROUP BY CAULACBO.MACLB, CAULACBO.TENCLB

--2. Thống kê số lượng cầu thủ nước ngoài (có khác quốc tịch Việt Nam) của mỗi câu lạc bộ

SELECT CAULACBO.TENCLB, COUNT(CAULACBO.MACLB) AS 'SỐ LƯỢNG CẦU THỦ'
FROM CAUTHU 
JOIN CAULACBO ON CAULACBO.MACLB= CAUTHU.MACLB
JOIN QUOCGIA ON QUOCGIA.MAQG= CAUTHU.MAQG
WHERE QUOCGIA.TENQG <> N'Việt Nam'
GROUP BY CAULACBO.MACLB, CAULACBO.TENCLB
ORDER BY CAULACBO.TENCLB DESC

--3. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài (có quốc tịch khác Việt Nam) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài.

SELECT CAULACBO.TENCLB, COUNT(CAULACBO.MACLB) AS 'SỐ LƯỢNG CẦU THỦ'
FROM CAUTHU 
JOIN CAULACBO ON CAULACBO.MACLB= CAUTHU.MACLB
JOIN QUOCGIA ON QUOCGIA.MAQG= CAUTHU.MAQG
WHERE QUOCGIA.TENQG <> N'Việt Nam'
GROUP BY CAULACBO.MACLB, CAULACBO.TENCLB
HAVING COUNT(CAULACBO.MACLB) > 2
ORDER BY CAULACBO.TENCLB DESC

--4. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong  các câu lạc bộ thuộc địa bàn tỉnh đó quản lý

SELECT TINH.TENTINH, COUNT(CAUTHU.MACT) AS 'SỐ LƯỢNG CẦU THỦ'
FROM CAULACBO 
JOIN CAUTHU ON CAULACBO.MACLB = CAUTHU.MACLB
JOIN TINH ON CAULACBO.MATINH = TINH.MATINH
WHERE CAUTHU.VITRI LIKE N'tiền đạo'
GROUP BY TINH.TENTINH, CAUTHU.MACT

--5. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng vòng 3, năm 2009

SELECT CAULACBO.TENCLB, TINH.TENTINH 
FROM CAULACBO
JOIN BANGXH ON CAULACBO.MACLB = BANGXH.MACLB
JOIN TINH ON CAULACBO.MATINH = TINH.MATINH
WHERE BANGXH.VONG = 3 AND BANGXH.HANG =1

--c. Các toán tử nâng cao
--1. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà chưa có số điện thoại

SELECT HUANLUYENVIEN.TENHLV
FROM HLV_CLB
JOIN HUANLUYENVIEN ON HUANLUYENVIEN.MAHLV= HLV_CLB.MAHLV
WHERE DIEMTHOAI IS NULL

SELECT * FROM HUANLUYENVIEN

--2. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ nào

SELECT *
FROM HUANLUYENVIEN h JOIN QUOCGIA ON h.MAQG=QUOCGIA.MAQG
WHERE QUOCGIA.TENQG LIKE N'việt nam'
AND h.MAHLV 
IN (SELECT h.MAHLV FROM HLV_CLB 
	RIGHT JOIN HUANLUYENVIEN h ON h.MAHLV = HLV_CLB.MAHLV
	WHERE HLV_CLB.MAHLV IS NULL)

--3. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009 lớn hơn 6 hoặc nhỏ hơn 3

SELECT CAULACBO.TENCLB, CAUTHU.HOTEN, CAUTHU.VITRI, CAUTHU.SO  
FROM CAULACBO 
JOIN CAUTHU ON CAUTHU.MACLB = CAULACBO.MACLB
JOIN BANGXH ON BANGXH.MACLB = CAULACBO.MACLB
WHERE BANGXH.HANG > 6 OR BANGXH.HANG < 3 AND NAM = 2009 
GROUP BY CAULACBO.TENCLB, CAUTHU.HOTEN, CAUTHU.VITRI, CAUTHU.SO  

