-- Drop database swimming_pool_management;
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
    role_id INT default 4,
    profile_picture VARCHAR(255) DEFAULT NULL,
    user_status ENUM('Active', 'Deactive', 'Banned'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

-- Reset Password
CREATE TABLE UserCode (
    user_id INT PRIMARY KEY,
    user_code VARCHAR(8),
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Pool_Area (Khu vực bể bơi)
CREATE TABLE Pool_Area (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    type VARCHAR(50) DEFAULT 'Standard',
    water_depth DECIMAL(5,2),
    length DECIMAL(5,2),
    width DECIMAL(5,2),
    max_capacity INT
);

-- Maintenance Requests
CREATE TABLE Maintenance_Requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT,
    status VARCHAR(15) NOT NULL DEFAULT 'Open', -- Changed to VARCHAR and set default
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    pool_area_id INT,
    staff_id INT NULL,
    FOREIGN KEY (created_by) REFERENCES Users(id),
    FOREIGN KEY (pool_area_id) REFERENCES Pool_Area(id),
    FOREIGN KEY (staff_id) REFERENCES Users(id)
);

-- Maintenance_Schedule (danh sách nhiệm vụ bảo trì định kỳ - KHÔNG gắn khu vực)
CREATE TABLE Maintenance_Schedule (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    frequency VARCHAR(15) NOT NULL, -- Changed to VARCHAR
    scheduled_time TIME,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

-- Maintenance_Log (nhật ký thực hiện bảo trì - CÓ gắn khu vực cụ thể)
CREATE TABLE Maintenance_Log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT,
    staff_id INT,
    pool_area_id INT,
    maintenance_date DATE,
    note TEXT,
    status VARCHAR(15) NOT NULL, -- Changed to VARCHAR
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (schedule_id) REFERENCES Maintenance_Schedule(id),
    FOREIGN KEY (staff_id) REFERENCES Users(id),
    FOREIGN KEY (pool_area_id) REFERENCES Pool_Area(id)
);

CREATE TABLE Notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) NOT NULL, -- Added NOT NULL
    related_id INT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Inventory related tables
CREATE TABLE Inventory_usage(
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    usage_name VARCHAR(100),
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Inventory_category(
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100),
    category_quantity INT,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    manager_id INT,
    item_name VARCHAR(100),
    category_id INT,
    quantity INT,
    unit VARCHAR(100),
    status ENUM('Available', 'In Use', 'Maintenance', 'Broken', 'Unavailable'),
    rent_price DECIMAL(10,2) DEFAULT 0 COMMENT 'Giá thuê 1 lần',
    sale_price DECIMAL(10,2) DEFAULT 0 COMMENT 'Giá bán',
    import_price DECIMAL(10,2) DEFAULT 0 COMMENT 'Giá nhập',
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usage_id INT,
    FOREIGN KEY (usage_id) REFERENCES Inventory_usage(usage_id),
    FOREIGN KEY (category_id) REFERENCES Inventory_category(category_id),
    FOREIGN KEY (manager_id) REFERENCES Users(id)
);

CREATE TABLE Inventory_Request (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    inventory_id INT NOT NULL,
    requested_quantity INT NOT NULL,
    reason TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    approved_at DATETIME,
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
);

-- Coaches
CREATE TABLE Coaches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    gender ENUM('Male', 'Female', 'Other'),
    bio TEXT,
    profile_picture VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Courses
CREATE TABLE Courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    duration INT,
    estimated_session_time VARCHAR(50),
    student_description VARCHAR(100),
    schedule_description VARCHAR(100),
    status ENUM('Active', 'Inactive') DEFAULT 'Inactive',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Course_Form
