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
    user_status enum('Active', 'Deactive', 'Banned'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

-- Course Registrations
-- CREATE TABLE Course_Registrations (
--     id INT PRIMARY KEY AUTO_INCREMENT,
--     user_id INT,
--     course_id INT,
--     registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
--     status ENUM('Pending', 'Approved', 'Cancelled'),
--     FOREIGN KEY (user_id) REFERENCES Users(id),
--     FOREIGN KEY (course_id) REFERENCES Courses(id)
-- );

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


-- Study Roadmaps
CREATE TABLE Study_Roadmaps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    content TEXT,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

-- Add INSERT HERE

-- Insert fake data for Users table
INSERT INTO Users (full_name, email, password_hash, phone_number, address, dob, gender, role_id, user_status) VALUES
('John Admin', 'admin@pool.com', 'hashed_password_123', '1234567890', '123 Admin St, City', '1985-05-15', 'Male', 1, 'Active'),
('Sarah Manager', 'manager@pool.com', 'hashed_password_456', '2345678901', '456 Manager Ave, City', '1988-08-20', 'Female', 2, 'Active'),
-- ('Mike Coach', 'coach1@pool.com', 'hashed_password_789', '3456789012', '789 Coach Blvd, City', '1990-03-10', 'Male', 3, 'Active'),
-- ('Lisa Coach', 'coach2@pool.com', 'hashed_password_101', '4567890123', '101 Coach Lane, City', '1992-07-25', 'Female', 3, 'Active'),
('Tom Staff', 'staff@pool.com', 'hashed_password_112', '5678901234', '112 Staff Rd, City', '1995-11-05', 'Male', 5, 'Active'),
('Emma Customer', 'customer1@example.com', 'hashed_password_131', '6789012345', '131 Customer St, City', '1998-01-30', 'Female', 4, 'Active'),
('David Customer', 'customer2@example.com', 'hashed_password_415', '7890123456', '415 Customer Ave, City', '2000-09-12', 'Male', 4, 'Active'),
('Sophia Customer', 'customer3@example.com', 'hashed_password_617', '8901234567', '617 Customer Blvd, City', '1997-04-18', 'Female', 4, 'Active'),
('James Customer', 'customer4@example.com', 'hashed_password_819', '9012345678', '819 Customer Lane, City', '1999-12-05', 'Male', 4, 'Active'),
('Olivia Customer', 'customer5@example.com', 'hashed_password_921', '0123456789', '921 Customer Rd, City', '2001-06-22', 'Female', 4, 'Active');

-- Insert fake data for Course_Registrations table
-- INSERT INTO Course_Registrations (user_id, course_id, status) VALUES
-- (6, 1, 'Approved'),
-- (7, 2, 'Approved'),
-- (8, 3, 'Pending'),
-- (9, 4, 'Approved'),
-- (10, 5, 'Cancelled'),
-- (6, 3, 'Approved'),
-- (7, 1, 'Approved'),
-- (8, 2, 'Approved');

-- Insert fake data for UserCode table
INSERT INTO UserCode (user_id, user_code, created_at) VALUES
(6, 'ABC12345', '2023-05-15 10:30:00'),
(7, 'DEF67890', '2023-05-16 11:45:00'),
(8, 'GHI13579', '2023-05-17 09:15:00');

-- Insert fake data for Feedbacks table
-- INSERT INTO Feedbacks (user_id, feedback_type, coach_id, course_id, general_feedback_type, content, rating) VALUES
-- (6, 'Course', NULL, 1, NULL, 'Great course for beginners! I learned a lot.', 5),
-- (7, 'Coach', 3, NULL, NULL, 'Mike is an excellent coach, very patient and knowledgeable.', 5),
-- (8, 'General', NULL, NULL, 'Facility', 'The pool area is always clean and well-maintained.', 4),
-- (9, 'Course', NULL, 4, NULL, 'The competitive swimming course is challenging but rewarding.', 4),
-- (10, 'General', NULL, NULL, 'Service', 'The staff is friendly and helpful.', 5),
-- (6, 'General', NULL, NULL, 'Food', 'The snack bar offers healthy options.', 3);

-- Insert fake data for Complaints table
-- INSERT INTO Complaints (user_id, staff_id, content, status) VALUES
-- (7, 5, 'The water temperature was too cold during my last session.', 'Resolved'),
-- (8, 5, 'The changing rooms need better ventilation.', 'In Progress'),
-- (9, 5, 'One of the showers is not working properly.', 'New');

-- Insert fake data for Maintenance_Requests table
INSERT INTO Maintenance_Requests (description, status, created_by) VALUES
('Pool filter needs cleaning', 'Closed', 2),
('Leak in the men\'s changing room', 'In Progress', 5),
('Light fixture broken near Pool B', 'Open', 3);

-- Insert fake data for Payments table
-- INSERT INTO Payments (user_id, amount, method, payment_for, reference_id, status) VALUES
-- (6, 199.99, 'Credit Card', 'Course', 1, 'Completed'),
-- (7, 249.99, 'PayPal', 'Course', 2, 'Completed'),
-- (8, 299.99, 'Bank Transfer', 'Course', 3, 'Pending'),
-- (9, 349.99, 'Credit Card', 'Course', 4, 'Completed'),
-- (10, 149.99, 'Cash', 'Course', 5, 'Completed'),
-- (6, 299.99, 'Credit Card', 'Course', 3, 'Completed');


-- Insert fake data for Ticket table
-- INSERT INTO Ticket (user_id, ticket_type_id, quantity, start_date, end_date, ticket_status, payment_status, payment_id, total, created_at) VALUES
-- (6, 2, 1, '2023-06-01', '2023-06-30', 'Active', 'Paid', 1, 300000.00, '2023-05-30 14:25:00'),
-- (7, 1, 5, '2023-06-02', '2023-06-02', 'Active', 'Paid', 2, 250000.00, '2023-06-01 09:30:00'),
-- (8, 3, 1, '2023-06-01', '2023-08-31', 'Active', 'Paid', 3, 850000.00, '2023-05-29 11:45:00'),
-- (9, 2, 1, '2023-06-01', '2023-06-30', 'Active', 'Paid', 4, 300000.00, '2023-05-30 16:20:00'),
-- (10, 1, 3, '2023-06-03', '2023-06-03', 'Active', 'Paid', 5, 150000.00, '2023-06-02 10:15:00');

-- Insert fake data for Study_Roadmaps table
INSERT INTO Study_Roadmaps (title, content, created_by) VALUES
('Beginner to Intermediate Swimmer', 'Week 1-4: Focus on basic techniques...\nWeek 5-8: Introduce different strokes...', 3),
('Competitive Swimming Preparation', 'Month 1: Build endurance...\nMonth 2: Speed training...\nMonth 3: Competition strategies...', 4),
('Water Safety Certification Path', 'Step 1: Basic water safety...\nStep 2: Rescue techniques...\nStep 3: First aid certification...', 2);

-- Tạo bảng Pool_Area (Khu vực bể bơi)
CREATE TABLE Pool_Area (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Tạo bảng Maintenance_Schedule (danh sách nhiệm vụ bảo trì định kỳ - KHÔNG gắn khu vực)
DROP TABLE IF EXISTS Maintenance_Schedule;
CREATE TABLE Maintenance_Schedule (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    frequency ENUM('Daily', 'Weekly', 'Monthly'),
    scheduled_time TIME,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

-- Tạo bảng Maintenance_Log (nhật ký thực hiện bảo trì - CÓ gắn khu vực cụ thể)
DROP TABLE IF EXISTS Maintenance_Log;
CREATE TABLE Maintenance_Log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT,
    staff_id INT,
    pool_area_id INT,
    maintenance_date DATE,
    note TEXT,
    status ENUM('Done', 'Missed', 'Rescheduled'),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (schedule_id) REFERENCES Maintenance_Schedule(id),
    FOREIGN KEY (staff_id) REFERENCES Users(id),
    FOREIGN KEY (pool_area_id) REFERENCES Pool_Area(id)
);
-- Dữ liệu Pool_Area (khu vực bể)
INSERT INTO Pool_Area (name, description) VALUES
('Bể A', 'Bể bơi chính tiêu chuẩn Olympic'),
('Bể B', 'Bể dành cho trẻ em vui chơi'),
('Bể C', 'Bể huấn luyện dành cho người lớn'),
('Bể D', 'Bể thư giãn VIP'),
('Khu thay đồ', 'Khu thay đồ và tủ gửi đồ');

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


ALTER TABLE Maintenance_Requests
ADD COLUMN pool_area_id INT,
ADD FOREIGN KEY (pool_area_id) REFERENCES Pool_Area(id);


ALTER TABLE Maintenance_Requests MODIFY status 
    ENUM('Open', 'Accepted', 'Rejected', 'In Progress', 'Closed') 
    NOT NULL DEFAULT 'Open';
    
ALTER TABLE Maintenance_Requests
ADD COLUMN staff_id INT NULL,
ADD CONSTRAINT fk_request_staff
  FOREIGN KEY (staff_id) REFERENCES Users(id);
  
CREATE TABLE Notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,           -- Người nhận thông báo (ví dụ: staff)
    message TEXT NOT NULL,          -- Nội dung thông báo
    notification_type VARCHAR(50),  -- Loại thông báo (ví dụ: 'MaintenanceRequestStatus')
    related_id INT,                 -- ID của yêu cầu bảo trì liên quan
    is_read BOOLEAN DEFAULT FALSE,  -- Trạng thái: FALSE (chưa đọc), TRUE (đã đọc)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);
ALTER TABLE Maintenance_Schedule
MODIFY COLUMN frequency VARCHAR(10) NOT NULL;
ALTER TABLE Maintenance_Log
MODIFY COLUMN status VARCHAR(15) NOT NULL;
ALTER TABLE Maintenance_Requests
MODIFY COLUMN status VARCHAR(15) NOT NULL;
ALTER TABLE Maintenance_Schedule
MODIFY COLUMN frequency VARCHAR(15) NOT NULL;
ALTER TABLE Maintenance_Log
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


-- tach (DUCNT)--

CREATE TABLE Inventory_usage(
	usage_id INT PRIMARY KEY AUTO_INCREMENT,
    usage_name varchar(100),
    last_updated datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE Inventory_category(
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name varchar(100),
    category_quantity INT,
    last_updated datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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


INSERT INTO Inventory_usage(usage_name)
VALUES 
  ('item for rent and sold'),
  ('item for rent'),
  ('item for maintannance'),
  ('item for sold'),
  ('item for facility');
  
  INSERT INTO Inventory_category (category_name, category_quantity)
VALUES
  ('Thiết bị cá nhân', 10),         -- id = 1
  ('Phụ kiện hồ bơi', 15),          -- id = 2
  ('Thiết bị kiểm tra nước', 9),   -- id = 3
  ('Hóa chất hồ bơi', 10),          -- id = 4
  ('Thiết bị an toàn', 9);         -- id = 5

INSERT INTO Inventory (manager_id, item_name, category_id, quantity, unit, status, rent_price, sale_price, import_price, usage_id) VALUES 
-- Category 1: Đồ bơi trẻ em (3 items: 2 rental, 1 sale)
(1, 'Kính bơi trẻ em chống sương mù', 1, 20, 'cái', 'Available', 50000.00, 0.00, 30000.00, 1),  -- Rental Only
(1, 'Phao bơi hình thú dễ thương', 1, 15, 'cái', 'Available', 80000.00, 0.00, 50000.00, 1),  -- Rental Only
(1, 'Áo bơi trẻ em chống UV', 1, 10, 'cái', 'Available', 0.00, 150000.00, 100000.00, 2),  -- Sale Only

-- Category 2: Đồ bơi người lớn (3 items: 2 rental, 1 sale)
(1, 'Mũ bơi silicone người lớn', 2, 25, 'cái', 'Available', 30000.00, 0.00, 20000.00, 1),  -- Rental Only
(1, 'Chân vịt bơi lội chuyên nghiệp', 2, 12, 'đôi', 'Available', 100000.00, 0.00, 70000.00, 1),  -- Rental Only
(1, 'Kính bơi người lớn polarized', 2, 18, 'cái', 'Available', 0.00, 200000.00, 150000.00, 2),  -- Sale Only

-- Category 3: Dụng cụ bơi (3 items: 1 rental, 2 sale)
(1, 'Vợt vớt rác hồ bơi dài', 3, 8, 'cái', 'Available', 0.00, 250000.00, 180000.00, 2),  -- Sale Only
(1, 'Ván bơi tập luyện foam', 3, 10, 'cái', 'Available', 70000.00, 0.00, 50000.00, 1),  -- Rental Only
(1, 'Bơm hơi điện cho phao', 3, 5, 'cái', 'Available', 0.00, 300000.00, 220000.00, 2),  -- Sale Only

-- Category 4: Thiết bị an toàn (3 items: 1 rental, 2 sale)
(1, 'Áo phao cứu hộ chuyên dụng', 4, 20, 'cái', 'Available', 0.00, 200000.00, 150000.00, 2),  -- Sale Only
(1, 'Dây cứu hộ bể bơi 10m', 4, 15, 'cuộn', 'Available', 0.00, 150000.00, 100000.00, 2),  -- Sale Only
(1, 'Còi cứu hộ khẩn cấp', 4, 30, 'cái', 'Available', 20000.00, 0.00, 15000.00, 1);  -- Rental Only

-- tach (NGOC)--

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

INSERT INTO Coaches (full_name, email, phone_number, gender, bio, profile_picture, active)
VALUES
('Lê Văn Cường', 'cuong@example.com', '0908000001', 'Male', '10 năm kinh nghiệm dạy bơi cơ bản và nâng cao.', 'coach1.jpg', TRUE),
('Nguyễn Thị Mai', 'mai@example.com', '0908000002', 'Female', 'Chuyên về phục hồi chức năng dưới nước.', 'coach2.jpg', TRUE),
('Trần Quốc Toản', 'toan@example.com', '0908000003', 'Male', 'Hơn 5 năm đào tạo kỹ năng bơi thi đấu.', 'coach3.jpg', TRUE);



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
INSERT INTO Courses (name, description, price, duration, estimated_session_time, student_description, schedule_description, status)
VALUES
('Bơi cơ bản', 'Dành cho người mới bắt đầu, học cách nổi và di chuyển trong nước.', 1000000, 10, '60 phút', '5 học viên/lớp', 'Thứ 2 - 4 - 6', 'Active'),
('Bơi nâng cao', 'Nâng cao kỹ thuật bơi ếch, bơi sải và tăng sức bền.', 1500000, 12, '75 phút', '4 học viên/lớp', 'Thứ 3 - 5 - 7', 'Active'),
('Bơi phục hồi chức năng', 'Chương trình hỗ trợ phục hồi sau chấn thương.', 1800000, 8, '45 phút', '3 học viên/lớp', 'Linh hoạt', 'Inactive'),
('Bơi thi đấu', 'Huấn luyện cường độ cao cho học viên thi đấu chuyên nghiệp.', 2500000, 15, '90 phút', '1-2 học viên/lớp', 'Thứ 2 đến Thứ 7', 'Active');


-- MINH

CREATE TABLE CourseForm(
id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT  , -- nối đến bảng user
FOREIGN KEY (user_id) REFERENCES Users(id),
user_fullName varchar (50),
user_email varchar (50),
user_phone varchar (11) ,
coach_id INT, -- nối đến bảng coach
FOREIGN KEY (coach_id) REFERENCES Coaches(id),
course_id INT, -- nối đến bảng coach
FOREIGN KEY (course_id) REFERENCES Courses(id),
request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
has_processed boolean DEFAULT false

); 

CREATE TABLE Feedbacks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    feedback_type ENUM('Course', 'Coach', 'General'),
    coach_id INT,
    course_id INT,
    general_feedback_type ENUM('Food', 'Service', 'Facility', 'Other'),
    content TEXT,
    rating INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (coach_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

-- Huy


-- Bảng cho thuê thiết bị
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


-- Bảng bán thiết bị
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


-- Bảng bồi thường thiết bị (SỬA: dùng import_price_total thay vì original_price)
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

CREATE TABLE TicketType (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name ENUM('Single', 'Monthly', 'ThreeMonthly', 'SixMonthly', 'Year') UNIQUE,
    price DECIMAL(10,2) NOT NULL
);
INSERT INTO TicketType (type_name, price) VALUES
('Single',        50000.00),
('Monthly',      300000.00),
  ('ThreeMonthly', 850000.00),
  ('SixMonthly',  1600000.00),
  ('Year',         3000000.00);

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
    customer_name VARCHAR(255) NULL,  -- Thêm: Tên khách hàng (nullable cho vãng lai hoặc extra info)
    customer_id_card VARCHAR(50) NULL,  -- Thêm: CMND/CCCD khách hàng (nullable)
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id),
    FOREIGN KEY (ticket_type_id) REFERENCES TicketType(id)
);
INSERT INTO Inventory_usage(usage_name)
VALUES 
  ('Rental Only'),  -- usage_id=1 (cho thuê)
('Sale Only');    -- usage_id=2 (cho bán)
INSERT INTO Inventory_category (category_name, category_quantity) VALUES 
('Đồ bơi trẻ em', 0),
('Đồ bơi người lớn', 0),
('Dụng cụ bơi', 0),
('Thiết bị an toàn', 0);
