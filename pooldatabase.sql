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

CREATE TABLE Maintenance_Schedule (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
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
-- Roles
INSERT INTO Roles (id, name) VALUES
(1, 'Admin'), (2, 'Quản lý'), (3, 'Khách hàng'), (4, 'Nhân viên');

-- Users
INSERT INTO Users (full_name, email, password_hash, phone_number, address, dob, gender, role_id, user_status)
VALUES
('Nguyễn Văn A', 'admin@example.com', 'hash_pass', '0901000001', '123 Lê Lợi, HCM', '1985-05-15', 'Male', 1, 'Active'),
('Trần Thị B', 'manager@example.com', 'hash_pass', '0901000002', '456 Hai Bà Trưng, HCM', '1990-07-20', 'Female', 2, 'Active'),
('Lê Văn C', 'staff@example.com', 'hash_pass', '0901000003', '789 Nguyễn Huệ, HCM', '1995-12-01', 'Male', 4, 'Active'),
('Nguyễn Thị D', 'user1@example.com', 'hash_pass', '0901000004', '101 Trường Chinh, HCM', '2000-01-01', 'Female', 3, 'Active');

-- UserCode
INSERT INTO UserCode (user_id, user_code, created_at)
VALUES
(1, 'AC123456', NOW()), (2, 'BC654321', NOW()), (3, 'XY999888', NOW()), (4, 'TT000111', NOW());

-- Coaches
INSERT INTO Coaches (full_name, email, phone_number, gender, bio, profile_picture)
VALUES
('Lê Văn Cường', 'coach.cuong@example.com', '0908000001', 'Male', '10 năm kinh nghiệm huấn luyện.', 'cuong.jpg'),
('Nguyễn Thị Mai', 'coach.mai@example.com', '0908000002', 'Female', 'Chuyên trị liệu dưới nước.', 'mai.jpg');

-- Courses
INSERT INTO Courses (name, description, price, duration, estimated_session_time, student_description, schedule_description, status)
VALUES
('Bơi cơ bản', 'Khóa học bơi cho người mới bắt đầu.', 1000000, 10, '1h', '5 người/lớp', 'Thứ 2 - 4 - 6', 'Inactive'),
('Bơi nâng cao', 'Cải thiện kỹ năng bơi.', 1500000, 12, '1h30', '3 người/lớp', 'Linh hoạt', 'Inactive');

-- Classes
INSERT INTO Classes (course_id, coach_id, name, description, student_limit, status, schedule)
VALUES
(1, 1, 'Lớp Bơi 1', 'Sáng Thứ 2 - 4 - 6', 5, 'Chưa khai giảng', 'Thứ 2 - 4 - 6'),
(2, 2, 'Lớp Bơi 2', 'Lịch linh hoạt theo yêu cầu', 3, 'Đang học', 'Linh hoạt');

-- Class_Registrations
INSERT INTO Class_Registrations (user_id, class_id, status)
VALUES
(4, 1, 'Approved'),
(4, 2, 'Pending');

-- Schedules
INSERT INTO Schedules (class_id, coach_id, weekday, location)
VALUES
(1, 1, 'Thứ 2, 4, 6', 'Bể bơi Trung Tâm'),
(2, 2, 'Linh hoạt', 'Bể bơi Linh Đàm');
INSERT INTO Payments (user_id, amount, method, payment_for, reference_id, status)
VALUES
(4, 1000000, 'Chuyển khoản', 'Course', 1, 'Completed'),
(4, 1500000, 'Tiền mặt', 'Course', 2, 'Completed');

INSERT INTO TicketType (type_name, price)
VALUES
('Single', 50000), ('Monthly', 300000);

INSERT INTO Ticket (user_id, ticket_type_id, quantity, start_date, end_date, ticket_status, payment_status, payment_id, total, created_at)
VALUES
(4, 1, 1, '2025-07-01', '2025-07-01', 'Active', 'Paid', 1, 50000, '2025-06-30 08:00:00'),
(4, 2, 1, '2025-07-01', '2025-07-31', 'Active', 'Paid', 2, 300000, '2025-06-30 08:30:00');
INSERT INTO Inventory_usage (usage_name) VALUES
('Dụng cụ cho thuê'), ('Đang bảo trì'), ('Dụng cụ bán'), ('Thiết bị cơ sở vật chất');

INSERT INTO Inventory (manager_id, item_name, category, quantity, unit, status, usage_id)
VALUES
(1, 'Phao bơi', 'Phao cứu sinh', 50, 'cái', 'Available', 1),
(2, 'Kính bơi', 'Trang bị cá nhân', 30, 'cái', 'Available', 1);

INSERT INTO Equipment_Rentals (customer_name, customer_id_card, staff_id, inventory_id, quantity, rental_date, rent_price, total_amount)
VALUES
('Ngô Thị Hồng', '123456789', 3, 1, 2, '2025-07-10', 10000, 20000);

INSERT INTO Equipment_Sales (customer_name, staff_id, inventory_id, quantity, sale_price, total_amount)
VALUES
('Phạm Văn Hưng', 3, 2, 1, 120000, 120000);
INSERT INTO Blogs (title, content, author_id, course_id, tags, likes)
VALUES ('Tại sao nên học bơi?', 'Học bơi giúp bạn tăng cường sức khỏe và sự tự tin.', 3, 1, 'bơi,sức khỏe', 10);

INSERT INTO Blog_Comments (blog_id, user_id, content)
VALUES (1, 4, 'Bài viết rất hay, cảm ơn tác giả!');

INSERT INTO Feedbacks (user_id, feedback_type, coach_id, course_id, general_feedback_type, content, rating)
VALUES
(4, 'Course', NULL, 1, NULL, 'Khóa học chất lượng.', 5),
(4, 'Coach', 1, NULL, NULL, 'Huấn luyện viên rất tận tâm.', 4),
(4, 'General', NULL, NULL, 'Facility', 'Cơ sở vật chất tốt.', 4);

INSERT INTO FeedbackReplies (feedback_id, user_id, content)
VALUES (1, 1, 'Cảm ơn bạn đã phản hồi tích cực!');
INSERT INTO Complaints (user_id, staff_id, content, status)
VALUES (4, 3, 'Bể bơi hơi lạnh vào buổi sáng.', 'Resolved');

INSERT INTO Maintenance_Requests (description, status, created_by)
VALUES ('Đèn ở bể bơi bị hỏng.', 'Open', 3);

INSERT INTO Maintenance_Schedule (title, description, frequency, assigned_staff_id, scheduled_time, created_by)
VALUES ('Vệ sinh bể bơi', 'Dọn rác và làm sạch bể.', 'Daily', 3, '06:00:00', 1);

INSERT INTO Maintenance_Log (schedule_id, staff_id, maintenance_date, note, status)
VALUES (1, 3, '2025-07-10', 'Đã vệ sinh sạch sẽ.', 'Done');

INSERT INTO Study_Roadmaps (title, content, created_by)
VALUES ('Lộ trình học 8 tuần', 'Tuần 1-2: Làm quen nước\nTuần 3-4: Kỹ thuật nổi\nTuần 5-6: Quạt tay, thở\nTuần 7-8: Kết hợp toàn thân', 3);