CREATE TABLE Course_Form(
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    user_fullName VARCHAR(50),
    user_email VARCHAR(50),
    user_phone VARCHAR(11),
    coach_id INT,
    course_id INT,
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    has_processed int DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (coach_id) REFERENCES Coaches(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

-- Feedbacks
CREATE TABLE Feedbacks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    feedback_type ENUM('Course', 'Coach', 'General'),
    coach_id INT, -- Corrected FK reference
    course_id INT,
    general_feedback_type ENUM('Food', 'Service', 'Facility', 'Other'),
    content TEXT,
    rating INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (coach_id) REFERENCES Coaches(id), -- Corrected to Coaches(id)
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

-- Equipment_Rentals
CREATE TABLE Equipment_Rentals (
    rental_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    customer_id_card VARCHAR(20) NOT NULL COMMENT 'CCCD thế chấp',
    staff_id INT NOT NULL,
    inventory_id INT NOT NULL,
    quantity INT NOT NULL,
    rental_date DATE NOT NULL,
    rent_price DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('active', 'returned', 'damaged', 'lost', 'overdue', 'compensated', 'cancelled') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_time TIMESTAMP NULL COMMENT 'Thời gian trả thực tế',
    due_date DATE NULL,
    notes TEXT NULL,
    FOREIGN KEY (staff_id) REFERENCES Users(id),
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
);

-- Equipment_Sales
CREATE TABLE Equipment_Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    staff_id INT NOT NULL,
    inventory_id INT NOT NULL,
    quantity INT NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES Users(id),
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
);

-- Equipment_Compensations
CREATE TABLE Equipment_Compensations (
    compensation_id INT PRIMARY KEY AUTO_INCREMENT,
    rental_id INT NOT NULL,
    compensation_type ENUM('damaged', 'lost', 'overdue_fee') NOT NULL,
    damage_description TEXT NULL,
    import_price_total DECIMAL(10,2) NOT NULL COMMENT 'Tổng giá nhập = import_price × quantity',
    compensation_rate DECIMAL(5,2) NOT NULL COMMENT 'Tỷ lệ bồi thường (0.0 - 1.0)',
    total_amount DECIMAL(10,2) NOT NULL COMMENT 'Số tiền phải bồi thường',
    paid_amount DECIMAL(10,2) DEFAULT 0,
    payment_status ENUM('pending', 'partial', 'paid', 'waived') DEFAULT 'pending',
    can_repair BOOLEAN NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (rental_id) REFERENCES Equipment_Rentals(rental_id)
);

-- Payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    customer_name VARCHAR(100),
    customer_id_card VARCHAR(20),
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    payment_for VARCHAR(50) NOT NULL,
    reference_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    staff_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (staff_id) REFERENCES Users(id)
);

-- TicketType
CREATE TABLE TicketType (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name ENUM('Single', 'Monthly', 'ThreeMonthly', 'SixMonthly', 'Year') UNIQUE,
    price DECIMAL(10,2) NOT NULL
);

-- Ticket
CREATE TABLE Ticket (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    ticket_type_id INT,
    quantity INT,
    start_date DATE,
    end_date DATE,
    ticket_status ENUM('Active', 'Expired', 'Cancelled'),
    payment_status ENUM('Paid', 'Unpaid'),
    payment_id INT NULL,
    total DECIMAL(10,2),
    created_at DATETIME,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    customer_name VARCHAR(255) NULL,
    customer_id_card VARCHAR(50) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id),
    FOREIGN KEY (ticket_type_id) REFERENCES TicketType(id)
);

-- StaffInitialSetup
CREATE TABLE StaffInitialSetup (
    user_id INT PRIMARY KEY,
    is_setup_complete BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);
Create TABLE Repair_Request (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    inventory_id INT NOT NULL,
    reason TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    reviewed_at DATETIME,
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
);

-- Data Insertion
INSERT INTO Users (full_name, email, password_hash, phone_number, address, dob, gender, role_id, user_status) VALUES
('Nguyễn Văn Quản Trị', 'admin@pool.com', 'hashed_password_123', '1234567890', '123 Đường Quản Trị, Thành phố', '1985-05-15', 'Male', 1, 'Active'),
('Trần Thị Quản Lý', 'manager@pool.com', 'hashed_password_456', '2345678901', '456 Đại lộ Quản Lý, Thành phố', '1988-08-20', 'Female', 2, 'Active'),
('Phạm Văn Nhân Viên', 'staff@pool.com', 'hashed_password_112', '5678901234', '112 Đường Nhân Viên, Thành phố', '1995-11-05', 'Male', 5, 'Active'),
('Lê Thị Khách Hàng', 'customer1@example.com', 'hashed_password_131', '6789012345', '131 Đường Khách Hàng, Thành phố', '1998-01-30', 'Female', 4, 'Active'),
('Ngô Minh Khách Hàng', 'customer2@example.com', 'hashed_password_415', '7890123456', '415 Đại lộ Khách Hàng, Thành phố', '2000-09-12', 'Male', 4, 'Active'),
('Hoàng Thị Khách Hàng', 'customer3@example.com', 'hashed_password_617', '8901234567', '617 Đường Khách Hàng, Thành phố', '1997-04-18', 'Female', 4, 'Active'),
('Vũ Văn Khách Hàng', 'customer4@example.com', 'hashed_password_819', '9012345678', '819 Ngõ Khách Hàng, Thành phố', '1999-12-05', 'Male', 4, 'Active'),
('Đặng Thị Khách Hàng', 'customer5@example.com', 'hashed_password_921', '0123456789', '921 Đường Khách Hàng, Thành phố', '2001-06-22', 'Female', 4, 'Active');


