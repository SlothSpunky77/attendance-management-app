create database dbms_project;
use dbms_project;

create table class (
    class_id varchar(3) primary key 
);

insert into class (class_id) values
('1A'), ('1B'),
('2A'), ('2B'),
('3A'), ('3B');

create table student (
    student_id int auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    date_of_birth date,
    gender enum('male', 'female', 'other'),
    class_id varchar(3), 
    password varchar(50), 
    registration_date date,
    foreign key (class_id) references class(class_id) on delete set null
);

create table teacher (
    teacher_id int auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    contact_number varchar(15), 
    password varchar(50), 
    hire_date date
);

create table email_addresses (
    email_id int auto_increment primary key,
    email varchar(100) unique,
    person_type enum('student', 'teacher'), 
    student_id int null, 
    teacher_id int null, 
    foreign key (student_id) references student(student_id) on delete cascade,
    foreign key (teacher_id) references teacher(teacher_id) on delete cascade
);

create table course (
	course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name varchar(100) ,
    course_code varchar(10) unique
);

create table attendance_records (
    attendance_id int auto_increment primary key,
    student_id int,
    class_id varchar(3),
    course_id int,
    attendance_date date,
    timeslot enum('1', '2', '3', '4', '5', '6', '7', '8'), 
    status enum('present', 'absent'), 
    foreign key (student_id) references student(student_id) on delete cascade,
    foreign key (class_id) references class(class_id) on delete cascade,
    foreign key (course_id) references course(course_id) on delete cascade
);

create table course_teacher (
    teacher_id int,
    course_id int,
    primary key (teacher_id, course_id),
    foreign key (teacher_id) references teacher(teacher_id) on delete cascade,
    foreign key (course_id) references course(course_id) on delete cascade
);

insert into student (first_name, last_name, date_of_birth, gender, class_id, password, registration_date) values
-- students for class 1a
('John', 'Doe', '2017-03-12', 'male', '1A', 's1', '2023-09-01'),
('Alice', 'Johnson', '2017-05-21', 'female', '1A', 's2', '2023-09-01'),
('Liam', 'Smith', '2017-06-30', 'male', '1A', 's3', '2023-09-01'),
('Olivia', 'Williams', '2017-07-19', 'female', '1A', 's4', '2023-09-01'),
('Noah', 'Brown', '2017-08-25', 'male', '1A', 's5', '2023-09-01'),
('Emma', 'Jones', '2017-09-12', 'female', '1A', 's6', '2023-09-01'),
('James', 'Garcia', '2017-10-08', 'male', '1A', 's7', '2023-09-01'),
('Sophia', 'Martinez', '2017-11-13', 'female', '1A', 's8', '2023-09-01'),
('William', 'Rodriguez', '2017-12-02', 'male', '1A', 's9', '2023-09-01'),
('Ava', 'Hernandez', '2017-01-10', 'female', '1A', 's10', '2023-09-01'),

-- students for class 1b
('Ethan', 'Lopez', '2017-02-11', 'male', '1B', 's11', '2023-09-01'),
('Mia', 'Gonzalez', '2017-03-23', 'female', '1B', 's12', '2023-09-01'),
('Lucas', 'Wilson', '2017-04-15', 'male', '1B', 's13', '2023-09-01'),
('Amelia', 'Anderson', '2017-05-17', 'female', '1B', 's14', '2023-09-01'),
('Mason', 'Thomas', '2017-06-25', 'male', '1B', 's15', '2023-09-01'),
('Isabella', 'Taylor', '2017-07-30', 'female', '1B', 's16', '2023-09-01'),
('Logan', 'Moore', '2017-08-19', 'male', '1B', 's17', '2023-09-01'),
('Charlotte', 'Jackson', '2017-09-09', 'female', '1B', 's18', '2023-09-01'),
('Benjamin', 'Martin', '2017-10-25', 'male', '1B', 's19', '2023-09-01'),
('Harper', 'Lee', '2017-11-07', 'female', '1B', 's20', '2023-09-01'),

