-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 20, 2025 lúc 06:57 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `vuadocau`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `activity_log`
--

CREATE TABLE `activity_log` (
  `Id` bigint(20) NOT NULL,
  `UserId` int(11) NOT NULL,
  `Type` varchar(50) NOT NULL,
  `Message` varchar(255) NOT NULL,
  `Meta` text DEFAULT NULL,
  `IP` varchar(45) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `activity_log`
--

INSERT INTO `activity_log` (`Id`, `UserId`, `Type`, `Message`, `Meta`, `IP`, `CreatedAt`) VALUES
(234, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=31', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 09:22:39'),
(235, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 09:22:41'),
(236, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=31', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 10:14:44'),
(237, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 10:14:45'),
(238, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=31', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 10:54:05'),
(239, 1, 'PRODUCT_CREATE', 'Thêm SP: testnews', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 10:54:54'),
(240, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 10:54:54'),
(241, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:18:40'),
(242, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:18:44'),
(243, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:18:49'),
(244, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'price\', dir=\'asc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:18:51'),
(245, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'price\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:18:51'),
(246, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:19:01'),
(247, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:19:09'),
(248, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'price\', dir=\'asc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:19:11'),
(249, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'price\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:19:12'),
(250, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:20:17'),
(251, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:20:20'),
(252, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:20:21'),
(253, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:20:23'),
(254, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:21:46'),
(255, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:49:29'),
(256, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:49:30'),
(257, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:50:15'),
(258, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:51:16'),
(259, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:51:37'),
(260, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:51:38'),
(261, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:51:42'),
(262, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:51:47'),
(263, 1, 'PRODUCT_UPDATE', 'Cập nhật SP: testnews', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:51:54'),
(264, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:51:54'),
(265, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=32', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:51:59'),
(266, 1, 'PRODUCT_CREATE', 'Thêm SP: tesstokuma', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:52:59'),
(267, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 11:52:59'),
(268, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:15:51'),
(269, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:15:52'),
(270, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:16:16'),
(271, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:16:18'),
(272, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:16:39'),
(273, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:16:49'),
(274, 1, 'PRODUCT_UPDATE', 'Cập nhật SP: tesstokuma', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:17:07'),
(275, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:17:07'),
(276, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:17:12'),
(277, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:49:05'),
(278, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:49:06'),
(279, 1, 'USER_LIST', 'Lọc user: q=\'\', role=null, status=null, sort=\'id\', dir=\'desc\', count=3', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:49:08'),
(280, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:49:09'),
(281, 1, 'PRODUCT_LIST', 'Lọc sản phẩm: q=\'\', cat=null, sort=\'id\', dir=\'desc\', count=33', NULL, '0:0:0:0:0:0:0:1', '2025-11-20 12:49:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietdh`
--

CREATE TABLE `chitietdh` (
  `MaDH` bigint(20) NOT NULL,
  `MaSP` int(11) NOT NULL,
  `SoLuong` int(11) NOT NULL CHECK (`SoLuong` > 0),
  `Gia` decimal(12,2) NOT NULL CHECK (`Gia` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietdh`
--

INSERT INTO `chitietdh` (`MaDH`, `MaSP`, `SoLuong`, `Gia`) VALUES
(2, 28, 2, 55000.00),
(4, 15, 2, 1750000.00),
(5, 29, 1, 120000.00),
(8, 21, 4, 2450000.00),
(9, 15, 4, 1750000.00),
(11, 29, 1, 120000.00),
(12, 16, 1, 1590000.00),
(13, 15, 1, 1750000.00),
(14, 15, 1, 1750000.00),
(15, 15, 1, 1750000.00),
(16, 15, 1, 1750000.00),
(17, 15, 1, 1750000.00),
(31, 31, 1, 9900000.00),
(32, 31, 1, 9900000.00),
(33, 31, 1, 9900000.00),
(34, 31, 1, 9900000.00),
(35, 31, 1, 9900000.00),
(36, 18, 1, 1850000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhmuc`
--

CREATE TABLE `danhmuc` (
  `MaDM` int(11) NOT NULL,
  `TenDM` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `danhmuc`
--

INSERT INTO `danhmuc` (`MaDM`, `TenDM`) VALUES
(1, 'Cần câu'),
(3, 'Dây'),
(2, 'Máy câu'),
(4, 'Mồi câu'),
(5, 'Phụ kiện');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `donhang`
--

CREATE TABLE `donhang` (
  `MaDH` bigint(20) NOT NULL,
  `MaND` int(11) NOT NULL,
  `NgayDH` datetime DEFAULT current_timestamp(),
  `TrangThai` enum('NEW','CONFIRMED','SHIPPING','DONE','CANCELED') NOT NULL,
  `GhiChu` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `donhang`
--

INSERT INTO `donhang` (`MaDH`, `MaND`, `NgayDH`, `TrangThai`, `GhiChu`) VALUES
(2, 3, '2025-10-31 09:42:39', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: áda'),
(4, 3, '2025-11-08 13:40:51', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: test'),
(5, 3, '2025-11-08 15:32:25', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: ádasd'),
(8, 3, '2025-11-10 11:21:01', 'DONE', 'Tên: SơnTesst | SDT: 0123456789 | Email: thson1602@gmail.com | Địa chỉ: hn | Note: gay'),
(9, 3, '2025-11-10 16:43:18', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: xzc'),
(11, 3, '2025-11-12 23:11:48', 'CANCELED', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: tsd'),
(12, 3, '2025-11-13 00:56:41', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: á'),
(13, 3, '2025-11-13 01:53:50', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: sa'),
(14, 3, '2025-11-14 07:21:52', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: Na Hang-Tuyên Quang'),
(15, 3, '2025-11-14 08:18:35', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: sss'),
(16, 3, '2025-11-14 08:35:52', 'DONE', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: á'),
(17, 3, '2025-11-14 08:49:40', 'CANCELED', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: '),
(31, 3, '2025-11-19 10:30:23', 'CANCELED', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: ÁDASDSDAASD'),
(32, 3, '2025-11-19 10:52:53', 'CANCELED', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: sádas'),
(33, 3, '2025-11-19 11:06:17', 'CANCELED', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: sadasfd | Note: àasf'),
(34, 3, '2025-11-19 11:06:54', 'CANCELED', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: sadsadasd'),
(35, 3, '2025-11-19 11:18:34', 'CANCELED', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: ừaefsdf'),
(36, 3, '2025-11-20 11:17:05', 'CANCELED', 'Tên: SơnTesst | SDT: 0886214922 | Email: thson1602@gmail.com | Địa chỉ: Tổ 13 Thị Trấn Na Hang - Tuyên Quang | Note: adsadas');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguoidung`
--

CREATE TABLE `nguoidung` (
  `MaND` int(11) NOT NULL,
  `TenND` varchar(100) NOT NULL,
  `Email` varchar(150) NOT NULL,
  `Avatar` varchar(255) DEFAULT NULL,
  `MatKhau` varchar(255) NOT NULL,
  `RoleID` int(11) NOT NULL DEFAULT 2,
  `TrangThai` tinyint(1) NOT NULL DEFAULT 1,
  `NgayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `nguoidung`
--

INSERT INTO `nguoidung` (`MaND`, `TenND`, `Email`, `Avatar`, `MatKhau`, `RoleID`, `TrangThai`, `NgayTao`) VALUES
(1, 'Quản trị', 'admin@vuadocau.vn', 'avatar-admin.png', '38FE9AA0297FA5B1DC9EFBB6C0868F8C84FE24BE5C4A534B3E10A94D025029EA', 1, 1, '2025-10-25 13:28:44'),
(2, 'Khách A', 'user@vuadocau.vn', 'avatar-user.png', '206270D6BD289E17432993D79DA37FF3F28C61924085BFFFA77EC0BC137C1EBD', 2, 1, '2025-10-25 13:28:44'),
(3, 'SơnTesst', 'thson1602@gmail.com', 'avatar-user.png', 'AB690C343513E3555C510E808D98C14BF65305696502BF7D9888ECFD6A7B4447', 2, 1, '2025-10-25 16:12:42');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_review`
--

CREATE TABLE `product_review` (
  `Id` int(11) NOT NULL,
  `MaDH` bigint(20) NOT NULL,
  `MaSP` int(11) NOT NULL,
  `MaND` int(11) NOT NULL,
  `Stars` tinyint(4) NOT NULL CHECK (`Stars` between 1 and 5),
  `Comment` varchar(1000) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `review`
--

CREATE TABLE `review` (
  `Id` int(11) NOT NULL,
  `MaSP` int(11) NOT NULL,
  `MaND` int(11) NOT NULL,
  `Rating` tinyint(4) NOT NULL,
  `Comment` text DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `review`
--

INSERT INTO `review` (`Id`, `MaSP`, `MaND`, `Rating`, `Comment`, `CreatedAt`) VALUES
(1, 15, 3, 1, 'lỏ', '2025-11-17 23:11:56'),
(2, 18, 2, 4, 'dung duoc', '2025-11-14 09:45:47'),
(4, 15, 2, 4, 'ok', '2025-11-17 23:14:17'),
(5, 17, 3, 5, 'tot', '2025-11-18 12:53:29');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles`
--

CREATE TABLE `roles` (
  `RoleID` int(11) NOT NULL,
  `RoleName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`RoleID`, `RoleName`) VALUES
(1, 'ADMIN'),
(2, 'USER');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanpham`
--

CREATE TABLE `sanpham` (
  `MaSP` int(11) NOT NULL,
  `TenSP` varchar(200) NOT NULL,
  `MaDM` int(11) NOT NULL,
  `MaTH` int(11) DEFAULT NULL,
  `Gia` decimal(12,2) NOT NULL DEFAULT 0.00,
  `GiaCu` decimal(12,2) DEFAULT NULL,
  `Anh` varchar(255) DEFAULT NULL,
  `MoTa` text DEFAULT NULL,
  `TonKho` int(11) NOT NULL DEFAULT 0,
  `Rating` decimal(2,1) DEFAULT 0.0,
  `Purchased` int(11) DEFAULT 0,
  `TrangThai` tinyint(1) DEFAULT 1,
  `NgayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `sanpham`
--

INSERT INTO `sanpham` (`MaSP`, `TenSP`, `MaDM`, `MaTH`, `Gia`, `GiaCu`, `Anh`, `MoTa`, `TonKho`, `Rating`, `Purchased`, `TrangThai`, `NgayTao`) VALUES
(1, 'Cần Daiwa Crossfire 2.1m', 1, 2, 890000.00, 1075000.00, 'can-2.jpg', 'Cần câu phổ thông, độ cứng M', 20, 0.0, 0, 1, '2025-10-25 13:28:44'),
(2, 'Cần Shimano Sojourn 2.4m', 1, 1, 1790000.00, 1796000.00, 'can-4.jpg', 'Cần câu nước ngọt đa dụng', 10, 0.0, 0, 1, '2025-10-25 13:28:44'),
(3, 'Máy Daiwa Revros 2500', 2, 2, 1490000.00, 1707000.00, 'may-1.jpg', 'Máy câu êm, drag ổn định', 15, 0.0, 0, 1, '2025-10-25 13:28:44'),
(4, 'Máy Okuma Ceymar 1000', 2, 3, 990000.00, 1204000.00, 'may-0.jpg', 'Nhẹ, phù hợp lure nhẹ', 12, 0.0, 0, 1, '2025-10-25 13:28:44'),
(5, 'Dây PE 8X YGK 150m', 3, 4, 329000.00, 377000.00, 'day-1.jpg', 'Dây bện 8 lõi, bền', 50, 0.0, 0, 1, '2025-10-25 13:28:44'),
(6, 'Dây Fluorocarbon 100m', 3, NULL, 159000.00, 172000.00, 'day-2.jpg', 'Chìm nhanh, khó nhìn', 40, 0.0, 0, 1, '2025-10-25 13:28:44'),
(7, 'Mồi giả cá nhái Jump Frog', 4, NULL, 59000.00, 71000.00, 'moi-1.jpg', 'Hiệu quả săn hàng', 60, 0.0, 0, 1, '2025-10-25 13:28:44'),
(8, 'Lưỡi câu Mustad số 8', 5, 5, 49000.00, 52000.00, 'phukien-2.jpg', 'Lưỡi cứng, bền', 80, 0.0, 0, 1, '2025-10-25 13:28:44'),
(9, 'Kìm gỡ cá inox 15cm', 5, NULL, 99000.00, 113000.00, 'kimgo.jpg', 'Thép không gỉ, cầm chắc tay.', 35, 0.0, 0, 1, '2025-10-25 13:28:44'),
(10, 'Túi cần câu du lịch 1.2m', 5, NULL, 259000.00, 268000.00, 'phukien-1.jpg', 'Gấp gọn, tiện mang theo', 25, 0.0, 0, 1, '2025-10-25 13:28:44'),
(11, 'Hộp đựng mồi lure đa năng', 4, NULL, 129000.00, 130000.00, 'hopmoi.jpg', 'Nhiều ngăn, chống nước.', 30, 0.0, 0, 1, '2025-10-25 13:28:44'),
(12, 'Cần câu Shimano Vengeance 2m1', 1, NULL, 1250000.00, 1499000.00, 'can1.jpg', 'Cần carbon bền nhẹ, phù hợp câu cá nước ngọt.', 12, 0.0, 0, 1, '2025-10-25 14:27:42'),
(13, 'Cần câu Daiwa Sweepfire 2m4', 1, NULL, 1350000.00, 1636000.00, 'can2.jpg', 'Thân cần composite, tay cầm EVA chống trơn.', 9, 0.0, 1, 1, '2025-10-25 14:27:42'),
(14, 'Cần câu Sunfish Telescopic 2m7', 1, NULL, 890000.00, 1080000.00, 'can3.jpg', 'Cần rút gọn tiện lợi, thiết kế gọn nhẹ.', 15, 0.0, 0, 1, '2025-10-25 14:27:42'),
(15, 'Cần câu Shimano Scimitar 2m1', 1, NULL, 1750000.00, 2068000.00, 'can4.jpg', 'Cần carbon độ nảy cao, cảm giác tốt.', 0, 2.5, 16, 1, '2025-10-25 14:27:42'),
(16, 'Cần câu SeaKnight Rapid 2m4', 1, NULL, 1590000.00, 1617000.00, 'can5.jpg', 'Phù hợp cả nước ngọt và nước mặn.', 5, 0.0, 4, 1, '2025-10-25 14:27:42'),
(17, 'Cần tay Mitchel Travel 2m1', 1, NULL, 950000.00, 989000.00, 'can6.jpg', 'Nhỏ gọn, dễ mang đi du lịch.', 6, 5.0, 2, 1, '2025-10-25 14:27:42'),
(18, 'Cần Shimano Catana 2m7', 1, NULL, 1850000.00, 2133000.00, 'can7.jpg', 'Độ cứng M–MH, câu lóc/chẽm.', 3, 4.0, 15, 1, '2025-10-25 14:27:42'),
(19, 'Máy câu Shimano FX 2500HG', 2, NULL, 890000.00, 1018000.00, 'may1.jpg', 'Trục quay êm, bền, dùng cho cần trung.', 20, 0.0, 0, 1, '2025-10-25 14:27:42'),
(20, 'Máy Daiwa Crossfire 3000', 2, NULL, 1090000.00, 1098000.00, 'may2.jpg', 'Tỉ số truyền 5.3:1, phù hợp sông hồ.', 14, 0.0, 0, 1, '2025-10-25 14:27:42'),
(21, 'Máy Penn Battle III 4000', 2, NULL, 2450000.00, 2707000.00, 'may3.jpg', 'Thân kim loại toàn phần, mạnh mẽ.', 5, 0.0, 0, 1, '2025-10-25 14:27:42'),
(22, 'Máy Shimano Sahara 2500', 2, NULL, 1890000.00, 1897000.00, 'may4.jpg', 'Máy đa dụng, nhẹ và bền.', 10, 0.0, 0, 1, '2025-10-25 14:27:42'),
(23, 'Máy Okuma Ceymar 3000', 2, NULL, 990000.00, 1191000.00, 'may5.jpg', 'Giá tốt, vận hành mượt.', 13, 0.0, 0, 1, '2025-10-25 14:27:42'),
(24, 'Máy Abu Garcia BlackMax', 2, NULL, 1390000.00, 1398000.00, 'may6.jpg', 'Baitcasting cho cần ngang.', 9, 0.0, 0, 1, '2025-10-25 14:27:42'),
(25, 'Máy KastKing Sharky III', 2, NULL, 1650000.00, 1926000.00, 'may7.jpg', 'Chống nước, phù hợp câu biển.', 11, 0.0, 0, 1, '2025-10-25 14:27:42'),
(26, 'Dây PE 8 lõi Shimano 100m 1.5', 3, NULL, 230000.00, 246000.00, 'day1.jpg', 'Dây PE 8 lõi chịu tải cao.', 40, 0.0, 0, 1, '2025-10-25 14:27:42'),
(27, 'Mồi giả cá nhái Surface 7cm', 4, NULL, 45000.00, 50000.00, 'moi1.jpg', 'Mồi nổi dạng nhái, hiệu quả câu lóc.', 60, 0.0, 0, 1, '2025-10-25 14:27:42'),
(28, 'Mồi giả Minnow 9cm', 4, NULL, 55000.00, 55000.00, 'moi2.jpg', 'Mồi giả cá nhỏ, thích hợp câu sông.', 50, 0.0, 0, 1, '2025-10-25 14:27:42'),
(29, 'Phao câu cảm biến điện tử', 3, NULL, 120000.00, 139000.00, 'phao1.jpg', 'Tự động báo cắn, dùng được ban đêm.', 25, 0.0, 0, 1, '2025-10-25 14:27:42'),
(30, 'Hộp đồ câu đa năng 3 tầng', 5, NULL, 175000.00, 206000.00, 'phukien1.jpg', 'Chứa phụ kiện, mồi, chì, lưỡi.', 15, 0.0, 0, 1, '2025-10-25 14:27:42'),
(31, 'Lưỡi câu Mustad số 6 (100 cái)', 5, NULL, 9900000.00, 11524000.00, 'luoi1.jpg', 'Thép carbon cao cấp, chống gỉ.', 99, 0.0, 5, 1, '2025-10-25 14:27:42'),
(40, 'testnews', 5, 5, 99000.00, 100000.00, 'luoi1.jpg', 'tetestnews', 5, 0.0, 0, 1, '2025-11-20 10:54:54'),
(41, 'tesstokuma', 1, 3, 990000.00, 99000.00, 'luoi1.jpg', 'tesstokuma', 6, 0.0, 0, 1, '2025-11-20 11:52:59');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanpham_backup_reset`
--

CREATE TABLE `sanpham_backup_reset` (
  `MaSP` int(11) NOT NULL DEFAULT 0,
  `TenSP` varchar(200) NOT NULL,
  `MaDM` int(11) NOT NULL,
  `MaTH` int(11) DEFAULT NULL,
  `Gia` decimal(12,2) NOT NULL DEFAULT 0.00,
  `GiaCu` decimal(12,2) DEFAULT NULL,
  `Anh` varchar(255) DEFAULT NULL,
  `MoTa` text DEFAULT NULL,
  `TonKho` int(11) NOT NULL DEFAULT 0,
  `Rating` decimal(2,1) DEFAULT 0.0,
  `Purchased` int(11) DEFAULT 0,
  `TrangThai` tinyint(1) DEFAULT 1,
  `NgayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `sanpham_backup_reset`
--

INSERT INTO `sanpham_backup_reset` (`MaSP`, `TenSP`, `MaDM`, `MaTH`, `Gia`, `GiaCu`, `Anh`, `MoTa`, `TonKho`, `Rating`, `Purchased`, `TrangThai`, `NgayTao`) VALUES
(1, 'Cần Daiwa Crossfire 2.1m', 1, 2, 890000.00, 1075000.00, 'can-2.jpg', 'Cần câu phổ thông, độ cứng M', 20, 4.0, 0, 1, '2025-10-25 13:28:44'),
(2, 'Cần Shimano Sojourn 2.4m', 1, 1, 1790000.00, 1796000.00, 'can-4.jpg', 'Cần câu nước ngọt đa dụng', 10, 4.2, 0, 1, '2025-10-25 13:28:44'),
(3, 'Máy Daiwa Revros 2500', 2, 2, 1490000.00, 1707000.00, 'may-1.jpg', 'Máy câu êm, drag ổn định', 15, 4.6, 0, 1, '2025-10-25 13:28:44'),
(4, 'Máy Okuma Ceymar 1000', 2, 3, 990000.00, 1204000.00, 'may-0.jpg', 'Nhẹ, phù hợp lure nhẹ', 12, 4.7, 0, 1, '2025-10-25 13:28:44'),
(5, 'Dây PE 8X YGK 150m', 3, 4, 329000.00, 377000.00, 'day-1.jpg', 'Dây bện 8 lõi, bền', 50, 4.8, 0, 1, '2025-10-25 13:28:44'),
(6, 'Dây Fluorocarbon 100m', 3, NULL, 159000.00, 172000.00, 'day-2.jpg', 'Chìm nhanh, khó nhìn', 40, 4.4, 0, 1, '2025-10-25 13:28:44'),
(7, 'Mồi giả cá nhái Jump Frog', 4, NULL, 59000.00, 71000.00, 'moi-1.jpg', 'Hiệu quả săn hàng', 60, 4.1, 0, 1, '2025-10-25 13:28:44'),
(8, 'Lưỡi câu Mustad số 8', 5, 5, 49000.00, 52000.00, 'phukien-2.jpg', 'Lưỡi cứng, bền', 80, 4.5, 2, 1, '2025-10-25 13:28:44'),
(9, 'Kìm gỡ cá inox 15cm', 5, NULL, 99000.00, 113000.00, 'kimgo.jpg', 'Thép không gỉ, cầm chắc tay.', 35, 4.6, 12, 1, '2025-10-25 13:28:44'),
(10, 'Túi cần câu du lịch 1.2m', 5, NULL, 259000.00, 268000.00, 'phukien-1.jpg', 'Gấp gọn, tiện mang theo', 25, 4.0, 2, 1, '2025-10-25 13:28:44'),
(11, 'Hộp đựng mồi lure đa năng', 4, NULL, 129000.00, 130000.00, 'hopmoi.jpg', 'Nhiều ngăn, chống nước.', 30, 4.2, 11, 1, '2025-10-25 13:28:44'),
(12, 'Cần câu Shimano Vengeance 2m1', 1, NULL, 1250000.00, 1499000.00, 'can1.jpg', 'Cần carbon bền nhẹ, phù hợp câu cá nước ngọt.', 12, 4.3, 5, 1, '2025-10-25 14:27:42'),
(13, 'Cần câu Daiwa Sweepfire 2m4', 1, NULL, 1350000.00, 1636000.00, 'can2.jpg', 'Thân cần composite, tay cầm EVA chống trơn.', 10, 4.2, 4, 1, '2025-10-25 14:27:42'),
(14, 'Cần câu Sunfish Telescopic 2m7', 1, NULL, 890000.00, 1080000.00, 'can3.jpg', 'Cần rút gọn tiện lợi, thiết kế gọn nhẹ.', 15, 4.0, 3, 1, '2025-10-25 14:27:42'),
(15, 'Cần câu Shimano Scimitar 2m1', 1, NULL, 1750000.00, 2068000.00, 'can4.jpg', 'Cần carbon độ nảy cao, cảm giác tốt.', 8, 4.5, 6, 1, '2025-10-25 14:27:42'),
(16, 'Cần câu SeaKnight Rapid 2m4', 1, NULL, 1590000.00, 1617000.00, 'can5.jpg', 'Phù hợp cả nước ngọt và nước mặn.', 9, 4.4, 2, 1, '2025-10-25 14:27:42'),
(17, 'Cần tay Mitchel Travel 2m1', 1, NULL, 950000.00, 989000.00, 'can6.jpg', 'Nhỏ gọn, dễ mang đi du lịch.', 7, 4.1, 1, 1, '2025-10-25 14:27:42'),
(18, 'Cần Shimano Catana 2m7', 1, NULL, 1850000.00, 2133000.00, 'can7.jpg', 'Độ cứng M–MH, câu lóc/chẽm.', 10, 4.6, 3, 1, '2025-10-25 14:27:42'),
(19, 'Máy câu Shimano FX 2500HG', 2, NULL, 890000.00, 1018000.00, 'may1.jpg', 'Trục quay êm, bền, dùng cho cần trung.', 20, 4.4, 10, 1, '2025-10-25 14:27:42'),
(20, 'Máy Daiwa Crossfire 3000', 2, NULL, 1090000.00, 1098000.00, 'may2.jpg', 'Tỉ số truyền 5.3:1, phù hợp sông hồ.', 14, 4.3, 7, 1, '2025-10-25 14:27:42'),
(21, 'Máy Penn Battle III 4000', 2, NULL, 2450000.00, 2707000.00, 'may3.jpg', 'Thân kim loại toàn phần, mạnh mẽ.', 5, 4.7, 4, 1, '2025-10-25 14:27:42'),
(22, 'Máy Shimano Sahara 2500', 2, NULL, 1890000.00, 1897000.00, 'may4.jpg', 'Máy đa dụng, nhẹ và bền.', 10, 4.5, 6, 1, '2025-10-25 14:27:42'),
(23, 'Máy Okuma Ceymar 3000', 2, NULL, 990000.00, 1191000.00, 'may5.jpg', 'Giá tốt, vận hành mượt.', 13, 4.6, 12, 1, '2025-10-25 14:27:42'),
(24, 'Máy Abu Garcia BlackMax', 2, NULL, 1390000.00, 1398000.00, 'may6.jpg', 'Baitcasting cho cần ngang.', 9, 4.2, 5, 1, '2025-10-25 14:27:42'),
(25, 'Máy KastKing Sharky III', 2, NULL, 1650000.00, 1926000.00, 'may7.jpg', 'Chống nước, phù hợp câu biển.', 11, 4.4, 8, 1, '2025-10-25 14:27:42'),
(26, 'Dây PE 8 lõi Shimano 100m 1.5', 3, NULL, 230000.00, 246000.00, 'day1.jpg', 'Dây PE 8 lõi chịu tải cao.', 40, 4.6, 15, 1, '2025-10-25 14:27:42'),
(27, 'Mồi giả cá nhái Surface 7cm', 4, NULL, 45000.00, 50000.00, 'moi1.jpg', 'Mồi nổi dạng nhái, hiệu quả câu lóc.', 60, 4.1, 20, 1, '2025-10-25 14:27:42'),
(28, 'Mồi giả Minnow 9cm', 4, NULL, 55000.00, 55000.00, 'moi2.jpg', 'Mồi giả cá nhỏ, thích hợp câu sông.', 50, 4.2, 18, 1, '2025-10-25 14:27:42'),
(29, 'Phao câu cảm biến điện tử', 3, NULL, 120000.00, 139000.00, 'phao1.jpg', 'Tự động báo cắn, dùng được ban đêm.', 25, 4.0, 7, 1, '2025-10-25 14:27:42'),
(30, 'Hộp đồ câu đa năng 3 tầng', 5, NULL, 175000.00, 206000.00, 'phukien1.jpg', 'Chứa phụ kiện, mồi, chì, lưỡi.', 15, 4.3, 9, 1, '2025-10-25 14:27:42'),
(31, 'Lưỡi câu Mustad số 6 (100 cái)', 5, NULL, 9900000.00, 11524000.00, 'luoi1.jpg', 'Thép carbon cao cấp, chống gỉ.', 99, 4.5, 22, 1, '2025-10-25 14:27:42');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thuonghieu`
--

CREATE TABLE `thuonghieu` (
  `MaTH` int(11) NOT NULL,
  `TenTH` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `thuonghieu`
--

INSERT INTO `thuonghieu` (`MaTH`, `TenTH`) VALUES
(2, 'Daiwa'),
(5, 'Mustad'),
(3, 'Okuma'),
(1, 'Shimano'),
(4, 'YGK');

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `vw_thongke_sanpham`
-- (See below for the actual view)
--
CREATE TABLE `vw_thongke_sanpham` (
`MaSP` int(11)
,`TenSP` varchar(200)
,`DaBan` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Cấu trúc cho view `vw_thongke_sanpham`
--
DROP TABLE IF EXISTS `vw_thongke_sanpham`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_thongke_sanpham`  AS SELECT `sp`.`MaSP` AS `MaSP`, `sp`.`TenSP` AS `TenSP`, coalesce(sum(case when `dh`.`TrangThai` in ('CONFIRMED','SHIPPING','DONE') then `ct`.`SoLuong` else 0 end),0) AS `DaBan` FROM ((`sanpham` `sp` left join `chitietdh` `ct` on(`ct`.`MaSP` = `sp`.`MaSP`)) left join `donhang` `dh` on(`dh`.`MaDH` = `ct`.`MaDH`)) GROUP BY `sp`.`MaSP`, `sp`.`TenSP` ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `idx_activity_user_time` (`UserId`,`CreatedAt`);

--
-- Chỉ mục cho bảng `chitietdh`
--
ALTER TABLE `chitietdh`
  ADD PRIMARY KEY (`MaDH`,`MaSP`),
  ADD KEY `idx_ct_masp` (`MaSP`);

--
-- Chỉ mục cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  ADD PRIMARY KEY (`MaDM`),
  ADD UNIQUE KEY `TenDM` (`TenDM`);

--
-- Chỉ mục cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`MaDH`),
  ADD KEY `MaND` (`MaND`);

--
-- Chỉ mục cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD PRIMARY KEY (`MaND`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `RoleID` (`RoleID`);

--
-- Chỉ mục cho bảng `product_review`
--
ALTER TABLE `product_review`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `uq_review` (`MaDH`,`MaSP`,`MaND`),
  ADD KEY `idx_sp` (`MaSP`),
  ADD KEY `fk_pr_nd` (`MaND`);

--
-- Chỉ mục cho bảng `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `uq_review` (`MaSP`,`MaND`),
  ADD KEY `fk_review_user` (`MaND`);

--
-- Chỉ mục cho bảng `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`RoleID`),
  ADD UNIQUE KEY `RoleName` (`RoleName`);

--
-- Chỉ mục cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`MaSP`),
  ADD UNIQUE KEY `uq_sanpham_tensp` (`TenSP`),
  ADD KEY `idx_sp_tensp` (`TenSP`),
  ADD KEY `idx_sp_madm` (`MaDM`),
  ADD KEY `idx_sp_math` (`MaTH`);

--
-- Chỉ mục cho bảng `thuonghieu`
--
ALTER TABLE `thuonghieu`
  ADD PRIMARY KEY (`MaTH`),
  ADD UNIQUE KEY `TenTH` (`TenTH`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `Id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=282;

--
-- AUTO_INCREMENT cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  MODIFY `MaDM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `donhang`
--
ALTER TABLE `donhang`
  MODIFY `MaDH` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  MODIFY `MaND` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `product_review`
--
ALTER TABLE `product_review`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `review`
--
ALTER TABLE `review`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `roles`
--
ALTER TABLE `roles`
  MODIFY `RoleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  MODIFY `MaSP` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT cho bảng `thuonghieu`
--
ALTER TABLE `thuonghieu`
  MODIFY `MaTH` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `fk_activity_user` FOREIGN KEY (`UserId`) REFERENCES `nguoidung` (`MaND`);

--
-- Các ràng buộc cho bảng `chitietdh`
--
ALTER TABLE `chitietdh`
  ADD CONSTRAINT `chitietdh_ibfk_1` FOREIGN KEY (`MaDH`) REFERENCES `donhang` (`MaDH`) ON DELETE CASCADE,
  ADD CONSTRAINT `chitietdh_ibfk_2` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`);

--
-- Các ràng buộc cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`MaND`) REFERENCES `nguoidung` (`MaND`);

--
-- Các ràng buộc cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD CONSTRAINT `nguoidung_ibfk_1` FOREIGN KEY (`RoleID`) REFERENCES `roles` (`RoleID`);

--
-- Các ràng buộc cho bảng `product_review`
--
ALTER TABLE `product_review`
  ADD CONSTRAINT `fk_pr_dh` FOREIGN KEY (`MaDH`) REFERENCES `donhang` (`MaDH`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pr_nd` FOREIGN KEY (`MaND`) REFERENCES `nguoidung` (`MaND`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pr_sp` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `fk_review_product` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`),
  ADD CONSTRAINT `fk_review_user` FOREIGN KEY (`MaND`) REFERENCES `nguoidung` (`MaND`);

--
-- Các ràng buộc cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD CONSTRAINT `sanpham_ibfk_1` FOREIGN KEY (`MaDM`) REFERENCES `danhmuc` (`MaDM`),
  ADD CONSTRAINT `sanpham_ibfk_2` FOREIGN KEY (`MaTH`) REFERENCES `thuonghieu` (`MaTH`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
