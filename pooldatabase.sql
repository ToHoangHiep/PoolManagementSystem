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
    profile_picture VARCHAR(255) DEFAULT NULL,
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
    student_limit INT DEFAULT 2,
    coach_id INT,
    status ENUM('Active', 'Inactive', 'Full'),
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

INSERT INTO Inventory_usage(usage_name)
VALUES 
  ('item for rent'),
  ('item for maintannance'),
  ('item for sold'),
  ('item for facility');

-- Blog
CREATE TABLE Blogs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    content TEXT,
    author_id INT,
    course_id INT,
    tags VARCHAR(255),
    likes INT DEFAULT 0,
    published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
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

-- Add INSERT HERE

-- Insert fake data for Users table
INSERT INTO Users (full_name, email, password_hash, phone_number, address, dob, gender, role_id, user_status) VALUES
('John Admin', 'admin@pool.com', 'hashed_password_123', '1234567890', '123 Admin St, City', '1985-05-15', 'Male', 1, 'Active'),
('Sarah Manager', 'manager@pool.com', 'hashed_password_456', '2345678901', '456 Manager Ave, City', '1988-08-20', 'Female', 2, 'Active'),
('Mike Coach', 'coach1@pool.com', 'hashed_password_789', '3456789012', '789 Coach Blvd, City', '1990-03-10', 'Male', 3, 'Active'),
('Lisa Coach', 'coach2@pool.com', 'hashed_password_101', '4567890123', '101 Coach Lane, City', '1992-07-25', 'Female', 3, 'Active'),
('Tom Staff', 'staff@pool.com', 'hashed_password_112', '5678901234', '112 Staff Rd, City', '1995-11-05', 'Male', 5, 'Active'),
('Emma Customer', 'customer1@example.com', 'hashed_password_131', '6789012345', '131 Customer St, City', '1998-01-30', 'Female', 4, 'Active'),
('David Customer', 'customer2@example.com', 'hashed_password_415', '7890123456', '415 Customer Ave, City', '2000-09-12', 'Male', 4, 'Active'),
('Sophia Customer', 'customer3@example.com', 'hashed_password_617', '8901234567', '617 Customer Blvd, City', '1997-04-18', 'Female', 4, 'Active'),
('James Customer', 'customer4@example.com', 'hashed_password_819', '9012345678', '819 Customer Lane, City', '1999-12-05', 'Male', 4, 'Active'),
('Olivia Customer', 'customer5@example.com', 'hashed_password_921', '0123456789', '921 Customer Rd, City', '2001-06-22', 'Female', 4, 'Active');

-- Insert fake data for Courses table
INSERT INTO Courses (name, description, price, duration, coach_id, status) VALUES
('Beginner Swimming', 'Learn the basics of swimming for beginners', 199.99, 30, 3, 'Active'),
('Intermediate Swimming', 'Improve your swimming techniques', 249.99, 45, 3, 'Active'),
('Advanced Swimming', 'Master advanced swimming techniques', 299.99, 60, 4, 'Active'),
('Competitive Swimming', 'Training for competitive swimmers', 349.99, 90, 4, 'Active'),
('Water Safety', 'Learn essential water safety skills', 149.99, 15, 3, 'Active');

-- Insert fake data for Course_Registrations table
INSERT INTO Course_Registrations (user_id, course_id, status) VALUES
(6, 1, 'Approved'),
(7, 2, 'Approved'),
(8, 3, 'Pending'),
(9, 4, 'Approved'),
(10, 5, 'Cancelled'),
(6, 3, 'Approved'),
(7, 1, 'Approved'),
(8, 2, 'Approved');

-- Insert fake data for UserCode table
INSERT INTO UserCode (user_id, user_code, created_at) VALUES
(6, 'ABC12345', '2023-05-15 10:30:00'),
(7, 'DEF67890', '2023-05-16 11:45:00'),
(8, 'GHI13579', '2023-05-17 09:15:00');

-- Insert fake data for Inventory table
INSERT INTO Inventory (manager_id, item_name, category, quantity, unit, status) VALUES
(2, 'Swimming Goggles', 'Equipment', 50, 'Piece', 'Available'),
(2, 'Swimming Caps', 'Equipment', 75, 'Piece', 'Available'),
(2, 'Kickboards', 'Training', 30, 'Piece', 'Available'),
(2, 'Pull Buoys', 'Training', 25, 'Piece', 'Available'),
(2, 'Swim Fins', 'Training', 20, 'Pair', 'In Use'),
(2, 'Lane Ropes', 'Facility', 10, 'Piece', 'Available'),
(2, 'Cleaning Chemicals', 'Maintenance', 15, 'Bottle', 'Available');