-- Insert fake data for UserCode table
INSERT INTO UserCode (user_id, user_code, created_at) VALUES
(6, 'ABC12345', '2023-05-15 10:30:00'),
(7, 'DEF67890', '2023-05-16 11:45:00'),
(8, 'GHI13579', '2023-05-17 09:15:00');

-- Dữ liệu Pool_Area (khu vực bể)
INSERT INTO Pool_Area (name, description, type, water_depth, length, width, max_capacity) VALUES
('Bể A', 'Bể bơi chính tiêu chuẩn Olympic', 'Olympic', 2.5, 50.0, 25.0, 300),
('Bể B', 'Bể dành cho trẻ em vui chơi', 'Children', 0.8, 15.0, 10.0, 50),
('Bể C', 'Bể huấn luyện dành cho người lớn', 'Training', 1.8, 25.0, 12.0, 100),
('Bể D', 'Bể thư giãn VIP', 'VIP', 1.2, 10.0, 8.0, 20),
('Khu thay đồ', 'Khu thay đồ và tủ gửi đồ', 'Facility', NULL, NULL, NULL, NULL);

INSERT INTO Maintenance_Requests (description, status, created_by, pool_area_id) VALUES
('Pool filter needs cleaning', 'Closed', 2, 1),
('Leak in the men\'s changing room', 'In Progress', 5, 5),
('Light fixture broken near Pool B', 'Open', 3, 2);

-- Dữ liệu Maintenance_Schedule (các nhiệm vụ định kỳ)
INSERT INTO Maintenance_Schedule (title, description, frequency, scheduled_time, created_by)
VALUES
('Vệ sinh nhà vệ sinh', 'Lau chùi và khử mùi toilet', 'Daily', '08:00:00', 1),
('Vớt rác mặt nước', 'Dọn rác nổi và lá cây trên mặt nước', 'Daily', '07:30:00', 2),
('Kiểm tra thiết bị bể bơi', 'Kiểm tra phao, chân vịt, gậy chống đuối nước', 'Weekly', '09:00:00', 1),
('Đo nồng độ Clo', 'Kiểm tra nồng độ Clo trong nước để đảm bảo an toàn', 'Daily', '10:00:00', 1),
('Vệ sinh sàn khu thay đồ', 'Lau chùi, diệt khuẩn khu thay đồ', 'Daily', '11:00:00', 2),
('Vệ sinh bể định kỳ', 'Vệ sinh kỹ toàn bộ lòng bể và tường bể', 'Monthly', '12:00:00', 1);

-- Dữ liệu Maintenance_Log (gán nhiệm vụ + khu vực cụ thể)
INSERT INTO Maintenance_Log (schedule_id, staff_id, pool_area_id, maintenance_date, note, status)
VALUES
(1, 5, 5, '2025-06-22', 'Đã lau dọn sạch toilet nam/nữ', 'Done'),
(2, 5, 1, '2025-06-22', 'Đã vớt sạch lá và rác nổi', 'Done'),
(4, 5, 1, '2025-06-23', 'Clo ở mức 2.5ppm, đạt chuẩn', 'Done'),
(5, 5, 5, '2025-06-23', 'Sàn trơn nhẹ, cần thêm biển cảnh báo', 'Done'),
(6, 5, 4, '2025-06-24', 'Đã làm sạch đáy bể, nước trong', 'Done');


INSERT INTO Inventory_usage(usage_name)
VALUES
    ('item for rent and sold'),
    ('item for rent'),
    ('item for maintannance'),
    ('item for sold'),
    ('item for facility');

INSERT INTO Inventory_category (category_name, category_quantity)
VALUES
    ('Thiết bị cá nhân', 10),
    ('Phụ kiện hồ bơi', 15),
    ('Thiết bị kiểm tra nước', 9),
    ('Hóa chất hồ bơi', 10),
    ('Thiết bị an toàn', 9);

