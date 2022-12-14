USE [master]
GO
/****** Object:  Database [Gwen]    Script Date: 11/22/2022 9:50:12 PM ******/
CREATE DATABASE [Gwen]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Gwen', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Gwen.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Gwen_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Gwen_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Gwen] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Gwen].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Gwen] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Gwen] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Gwen] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Gwen] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Gwen] SET ARITHABORT OFF 
GO
ALTER DATABASE [Gwen] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Gwen] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Gwen] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Gwen] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Gwen] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Gwen] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Gwen] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Gwen] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Gwen] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Gwen] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Gwen] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Gwen] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Gwen] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Gwen] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Gwen] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Gwen] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Gwen] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Gwen] SET RECOVERY FULL 
GO
ALTER DATABASE [Gwen] SET  MULTI_USER 
GO
ALTER DATABASE [Gwen] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Gwen] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Gwen] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Gwen] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Gwen] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Gwen] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Gwen', N'ON'
GO
ALTER DATABASE [Gwen] SET QUERY_STORE = OFF
GO
USE [Gwen]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_kt_hoanthanhHD]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_kt_hoanthanhHD]
(
    @HD_id INT
)
RETURNS bit
AS
BEGIN
    IF (select COUNT(xn.baocao_id) 
	from XacNhanPC xn join PhanCong pc on xn.PC_id = pc.PC_id 
	where xn.kq=1 and pc.HD_id =@HD_id) = (select COUNT(PC_id)
	from HoaDon hd join PhanCong pc on hd.HD_id = pc.HD_id
	where hd.HD_id = @HD_id)
	BEGIN
		RETURN 1
	END
	RETURN 0
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_tinhtien_sp]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_tinhtien_sp]
(
    @SP_id INT,
    @soluong INT
)
RETURNS INT
AS
BEGIN
    DECLARE @gia INT
    SELECT @gia = gia FROM SanPham WHERE SP_id = @SP_id
    RETURN @gia * @soluong
END
GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[HD_id] [int] IDENTITY(1,1) NOT NULL,
	[tenKH] [nvarchar](50) NOT NULL,
	[SDT_KH] [varchar](10) NOT NULL,
	[QL_id] [int] NOT NULL,
	[mota] [nvarchar](max) NULL,
	[tongtien] [int] NULL,
	[ngaytao] [datetime] NOT NULL,
	[ngaygiao] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[HD_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhanCong]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhanCong](
	[PC_id] [int] IDENTITY(1,1) NOT NULL,
	[HD_id] [int] NOT NULL,
	[QL_id] [int] NOT NULL,
	[NV_id] [int] NOT NULL,
	[mota] [nvarchar](max) NULL,
	[trangthai] [bit] NOT NULL,
	[ngaytao] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PC_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_load_hd_chuapc]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_load_hd_chuapc]
AS
SELECT        HD_id, tenKH, SDT_KH, QL_id, mota, tongtien, ngaytao, ngaygiao
FROM            dbo.HoaDon
WHERE        (NOT EXISTS
                             (SELECT        PC_id, HD_id, QL_id, NV_id, mota, trangthai, ngaytao
                               FROM            dbo.PhanCong
                               WHERE        (HD_id = dbo.HoaDon.HD_id)))
