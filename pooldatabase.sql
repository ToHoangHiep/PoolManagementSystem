-- Drop table
drop database swimming_pool_management;


-- Tạo database
CREATE DATABASE swimming_pool_management;
USE swimming_pool_management;
-- Roles
CREATE TABLE Roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);
INSERT INTO Roles(id, name) VALUES
  (1, 'Admin'),
  (2, 'Manager'),
  (3, 'Coach'),
  (4, 'Customer'),
  (5, 'Staff');

-- Users
CREATE TABLE Users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash TEXT,
    phone_number VARCHAR(20),
    address TEXT,
    dob DATE,
    gender ENUM('Male', 'Female', 'Other'),
    role_id INT,
    user_status enum('Active', 'Deactive', 'Banned'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

INSERT INTO Users (
    full_name,
    email,
    password_hash,
    phone_number,
    address,
    dob,
    gender,
    role_id
) VALUES (
    'Nguyễn Văn A',
    'nguyenvana@example.com',
    'hashed_password_here', -- giả sử bạn dùng hash
    '0909123456',
    '123 Đường ABC, Quận 1, TP.HCM',
    '1990-01-01',
    'Male',
    2
);

-- Courses
CREATE TABLE Courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    duration INT,
    coach_id INT,
    status ENUM('Active', 'Inactive'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coach_id) REFERENCES Users(id)
);

-- Course Registrations
CREATE TABLE Course_Registrations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    course_id INT,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Approved', 'Cancelled'),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

-- Services
-- CREATE TABLE Services (
--     id INT PRIMARY KEY AUTO_INCREMENT,
--     name VARCHAR(100),
--     description TEXT,
--     price DECIMAL(10, 2),
--     status ENUM('Available', 'Unavailable'),
--     created_at DATETIME DEFAULT CURRENT_TIMESTAMP
-- );

-- Service Registrations
-- CREATE TABLE Service_Registrations (
--     id INT PRIMARY KEY AUTO_INCREMENT,
--     user_id INT,
--     service_id INT,
--     registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
--     status ENUM('Pending', 'Approved', 'Cancelled'),
--     FOREIGN KEY (user_id) REFERENCES Users(id),
--     FOREIGN KEY (service_id) REFERENCES Services(id)
-- );


-- Reset Password
CREATE TABLE UserCode (
	user_id int primary key,
    user_code varchar(8),
    created_at datetime,
    foreign key (user_id) references users(id)
);


-- Iventory
CREATE TABLE Inventory (
	inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    manager_id int,
    item_name varchar(100),
    category varchar(100),
    quantity int,
    unit varchar(100),
    status enum('Available', 'In Use', 'Maintenance', 'Broken'),
    last_updated datetime,
    usage_id int,
    foreign key (manager_id) references users(id),
	foreign key (usage_id)   references Inventory_usage(usage_id)
);
CREATE TABLE Inventory_usage(
	usage_id INT PRIMARY KEY AUTO_INCREMENT,
    usage_name varchar(100)

);
INSERT INTO Inventory_usage(usage_name)
VALUES 
  ('item for rent'),
  ('item for maintannance'),
  ('item for sold'),
  ('item for facility');




-- Feedbacks
CREATE TABLE Feedbacks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    coach_id INT,
    content TEXT,
    rating INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (coach_id) REFERENCES Users(id)
);

-- Complaints
CREATE TABLE Complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    staff_id INT,
    content TEXT,
    status ENUM('New', 'In Progress', 'Resolved'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (staff_id) REFERENCES Users(id)
);

-- Schedules
CREATE TABLE Schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    coach_id INT,
    start_time DATETIME,
    end_time DATETIME,
    location VARCHAR(100),
    FOREIGN KEY (course_id) REFERENCES Courses(id),
    FOREIGN KEY (coach_id) REFERENCES Users(id)
);

-- Maintenance Requests
CREATE TABLE Maintenance_Requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT,
    status ENUM('Open', 'In Progress', 'Closed'),
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

-- Payments
CREATE TABLE Payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    amount DECIMAL(10, 2),
    method VARCHAR(50),
    payment_for ENUM('Course', 'Service'),
    reference_id INT,
    status ENUM('Pending', 'Completed', 'Failed'),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Tracking (theo dõi học tập)
CREATE TABLE Tracking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    progress TEXT,
    coach_feedback TEXT,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

-- Blogs
CREATE TABLE Blogs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    content TEXT,
    author_id INT,
    published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES Users(id)
);


CREATE TABLE Ticket (
	ticket_id int primary key auto_increment,
    user_id int,
    ticket_type enum('Single', 'Monthly', 'Combo'),
    quantity int,
    start_date date,
    end_date date,
    ticket_status enum('Active', 'Expired', 'Cancelled'),
    payment_status enum('Paid', 'Unpaid'),
    payment_id int,
    created_at datetime,
    foreign key (user_id) references users(id),
    foreign key (payment_id) references payments(id)
);


-- Study Roadmaps
CREATE TABLE Study_Roadmaps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    content TEXT,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);
INSERT INTO Inventory (manager_id, item_name, category, quantity, unit, status, last_updated, usage_id)
VALUES
  (1, 'Gậy bơi', 'Thiết bị tập luyện', 100, 'cây', 'Available', NOW(), 1),
  (1, 'Phao tròn', 'Phao cứu sinh', 50, 'cái', 'Available', NOW(), 1),
  (1, 'Phao tay', 'Phao cứu sinh', 80, 'cái', 'Available', NOW(), 1),
  (1, 'Ghế nằm', 'Thiết bị nghỉ ngơi', 30, 'cái', 'In Use', NOW(), 4),
  (1, 'Đèn chiếu sáng', 'Thiết bị chiếu sáng', 20, 'bóng', 'Maintenance', NOW(), 4),
  (1, 'Khăn tắm', 'Tiện ích', 200, 'cái', 'Available', NOW(), 1),
  (1, 'Dép nhựa', 'Tiện ích', 150, 'đôi', 'Available', NOW(), 1),
  (1, 'Kính bơi', 'Trang bị cá nhân', 120, 'cái', 'Available', NOW(), 1),
  (1, 'Đồ bơi nữ', 'Trang phục', 60, 'bộ', 'Available', NOW(), 1),
  (1, 'Đồ bơi nam', 'Trang phục', 70, 'bộ', 'Available', NOW(), 1);


Select * from inventory
ALTER TABLE Inventory ADD threshold_quantity INT DEFAULT 10;
ALTER TABLE Inventory
ADD rentable BIT DEFAULT 1;
UPDATE Inventory
SET rentable = 0
WHERE category IN ('Thiết bị chiếu sáng',  'Thiết bị nghỉ ngơi');

Select * from inventory

SET SQL_SAFE_UPDATES = 1;

Drop table inventory
