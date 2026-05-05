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
CREATE TABLE Subjects (
    SubjectID   INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(100) NOT NULL
);
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
CREATE TABLE QuestionsTable (
    QuestionID        INT IDENTITY(1,1) PRIMARY KEY,
    SubjectID         INT           NOT NULL REFERENCES Subjects(SubjectID),
    QuestionStatement NVARCHAR(MAX) NOT NULL,
    OptionA           NVARCHAR(500) NOT NULL,
    OptionB           NVARCHAR(500) NOT NULL,
    OptionC           NVARCHAR(500) NOT NULL,
    OptionD           NVARCHAR(500) NOT NULL,
    CorrectOption     CHAR(1)       NULL,
    CorrectOptions    NVARCHAR(500) NULL,
    QuestionType      NVARCHAR(20)  NOT NULL DEFAULT 'Radio',
    DifficultyLevel   NVARCHAR(20)  NOT NULL DEFAULT 'Medium'
                        CHECK (DifficultyLevel IN ('Easy','Medium','Hard','Expert')),
    CreatedBy         INT           NOT NULL REFERENCES Users2(UserID),
    CreatedAt         DATETIME      NOT NULL DEFAULT GETDATE()
);
CREATE TABLE Quiz (
    QuizID          INT IDENTITY(1,1) PRIMARY KEY,
    QuizTitle       NVARCHAR(200) NOT NULL,
    SubjectID       INT           NOT NULL REFERENCES Subjects(SubjectID),
    StartTime       DATETIME      NULL,
    AllowedTime     INT           NOT NULL DEFAULT 30,
    TotalQuestions  INT           NOT NULL DEFAULT 10,
    RandomizeQ      BIT           NOT NULL DEFAULT 1,
    ShuffleOptions  BIT           NOT NULL DEFAULT 1,
    NegativeMarking BIT           NOT NULL DEFAULT 0,
    NegativeMarks   DECIMAL(3,2)  NOT NULL DEFAULT 0.25,
    Remarks         NVARCHAR(500) NULL,
    ReviewAnswer    BIT           NOT NULL DEFAULT 0,
    IsPublished     BIT           NOT NULL DEFAULT 0,
    CreatedBy       INT           NOT NULL REFERENCES Users2(UserID),
    CreatedAt       DATETIME      NOT NULL DEFAULT GETDATE()
);
CREATE TABLE QuizQuestions (
    QuizQuestionID INT IDENTITY(1,1) PRIMARY KEY,
    QuizID         INT NOT NULL REFERENCES Quiz(QuizID),
    QuestionID     INT NOT NULL REFERENCES QuestionsTable(QuestionID),
    DisplayOrder   INT NOT NULL DEFAULT 0
);
CREATE TABLE Answers (
    AnswerID    INT IDENTITY(1,1) PRIMARY KEY,
    StudentID   INT           NOT NULL REFERENCES Users2(UserID),
    QuizID      INT           NOT NULL REFERENCES Quiz(QuizID),
    QuestionID  INT           NOT NULL REFERENCES QuestionsTable(QuestionID),
    QNo         INT           NOT NULL,
    CorrectAns  NVARCHAR(500) NOT NULL,
    StudentAns  NVARCHAR(500) NULL,
    Marks       DECIMAL(3,1)  NOT NULL DEFAULT 0,
    AnsweredAt  DATETIME      NOT NULL DEFAULT GETDATE()
);
CREATE TABLE Results (
    ResultID       INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT           NOT NULL REFERENCES Users2(UserID),
    QuizID         INT           NOT NULL REFERENCES Quiz(QuizID),
    TotalMarks     INT           NOT NULL,
    ObtainedMarks  DECIMAL(10,1) NOT NULL,
    Percentage     DECIMAL(5,2)  NOT NULL,
    AttemptDate    DATETIME      NOT NULL DEFAULT GETDATE()
);
CREATE TABLE Notifications (
    NotifID    INT IDENTITY(1,1) PRIMARY KEY,
    ToUserID   INT           NOT NULL REFERENCES Users2(UserID),
    FromUserID INT           NOT NULL REFERENCES Users2(UserID),
    Message    NVARCHAR(500) NOT NULL,
    IsRead     BIT           NOT NULL DEFAULT 0,
    CreatedAt  DATETIME      NOT NULL DEFAULT GETDATE()
);
GO
INSERT INTO Subjects (SubjectName) VALUES ('Computer Science'), ('Mathematics'), ('Physics'), ('Chemistry'), ('General Knowledge'), ('English');
INSERT INTO Users2 (FullName, Username, Password, Role, SubjectID) VALUES
('Super Admin',   'admin',     'Admin@123',  'Admin',   NULL),
('Ali Hassan',    't_ali',     'Teacher@1',  'Teacher', 1),
('Sara Khan',     't_sara',    'Teacher@2',  'Teacher', 2),
('Usman Tariq',   's_usman',   'Student@1',  'Student', NULL),
('Ayesha Malik',  's_ayesha',  'Student@2',  'Student', NULL),
('Bilal Ahmed',   's_bilal',   'Student@3',  'Student', NULL),
('Fatima Zahra',  's_fatima',  'Student@4',  'Student', NULL),
('Zain Ahmed',    's_zain',    'Student@5',  'Student', NULL),
('Hamza Ali',     's_hamza',   'Student@6',  'Student', NULL);
INSERT INTO QuestionsTable (SubjectID, QuestionStatement, OptionA, OptionB, OptionC, OptionD, CorrectOption, CorrectOptions, QuestionType, DifficultyLevel, CreatedBy) VALUES
(1,'Which data structure operates on the LIFO principle?','Queue','Stack','Linked List','Tree','B','B','Radio','Easy',2),
(1,'What is the time complexity of Binary Search?','O(n)','O(n2)','O(log n)','O(1)','C','C','Radio','Medium',2),
(1,'Which OSI layer is responsible for routing?','Data Link','Transport','Network','Application','C','C','Radio','Medium',2),
(1,'What does HTML stand for?','Hyper Transfer Markup Language','HyperText Markup Language','High Text Machine Language','HyperText Management Language','B','B','Radio','Easy',2),
(1,'Which sorting algorithm achieves O(n log n) on average?','Bubble Sort','Insertion Sort','Merge Sort','Selection Sort','C','C','Radio','Hard',2),
(1,'What does SQL stand for?', 'Structured Query Language', 'Simple Query Language', 'Sequential Query Logic', 'Standard Query List', 'A', 'A', 'Radio', 'Easy', 2),
(1, 'Which language is primarily used for Android app development?', 'Swift', 'Kotlin', 'Objective-C', 'C#', 'B', 'B', 'Radio', 'Medium', 2),
(2,'What is the derivative of sin(x)?','cos(x)','-cos(x)','tan(x)','-sin(x)','A','A','Radio','Medium',3),
(2,'What is the value of 2^10?','512','1024','2048','256','B','B','Radio','Easy',3),
(2, 'What is the square root of 225?', '13', '14', '15', '16', 'C', '15', 'Radio', 'Easy', 3),
(2, 'What is the value of Sin(90 degrees)?', '0', '1', '0.5', '-1', 'B', '1', 'Radio', 'Easy', 3);
INSERT INTO Quiz (QuizTitle, SubjectID, StartTime, AllowedTime, TotalQuestions, RandomizeQ, ShuffleOptions, Remarks, ReviewAnswer, IsPublished, CreatedBy)
VALUES ('CS Basics Midterm', 1, GETDATE(), 15, 5, 1, 1, 'Covers DS, Networks and SQL', 1, 1, 2);
DECLARE @CSQuizID INT = SCOPE_IDENTITY();
INSERT INTO QuizQuestions (QuizID, QuestionID, DisplayOrder)
SELECT @CSQuizID, QuestionID, ROW_NUMBER() OVER(ORDER BY QuestionID)
FROM QuestionsTable WHERE SubjectID = 1 AND QuestionID <= 5;
INSERT INTO Results (StudentID, QuizID, TotalMarks, ObtainedMarks, Percentage, AttemptDate)
VALUES (4, @CSQuizID, 5, 4, 80.00, DATEADD(day, -1, GETDATE()));
INSERT INTO Results (StudentID, QuizID, TotalMarks, ObtainedMarks, Percentage, AttemptDate)
VALUES (5, @CSQuizID, 5, 3, 60.00, DATEADD(day, -1, GETDATE()));
PRINT 'QuizWiz Complete Database Script executed successfully!';
GO
