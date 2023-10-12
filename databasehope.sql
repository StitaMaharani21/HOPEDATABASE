-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 12, 2023 at 04:33 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `databasehope`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `crowded_schedule` ()   BEGIN
	CREATE VIEW crowded_schedule AS
    SELECT month(pemesananpergi.Tanggal_Keberangkatan) AS Bulan, COUNT(month(pemesananpergi.Tanggal_Keberangkatan)) AS Crowded_Schedule
FROM pemesananpergi 
GROUP BY month(pemesananpergi.Tanggal_Keberangkatan)
ORDER BY (Crowded_Schedule) DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `notaHargatiket` ()   BEGIN
	SELECT DISTINCT pembayaran.Nomor_Pembayaran AS NomorBayar, customer.CustomerId, customer.NamaCustomer, customer.Email_Customer AS Email, customer.Nomor_Telepon_Customer AS Telepon, pembayaran.Metode_Pembayaran as PembayaranMelalui, pemesananpergi.Nomor_Transaksi_Pergi AS TiketPergi, pemesananpulang.Nomor_Transaksi_Pulang AS TiketPulang, (hargatiket.HargaTiket * 2) AS Total 
    FROM pemesananpergi, pemesananpulang, customer, hargatiket JOIN pembayaran
    WHERE pembayaran.hargaId = hargatiket.Idharga AND pembayaran.Customer_ID = customer.CustomerId AND pemesananpergi.Customer_ID = customer.CustomerId AND pemesananpulang.Nomor_Pergi = pemesananpergi.Nomor_Transaksi_Pergi AND pembayaran.Nomor_Pergi = pemesananpergi.Nomor_Transaksi_Pergi AND pembayaran.Nomor_Pulang = pemesananpulang.Nomor_Transaksi_Pulang;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profitpenjualan1` ()   BEGIN
	CREATE VIEW profitPenjualan AS
	SELECT SUM(HitungProfit(hargatiket.HargaTiket))
FROM hargatiket;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `HitungProfit` (`harga_tiket` INT) RETURNS INT(11)  BEGIN
    DECLARE profit INT;
    SET profit = (harga_tiket - (0.9*harga_tiket))*2;
    RETURN profit;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bandara`
--

CREATE TABLE `bandara` (
  `BandaraId` char(5) NOT NULL,
  `Nama_Bandara` varchar(50) NOT NULL,
  `Kota_Bandara` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bandara`
--

INSERT INTO `bandara` (`BandaraId`, `Nama_Bandara`, `Kota_Bandara`) VALUES
('BI001', 'Bandara Internasional Juanda', 'Sidoarjo'),
('BI002', 'Bandara Internasional Soekarno-Hatta', 'Tangerang'),
('BI003', 'Bandara Internasional Ngurah Rai', 'Denpasar'),
('BI004', 'Bandara Internasional Sultan Hasanuddin', 'Makassar'),
('BI005', 'Bandara Internasional Husein Sastranegara', 'Bandung'),
('BI006', 'Bandara Halim Perdanakusuma', 'Jakarta'),
('BI007', 'Bandara Internasional Syamsudin Noor', 'Banjar Baru'),
('BI008', 'Bandara Internasional Sultan Mahmud Badaruddin II', 'Palembang'),
('BI009', 'Bandara Internasional Kualanamu', 'Deli Serdang'),
('BI010', 'Bandara Internasional Komodo', 'Labuan Bajo');

-- --------------------------------------------------------

--
-- Stand-in structure for view `crowded_schedule`
-- (See below for the actual view)
--
CREATE TABLE `crowded_schedule` (
`Bulan` int(2)
,`Crowded_Schedule` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CustomerId` char(5) NOT NULL,
  `Profil_Customer` varchar(10) NOT NULL,
  `NIK` varchar(12) NOT NULL,
  `NamaCustomer` varchar(50) NOT NULL,
  `Gender_Customer` enum('Male','Female') DEFAULT NULL,
  `Tanggal_Lahir_Customer` date NOT NULL,
  `Nomor_Telepon_Customer` bigint(20) NOT NULL,
  `Email_Customer` varchar(50) NOT NULL,
  `Pass_Customer` varchar(8) NOT NULL,
  `Alamat_Customer` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`CustomerId`, `Profil_Customer`, `NIK`, `NamaCustomer`, `Gender_Customer`, `Tanggal_Lahir_Customer`, `Nomor_Telepon_Customer`, `Email_Customer`, `Pass_Customer`, `Alamat_Customer`) VALUES