INSERT INTO Inventory (manager_id, item_name, category_id, quantity, unit, status, rent_price, sale_price, import_price, usage_id) VALUES
-- Category 1: Đồ bơi trẻ em (3 items: 2 rental, 1 sale)
(1, 'Kính bơi trẻ em chống sương mù', 1, 20, 'cái', 'Available', 50000.00, 0.00, 30000.00, 1),
(1, 'Phao bơi hình thú dễ thương', 1, 15, 'cái', 'Available', 80000.00, 0.00, 50000.00, 1),
(1, 'Áo bơi trẻ em chống UV', 1, 10, 'cái', 'Available', 0.00, 150000.00, 100000.00, 2),

-- Category 2: Đồ bơi người lớn (3 items: 2 rental, 1 sale)
(1, 'Mũ bơi silicone người lớn', 2, 25, 'cái', 'Available', 30000.00, 0.00, 20000.00, 1),
(1, 'Chân vịt bơi lội chuyên nghiệp', 2, 12, 'đôi', 'Available', 100000.00, 0.00, 70000.00, 1),
(1, 'Kính bơi người lớn polarized', 2, 18, 'cái', 'Available', 0.00, 200000.00, 150000.00, 2),

-- Category 3: Dụng cụ bơi (3 items: 1 rental, 2 sale)
(1, 'Vợt vớt rác hồ bơi dài', 3, 8, 'cái', 'Available', 0.00, 250000.00, 180000.00, 2),
(1, 'Ván bơi tập luyện foam', 3, 10, 'cái', 'Available', 70000.00, 0.00, 50000.00, 1),
(1, 'Bơm hơi điện cho phao', 3, 5, 'cái', 'Available', 0.00, 300000.00, 220000.00, 2),

-- Category 4: Thiết bị an toàn (3 items: 1 rental, 2 sale)
(1, 'Áo phao cứu hộ chuyên dụng', 4, 20, 'cái', 'Available', 0.00, 200000.00, 150000.00, 2),
(1, 'Dây cứu hộ bể bơi 10m', 4, 15, 'cuộn', 'Available', 0.00, 150000.00, 100000.00, 2),
(1, 'Còi cứu hộ khẩn cấp', 4, 30, 'cái', 'Available', 20000.00, 0.00, 15000.00, 1);

INSERT INTO Coaches (full_name, email, phone_number, gender, bio, profile_picture, active)
VALUES
('Lê Văn Cường', 'cuong@example.com', '0908000001', 'Male', '10 năm kinh nghiệm dạy bơi cơ bản và nâng cao.', 'coach1.jpg', TRUE),
('Nguyễn Thị Mai', 'mai@example.com', '0908000002', 'Female', 'Chuyên về phục hồi chức năng dưới nước.', 'coach2.jpg', TRUE),
('Trần Quốc Toản', 'toan@example.com', '0908000003', 'Male', 'Hơn 5 năm đào tạo kỹ năng bơi thi đấu.', 'coach3.jpg', TRUE);

INSERT INTO Courses (name, description, price, duration, estimated_session_time, student_description, schedule_description, status)
VALUES
('Bơi cơ bản', 'Dành cho người mới bắt đầu, học cách nổi và di chuyển trong nước.', 1000000, 10, '60 phút', '5 học viên/lớp', 'Thứ 2 - 4 - 6', 'Active'),
('Bơi nâng cao', 'Nâng cao kỹ thuật bơi ếch, bơi sải và tăng sức bền.', 1500000, 12, '75 phút', '4 học viên/lớp', 'Thứ 3 - 5 - 7', 'Active'),
('Bơi phục hồi chức năng', 'Chương trình hỗ trợ phục hồi sau chấn thương.', 1800000, 8, '45 phút', '3 học viên/lớp', 'Linh hoạt', 'Inactive'),
('Bơi thi đấu', 'Huấn luyện cường độ cao cho học viên thi đấu chuyên nghiệp.', 2500000, 15, '90 phút', '1-2 học viên/lớp', 'Thứ 2 đến Thứ 7', 'Active');

INSERT INTO TicketType (type_name, price) VALUES
('Single', 50000.00),
('Monthly', 300000.00),
('ThreeMonthly', 850000.00),
('SixMonthly', 1600000.00),
('Year', 3000000.00);

-- Insert data for StaffInitialSetup for existing staff (assuming staff_id 3 and 5 from Users table)
INSERT INTO StaffInitialSetup (user_id, is_setup_complete) VALUES
(3, TRUE),
(5, FALSE);