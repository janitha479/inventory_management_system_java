-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 27, 2025 at 02:29 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `inventory_management_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddUser` (IN `p_username` VARCHAR(100), IN `p_password` VARCHAR(255), IN `p_role` ENUM('Admin','User'), IN `p_email` VARCHAR(100), IN `p_full_name` VARCHAR(150), IN `p_department_id` INT(11), IN `p_status` ENUM('ACTIVE','INACTIVE'))   BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            -- Rollback in case of an error
            ROLLBACK;
        END;
        
    -- Start transaction
    START TRANSACTION;

    -- Check if the username already exists
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    -- Insert the new user into the users table
    INSERT INTO users (username, password, role, email, full_name, department_id, status)
    VALUES (p_username, p_password, IFNULL(p_role, 'User'), p_email, p_full_name, p_department_id, IFNULL(p_status, 'ACTIVE'));
    
    -- Commit transaction
    COMMIT;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_quntity` ()   BEGIN

SELECT * FROM `inventory` WHERE quantity > 15;


    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `auditlogs`
--

CREATE TABLE `auditlogs` (
  `id` int(11) NOT NULL,
  `table_name` varchar(50) NOT NULL,
  `operation` enum('CREATE','READ','UPDATE','DELETE') NOT NULL,
  `changed_data` text DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`) VALUES
(2, 'Finance'),
(1, 'HR'),
(5, 'IT Support'),
(4, 'Marketing'),
(3, 'Sales');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `img_path` varchar(2048) DEFAULT NULL,
  `status` enum('IN STOCK','OUT OF STOCK') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `item_name`, `description`, `quantity`, `img_path`, `status`, `created_at`, `updated_at`) VALUES
(12, 'Tennis racket', 'Wilson Branded Tennis racket', 20, NULL, 'IN STOCK', '2024-12-17 17:57:15', '2024-12-18 04:02:41'),
(13, 'Cricket bat', ' Kookaburra Branded bats ', 15, NULL, 'IN STOCK', '2024-12-17 17:59:12', '2024-12-17 18:08:08'),
(14, 'Football', 'Grade S Footballs', 10, NULL, 'IN STOCK', '2024-12-17 18:06:44', '2024-12-17 18:06:44'),
(15, 'Dumbbell', 'Bowflex SelectTech 552 Adjustable Dumbbells', 40, NULL, 'IN STOCK', '2024-12-17 18:10:14', '2024-12-17 18:14:05');

--
-- Triggers `inventory`
--
DELIMITER $$
CREATE TRIGGER `update_inventory_status` BEFORE UPDATE ON `inventory` FOR EACH ROW BEGIN
    
    IF NEW.quantity = 0 THEN
        SET NEW.status = 'OUT OF STOCK';
   
    ELSEIF NEW.quantity > 0 THEN
        SET NEW.status = 'IN STOCK';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `inventoryhistory`
--

