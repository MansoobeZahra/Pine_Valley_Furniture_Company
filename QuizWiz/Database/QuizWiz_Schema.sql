-- ============================================
-- QuizWiz Database Schema
-- Drop and recreate database
-- ============================================
USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'QuizWizDB')
BEGIN
    ALTER DATABASE QuizWizDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QuizWizDB;
END
GO
CREATE DATABASE QuizWizDB;
GO
USE QuizWizDB;
GO

-- ============================================
-- TABLE: Subjects
-- ============================================
CREATE TABLE Subjects (
    SubjectID   INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(100) NOT NULL
);

-- ============================================
-- TABLE: Users2
-- ============================================
CREATE TABLE Users2 (
    UserID    INT IDENTITY(1,1) PRIMARY KEY,
    FullName  NVARCHAR(100) NOT NULL,
    Username  NVARCHAR(50)  NOT NULL UNIQUE,
    Password  NVARCHAR(100) NOT NULL,
    Role      NVARCHAR(20)  NOT NULL CHECK (Role IN ('Admin','Teacher','Student')),
    SubjectID INT NULL REFERENCES Subjects(SubjectID),
    IsActive  BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- TABLE: QuestionsTable
-- ============================================
CREATE TABLE QuestionsTable (
    QuestionID        INT IDENTITY(1,1) PRIMARY KEY,
    SubjectID         INT          NOT NULL REFERENCES Subjects(SubjectID),
    QuestionStatement NVARCHAR(MAX) NOT NULL,
    OptionA           NVARCHAR(500) NOT NULL,
    OptionB           NVARCHAR(500) NOT NULL,
    OptionC           NVARCHAR(500) NOT NULL,
    OptionD           NVARCHAR(500) NOT NULL,
    CorrectOption     CHAR(1)       NOT NULL CHECK (CorrectOption IN ('A','B','C','D')),
    DifficultyLevel   NVARCHAR(20)  NOT NULL DEFAULT 'Medium'
                        CHECK (DifficultyLevel IN ('Easy','Medium','Hard','Expert')),
    ImagePath         NVARCHAR(500) NULL,
    CreatedBy         INT           NOT NULL REFERENCES Users2(UserID),
    CreatedAt         DATETIME      NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Quiz
-- ============================================
CREATE TABLE Quiz (
    QuizID         INT IDENTITY(1,1) PRIMARY KEY,
    QuizTitle      NVARCHAR(200) NOT NULL,
    SubjectID      INT           NOT NULL REFERENCES Subjects(SubjectID),
    StartTime      DATETIME      NULL,
    AllowedTime    INT           NOT NULL DEFAULT 30,   -- minutes
    TotalQuestions INT           NOT NULL DEFAULT 10,
    RandomizeQ     BIT           NOT NULL DEFAULT 1,
    ShuffleOptions BIT           NOT NULL DEFAULT 1,
    Remarks        NVARCHAR(500) NULL,
    ReviewAnswer   BIT           NOT NULL DEFAULT 0,
    IsPublished    BIT           NOT NULL DEFAULT 0,
    CreatedBy      INT           NOT NULL REFERENCES Users2(UserID),
    CreatedAt      DATETIME      NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- TABLE: QuizQuestions  (Quiz <-> Questions link)
-- ============================================
CREATE TABLE QuizQuestions (
    QuizQuestionID INT IDENTITY(1,1) PRIMARY KEY,
    QuizID         INT NOT NULL REFERENCES Quiz(QuizID),
    QuestionID     INT NOT NULL REFERENCES QuestionsTable(QuestionID),
    DisplayOrder   INT NOT NULL DEFAULT 0
);

-- ============================================
-- TABLE: Answers
--   One row per question per student per quiz.
--   Answer is saved immediately when student clicks Next (no going back).
-- ============================================
CREATE TABLE Answers (
    AnswerID    INT IDENTITY(1,1) PRIMARY KEY,
    StudentID   INT           NOT NULL REFERENCES Users2(UserID),
    QuizID      INT           NOT NULL REFERENCES Quiz(QuizID),
    QuestionID  INT           NOT NULL REFERENCES QuestionsTable(QuestionID),
    QNo         INT           NOT NULL,   -- display order (1,2,3…)
    CorrectAns  CHAR(1)       NOT NULL,
    StudentAns  CHAR(1)       NULL,       -- NULL if not answered (time ran out)
    Marks       DECIMAL(3,1)  NOT NULL DEFAULT 0,
    AnsweredAt  DATETIME      NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Results
-- ============================================
CREATE TABLE Results (
    ResultID       INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT           NOT NULL REFERENCES Users2(UserID),
    QuizID         INT           NOT NULL REFERENCES Quiz(QuizID),
    TotalMarks     INT           NOT NULL,
    ObtainedMarks  DECIMAL(10,1) NOT NULL,
    Percentage     DECIMAL(5,2)  NOT NULL,
    AttemptDate    DATETIME      NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- TABLE: Notifications
-- ============================================
CREATE TABLE Notifications (
    NotifID    INT IDENTITY(1,1) PRIMARY KEY,
    ToUserID   INT           NOT NULL REFERENCES Users2(UserID),
    FromUserID INT           NOT NULL REFERENCES Users2(UserID),
    Message    NVARCHAR(500) NOT NULL,
    IsRead     BIT           NOT NULL DEFAULT 0,
    CreatedAt  DATETIME      NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- SEED DATA
-- ============================================

-- Subjects
INSERT INTO Subjects (SubjectName) VALUES
('Computer Science'),
('Mathematics'),
('Physics');

-- Users
--  UserID 1 = Admin, 2 = t_ali (CS Teacher), 3 = t_sara (Math Teacher)
--  UserID 4 = s_usman, 5 = s_ayesha, 6 = s_bilal  (Students)
INSERT INTO Users2 (FullName, Username, Password, Role, SubjectID) VALUES
('Super Admin',           'admin',     'Admin@123',  'Admin',   NULL),
('Ali Hassan',            't_ali',     'Teacher@1',  'Teacher', 1),
('Sara Khan',             't_sara',    'Teacher@2',  'Teacher', 2),
('Usman Tariq',           's_usman',   'Student@1',  'Student', NULL),
('Ayesha Malik',          's_ayesha',  'Student@2',  'Student', NULL),
('Bilal Ahmed',           's_bilal',   'Student@3',  'Student', NULL);

-- --------- Computer Science Questions (by t_ali, UserID = 2) ---------
INSERT INTO QuestionsTable
    (SubjectID, QuestionStatement, OptionA, OptionB, OptionC, OptionD, CorrectOption, DifficultyLevel, CreatedBy)
VALUES
(1,'Which data structure operates on the LIFO principle?',
   'Queue','Stack','Linked List','Tree','B','Easy',2),

(1,'What is the time complexity of Binary Search?',
   'O(n)','O(n²)','O(log n)','O(1)','C','Medium',2),

(1,'Which OSI layer is responsible for routing?',
   'Data Link','Transport','Network','Application','C','Medium',2),

(1,'What does HTML stand for?',
   'Hyper Transfer Markup Language',
   'HyperText Markup Language',
   'High Text Machine Language',
   'HyperText Management Language','B','Easy',2),

(1,'Which sorting algorithm achieves O(n log n) on average?',
   'Bubble Sort','Insertion Sort','Merge Sort','Selection Sort','C','Hard',2),

(1,'What is a Primary Key in a database?',
   'A key that is foreign',
   'A key that uniquely identifies each record',
   'A key that can be NULL',
   'A key used only for sorting','B','Easy',2),

(1,'Which protocol is used for secure web browsing?',
   'HTTP','FTP','HTTPS','SMTP','C','Easy',2),

(1,'What is polymorphism in OOP?',
   'Hiding internal data',
   'One interface, multiple implementations',
   'Inheriting all parent properties',
   'Encapsulating private methods','B','Medium',2),

(1,'What does CPU stand for?',
   'Central Processing Unit',
   'Core Processing Unit',
   'Computer Processing Unit',
   'Central Program Unit','A','Easy',2),

(1,'Which of the following is NOT a programming language?',
   'Python','HTML','Java','C++','B','Medium',2);

-- --------- Mathematics Questions (by t_sara, UserID = 3) ---------
INSERT INTO QuestionsTable
    (SubjectID, QuestionStatement, OptionA, OptionB, OptionC, OptionD, CorrectOption, DifficultyLevel, CreatedBy)
VALUES
(2,'What is the derivative of sin(x)?',
   'cos(x)','-cos(x)','tan(x)','-sin(x)','A','Medium',3),

(2,'What is the value of 2¹⁰?',
   '512','1024','2048','256','B','Easy',3),

(2,'What is the approximate value of π (pi)?',
   '3.14159','2.71828','1.61803','1.41421','A','Easy',3),

(2,'What is the integral of 1/x?',
   'x','ln(x)','e^x','1/x²','B','Hard',3),

(2,'What is the determinant of a 2×2 identity matrix?',
   '0','2','1','-1','C','Medium',3),

(2,'Solve: 3x + 5 = 20',
   'x = 4','x = 5','x = 6','x = 3','B','Easy',3),

(2,'What is the area of a circle with radius r?',
   '2πr','πr','πr²','2πr²','C','Easy',3),

(2,'What is the sum of interior angles of a triangle?',
   '90°','180°','270°','360°','B','Easy',3),

(2,'What is the quadratic formula?',
   '(-b ± √(b²−4ac)) / 2a',
   '(-b ± √(b+4ac)) / 2a',
   '(b ± √(b²−4ac)) / 2a',
   '(-b ± √(b²+4ac)) / 2a','A','Hard',3),

(2,'What is log₁₀(1000)?',
   '2','3','4','10','B','Medium',3);

-- --------- Physics Questions (by t_ali, UserID = 2) ---------
INSERT INTO QuestionsTable
    (SubjectID, QuestionStatement, OptionA, OptionB, OptionC, OptionD, CorrectOption, DifficultyLevel, CreatedBy)
VALUES
(3,'What is the SI unit of force?',
   'Watt','Joule','Newton','Pascal','C','Easy',2),

(3,'What is the speed of light in vacuum?',
   '3 × 10⁸ m/s','3 × 10⁶ m/s','3 × 10¹⁰ m/s','3 × 10⁴ m/s','A','Easy',2),

(3,'Which law states F = ma?',
   'Newton''s First Law',
   'Newton''s Second Law',
   'Newton''s Third Law',
   'Law of Gravitation','B','Easy',2),

(3,'What is the unit of electric resistance?',
   'Ampere','Volt','Ohm','Coulomb','C','Easy',2),

(3,'What is the formula for kinetic energy?',
   'mgh','½mv²','mv','Fd','B','Medium',2);

PRINT 'QuizWizDB created successfully!';
PRINT 'Tables: Subjects, Users2, QuestionsTable, Quiz, QuizQuestions, Answers, Results, Notifications';
PRINT 'Login credentials:';
PRINT '  admin      / Admin@123';
PRINT '  t_ali      / Teacher@1   (CS Teacher)';
PRINT '  t_sara     / Teacher@2   (Math Teacher)';
PRINT '  s_usman    / Student@1';
PRINT '  s_ayesha   / Student@2';
PRINT '  s_bilal    / Student@3';
GO
