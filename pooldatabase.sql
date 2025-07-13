-- DROP & CREATE DATABASE
DROP DATABASE IF EXISTS swimming_pool_management;
CREATE DATABASE swimming_pool_management;
USE swimming_pool_management;
-- 1. ROLES
CREATE TABLE Roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash TEXT,
    phone_number VARCHAR(20),
    address TEXT,
    dob DATE,
    gender ENUM('Male', 'Female', 'Other'),
    role_id INT DEFAULT 3,
    profile_picture VARCHAR(255),
    user_status ENUM('Active', 'Deactive', 'Banned') DEFAULT 'Active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

CREATE TABLE UserCode (
    user_id INT PRIMARY KEY,
    user_code VARCHAR(8),
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Coaches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    gender ENUM('Male', 'Female', 'Other'),
    bio TEXT,
    profile_picture VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    duration INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Classes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    coach_id INT,
    student_limit INT DEFAULT 2,
    status ENUM('Chưa khai giảng', 'Đang học', 'Đã kết thúc') DEFAULT 'Chưa khai giảng',
    schedule VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(id),
    FOREIGN KEY (coach_id) REFERENCES Coaches(id)
);


CREATE TABLE Class_Registrations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    class_id INT,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Approved', 'Cancelled'),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (class_id) REFERENCES Classes(id)
);


CREATE TABLE Tracking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    class_id INT,
    progress TEXT,
    coach_feedback TEXT,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Users(id),
    FOREIGN KEY (class_id) REFERENCES Classes(id)
);


CREATE TABLE Schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT,
    start_time DATETIME,
    end_time DATETIME,
    location VARCHAR(100),
    FOREIGN KEY (class_id) REFERENCES Classes(id)
);

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

CREATE TABLE TicketType (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name ENUM('Single', 'Monthly', 'ThreeMonthly', 'SixMonthly', 'Year') UNIQUE,
    price DECIMAL(10,2) NOT NULL
);

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
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (payment_id) REFERENCES Payments(id),
    FOREIGN KEY (ticket_type_id) REFERENCES TicketType(id)
);

CREATE TABLE Inventory_usage(
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    usage_name VARCHAR(100),
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Inventory (
   inventory_id INT PRIMARY KEY AUTO_INCREMENT,
   manager_id INT,
   item_name VARCHAR(100),
   category VARCHAR(100),
   quantity INT,
   unit VARCHAR(100),
   status ENUM('Available', 'In Use', 'Maintenance', 'Broken'),
   rent_price DECIMAL(10,2) DEFAULT 0 COMMENT 'Giá thuê 1 lần',
   sale_price DECIMAL(10,2) DEFAULT 0 COMMENT 'Giá bán',
   last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   usage_id INT,
   FOREIGN KEY (usage_id) REFERENCES Inventory_usage(usage_id),
   FOREIGN KEY (manager_id) REFERENCES Users(id)
);

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
   status ENUM('active', 'returned') DEFAULT 'active',
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   return_time TIMESTAMP NULL COMMENT 'Thời gian trả thực tế',
   FOREIGN KEY (staff_id) REFERENCES Users(id),
   FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
);

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

CREATE TABLE Blogs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    content TEXT,
    author_id INT,
    course_id INT,
    tags VARCHAR(255),
    likes INT DEFAULT 0,
    active BOOLEAN DEFAULT FALSE,
    published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

CREATE TABLE Blog_Comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    blog_id INT,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (blog_id) REFERENCES Blogs(id),
    FOREIGN KEY (user_id) REFERENCES Users(id)
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

CREATE TABLE FeedbackReplies (
     id INT PRIMARY KEY AUTO_INCREMENT,
     feedback_id INT NOT NULL,
     user_id INT NOT NULL,
     content TEXT NOT NULL,
     created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
     updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
     FOREIGN KEY (feedback_id) REFERENCES Feedbacks(id),
     FOREIGN KEY (user_id) REFERENCES Users(id)
);

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

CREATE TABLE Maintenance_Requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT,
    status ENUM('Open', 'In Progress', 'Closed'),
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

CREATE TABLE Maintenance_Schedule (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    frequency ENUM('Daily', 'Weekly', 'Monthly'),
    assigned_staff_id INT,
    scheduled_time TIME,
    status ENUM('Scheduled', 'Completed', 'Missed') DEFAULT 'Scheduled',
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assigned_staff_id) REFERENCES Users(id),
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

CREATE TABLE Maintenance_Log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT,
    staff_id INT,
    maintenance_date DATE,
    note TEXT,
    status ENUM('Done', 'Missed', 'Rescheduled'),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (schedule_id) REFERENCES Maintenance_Schedule(id),
    FOREIGN KEY (staff_id) REFERENCES Users(id)
);

CREATE TABLE Study_Roadmaps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    content TEXT,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

-- Dữ liệu mẫu cho bảng Roles
INSERT INTO Roles (id, name) VALUES
  (1, 'Admin'),
  (2, 'Quản lý'),
  (3, 'Khách hàng'),
  (4, 'Nhân viên');