('CU001', 'imgc1', '123456789012', 'Aurelius', 'Male', '2022-10-02', 82229164338, 'aurelius@gmail.com', '00000001', 'Jl. Wonerejo No.29 B'),
('CU002', 'imgc2', '123456789013', 'Tita', 'Female', '2022-10-03', 82145287612, 'tita@gmail.com', '00000002', 'Jl.Karang sari V No.24'),
('CU003', 'imgc3', '123456789014', 'Kezia', 'Female', '2022-10-04', 81216221733, 'kezia@gmail.com', '00000003', 'Jl. Jagir No.238'),
('CU004', 'imgc4', '123456789015', 'Angel', 'Female', '2022-10-05', 81365889012, 'angel@gmail.com', '00000004', 'Jl. Araya No. B37'),
('CU005', 'imgc5', '123456789016', 'Rafael', 'Male', '2022-10-06', 82156281162, 'rafael@gmail.com', '00000005', 'Jl. Melati Indah No.15'),
('CU006', 'imgc6', '123456789017', 'Pirelli', 'Female', '2022-10-07', 81245637288, 'pirelli@gmail.com', '00000006', 'Jl. Belimbing No.28'),
('CU007', 'imgc7', '123456789018', 'Fangeline', 'Female', '2022-10-08', 82416772201, 'fangeline@gmail.com', '00000007', 'Jl. Mekar Raya No.10'),
('CU008', 'imgc8', '123456789019', 'William', 'Male', '2022-10-09', 81266242412, 'william@gmail.com', '00000008', 'Jl. Kawi No.6'),
('CU009', 'imgc9', '123456789010', 'Andrew', 'Male', '2022-10-10', 81077332424, 'andrew@gmail.com', '00000009', 'Jl. Ahmad Yani No.4'),
('CU010', 'imgc10', '123456789011', 'Josesdio Dio', 'Male', '2022-10-11', 82145664422, 'josesdio@gmail.com', '00000010', 'Jl. Wonokromo No.8');

-- --------------------------------------------------------

--
-- Table structure for table `hargatiket`
--

