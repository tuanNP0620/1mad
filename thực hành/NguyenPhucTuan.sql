create table NHANIVIEN(
MANV nvarchar(20) primary key, 
HOTENNV nvarchar(50) not null, 
NGAYSINH date not null,
DIACHI nvarchar(50) not null,
LUONGCB int not null
)

use QLPhiCo_NguyenPhucTuan
create table CHUYENBAY(
MACB nvarchar(20) primary key,
MAPC nvarchar(10) not null,
NoiXP nvarchar(10) not null,
NoiDen nvarchar(10) not null,
GioXP datetime2 not null,
GioDen datetime2 not null,
)


create table PHICO(
MAPC nvarchar(10) primary key,
TENPHICO nvarchar(20) not null,
KHOANGCACHBAY int not null
)

create table CHITIET_CHUYENBAY(
MACB nvarchar(20),
MANV nvarchar(20),
primary key (MACB, MANV),
)


--1
SELECT pc.MAPC ,pc.TENPHICO, pc.KHOANGCACHBAY FROM PHICO pc, CHUYENBAY cb 
WHERE 
pc.MAPC=cb.MAPC
AND KHOANGCACHBAY BETWEEN 1000 AND 5000
AND YEAR(GIOXP)=2020

--2 
SELECT CB.MACB,NOIXP,NOIDEN,GIOXP,GIODEN,TENPHICO,COUNT(MANV) AS SONHANVIEN
FROM PHICO pc,CHUYENBAY cb,CHITIET_CHUYENBAY ct_cb
WHERE pc.MAPC=cb.MAPC
AND cb.MACB=ct_cb.MACB
AND NoiXP=N'HANOI'
AND YEAR(GIOXP)=2019
GROUP BY CB.MACB,NOIXP,NOIDEN,GIOXP,GIODEN,TENPHICO

--3
select CHITIET_CHUYENBAY.MANV, HOTENNV, DIACHI, COUNT(CHITIET_CHUYENBAY.MACB) as N'Số lần tham gia bay', SUM(LUONGCB) as N'Tổng Lương'   
from CHITIET_CHUYENBAY
join NHANVIEN on CHITIET_CHUYENBAY.MANV = NHANVIEN.MANV
GROUP BY CHITIET_CHUYENBAY.MANV, HOTENNV, DIACHI

--4
select top 1 pc.MAPC, pc.TENPHICO,COUNT(ct_cb.MACB) as SOLANBAY
from PHICO pc, CHUYENBAY cb,CHITIET_CHUYENBAY ct_cb
where cb.MACB=ct_cb.MACB
AND cb.MAPC=pc.MAPC
AND YEAR(GIOXP)=2019
group by pc.MAPC, pc.TENPHICO 
order by SOLANBAY DESC

--6
select * from PHICO 
where MAPC not in 
(
	select MAPC from CHITIET_CHUYENBAY, CHUYENBAY
	where CHITIET_CHUYENBAY.MACB = CHUYENBAY.MACB and year(GioXp) = 2012
)

--4
select CHUYENBAY.MAPC, TENPHICO from CHUYENBAY
join PHICO on CHUYENBAY.MAPC = PHICO.MAPC