-- students for class 2a
('Elijah', 'White', '2016-04-01', 'male', '2A', 's21', '2022-09-01'),
('Emily', 'Harris', '2016-05-03', 'female', '2A', 's22', '2022-09-01'),
('Aiden', 'Clark', '2016-06-18', 'male', '2A', 's23', '2022-09-01'),
('Scarlett', 'Lewis', '2016-07-12', 'female', '2A', 's24', '2022-09-01'),
('Henry', 'Walker', '2016-08-26', 'male', '2A', 's25', '2022-09-01'),
('Ella', 'Hall', '2016-09-13', 'female', '2A', 's26', '2022-09-01'),
('Jacob', 'Young', '2016-10-21', 'male', '2A', 's27', '2022-09-01'),
('Lily', 'King', '2016-11-30', 'female', '2A', 's28', '2022-09-01'),
('Daniel', 'Scott', '2016-12-05', 'male', '2A', 's29', '2022-09-01'),
('Avery', 'Green', '2016-01-18', 'female', '2A', 's30', '2022-09-01'),

-- students for class 2b
('Matthew', 'Adams', '2016-02-19', 'male', '2B', 's31', '2022-09-01'),
('Chloe', 'Baker', '2016-03-25', 'female', '2B', 's32', '2022-09-01'),
('Sebastian', 'Nelson', '2016-04-14', 'male', '2B', 's33', '2022-09-01'),
('Grace', 'Carter', '2016-05-29', 'female', '2B', 's34', '2022-09-01'),
('Jackson', 'Mitchell', '2016-06-10', 'male', '2B', 's35', '2022-09-01'),
('Zoe', 'Perez', '2016-07-05', 'female', '2B', 's36', '2022-09-01'),
('David', 'Roberts', '2016-08-09', 'male', '2B', 's37', '2022-09-01'),
('Layla', 'Turner', '2016-09-11', 'female', '2B', 's38', '2022-09-01'),
('Michael', 'Phillips', '2016-10-27', 'male', '2B', 's39', '2022-09-01'),
('Penelope', 'Campbell', '2016-11-23', 'female', '2B', 's40', '2022-09-01'),

-- students for class 3a
('Samuel', 'Parker', '2015-05-04', 'male', '3A', 's41', '2021-09-01'),
('Ellie', 'Evans', '2015-06-06', 'female', '3A', 's42', '2021-09-01'),
('Alexander', 'Edwards', '2015-07-20', 'male', '3A', 's43', '2021-09-01'),
('Aria', 'Collins', '2015-08-13', 'female', '3A', 's44', '2021-09-01'),
('Joseph', 'Stewart', '2015-09-07', 'male', '3A', 's45', '2021-09-01'),
('Victoria', 'Sanchez', '2015-10-30', 'female', '3A', 's46', '2021-09-01'),
('Joshua', 'Morris', '2015-11-02', 'male', '3A', 's47', '2021-09-01'),
('Riley', 'Reed', '2015-12-08', 'female', '3A', 's48', '2021-09-01'),
('Andrew', 'Cook', '2015-01-28', 'male', '3A', 's49', '2021-09-01'),
('Maya', 'Bell', '2015-02-15', 'female', '3A', 's50', '2021-09-01'),

-- students for class 3b
('Gabriel', 'Murphy', '2015-03-21', 'male', '3B', 's51', '2021-09-01'),
('Hazel', 'Bailey', '2015-04-10', 'female', '3B', 's52', '2021-09-01'),
('Christopher', 'Rivera', '2015-05-26', 'male', '3B', 's53', '2021-09-01'),
('Aurora', 'Cooper', '2015-06-08', 'female', '3B', 's54', '2021-09-01'),
('Ryan', 'Richardson', '2015-07-19', 'male', '3B', 's55', '2021-09-01'),
('Hannah', 'Cox', '2015-08-31', 'female', '3B', 's56', '2021-09-01'),
('Caleb', 'Howard', '2015-09-15', 'male', '3B', 's57', '2021-09-01'),
('Lillian', 'Ward', '2015-10-03', 'female', '3B', 's58', '2021-09-01'),
('Dylan', 'Torres', '2015-11-25', 'male', '3B', 's59', '2021-09-01'),
('Sophie', 'Peterson', '2015-12-15', 'female', '3B', 's60', '2021-09-01');

insert into teacher (first_name, last_name, contact_number, password, hire_date) values
('Elizabeth', 'Watson', '123-456-7890', 'teacher1', '2018-06-01'),
('Jacob', 'Taylor', '234-567-8901', 'teacher2', '2019-08-15'),
('Emily', 'Brown', '345-678-9012', 'teacher3', '2020-09-20');

insert into course (course_name, course_code) values
('Mathematics', 'MATH101'),
('Science', 'SCI102'),
('English', 'ENG103');

insert into course_teacher (teacher_id, course_id) values
(1, 1),
(2, 2),
(3, 1);