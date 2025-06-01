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
    last_updated datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    foreign key (manager_id) references users(id)

);

-- Feedbacks
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