CREATE TABLE `inventoryhistory` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `change_type` enum('ADDED','UPDATED','REMOVED') NOT NULL,
  `old_quantity` int(11) DEFAULT NULL,
  `new_quantity` int(11) NOT NULL,
  `changed_by` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventoryhistory`
--

INSERT INTO `inventoryhistory` (`id`, `item_id`, `change_type`, `old_quantity`, `new_quantity`, `changed_by`, `timestamp`) VALUES
(59, 12, 'REMOVED', 20, 18, 9, '2024-12-17 18:11:45'),
(60, 15, 'REMOVED', 40, 36, 9, '2024-12-17 18:11:51'),
(61, 15, 'ADDED', 36, 40, 9, '2024-12-17 18:14:05'),
(62, 12, 'ADDED', 18, 20, 9, '2024-12-17 18:14:07'),
(63, 12, 'REMOVED', 20, 10, 9, '2024-12-18 04:02:24'),
(64, 12, 'ADDED', 10, 20, 9, '2024-12-18 04:02:41');

-- --------------------------------------------------------

--
-- Table structure for table `issued_items`
--

CREATE TABLE `issued_items` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `status` enum('Brought','Returned') NOT NULL DEFAULT 'Brought',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `issued_items`
--

INSERT INTO `issued_items` (`id`, `item_id`, `user_id`, `quantity`, `status`, `created_at`, `updated_at`) VALUES
(25, 12, 9, 2, 'Returned', '2024-12-17 18:11:45', '2024-12-17 18:11:45'),
(26, 15, 9, 4, 'Returned', '2024-12-17 18:11:51', '2024-12-17 18:11:51'),
(27, 12, 9, 10, 'Returned', '2024-12-18 04:02:24', '2024-12-18 04:02:24');

-- --------------------------------------------------------

--
-- Stand-in structure for view `issued_items_view`
-- (See below for the actual view)
--
CREATE TABLE `issued_items_view` (
`status` enum('Brought','Returned')
,`quantity` int(11)
,`created_at` date
,`item_name` varchar(150)
,`full_name` varchar(150)
);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Admin','User') NOT NULL DEFAULT 'User',
  `email` varchar(100) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `img_path` varchar(2048) DEFAULT NULL,
  `department_id` int(11) NOT NULL,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `email`, `full_name`, `img_path`, `department_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'superAdmin', '12345678', 'Admin', 'user@gmail.com', 'admin name', NULL, 1, 'ACTIVE', '2024-12-11 07:20:48', '2024-12-17 17:51:38'),
(5, 'janitha', '12345678', 'Admin', 'qwerfhgh@gmail.com', 'Janitha', NULL, 1, 'ACTIVE', '2024-12-11 08:11:15', '2024-12-17 18:19:43'),
(9, 'kamal', '12345', 'User', 'admin@gmail.com', 'kamal w', 'img/9_1734490036419_avatar4.png', 1, 'ACTIVE', '2024-12-11 08:22:20', '2024-12-18 02:47:16'),
(27, 'qwersunil@gmail.com', '1234', 'User', 'qwersunil@gmail.com', 'sunil', NULL, 1, 'ACTIVE', '2024-12-17 19:01:05', '2024-12-17 19:01:05'),
(28, 'nimal', '1234', 'User', 'kamal@gmail.com', 'kamal w', NULL, 4, 'ACTIVE', '2024-12-18 04:05:31', '2024-12-18 04:05:31');

-- --------------------------------------------------------

--
-- Structure for view `issued_items_view`
--
DROP TABLE IF EXISTS `issued_items_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `issued_items_view`  AS SELECT `ii`.`status` AS `status`, `ii`.`quantity` AS `quantity`, cast(`ii`.`created_at` as date) AS `created_at`, `inv`.`item_name` AS `item_name`, `usr`.`full_name` AS `full_name` FROM ((`issued_items` `ii` join `inventory` `inv` on(`ii`.`item_id` = `inv`.`id`)) join `users` `usr` on(`ii`.`user_id` = `usr`.`id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auditlogs`
--
ALTER TABLE `auditlogs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventoryhistory`
--
ALTER TABLE `inventoryhistory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `changed_by` (`changed_by`);

--
-- Indexes for table `issued_items`
--
ALTER TABLE `issued_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `forign key to inventory` (`item_id`),
  ADD KEY `forign key to users` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `idx_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auditlogs`
--
ALTER TABLE `auditlogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `inventoryhistory`
--
ALTER TABLE `inventoryhistory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `issued_items`
--
ALTER TABLE `issued_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auditlogs`
--
ALTER TABLE `auditlogs`
  ADD CONSTRAINT `auditlogs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `inventoryhistory`
--
ALTER TABLE `inventoryhistory`
  ADD CONSTRAINT `inventoryhistory_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory` (`id`),
  ADD CONSTRAINT `inventoryhistory_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `issued_items`
--
ALTER TABLE `issued_items`
  ADD CONSTRAINT `forign key to inventory` FOREIGN KEY (`item_id`) REFERENCES `inventory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `forign key to users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
