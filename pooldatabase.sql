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
    role_id INT default 4,
    profile_picture VARCHAR(255) DEFAULT NULL,
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


CREATE TABLE Inventory_usage(
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    usage_name varchar(100),
    last_updated datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Iventory
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
   customer_name VARCHAR(100) NOT NULL,          -- Tên khách hàng
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
    customer_name VARCHAR(100) NOT NULL,          -- Tên khách hàng
    staff_id INT NOT NULL,
    inventory_id INT NOT NULL,
    quantity INT NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES Users(id),
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
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

-- Maintenance Schedule table
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

-- Maintenance Log table
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

-- Insert fake data for Feedbacks table
INSERT INTO Feedbacks (user_id, feedback_type, coach_id, course_id, general_feedback_type, content, rating) VALUES
(6, 'Course', NULL, 1, NULL, 'Great course for beginners! I learned a lot.', 5),
(7, 'Coach', 3, NULL, NULL, 'Mike is an excellent coach, very patient and knowledgeable.', 5),
(8, 'General', NULL, NULL, 'Facility', 'The pool area is always clean and well-maintained.', 4),
(9, 'Course', NULL, 4, NULL, 'The competitive swimming course is challenging but rewarding.', 4),
(10, 'General', NULL, NULL, 'Service', 'The staff is friendly and helpful.', 5),
(6, 'General', NULL, NULL, 'Food', 'The snack bar offers healthy options.', 3);

-- Insert more fake data for FeedbackReplies table
INSERT INTO FeedbackReplies (feedback_id, user_id, content) VALUES
-- Replies to feedback #1 (Course feedback from user 6)
(1, 3, 'Thank you for the positive feedback! I\'m glad the beginner course was helpful for you.'),
(1, 2, 'We appreciate your review. Keep up the great work in your swimming journey!'),
(1, 6, 'Thanks Mike! Looking forward to the intermediate course next month.'),
(1, 4, 'That\'s wonderful to hear! The beginner course is designed to build confidence.'),
(1, 6, 'Absolutely! I feel so much more confident in the water now.'),

-- Replies to feedback #2 (Coach feedback about Mike from user 7)
(2, 3, 'Thank you so much! It\'s always rewarding to help students improve their swimming skills.'),
(2, 7, 'You\'re the best coach! Thanks for being so patient with my technique.'),
(2, 2, 'Mike is indeed one of our most dedicated coaches. Great to see this feedback!'),
(2, 4, 'Collaboration between coaches helps us all improve. Well done Mike!'),

-- Replies to feedback #3 (General facility feedback from user 8)
(3, 5, 'Thank you for noticing! Our maintenance team works hard to keep everything clean.'),
(3, 2, 'We take pride in maintaining high standards for our facilities.'),
(3, 8, 'Keep up the excellent work! The pool area always looks spotless.'),
(3, 6, 'I agree! The cleanliness here is outstanding compared to other facilities.'),
(3, 10, 'The attention to detail really shows. Thank you for maintaining such high standards.'),

-- Replies to feedback #4 (Competitive course feedback from user 9)
(4, 4, 'I\'m thrilled you\'re enjoying the competitive program! You\'re making excellent progress.'),
(4, 9, 'Thanks Lisa! The training is intense but I can feel myself getting stronger.'),
(4, 3, 'The competitive program is challenging but very rewarding. Keep pushing!'),
(4, 2, 'We\'re proud of all our competitive swimmers. Great dedication!'),

-- Replies to feedback #5 (Service feedback from user 10)
(5, 5, 'We really appreciate your kind words! Our team strives to provide the best service.'),
(5, 2, 'Thank you for taking the time to share your positive experience.'),
(5, 6, 'The staff here is always so helpful and friendly!'),
(5, 7, 'I second this! Everyone here makes you feel welcome.'),

-- Replies to feedback #6 (Food feedback from user 6)
(6, 2, 'Thank you for the feedback. We\'re always looking to improve our snack bar offerings.'),
(6, 6, 'Maybe consider adding more protein options for post-workout meals?'),
(6, 5, 'We\'ll pass your suggestion to our food service team. Thanks for the input!'),
(6, 9, 'More protein bars and shakes would be great after intense training sessions.'),
(6, 10, 'Some fresh fruit options would also be nice!');

-- Insert additional Blogs
INSERT INTO Blogs (title, content, author_id, course_id, tags, likes) VALUES
('Winter Swimming: Staying Motivated During Cold Months', 'As temperatures drop, maintaining your swimming routine can be challenging. Here are proven strategies to stay motivated during winter months:\n\n1. Set indoor goals and challenges\n2. Focus on technique improvement\n3. Join group training sessions\n4. Track your progress with apps\n5. Reward yourself for consistency\n\nRemember, consistency beats intensity. Even shorter sessions are better than no sessions at all!', 3, NULL, 'winter,motivation,consistency,training', 19),

('Breathing Techniques for Better Performance', 'Proper breathing is fundamental to swimming efficiency. Many swimmers struggle with breathing rhythm, which can limit their performance and endurance.\n\nKey breathing principles:\n- Exhale underwater through nose and mouth\n- Turn head, don\'t lift it\n- Practice bilateral breathing\n- Maintain steady rhythm\n- Don\'t hold your breath\n\nMaster these basics and watch your swimming transform!', 4, 2, 'breathing,technique,performance,fundamentals', 34),

('Pool Etiquette: Sharing Lanes Respectfully', 'Swimming in shared lanes requires courtesy and awareness. Here\'s your guide to pool etiquette:\n\n**Lane Selection:**\n- Choose appropriate speed lane\n- Ask before joining occupied lane\n- Observe posted lane directions\n\n**Swimming Protocol:**\n- Stay to the right side\n- Pass on the left when faster\n- Rest at lane ends, not middle\n- Use equipment considerately\n\nGood etiquette creates a pleasant environment for everyone!', 2, NULL, 'etiquette,pool-rules,courtesy,sharing', 26),

('Swimming Gear Essentials for Beginners', 'Starting your swimming journey? Here\'s what you really need versus what\'s nice to have:\n\n**Essential Gear:**\n- Proper fitting swimsuit\n- Goggles (most important!)\n- Towel and water bottle\n\n**Helpful Additions:**\n- Kickboard for technique practice\n- Pull buoy for arm strength\n- Swim cap for hair protection\n- Waterproof watch for timing\n\nStart simple, add equipment as you progress!', 3, 1, 'gear,equipment,beginners,essentials', 22),

('Overcoming Fear of Deep Water', 'Water anxiety is more common than you think. If deep water makes you nervous, you\'re not alone. Here\'s how to build confidence:\n\n**Gradual Exposure:**\n- Start in shallow end\n- Practice floating with support\n- Use flotation aids initially\n- Focus on breathing control\n\n**Mental Techniques:**\n- Visualization exercises\n- Positive self-talk\n- Set small, achievable goals\n- Celebrate every success\n\nRemember: every expert was once a beginner!', 3, NULL, 'fear,anxiety,confidence,mental-health', 41),

('Swimming Injuries: Prevention and Recovery', 'Swimming is low-impact, but injuries can still occur. Most swimming injuries are preventable with proper technique and preparation.\n\n**Common Issues:**\n- Shoulder impingement\n- Lower back strain  \n- Knee pain from breaststroke\n- Neck tension\n\n**Prevention Tips:**\n- Warm up thoroughly\n- Focus on proper technique\n- Strengthen supporting muscles\n- Listen to your body\n- Don\'t ignore pain\n\nWhen in doubt, consult a healthcare professional!', 4, NULL, 'injury,prevention,health,recovery,safety', 18),

('The Benefits of Open Water Swimming', 'Ready to take your swimming beyond the pool? Open water swimming offers unique challenges and rewards:\n\n**Physical Benefits:**\n- Full-body workout in varied conditions\n- Improved navigation skills\n- Enhanced mental toughness\n- Connection with nature\n\n**Getting Started:**\n- Master pool swimming first\n- Start in calm, supervised waters\n- Swim with experienced partners\n- Use proper safety equipment\n- Check weather and water conditions\n\nOpen water swimming can transform your relationship with the sport!', 4, 3, 'open-water,nature,adventure,challenge', 29);

-- Insert fake data for Blog_Comments table  
INSERT INTO Blog_Comments (blog_id, user_id, content) VALUES
-- Comments on Blog #1 (Benefits of Swimming) - 5 comments
(1, 6, 'This article really motivated me to start swimming regularly! Thanks for sharing.'),
(1, 7, 'I never realized swimming worked so many muscle groups. Great information!'),
(1, 8, 'As someone who just started swimming, this is very encouraging.'),
(1, 10, 'Swimming has changed my life. Best decision I ever made for my health.'),
(1, 9, 'Swimming has helped me recover from a knee injury. Low-impact is perfect!'),

-- Comments on Blog #2 (Preparing for Your First Competition) - 4 comments
(2, 9, 'Perfect timing! I have my first competition next month. These tips are gold.'),
(2, 7, 'The mental preparation section is so helpful. I get nervous before races.'),
(2, 4, 'Great advice! I wish I had read this before my first competition years ago.'),
(2, 8, 'The pre-race routine section helped calm my nerves significantly.'),

-- Comments on Blog #3 (Water Safety Tips for Summer) - 5 comments
(3, 6, 'Every parent should read this. Water safety is so important.'),
(3, 10, 'Sharing this with my family. These tips could save lives.'),
(3, 8, 'The section about recognizing drowning signs is eye-opening.'),
(3, 9, 'Shared this with my entire family. Water safety can\'t be emphasized enough.'),
(3, 4, 'Every coach should share these tips with their students.'),

-- Comments on Blog #4 (Nutrition for Swimmers) - 4 comments
(4, 9, 'I\'ve been struggling with what to eat before practice. This helps a lot!'),
(4, 7, 'The post-workout meal suggestions are perfect. Thanks coach!'),
(4, 6, 'Never thought about timing my meals around swimming. Will try this.'),
(4, 8, 'The hydration tips are spot on. I used to underestimate water intake.'),

-- Comments on Blog #5 (Improving Your Freestyle Technique) - 5 comments
(5, 8, 'The step-by-step breakdown is excellent. Finally understand the catch phase!'),
(5, 6, 'My freestyle has improved so much after following these tips.'),
(5, 10, 'The video references would be helpful too. Any plans for that?'),
(5, 7, 'My stroke efficiency improved dramatically after following this guide.'),
(5, 9, 'The catch phase explanation finally made sense to me!'),

-- Comments on Blog #6 (Common Swimming Mistakes to Avoid) - 4 comments
(6, 7, 'Guilty of mistake #2! Working on keeping my head down now.'),
(6, 9, 'This list is spot on. I made all these mistakes when I started.'),
(6, 6, 'Wish I had read this when I first learned to swim. Would have saved time!'),
(6, 8, 'Guilty of all five mistakes when I started! This would have saved me months.'),

-- Comments on Blog #7 (The Science Behind Swimming Efficiency) - 5 comments
(7, 8, 'Fascinating read! The physics explanation makes so much sense.'),
(7, 9, 'This scientific approach really helps me understand the \'why\' behind technique.'),
(7, 6, 'The physics explanation helps me understand why technique matters so much.'),
(7, 10, 'This scientific approach makes swimming more interesting and logical.'),
(7, 4, 'Excellent breakdown of complex concepts in simple terms!');

-- Insert more Blog Comments
INSERT INTO Blog_Comments (blog_id, user_id, content) VALUES
-- Additional comments on existing blogs for more engagement
-- Benefits of Swimming blog
(1, 9, 'Swimming has helped me recover from a knee injury. Low-impact is perfect!'),
(1, 4, 'Great to see such positive responses! Swimming truly is for everyone.'),

-- Preparing for Competition blog
(2, 8, 'The pre-race routine section helped calm my nerves significantly.'),
(2, 6, 'Mental preparation is just as important as physical training!'),

-- Water Safety blog
(3, 9, 'Shared this with my entire family. Water safety can\'t be emphasized enough.'),
(3, 4, 'Every coach should share these tips with their students.'),

-- Nutrition blog
(4, 8, 'The hydration tips are spot on. I used to underestimate water intake.'),
(4, 10, 'Post-workout nutrition timing has improved my recovery so much!'),

-- Freestyle Technique blog
(5, 7, 'My stroke efficiency improved dramatically after following this guide.'),
(5, 9, 'The catch phase explanation finally made sense to me!'),

-- Common Mistakes blog
(6, 8, 'Guilty of all five mistakes when I started! This would have saved me months.'),
(6, 10, 'The body rotation tip was eye-opening. Game changer!'),

-- Science Behind Swimming blog
(7, 6, 'The physics explanation helps me understand why technique matters so much.'),
(7, 10, 'This scientific approach makes swimming more interesting and logical.');

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

INSERT INTO Inventory (manager_id, item_name, category, quantity, unit, status, last_updated, usage_id)
VALUES
  (1, 'Gậy bơi', 'Thiết bị tập luyện', 100, 'cây', 'Available', NOW(), 1),
  (1, 'Phao tròn', 'Phao cứu sinh', 50, 'cái', 'Available', NOW(), 1),
  (1, 'Ghế nằm', 'Thiết bị nghỉ ngơi', 30, 'cái', 'In Use', NOW(), 4),
  (1, 'Phao tay', 'Phao cứu sinh', 80, 'cái', 'Available', NOW(), 1),
  (1, 'Đèn chiếu sáng', 'Thiết bị chiếu sáng', 20, 'bóng', 'Maintenance', NOW(), 4),
  (1, 'Khăn tắm', 'Tiện ích', 200, 'cái', 'Available', NOW(), 1),
  (1, 'Dép nhựa', 'Tiện ích', 150, 'đôi', 'Available', NOW(), 1),
  (1, 'Kính bơi', 'Trang bị cá nhân', 120, 'cái', 'Available', NOW(), 1),
  (1, 'Đồ bơi nam', 'Trang phục', 70, 'bộ', 'Available', NOW(), 1),
  (1, 'Đồ bơi nữ', 'Trang phục', 60, 'bộ', 'Available', NOW(), 1);

-- Insert fake data for Complaints table
INSERT INTO Complaints (user_id, staff_id, content, status) VALUES
(7, 5, 'The water temperature was too cold during my last session.', 'Resolved'),
(8, 5, 'The changing rooms need better ventilation.', 'In Progress'),
(9, 5, 'One of the showers is not working properly.', 'New');

-- Insert sample daily maintenance schedules
INSERT INTO Maintenance_Schedule (title, description, frequency, assigned_staff_id, scheduled_time, created_by)
VALUES
('Check Bathroom Cleanliness', 'Ensure all toilets and sinks are clean', 'Daily', 5, '08:00:00', 1),
('Clean Pool Trash', 'Remove debris from pool and surroundings', 'Daily', 5, '07:30:00', 2),
('Check Locker Rooms', 'Inspect and clean locker rooms', 'Daily', 5, '09:00:00', 1);

-- Insert sample maintenance logs
INSERT INTO Maintenance_Log (schedule_id, staff_id, maintenance_date, note, status)
VALUES
(1, 5, '2025-06-22', 'All bathrooms clean', 'Done'),
(2, 5, '2025-06-22', 'Removed leaves and plastic bottles', 'Done'),
(3, 5, '2025-06-22', 'Locker room floor mopped and cleaned properly', 'Done');