GO
/****** Object:  View [dbo].[vw_load_hd_dapc]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_load_hd_dapc]
AS
SELECT        HD_id, tenKH, SDT_KH, QL_id, mota, tongtien, ngaytao, ngaygiao
FROM            dbo.HoaDon
WHERE        EXISTS
                             (SELECT        PC_id, HD_id, QL_id, NV_id, mota, trangthai, ngaytao
                               FROM            dbo.PhanCong
                               WHERE        (HD_id = dbo.HoaDon.HD_id)) AND (ngaygiao IS NULL)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_pcBy_HD_id]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_pcBy_HD_id]
(
    @HD_id INT
)
RETURNS TABLE
AS
return
(
    SELECT *
	FROM PhanCong
	where PhanCong.HD_id = @HD_id
)
GO
/****** Object:  View [dbo].[vw_load_hd_chogiao]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* HOÁ ĐƠN*/
CREATE VIEW [dbo].[vw_load_hd_chogiao]
AS
SELECT        HD_id, tenKH, SDT_KH, QL_id, mota, tongtien, ngaytao, ngaygiao
FROM            dbo.HoaDon
WHERE        (dbo.fn_kt_hoanthanhHD(HD_id) = 1) AND (ngaygiao IS NULL)
GO
/****** Object:  View [dbo].[vw_load_hd_dagiao]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- HOÁ ĐƠN
CREATE VIEW [dbo].[vw_load_hd_dagiao]
AS
SELECT * FROM HoaDon
where ngaygiao is not null
GO
/****** Object:  View [dbo].[vw_load_HD_id]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- HOÁ ĐƠN
CREATE VIEW [dbo].[vw_load_HD_id]
AS
select HD_id from HoaDon
GO
/****** Object:  Table [dbo].[TaiKhoan]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaiKhoan](
	[TK_id] [int] IDENTITY(1,1) NOT NULL,
	[tenTK] [varchar](50) NOT NULL,
	[MK] [varchar](50) NOT NULL,
	[hoten] [nvarchar](50) NOT NULL,
	[gioitinh] [bit] NOT NULL,
	[ngaysinh] [date] NOT NULL,
	[SDT] [varchar](10) NULL,
	[diachi] [nvarchar](50) NULL,
	[email] [varchar](50) NULL,
	[chucvu] [varchar](2) NOT NULL,
	[nghiviec] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TK_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[tenTK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_load_TK_QL]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- HOÁ ĐƠN
CREATE VIEW [dbo].[vw_load_TK_QL]
AS
select TK_id,hoten from TaiKhoan
where chucvu='QL'and nghiviec = 0
GO
/****** Object:  View [dbo].[vw_load_TK_NV]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- HOÁ ĐƠN
CREATE VIEW [dbo].[vw_load_TK_NV]
AS
select TK_id,hoten from TaiKhoan
where chucvu='NV' and nghiviec = 0
GO
/****** Object:  UserDefinedFunction [dbo].[fn_pcBy_NV_id]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_pcBy_NV_id]
(
    @NV_id INT
)
RETURNS TABLE
AS
return
(
    SELECT *
	FROM PhanCong
	where PhanCong.NV_id = @NV_id
)
GO
/****** Object:  Table [dbo].[XacNhanPC]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XacNhanPC](
	[baocao_id] [int] IDENTITY(1,1) NOT NULL,
	[PC_id] [int] NOT NULL,
	[QL_id] [int] NOT NULL,
	[kq] [bit] NOT NULL,
	[LoiNhan] [nvarchar](max) NOT NULL,
	[ngaytao] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[baocao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_xnBy_PC_id]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- xem phân công theo NV_id
create FUNCTION [dbo].[fn_xnBy_PC_id]
(
    @PC_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM XacNhanPC
    WHERE PC_id = @PC_id
)
GO
/****** Object:  Table [dbo].[ChiTietHD]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietHD](
	[CTHD_id] [int] IDENTITY(1,1) NOT NULL,
	[HD_id] [int] NOT NULL,
	[SP_id] [int] NOT NULL,
	[soluong] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CTHD_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SanPham]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SanPham](
	[SP_id] [int] IDENTITY(1,1) NOT NULL,
	[tenSP] [nvarchar](50) NOT NULL,
	[mota] [nvarchar](max) NOT NULL,
	[anh] [image] NULL,
	[gia] [int] NOT NULL,
	[xoa] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SP_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_vw_cthd]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--xem chi tiết hóa đơn theo HD_id
CREATE FUNCTION [dbo].[fn_vw_cthd]
(
    @HD_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT cthd.CTHD_id, sp.tenSP, sp.gia, cthd.soluong, cthd.soluong * sp.gia AS thanhtien
    FROM ChiTietHD AS cthd JOIN SanPham AS sp ON cthd.SP_id = sp.SP_id
    WHERE cthd.HD_id = @HD_id
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_vw_hddagiao]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--xem hóa đơn đã giao
CREATE FUNCTION [dbo].[fn_vw_hddagiao]
(
    @HD_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM HoaDon 
    WHERE ngaygiao != NULL AND HD_id = @HD_id
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_vw_hdchuagiao]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--xem hóa đơn chưa giao
CREATE FUNCTION [dbo].[fn_vw_hdchuagiao]
(
    @HD_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM HoaDon 
    WHERE ngaygiao = NULL AND HD_id = @HD_id
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_vw_baocao_pc]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- xem các báo các của phân công
CREATE FUNCTION [dbo].[fn_vw_baocao_pc]
(
    @PC_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM XacNhanPC
    WHERE PC_id = @PC_id
)
GO
/****** Object:  View [dbo].[vw_load_TaiKhoan]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- TÀI KHOẢN
CREATE VIEW [dbo].[vw_load_TaiKhoan] AS
SELECT * FROM TaiKhoan
GO
/****** Object:  View [dbo].[vw_load_hoadon_tt]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- HOÁ ĐƠN
CREATE VIEW [dbo].[vw_load_hoadon_tt] AS
SELECT * FROM HoaDon
GO
/****** Object:  View [dbo].[vw_load_sanpham]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* SẢN PHẨM*/
CREATE VIEW [dbo].[vw_load_sanpham]
AS
SELECT        SP_id, tenSP, mota, anh, gia
FROM            dbo.SanPham
WHERE        (xoa = 0)
GO
/****** Object:  View [dbo].[vw_load_phancong]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- PHÂN CÔNG
CREATE VIEW [dbo].[vw_load_phancong] AS
SELECT * FROM PhanCong
GO
/****** Object:  View [dbo].[vw_load_id_ql]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_load_id_ql]
AS
SELECT        TK_id, hoten
FROM            dbo.TaiKhoan
WHERE        (chucvu = 'QL')
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT ((0)) FOR [tongtien]
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT (NULL) FOR [ngaygiao]
GO
ALTER TABLE [dbo].[PhanCong] ADD  CONSTRAINT [DF_PhanCong_trangthai]  DEFAULT ((0)) FOR [trangthai]
GO
ALTER TABLE [dbo].[SanPham] ADD  DEFAULT ((0)) FOR [xoa]
GO
ALTER TABLE [dbo].[TaiKhoan] ADD  DEFAULT ((0)) FOR [nghiviec]
GO
ALTER TABLE [dbo].[ChiTietHD]  WITH CHECK ADD FOREIGN KEY([HD_id])
REFERENCES [dbo].[HoaDon] ([HD_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PhanCong]  WITH CHECK ADD FOREIGN KEY([HD_id])
REFERENCES [dbo].[HoaDon] ([HD_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[XacNhanPC]  WITH CHECK ADD FOREIGN KEY([PC_id])
REFERENCES [dbo].[PhanCong] ([PC_id])
ON DELETE CASCADE
GO
/****** Object:  StoredProcedure [dbo].[sp_check_login]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_check_login]
@tenTK VARCHAR(50),@MK VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM TaiKhoan
    WHERE TenTK = @tenTK AND MK = @MK
END
GO
/****** Object:  StoredProcedure [dbo].[sp_phancongcongviec]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- PHÂN CÔNG
CREATE PROCEDURE [dbo].[sp_phancongcongviec]
@HD_id INT,@QL_id INT,@NV_id INT,@mota nvarchar(max),@ngaytao DATETIME
AS
BEGIN
INSERT INTO PhanCong(HD_id,QL_id,NV_id,mota,ngaytao) VALUES(@HD_id,@QL_id,@NV_id,@mota,@ngaytao)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_suacthd]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_suacthd]
@CTHD_id INT,@SP_id INT,@soluong INT
AS
BEGIN
UPDATE ChiTietHD SET SP_id=@SP_id,soluong=@soluong WHERE CTHD_id=@CTHD_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_suahd]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_suahd]
@HD_id INT,@tenKH NVARCHAR(50),@SDT_KH VARCHAR(10),@mota nvarchar(max)
AS
BEGIN
UPDATE HoaDon SET tenKH=@tenKH,SDT_KH=@SDT_KH,mota=@mota WHERE HD_id=@HD_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_suaphancong]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_suaphancong]
@PC_id INT,@NV_id INT,@mota nvarchar(max)
AS
BEGIN
UPDATE PhanCong SET NV_id=@NV_id,mota=@mota WHERE PC_id=@PC_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_suasp]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_suasp]
@SP_id INT,@tenSP NVARCHAR(50),@mota nvarchar(max),@anh IMAGE,@gia INT
AS
BEGIN
UPDATE SanPham SET tenSP=@tenSP,mota=@mota,anh=@anh,gia=@gia WHERE SP_id=@SP_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_suatk_chucvu]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_suatk_chucvu]
@TK_id INT,@chucvu VARCHAR(2)
AS
BEGIN
UPDATE TaiKhoan SET chucvu=@chucvu WHERE TK_id=@TK_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_suatk_MK]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_suatk_MK]
@TK_id INT,@MK VARCHAR(50)
AS
BEGIN
UPDATE TaiKhoan SET MK=@MK WHERE TK_id=@TK_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_suatk_thongtincanhan]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_suatk_thongtincanhan]
@TK_id INT,@hoten NVARCHAR(50),@gioitinh BIT,@ngaysinh DATE,@SDT VARCHAR(10),@diachi NVARCHAR(50),@email VARCHAR(50)
AS
BEGIN
UPDATE TaiKhoan SET hoten=@hoten,gioitinh=@gioitinh,ngaysinh=@ngaysinh,SDT=@SDT,diachi=@diachi,email=@email WHERE TK_id=@TK_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_themcthd]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- CHI TIẾT HÓA ĐƠN
CREATE PROCEDURE [dbo].[sp_themcthd]
@HD_id INT,@SP_id INT,@soluong INT
AS
BEGIN
INSERT INTO ChiTietHD(HD_id,SP_id,soluong) VALUES(@HD_id,@SP_id,@soluong)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_themhd]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- HÓA ĐƠN
CREATE PROCEDURE [dbo].[sp_themhd]
@tenKH NVARCHAR(50),@SDT_KH VARCHAR(10),@QL_id int,@mota nvarchar(max),@ngaytao DATETIME
AS
BEGIN
INSERT INTO HoaDon(tenKH,SDT_KH,QL_id,mota,ngaytao) VALUES(@tenKH,@SDT_KH,@QL_id,@mota,@ngaytao)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_themsp]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- SẢN PHẨM
CREATE PROCEDURE [dbo].[sp_themsp]
@tenSP NVARCHAR(50),@mota nvarchar(max),@anh IMAGE,@gia INT
AS
BEGIN
INSERT INTO SanPham(tenSP,mota,anh,gia) VALUES(@tenSP,@mota,@anh,@gia)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_themtk]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- TÀI KHOẢN
CREATE PROCEDURE [dbo].[sp_themtk]
@tenTK VARCHAR(50),@MK VARCHAR(50),@hoten NVARCHAR(50),@gioitinh BIT,@ngaysinh DATE,@SDT VARCHAR(10),@diachi NVARCHAR(50),@email VARCHAR(50),@chucvu VARCHAR(2)
AS
BEGIN
INSERT INTO TaiKhoan(tenTK,MK,hoten,gioitinh,ngaysinh,SDT,diachi,email,chucvu) VALUES(@tenTK,@MK,@hoten,@gioitinh,@ngaysinh,@SDT,@diachi,@email,@chucvu)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_xacnhanCV_hoanthanh]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- PHÂN CÔNG
CREATE PROCEDURE [dbo].[sp_xacnhanCV_hoanthanh]
@PC_id int
AS
BEGIN
UPDATE PhanCong SET trangthai=1 WHERE PC_id = @PC_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XacNhanPC_hoanthanh]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_XacNhanPC_hoanthanh]
@HD_id INT,@ngaygiao DATETIME
AS
BEGIN
UPDATE HoaDon SET ngaygiao=@ngaygiao WHERE HD_id=@HD_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XacNhanPC_kiemtra]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- KIỂM TRA HÓA ĐƠN
CREATE PROCEDURE [dbo].[sp_XacNhanPC_kiemtra]
@PC_id INT,@QL_id INT,@kq BIT,@LoiNhan nvarchar(max),@ngaytao DATETIME
AS
BEGIN
INSERT INTO XacNhanPC(PC_id,QL_id,kq,LoiNhan,ngaytao) VALUES(@PC_id,@QL_id,@kq,@LoiNhan,@ngaytao)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_xoacthd]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_xoacthd]
@CTHD_id INT
AS
BEGIN
DELETE FROM ChiTietHD WHERE CTHD_id=@CTHD_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_xoahd]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_xoahd]
@HD_id INT
AS
BEGIN
DELETE FROM HoaDon WHERE HD_id=@HD_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_xoaphancong]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_xoaphancong]
@PC_id INT
AS
BEGIN
DELETE FROM PhanCong WHERE PC_id=@PC_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_xoasp]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_xoasp]
@SP_id INT
AS
BEGIN
DELETE FROM SanPham WHERE SP_id=@SP_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_xoatk]    Script Date: 11/22/2022 9:50:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_xoatk]
@TK_id INT
AS
BEGIN
DELETE FROM TaiKhoan WHERE TK_id=@TK_id
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "HoaDon"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_hd_chogiao'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_hd_chogiao'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "HoaDon"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_hd_chuapc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_hd_chuapc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "HoaDon"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_hd_dapc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_hd_dapc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TaiKhoan"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 1470
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_id_ql'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_id_ql'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SanPham"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_sanpham'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_load_sanpham'
GO
USE [master]
GO
ALTER DATABASE [Gwen] SET  READ_WRITE 
GO
