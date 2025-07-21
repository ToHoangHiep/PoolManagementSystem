Drop database swimming_pool_management;
CREATE DATABASE swimming_pool_management;
USE swimming_pool_management;
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
CREATE TABLE Classes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    coach_id INT,
    name VARCHAR(100),
    description TEXT,
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

CREATE TABLE Schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT,
    coach_id INT,
    weekday VARCHAR(50),
    location VARCHAR(100),
    FOREIGN KEY (class_id) REFERENCES Classes(id),
    FOREIGN KEY (coach_id) REFERENCES Coaches(id)
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
    payment_id INT,
    total DECIMAL(10,2),
    created_at DATETIME,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (payment_id) REFERENCES Payments(id),
    FOREIGN KEY (ticket_type_id) REFERENCES TicketType(id)
);
CREATE TABLE Inventory_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    usage_name VARCHAR(100),
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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
    category VARCHAR(100),
    quantity INT,
    unit VARCHAR(100),
    status ENUM('Available', 'In Use', 'Maintenance', 'Broken'),
    rent_price DECIMAL(10,2) DEFAULT 0,
    sale_price DECIMAL(10,2) DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usage_id INT,
    FOREIGN KEY (usage_id) REFERENCES Inventory_usage(usage_id),
    FOREIGN KEY (manager_id) REFERENCES Users(id)
);





CREATE TABLE Equipment_Rentals (
    rental_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    customer_id_card VARCHAR(20),
    staff_id INT,
    inventory_id INT,
    quantity INT,
    rental_date DATE,
    rent_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    status ENUM('active', 'returned') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_time TIMESTAMP NULL,
    FOREIGN KEY (staff_id) REFERENCES Users(id),
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
);

CREATE TABLE Equipment_Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    staff_id INT,
    inventory_id INT,
    quantity INT,
    sale_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
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


-- Blog
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

-- Blog Comments
CREATE TABLE Blog_Comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    blog_id INT,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (blog_id) REFERENCES Blogs(id),
    FOREIGN KEY (user_id) REFERENCES Users(id)
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
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (payment_id) REFERENCES Payments(id),
    FOREIGN KEY (ticket_type_id) REFERENCES TicketType(id)
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
-- Maintenance Schedule table
CREATE TABLE Maintenance_Schedule (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
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
CREATE TABLE Study_Roadmaps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    content TEXT,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);
-- Roles
INSERT INTO Roles (id, name) VALUES
(1, 'Admin'), (2, 'Quản lý'), (3, 'Khách hàng'), (4, 'Nhân viên');