-- Insert fake data for Feedbacks table
INSERT INTO Feedbacks (user_id, feedback_type, coach_id, course_id, general_feedback_type, content, rating) VALUES
(6, 'Course', NULL, 1, NULL, 'Great course for beginners! I learned a lot.', 5),
(7, 'Coach', 3, NULL, NULL, 'Mike is an excellent coach, very patient and knowledgeable.', 5),
(8, 'General', NULL, NULL, 'Facility', 'The pool area is always clean and well-maintained.', 4),
(9, 'Course', NULL, 4, NULL, 'The competitive swimming course is challenging but rewarding.', 4),
(10, 'General', NULL, NULL, 'Service', 'The staff is friendly and helpful.', 5),
(6, 'General', NULL, NULL, 'Food', 'The snack bar offers healthy options.', 3);

-- Insert fake data for Complaints table
INSERT INTO Complaints (user_id, staff_id, content, status) VALUES
(7, 5, 'The water temperature was too cold during my last session.', 'Resolved'),
(8, 5, 'The changing rooms need better ventilation.', 'In Progress'),
(9, 5, 'One of the showers is not working properly.', 'New');

-- Insert fake data for Schedules table
INSERT INTO Schedules (course_id, coach_id, start_time, end_time, location) VALUES
(1, 3, '2023-06-05 09:00:00', '2023-06-05 10:00:00', 'Pool A'),
(2, 3, '2023-06-05 11:00:00', '2023-06-05 12:30:00', 'Pool B'),
(3, 4, '2023-06-05 14:00:00', '2023-06-05 15:30:00', 'Pool A'),
(4, 4, '2023-06-06 09:00:00', '2023-06-06 11:00:00', 'Pool C'),
(5, 3, '2023-06-06 13:00:00', '2023-06-06 14:00:00', 'Pool B'),
(1, 3, '2023-06-07 09:00:00', '2023-06-07 10:00:00', 'Pool A');

-- Insert fake data for Maintenance_Requests table
INSERT INTO Maintenance_Requests (description, status, created_by) VALUES
('Pool filter needs cleaning', 'Closed', 2),
('Leak in the men\'s changing room', 'In Progress', 5),
('Light fixture broken near Pool B', 'Open', 3);

-- Insert fake data for Payments table
INSERT INTO Payments (user_id, amount, method, payment_for, reference_id, status) VALUES
(6, 199.99, 'Credit Card', 'Course', 1, 'Completed'),
(7, 249.99, 'PayPal', 'Course', 2, 'Completed'),
(8, 299.99, 'Bank Transfer', 'Course', 3, 'Pending'),
(9, 349.99, 'Credit Card', 'Course', 4, 'Completed'),
(10, 149.99, 'Cash', 'Course', 5, 'Completed'),
(6, 299.99, 'Credit Card', 'Course', 3, 'Completed');

-- Insert fake data for Tracking table
INSERT INTO Tracking (student_id, course_id, progress, coach_feedback) VALUES
(6, 1, 'Completed 60% of the course', 'Good progress, needs to work on breathing technique'),
(7, 2, 'Completed 45% of the course', 'Improving steadily, focus on arm movement'),
(8, 3, 'Completed 30% of the course', 'Excellent form, continue practicing turns'),
(9, 4, 'Completed 70% of the course', 'Outstanding progress, ready for competition soon');

-- Insert fake data for Blogs table
INSERT INTO Blogs (title, content, author_id) VALUES
('Benefits of Swimming', 'Swimming is one of the best full-body workouts...', 3),
('Preparing for Your First Competition', 'Tips and tricks to prepare for your first swimming competition...', 4),
('Water Safety Tips for Summer', 'As summer approaches, it\'s important to remember these water safety tips...', 2),
('Nutrition for Swimmers', 'What to eat before and after swimming sessions for optimal performance...', 3),
('Improving Your Freestyle Technique', 'Step-by-step guide to perfecting your freestyle swimming technique...', 4);

-- Insert fake data for Ticket table
INSERT INTO Ticket (user_id, ticket_type_id, quantity, start_date, end_date, ticket_status, payment_status, payment_id, total, created_at) VALUES
(6, 2, 1, '2023-06-01', '2023-06-30', 'Active', 'Paid', 1, 300000.00, '2023-05-30 14:25:00'),
(7, 1, 5, '2023-06-02', '2023-06-02', 'Active', 'Paid', 2, 250000.00, '2023-06-01 09:30:00'),
(8, 3, 1, '2023-06-01', '2023-08-31', 'Active', 'Paid', 3, 850000.00, '2023-05-29 11:45:00'),
(9, 2, 1, '2023-06-01', '2023-06-30', 'Active', 'Paid', 4, 300000.00, '2023-05-30 16:20:00'),
(10, 1, 3, '2023-06-03', '2023-06-03', 'Active', 'Paid', 5, 150000.00, '2023-06-02 10:15:00');

-- Insert fake data for Study_Roadmaps table
INSERT INTO Study_Roadmaps (title, content, created_by) VALUES
('Beginner to Intermediate Swimmer', 'Week 1-4: Focus on basic techniques...\nWeek 5-8: Introduce different strokes...', 3),
('Competitive Swimming Preparation', 'Month 1: Build endurance...\nMonth 2: Speed training...\nMonth 3: Competition strategies...', 4),
('Water Safety Certification Path', 'Step 1: Basic water safety...\nStep 2: Rescue techniques...\nStep 3: First aid certification...', 2);