-- Dữ liệu mẫu cho bảng Users
INSERT INTO Users (full_name, email, password_hash, phone_number, address, dob, gender, role_id, user_status) 
VALUES
('Nguyễn Văn A', 'admin@pool.com', 'mat_khau_ma_hoa', '0901000001', '123 Đường Quản Trị, TP.HCM', '1985-05-15', 'Male', 1, 'Active'),
('Trần Văn B', 'manager@pool.com', 'mat_khau_ma_hoa', '0901000002', '456 Đường Quản Lý, TP.HCM', '1988-08-20', 'Female', 2, 'Active'),
('Phạm Văn C', 'staff@pool.com', 'mat_khau_ma_hoa', '0901000003', '789 Đường Nhân Viên, TP.HCM', '1995-11-05', 'Male', 4, 'Active'),
('Lê Thị D', 'khach1@example.com', 'mat_khau_ma_hoa', '0901000004', '101 Đường Khách Hàng, TP.HCM', '1998-01-30', 'Female', 3, 'Active');

-- Dữ liệu mẫu cho bảng Coaches
INSERT INTO Coaches (full_name, email, phone_number, gender, bio, profile_picture)
VALUES 
('Phạm Quốc Dũng', 'coach.dung@example.com', '0988123456', 'Male', 'Chuyên gia bơi lội quốc gia, có hơn 10 năm kinh nghiệm huấn luyện.', 'coach_dung.jpg'),
('Nguyễn Hồng Nhung', 'coach.nhung@example.com', '0977555444', 'Female', 'HLV bơi lội cho trẻ em và người mới bắt đầu, thân thiện và nhiệt huyết.', 'coach_nhung.jpg');

-- Dữ liệu mẫu cho bảng Inventory_usage
INSERT INTO Inventory_usage (usage_name)
VALUES 
('Dụng cụ cho thuê'),
('Đang bảo trì'),
('Dụng cụ bán'),
('Thiết bị cơ sở vật chất');

-- Dữ liệu mẫu cho bảng Courses
INSERT INTO Courses (name, description, price, duration, student_limit, coach_id, status)
VALUES 
('Khóa học bơi cơ bản', 'Dành cho người chưa biết bơi, học từ căn bản đến lướt nước.', 1200000.00, 600, 6, 1, 'Active'),
('Khóa bơi nâng cao', 'Rèn luyện sức bền và kỹ thuật chuyên sâu.', 1500000.00, 720, 6, 2, 'Active');

-- Dữ liệu mẫu cho bảng Course_Registrations
INSERT INTO Course_Registrations (user_id, course_id, status)
VALUES 
(4, 1, 'Approved'),
(4, 2, 'Pending');

-- Dữ liệu mẫu cho bảng Schedules
INSERT INTO Schedules (course_id, coach_id, start_time, end_time, location)
VALUES 
(1, 1, '2025-07-10 07:00:00', '2025-07-10 08:00:00', 'Hồ bơi Di Linh A'),
(2, 2, '2025-07-11 08:30:00', '2025-07-11 10:00:00', 'Hồ bơi Di Linh B');

-- Dữ liệu mẫu cho bảng Feedbacks
INSERT INTO Feedbacks (user_id, feedback_type, coach_id, course_id, general_feedback_type, content, rating)
VALUES
(4, 'Course', NULL, 1, NULL, 'Khóa học rất phù hợp cho người mới bắt đầu, tôi cảm thấy tự tin hơn khi xuống nước.', 5),
(4, 'Coach', 2, NULL, NULL, 'Cô Nhung rất nhiệt tình và kiên nhẫn, hướng dẫn dễ hiểu.', 5),
(4, 'General', NULL, NULL, 'Facility', 'Khu vực hồ bơi sạch sẽ và an toàn.', 4);

-- Dữ liệu mẫu cho bảng Blogs
INSERT INTO Blogs (title, content, author_id, course_id, tags, likes)
VALUES
('Lợi ích của việc học bơi', 'Học bơi không chỉ giúp cải thiện sức khỏe mà còn là kỹ năng sinh tồn cần thiết...', 3, 1, 'sức khỏe,bơi lội,kỹ năng', 25),
('Kỹ thuật thở khi bơi', 'Thở đúng cách giúp tiết kiệm sức và cải thiện tốc độ bơi...', 4, 2, 'kỹ thuật,thở,bơi', 40);

-- Dữ liệu mẫu cho bảng Blog_Comments
INSERT INTO Blog_Comments (blog_id, user_id, content)
VALUES
(1, 4, 'Cảm ơn bài viết rất hữu ích, tôi sẽ bắt đầu học bơi ngay!'),
(2, 4, 'Tôi luôn gặp khó khăn khi thở dưới nước, bài này giúp tôi hiểu rõ hơn.');