CREATE TABLE `hargatiket` (
  `Idharga` char(5) NOT NULL,
  `MaskapaiId` char(5) NOT NULL,
  `KotaAsal` varchar(50) NOT NULL,
  `KotaTujuan` varchar(50) NOT NULL,
  `HargaTiket` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hargatiket`
--

INSERT INTO `hargatiket` (`Idharga`, `MaskapaiId`, `KotaAsal`, `KotaTujuan`, `HargaTiket`) VALUES
('HI001', 'MI001', 'Denpasar', 'Surabaya', 700000),
('HI002', 'MI001', 'Denpasar', 'Surabaya', 700000),
('HI003', 'MI001', 'Sidoarjo', 'Tangerang', 650000),
('HI004', 'MI001', 'Tangerang', 'Palembang', 800000),
('HI005', 'MI001', 'Palembang', 'Tangerang', 800000),
('HI006', 'MI001', 'Denpasar', 'Tangerang', 900000),
('HI007', 'MI001', 'Labuan Bajo', 'Banjar Baru', 750000),
('HI008', 'MI001', 'Tangerang', 'Palembang', 750000),
('HI009', 'MI001', 'Bandung', 'Jakarta', 500000),
('HI010', 'MI001', 'Makassar', 'Palembang', 750000),
('HI011', 'MI001', 'Palembang', 'Laboan Bajo', 900000);

-- --------------------------------------------------------

--
-- Table structure for table `kuliner`
--

CREATE TABLE `kuliner` (
  `KulinerId` varchar(10) NOT NULL,
  `Nama_Tempat_Kuliner` varchar(50) NOT NULL,
  `Alamat_Tempat_Kuliner` varchar(50) NOT NULL,
  `Nomor_Telepon_Kuliner` varchar(12) NOT NULL,
  `Foto_Lokasi_kuliner` varchar(10) NOT NULL,
  `Nomor_Pergi_Kuliner` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kuliner`
--

INSERT INTO `kuliner` (`KulinerId`, `Nama_Tempat_Kuliner`, `Alamat_Tempat_Kuliner`, `Nomor_Telepon_Kuliner`, `Foto_Lokasi_kuliner`, `Nomor_Pergi_Kuliner`) VALUES
('KI00000001', 'Rawon Gajah Mada', 'Jl. Gajah Mada', '085455221545', 'foto1', 'NP00000001'),
('KI00000002', 'Baso Aci Akang', 'Jl. Kisamaun', '082947510760', 'foto2', 'NP00000002'),
('KI00000003', 'Martabak Har', 'Jl. Bumi Sriwijaya', '081074020150', 'foto3', 'NP00000003'),
('KI00000004', 'Roti Nogat', 'Ruko Pasar Modern BSD', '08866128180', 'foto4', 'NP00000004'),
('KI00000005', 'Nasi Cumi Hitam Pak Kris', 'Ruko Paramount', '085455221545', 'foto5', 'NP00000005'),
('KI00000006', 'RM Swarga', 'Jl. A Yani Km 34', '08557871838', 'foto6', 'NP00000006'),
('KI00000007', 'Pempek Saga', 'Jl. Merdeka', '08212987176', 'foto7', 'NP00000007'),
('KI00000008', 'Mie Ayam Gondangdia', 'Jl. Cikini IV', '086886978363', 'foto8', 'NP00000008'),
('KI00000009', 'Mie celor 26', 'Jl. Ilir', '089342256234', 'foto9', 'NP00000009'),
('KI00000010', 'Ikan Kuah Asam Philemon', 'Kampung Ujung', '088137006929', 'foto10', 'NP00000010');

-- --------------------------------------------------------

--
-- Table structure for table `maskapai`
--

CREATE TABLE `maskapai` (
  `MaskapaiId` char(5) NOT NULL,
  `Nama_Maskapai` varchar(50) NOT NULL,
  `Email_Maskapai` varchar(50) NOT NULL,
  `Kelas_Penerbangan` enum('Ekonomi','Bisnis','First Class') NOT NULL,
  `Pesawat_ID` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `maskapai`
--

INSERT INTO `maskapai` (`MaskapaiId`, `Nama_Maskapai`, `Email_Maskapai`, `Kelas_Penerbangan`, `Pesawat_ID`) VALUES
('MI001', 'Batik Air', 'batikair@gmail.com', 'Ekonomi', 'PI001'),
('MI002', 'Batik Air', 'batikair@gmail.com', 'Bisnis', 'PI001'),
('MI003', 'Batik Air', 'batikair@gmail.com', 'First Class', 'PI001'),
('MI004', 'Lion Air', 'lionair@gmail.com', 'Ekonomi', 'PI002'),
('MI005', 'Lion Air', 'lionair@gmail.com', 'Bisnis', 'PI002'),
('MI006', 'Lion Air', 'lionair@gmail.com', 'First Class', 'PI002'),
('MI007', 'Garuda Indonesia', 'garudaind@gmail.com', 'Ekonomi', 'PI001'),
('MI008', 'Garuda Indonesia', 'garudaind@gmail.com', 'Bisnis', 'PI001'),
('MI009', 'Garuda Indonesia', 'garudaind@gmail.com', 'First Class', 'PI001'),
('MI010', 'Air Asia', 'Air Asia@gmail.com', 'Ekonomi', 'PI002');

-- --------------------------------------------------------

--
-- Table structure for table `pembatalan`
--

CREATE TABLE `pembatalan` (
  `PembatalanID` char(10) NOT NULL,
  `Status_Pembatalan` enum('Berhasil Batal','Tidak Berhasil Batal') NOT NULL,
  `Status_Refund` enum('Berhasil Refund','Tidak Berhasil Refund') NOT NULL,
  `Customer_ID` char(5) NOT NULL,
  `Nomor_Pulang` char(10) NOT NULL,
  `Nomor_Pergi` char(10) NOT NULL,
  `Nomor_Bayar` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pembatalan`
--

INSERT INTO `pembatalan` (`PembatalanID`, `Status_Pembatalan`, `Status_Refund`, `Customer_ID`, `Nomor_Pulang`, `Nomor_Pergi`, `Nomor_Bayar`) VALUES
('PI00000001', 'Berhasil Batal', 'Berhasil Refund', 'CI001', 'NL00000001', 'NP00000001', 'NB00000001'),
('PI00000002', 'Tidak Berhasil Batal', 'Tidak Berhasil Refund', 'CI002', 'NL00000002', 'NP00000002', 'NB00000002'),
('PI00000003', 'Berhasil Batal', 'Berhasil Refund', 'CI003', 'NL00000003', 'NP00000003', 'NB00000003'),
('PI00000004', 'Tidak Berhasil Batal', 'Tidak Berhasil Refund', 'CI004', 'NL00000004', 'NP00000004', 'NB00000004'),
('PI00000005', 'Tidak Berhasil Batal', 'Tidak Berhasil Refund', 'CI005', 'NL00000005', 'NP00000005', 'NB00000005'),
('PI00000006', 'Berhasil Batal', 'Berhasil Refund', 'CI006', 'NL00000006', 'NP00000006', 'NB00000006'),
('PI00000007', 'Berhasil Batal', 'Berhasil Refund', 'CI007', 'NL00000007', 'NP00000007', 'NB00000007'),
('PI00000008', 'Berhasil Batal', 'Berhasil Refund', 'CI008', 'NL00000008', 'NP00000008', 'NB00000008'),
('PI00000009', 'Berhasil Batal', 'Berhasil Refund', 'CI009', 'NL00000009', 'NP00000009', 'NB00000009'),
('PI00000010', 'Tidak Berhasil Batal', 'Tidak Berhasil Refund', 'CI010', 'NL00000004', 'NP00000010', 'NB00000010');

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `Nomor_Pembayaran` char(10) NOT NULL,
  `Metode_Pembayaran` enum('OVO','GoPay','Debit Card','Credit Card') NOT NULL,
  `Customer_ID` char(5) NOT NULL,
  `Nomor_Pergi` char(10) NOT NULL,
  `Nomor_Pulang` char(10) NOT NULL,
  `hargaId` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`Nomor_Pembayaran`, `Metode_Pembayaran`, `Customer_ID`, `Nomor_Pergi`, `Nomor_Pulang`, `hargaId`) VALUES
('NB00000001', 'OVO', 'CI001', 'NP00000001', 'NL00000001', 'HI001'),
('NB00000002', 'GoPay', 'CI002', 'NP00000002', 'NL00000002', 'HI002'),
('NB00000003', 'Debit Card', 'CI003', 'NP00000003', 'NL00000003', 'HI003'),
('NB00000004', 'OVO', 'CI004', 'NP00000004', 'NL00000004', 'HI004'),
('NB00000005', 'GoPay', 'CI005', 'NP00000005', 'NL00000005', 'HI005'),
('NB00000006', 'Debit Card', 'CI006', 'NP00000006', 'NL00000006', 'HI006'),
('NB00000007', 'Debit Card', 'CI007', 'NP00000007', 'NL00000007', 'HI007'),
('NB00000008', 'GoPay', 'CI008', 'NP00000008', 'NL00000008', 'HI008'),
('NB00000009', 'Credit Card', 'CI009', 'NP00000009', 'NL00000009', 'HI009'),
('NB00000010', 'Debit Card', 'CI010', 'NP00000010', 'NL00000010', 'HI010');

-- --------------------------------------------------------

--
-- Table structure for table `pemesananpergi`
--

CREATE TABLE `pemesananpergi` (
  `Nomor_Transaksi_Pergi` char(10) NOT NULL,
  `Kota_Asal` varchar(50) NOT NULL,
  `Kota_Tujuan` varchar(50) NOT NULL,
  `Tanggal_Keberangkatan` date NOT NULL,
  `Nomor_Kursi` varchar(3) NOT NULL,
  `Customer_ID` char(5) DEFAULT NULL,
  `Bandara_ID` char(5) DEFAULT NULL,
  `Maskapai_ID` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pemesananpergi`
--

INSERT INTO `pemesananpergi` (`Nomor_Transaksi_Pergi`, `Kota_Asal`, `Kota_Tujuan`, `Tanggal_Keberangkatan`, `Nomor_Kursi`, `Customer_ID`, `Bandara_ID`, `Maskapai_ID`) VALUES
('NP00000001', 'Denpasar', 'Surabaya', '2022-10-27', '1A', 'CI001', 'BI003', 'MI001'),
('NP00000002', 'Sidoarjo', 'Tangerang', '2022-11-10', '10D', 'CI002', 'BI001', 'MI001'),
('NP00000003', 'Tangerang', 'Palembang', '2022-11-08', '12A', 'CI003', 'BI002', 'MI001'),
('NP00000004', 'Palembang', 'Tangerang', '2022-12-09', '14B', 'CI004', 'BI006', 'MI001'),
('NP00000005', 'Denpasar', 'Tangerang', '2022-11-10', '12A', 'CI005', 'BI003', 'MI001'),
('NP00000006', 'Labuan Bajo', 'Banjar Baru', '2022-12-21', '12D', 'CI006', 'BI010', 'MI001'),
('NP00000007', 'Tangerang', 'Palembang', '2022-12-18', '10B', 'CI007', 'BI002', 'MI001'),
('NP00000008', 'Bandung', 'Jakarta', '2022-11-13', '9B', 'CI008', 'BI005', 'MI001'),
('NP00000009', 'Makassar', 'Palembang', '2022-12-08', '10B', 'CI009', 'BI004', 'MI001'),
('NP00000010', 'Palembang', 'Labuan Bajo', '2022-11-20', '2A', 'CI010', 'BI008', 'MI001');

-- --------------------------------------------------------

--
-- Table structure for table `pemesananpulang`
--

CREATE TABLE `pemesananpulang` (
  `Nomor_Transaksi_Pulang` char(10) NOT NULL,
  `Tanggal_Pulang` date NOT NULL,
  `Nomor_Kursi_Pulang` varchar(3) NOT NULL,
  `Nomor_Pergi` char(10) NOT NULL,
  `Bandara_ID` char(5) NOT NULL,
  `Maskapai_ID` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pemesananpulang`
--

INSERT INTO `pemesananpulang` (`Nomor_Transaksi_Pulang`, `Tanggal_Pulang`, `Nomor_Kursi_Pulang`, `Nomor_Pergi`, `Bandara_ID`, `Maskapai_ID`) VALUES
('NL00000001', '2022-10-31', '10D', 'NP00000001', 'BI010', 'MI001'),
('NL00000002', '2023-01-01', '1A', 'NP00000002', 'BI002', 'MI001'),
('NL00000003', '2023-01-02', '12B', 'NP00000003', 'BI008', 'MI001'),
('NL00000004', '2023-01-03', '6C', 'NP00000004', 'BI002', 'MI001'),
('NL00000005', '2023-01-04', '15B', 'NP00000005', 'BI002', 'MI001'),
('NL00000006', '2023-01-05', '14B', 'NP00000006', 'BI007', 'MI001'),
('NL00000007', '2023-01-06', '9A', 'NP00000007', 'BI008', 'MI001'),
('NL00000008', '2023-01-07', '8E', 'NP00000008', 'BI006', 'MI001'),
('NL00000009', '2023-01-08', '10D', 'NP00000009', 'BI008', 'MI001'),
('NL00000010', '2023-01-09', '16D', 'NP00000010', 'BI010', 'MI001');

-- --------------------------------------------------------

--
-- Stand-in structure for view `profitpenjualan`
-- (See below for the actual view)
--
CREATE TABLE `profitpenjualan` (
`SUM(HitungProfit(hargatiket.HargaTiket))` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Table structure for table `reschedule`
--

CREATE TABLE `reschedule` (
  `RescheduleID` varchar(10) NOT NULL,
  `Status_Reschedule` enum('Berhasil Reschedule','Tidak Berhasil Reschedule') NOT NULL,
  `Tanggal_Baru` date DEFAULT NULL,
  `Customer_ID` char(5) NOT NULL,
  `Nomor_Pulang` varchar(10) NOT NULL,
  `Nomor_Pergi` varchar(10) NOT NULL,
  `Nomor_Bayar` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `reschedule`
--

INSERT INTO `reschedule` (`RescheduleID`, `Status_Reschedule`, `Tanggal_Baru`, `Customer_ID`, `Nomor_Pulang`, `Nomor_Pergi`, `Nomor_Bayar`) VALUES
('RC00000001', 'Tidak Berhasil Reschedule', '2023-02-04', 'CI001', 'NL00000001', 'NP00000001', 'NB00000001'),
('RC00000002', 'Tidak Berhasil Reschedule', '2023-02-04', 'CI002', 'NL00000002', 'NP00000002', 'NB00000002'),
('RC00000003', 'Tidak Berhasil Reschedule', '2023-02-04', 'CI003', 'NL00000003', 'NP00000003', 'NB00000003'),
('RC00000004', 'Tidak Berhasil Reschedule', '2023-02-04', 'CI004', 'NL00000004', 'NP00000004', 'NB00000004'),
('RC00000005', 'Berhasil Reschedule', '2023-02-04', 'CI005', 'NL00000005', 'NP00000005', 'NB00000005'),
('RC00000006', 'Berhasil Reschedule', '2022-11-25', 'CI006', 'NL00000006', 'NP00000006', 'NB00000006'),
('RC00000007', 'Berhasil Reschedule', '2023-03-04', 'CI007', 'NL00000007', 'NP00000007', 'NB00000007'),
('RC00000008', 'Tidak Berhasil Reschedule', '2022-11-29', 'CI008', 'NL00000008', 'NP00000008', 'NB00000008'),
('RC00000009', 'Berhasil Reschedule', '2023-08-04', 'CI009', 'NL00000009', 'NP00000009', 'NB00000009'),
('RC00000010', 'Berhasil Reschedule', '2022-12-28', 'CI010', 'NL00000010', 'NP00000010', 'NB00000010');

-- --------------------------------------------------------

--
-- Table structure for table `tipe_pesawat`
--

CREATE TABLE `tipe_pesawat` (
  `PesawatId` char(5) NOT NULL,
  `Tipe_Pesawat` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tipe_pesawat`
--

INSERT INTO `tipe_pesawat` (`PesawatId`, `Tipe_Pesawat`) VALUES
('PI001', 'Boeing737'),
('PI002', 'Airbus_A320'),
('PI003', 'ATR72'),
('PI004', 'Boeing777'),
('PI005', 'Boeing787'),
('PI006', 'Boeing747'),
('PI007', 'Boeing707'),
('PI008', 'Airbus_A330'),
('PI009', 'Airbus_A310'),
('PI010', 'Airbus_A340');

-- --------------------------------------------------------

--
-- Table structure for table `wisata`
--

CREATE TABLE `wisata` (
  `WisataId` varchar(10) NOT NULL,
  `Nama_Tempat_Wisata` varchar(50) NOT NULL,
  `Alamat_Tempat_Wisata` varchar(50) NOT NULL,
  `Nomor_Telepon` varchar(12) NOT NULL,
  `Foto_Lokasi` varchar(10) NOT NULL,
  `Nomor_Pergi` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `wisata`
--

INSERT INTO `wisata` (`WisataId`, `Nama_Tempat_Wisata`, `Alamat_Tempat_Wisata`, `Nomor_Telepon`, `Foto_Lokasi`, `Nomor_Pergi`) VALUES
('WI00000001', 'Bahari Tlocor', 'Jl. Desa Tlocor', '081245362212', 'img1', 'NP00000001'),
('WI00000002', 'Benteng Heritage', 'Jalan Cilame', '081290902212', 'img2', 'NP00000002'),
('WI00000003', 'Pulo Kerto', 'Kecamatan Gandus', '087878101599', 'img3', 'NP00000003'),
('WI00000004', 'Scientia Square Park', 'Jl. Gading Serpong', '081699111256', 'img4', 'NP00000004'),
('WI00000005', 'Ocean Water Park', 'Jalamn Pahlawan Seribu', '082245392978', 'img5', 'NP00000005'),
('WI00000006', 'Danau Seran', 'Kecamatan Landasan Ulin', '081875762288', 'img6', 'NP00000006'),
('WI00000007', 'Kambang Iwak', 'Jl. Tasik', '082335365543', 'img7', 'NP00000007'),
('WI00000008', 'Wisata Kota Tua', 'Kota Tua Jakarta', '081786265353', 'img8', 'NP00000008'),
('WI00000009', 'Jembatan Ampera', 'Jl. Lintas Sumatera', '081515881010', 'img9', 'NP00000009'),
('WI00000010', 'Taman Nasional Komodo', 'Pulau Komodo', '082525881616', 'img10', 'NP00000010');

-- --------------------------------------------------------

--
-- Structure for view `crowded_schedule`
--
DROP TABLE IF EXISTS `crowded_schedule`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `crowded_schedule`  AS SELECT month(`pemesananpergi`.`Tanggal_Keberangkatan`) AS `Bulan`, count(month(`pemesananpergi`.`Tanggal_Keberangkatan`)) AS `Crowded_Schedule` FROM `pemesananpergi` GROUP BY month(`pemesananpergi`.`Tanggal_Keberangkatan`) ORDER BY count(month(`pemesananpergi`.`Tanggal_Keberangkatan`)) AS `DESCdesc` ASC  ;

-- --------------------------------------------------------

--
-- Structure for view `profitpenjualan`
--
DROP TABLE IF EXISTS `profitpenjualan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `profitpenjualan`  AS SELECT sum(`HitungProfit`(`hargatiket`.`HargaTiket`)) AS `SUM(HitungProfit(hargatiket.HargaTiket))` FROM `hargatiket``hargatiket`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bandara`
--
ALTER TABLE `bandara`
  ADD PRIMARY KEY (`BandaraId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