-- Dữ liệu mẫu cho bảng Inventory
INSERT INTO Inventory (manager_id, item_name, category, quantity, unit, status, usage_id)
VALUES
(1, 'Phao tròn', 'Phao cứu sinh', 50, 'cái', 'Available', 1),
(1, 'Kính bơi', 'Trang bị cá nhân', 120, 'cái', 'Available', 1),
(1, 'Ghế nằm', 'Thiết bị nghỉ ngơi', 30, 'cái', 'In Use', 4),
(1, 'Đèn chiếu sáng', 'Thiết bị chiếu sáng', 20, 'bóng', 'Maintenance', 4);

-- Dữ liệu mẫu cho bảng Equipment_Rentals
INSERT INTO Equipment_Rentals (customer_name, customer_id_card, staff_id, inventory_id, quantity, rental_date, rent_price, total_amount)
VALUES
('Trần Thị Hương', '123456789', 3, 1, 2, '2025-07-08', 10000, 20000),
('Lê Văn Tâm', '987654321', 3, 2, 1, '2025-07-08', 15000, 15000);

-- Dữ liệu mẫu cho bảng Equipment_Sales
INSERT INTO Equipment_Sales (customer_name, staff_id, inventory_id, quantity, sale_price, total_amount)
VALUES
('Nguyễn Thị Mai', 3, 2, 2, 120000, 240000),
('Phạm Văn Lộc', 3, 4, 1, 80000, 80000);

-- Dữ liệu mẫu cho bảng Payments
INSERT INTO Payments (user_id, amount, method, payment_for, reference_id, status)
VALUES
(4, 1200000, 'Chuyển khoản', 'Course', 1, 'Completed'),
(4, 1500000, 'Tiền mặt', 'Course', 2, 'Completed');

-- Dữ liệu mẫu cho bảng TicketType
INSERT INTO TicketType (type_name, price) VALUES
('Single', 50000.00),
('Monthly', 300000.00),
('ThreeMonthly', 850000.00),
('SixMonthly', 1600000.00),
('Year', 3000000.00);

-- Dữ liệu mẫu cho bảng Ticket
INSERT INTO Ticket (user_id, ticket_type_id, quantity, start_date, end_date, ticket_status, payment_status, payment_id, total, created_at)
VALUES
(4, 2, 1, '2025-07-01', '2025-07-31', 'Active', 'Paid', 1, 300000, '2025-06-30 08:00:00'),
(4, 1, 3, '2025-07-05', '2025-07-05', 'Active', 'Paid', 2, 150000, '2025-07-04 09:00:00');

-- Dữ liệu mẫu cho bảng Tracking
INSERT INTO Tracking (student_id, course_id, progress, coach_feedback)
VALUES
(4, 1, 'Hoàn thành 60% khóa học', 'Học viên tiến bộ tốt, cần luyện thêm kỹ thuật thở.'),
(4, 2, 'Hoàn thành 30% khóa học', 'Học viên chăm chỉ, cần cải thiện sải tay.');

-- Dữ liệu mẫu cho bảng Complaints
INSERT INTO Complaints (user_id, staff_id, content, status)
VALUES
(4, 3, 'Nhiệt độ nước trong hồ bơi quá lạnh vào buổi sáng.', 'Resolved'),
(4, 3, 'Phòng thay đồ có mùi ẩm mốc.', 'In Progress');

-- Dữ liệu mẫu cho bảng Maintenance_Requests
INSERT INTO Maintenance_Requests (description, status, created_by)
VALUES
('Lọc hồ bơi cần được vệ sinh', 'Closed', 2),
('Bóng đèn khu vực hồ B bị hỏng', 'Open', 3);

-- Dữ liệu mẫu cho bảng Maintenance_Schedule
INSERT INTO Maintenance_Schedule (title, description, frequency, assigned_staff_id, scheduled_time, created_by)
VALUES
('Kiểm tra nhà vệ sinh', 'Đảm bảo vệ sinh các bồn cầu và bồn rửa', 'Daily', 3, '08:00:00', 1),
('Vớt rác hồ bơi', 'Loại bỏ lá cây và rác khỏi hồ', 'Daily', 3, '07:30:00', 2);

-- Dữ liệu mẫu cho bảng Maintenance_Log
INSERT INTO Maintenance_Log (schedule_id, staff_id, maintenance_date, note, status)
VALUES
(1, 3, '2025-07-08', 'Nhà vệ sinh được lau dọn sạch sẽ', 'Done'),
(2, 3, '2025-07-08', 'Đã vớt sạch lá cây và rác nổi', 'Done');

-- Dữ liệu mẫu cho bảng Study_Roadmaps
INSERT INTO Study_Roadmaps (title, content, created_by)
VALUES
('Lộ trình từ cơ bản đến nâng cao', 'Tuần 1-2: Học nổi và đập chân
Tuần 3-4: Tập thở và quạt tay
Tuần 5-6: Kết hợp động tác và di chuyển
Tuần 7-8: Rèn luyện sức bền', 3);
