USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SurveyDB')
BEGIN
    CREATE DATABASE SurveyDB;
END
GO

USE SurveyDB;
GO

IF OBJECT_ID('dbo.ResponseAnswers', 'U') IS NOT NULL DROP TABLE dbo.ResponseAnswers;
GO
IF OBJECT_ID('dbo.Responses',       'U') IS NOT NULL DROP TABLE dbo.Responses;
GO
IF OBJECT_ID('dbo.Options',         'U') IS NOT NULL DROP TABLE dbo.Options;
GO
IF OBJECT_ID('dbo.Questions',       'U') IS NOT NULL DROP TABLE dbo.Questions;
GO
IF OBJECT_ID('dbo.Surveys',         'U') IS NOT NULL DROP TABLE dbo.Surveys;
GO
IF OBJECT_ID('dbo.UsersSurvey',     'U') IS NOT NULL DROP TABLE dbo.UsersSurvey;
GO
IF OBJECT_ID('dbo.Roles',           'U') IS NOT NULL DROP TABLE dbo.Roles;
GO

CREATE TABLE dbo.Roles (
    RoleID   INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.UsersSurvey (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    Username     NVARCHAR(50)  NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    FullName     NVARCHAR(100) NOT NULL,
    Email        NVARCHAR(150) NOT NULL UNIQUE,
    RoleID       INT           NOT NULL,
    IsActive     BIT           NOT NULL DEFAULT 1,
    CreatedDate  DATETIME      NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_UsersSurvey_Roles FOREIGN KEY (RoleID) REFERENCES dbo.Roles(RoleID)
);
GO

CREATE TABLE dbo.Surveys (
    SurveyID    INT IDENTITY(1,1) PRIMARY KEY,
    Title       NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    CreatedBy   INT           NOT NULL,
    CreatedDate DATETIME      NOT NULL DEFAULT GETDATE(),
    IsActive    BIT           NOT NULL DEFAULT 1,
    IsAnonymous BIT           NOT NULL DEFAULT 0,
    CONSTRAINT FK_Surveys_UsersSurvey FOREIGN KEY (CreatedBy) REFERENCES dbo.UsersSurvey(UserID)
);
GO

CREATE TABLE dbo.Questions (
    QuestionID   INT IDENTITY(1,1) PRIMARY KEY,
    SurveyID     INT           NOT NULL,
    QuestionText NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(20)  NOT NULL, 
    OrderNo      INT           NOT NULL DEFAULT 1,
    CONSTRAINT FK_Questions_Surveys FOREIGN KEY (SurveyID) REFERENCES dbo.Surveys(SurveyID)
);
GO

CREATE TABLE dbo.Options (
    OptionID     INT IDENTITY(1,1) PRIMARY KEY,
    QuestionID   INT           NOT NULL,
    OptionText   NVARCHAR(500) NOT NULL,
    DisplayOrder INT           NOT NULL DEFAULT 1,
    CONSTRAINT FK_Options_Questions FOREIGN KEY (QuestionID) REFERENCES dbo.Questions(QuestionID)
);
GO

CREATE TABLE dbo.Responses (
    ResponseID     INT IDENTITY(1,1) PRIMARY KEY,
    SurveyID       INT      NOT NULL,
    UserID         INT      NULL,  
    SubmittedDate  DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Responses_Surveys FOREIGN KEY (SurveyID) REFERENCES dbo.Surveys(SurveyID),
    CONSTRAINT FK_Responses_UsersSurvey FOREIGN KEY (UserID)   REFERENCES dbo.UsersSurvey(UserID)
);
GO

CREATE TABLE dbo.ResponseAnswers (
    AnswerID   INT IDENTITY(1,1) PRIMARY KEY,
    ResponseID INT NOT NULL,
    QuestionID INT NOT NULL,
    OptionID   INT NOT NULL,
    CONSTRAINT FK_Answers_Responses FOREIGN KEY (ResponseID) REFERENCES dbo.Responses(ResponseID),
    CONSTRAINT FK_Answers_Questions FOREIGN KEY (QuestionID) REFERENCES dbo.Questions(QuestionID),
    CONSTRAINT FK_Answers_Options   FOREIGN KEY (OptionID)   REFERENCES dbo.Options(OptionID)
);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE RoleName = 'Survey Administrator')
BEGIN
    INSERT INTO dbo.Roles (RoleName) VALUES
        ('Survey Administrator'),
        ('Survey Builder'),
        ('Surveyor');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.UsersSurvey WHERE Username = 'admin')
BEGIN
    INSERT INTO dbo.UsersSurvey (Username, PasswordHash, FullName, Email, RoleID) VALUES
    ('admin',   'Admin@123',   'System Administrator', 'admin@survey.com',   1),
    ('builder1','Builder@123', 'Alice Builder',         'alice@survey.com',   2),
    ('surveyor1','Survey@123', 'Bob Surveyor',          'bob@survey.com',     3);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Surveys WHERE Title = 'Website Feedback Survey')
BEGIN
    INSERT INTO dbo.Surveys (Title, Description, CreatedBy, IsActive, IsAnonymous) 
    VALUES ('Website Feedback Survey', 'Please let us know your thoughts about our new website design and features.', 2, 1, 0);

    DECLARE @SurveyID INT = SCOPE_IDENTITY();

    INSERT INTO dbo.Questions (SurveyID, QuestionText, QuestionType, OrderNo)
    VALUES 
    (@SurveyID, 'How satisfied are you with the website navigation?', 'MCQ', 1),
    (@SurveyID, 'The website loaded fast enough for my needs.', 'TrueFalse', 2),
    (@SurveyID, 'How likely are you to recommend our platform?', 'MCQ', 3);

    DECLARE @Q1 INT = (SELECT QuestionID FROM dbo.Questions WHERE SurveyID = @SurveyID AND OrderNo = 1);
    DECLARE @Q2 INT = (SELECT QuestionID FROM dbo.Questions WHERE SurveyID = @SurveyID AND OrderNo = 2);
    DECLARE @Q3 INT = (SELECT QuestionID FROM dbo.Questions WHERE SurveyID = @SurveyID AND OrderNo = 3);

    INSERT INTO dbo.Options (QuestionID, OptionText, DisplayOrder) VALUES
    (@Q1, 'Very Satisfied', 1),
    (@Q1, 'Somewhat Satisfied', 2),
    (@Q1, 'Neutral', 3),
    (@Q1, 'Dissatisfied', 4);

    INSERT INTO dbo.Options (QuestionID, OptionText, DisplayOrder) VALUES
    (@Q2, 'True', 1),
    (@Q2, 'False', 2);

    INSERT INTO dbo.Options (QuestionID, OptionText, DisplayOrder) VALUES
    (@Q3, 'Very Likely', 1),
    (@Q3, 'Somewhat Likely', 2),
    (@Q3, 'Not Likely', 3);

    INSERT INTO dbo.Responses (SurveyID, UserID) VALUES (@SurveyID, 3);
    DECLARE @R1 INT = SCOPE_IDENTITY();
    INSERT INTO dbo.ResponseAnswers (ResponseID, QuestionID, OptionID) VALUES
    (@R1, @Q1, (SELECT OptionID FROM dbo.Options WHERE QuestionID = @Q1 AND DisplayOrder = 1)),
    (@R1, @Q2, (SELECT OptionID FROM dbo.Options WHERE QuestionID = @Q2 AND DisplayOrder = 1)),
    (@R1, @Q3, (SELECT OptionID FROM dbo.Options WHERE QuestionID = @Q3 AND DisplayOrder = 1));

    INSERT INTO dbo.Responses (SurveyID, UserID) VALUES (@SurveyID, NULL);
    DECLARE @R2 INT = SCOPE_IDENTITY();
    INSERT INTO dbo.ResponseAnswers (ResponseID, QuestionID, OptionID) VALUES
    (@R2, @Q1, (SELECT OptionID FROM dbo.Options WHERE QuestionID = @Q1 AND DisplayOrder = 2)),
    (@R2, @Q2, (SELECT OptionID FROM dbo.Options WHERE QuestionID = @Q2 AND DisplayOrder = 1)),
    (@R2, @Q3, (SELECT OptionID FROM dbo.Options WHERE QuestionID = @Q3 AND DisplayOrder = 2));
END
GO

IF OBJECT_ID('dbo.sp_ValidateUser', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_ValidateUser;
GO
CREATE PROCEDURE dbo.sp_ValidateUser
    @Username NVARCHAR(50),
    @Password NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.UserID, u.Username, u.FullName, u.Email, u.RoleID, r.RoleName
    FROM   dbo.UsersSurvey u
    INNER JOIN dbo.Roles r ON u.RoleID = r.RoleID
    WHERE  u.Username     = @Username
      AND  u.PasswordHash = @Password
      AND  u.IsActive     = 1;
END
GO

IF OBJECT_ID('dbo.sp_GetAllSurveys', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetAllSurveys;
GO
CREATE PROCEDURE dbo.sp_GetAllSurveys
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.SurveyID, s.Title, s.Description, s.IsActive, s.IsAnonymous,
           s.CreatedDate, u.FullName AS CreatedBy,
           (SELECT COUNT(*) FROM dbo.Questions q WHERE q.SurveyID = s.SurveyID) AS QuestionCount,
           (SELECT COUNT(*) FROM dbo.Responses r WHERE r.SurveyID = s.SurveyID) AS ResponseCount
    FROM   dbo.Surveys s
    INNER JOIN dbo.UsersSurvey u ON s.CreatedBy = u.UserID
    ORDER BY s.CreatedDate DESC;
END
GO

IF OBJECT_ID('dbo.sp_GetSurveysByBuilder', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetSurveysByBuilder;
GO
CREATE PROCEDURE dbo.sp_GetSurveysByBuilder
    @BuilderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.SurveyID, s.Title, s.Description, s.IsActive, s.IsAnonymous,
           s.CreatedDate,
           (SELECT COUNT(*) FROM dbo.Questions q WHERE q.SurveyID = s.SurveyID) AS QuestionCount,
           (SELECT COUNT(*) FROM dbo.Responses r WHERE r.SurveyID = s.SurveyID) AS ResponseCount
    FROM   dbo.Surveys s
    WHERE  s.CreatedBy = @BuilderID
    ORDER BY s.CreatedDate DESC;
END
GO

IF OBJECT_ID('dbo.sp_GetActiveSurveys', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetActiveSurveys;
GO
CREATE PROCEDURE dbo.sp_GetActiveSurveys
    @SurveyorID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.SurveyID, s.Title, s.Description, s.IsAnonymous,
           s.CreatedDate, u.FullName AS CreatedBy,
           (SELECT COUNT(*) FROM dbo.Questions q WHERE q.SurveyID = s.SurveyID) AS QuestionCount,
           CASE WHEN EXISTS(SELECT 1 FROM dbo.Responses r
                            WHERE r.SurveyID = s.SurveyID AND r.UserID = @SurveyorID)
                THEN 1 ELSE 0 END AS AlreadyTaken
    FROM   dbo.Surveys s
    INNER JOIN dbo.UsersSurvey u ON s.CreatedBy = u.UserID
    WHERE  s.IsActive = 1
    ORDER BY s.CreatedDate DESC;
END
GO

IF OBJECT_ID('dbo.sp_GetSurveyQuestions', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetSurveyQuestions;
GO
CREATE PROCEDURE dbo.sp_GetSurveyQuestions
    @SurveyID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT q.QuestionID, q.QuestionText, q.QuestionType, q.OrderNo
    FROM   dbo.Questions q
    WHERE  q.SurveyID = @SurveyID
    ORDER BY q.OrderNo;
END
GO

IF OBJECT_ID('dbo.sp_GetQuestionOptions', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetQuestionOptions;
GO
CREATE PROCEDURE dbo.sp_GetQuestionOptions
    @QuestionID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT OptionID, OptionText, DisplayOrder
    FROM   dbo.Options
    WHERE  QuestionID = @QuestionID
    ORDER BY DisplayOrder;
END
GO

IF OBJECT_ID('dbo.sp_GetSurveyResults', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetSurveyResults;
GO
CREATE PROCEDURE dbo.sp_GetSurveyResults
    @SurveyID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT q.QuestionID, q.QuestionText, q.QuestionType,
           o.OptionID, o.OptionText,
           COUNT(ra.AnswerID) AS AnswerCount
    FROM   dbo.Questions q
    INNER JOIN dbo.Options o ON o.QuestionID = q.QuestionID
    LEFT  JOIN dbo.ResponseAnswers ra ON ra.OptionID = o.OptionID
    WHERE  q.SurveyID = @SurveyID
    GROUP BY q.QuestionID, q.QuestionText, q.QuestionType, q.OrderNo,
             o.OptionID, o.OptionText, o.DisplayOrder
    ORDER BY q.OrderNo, o.DisplayOrder;
END
GO

IF OBJECT_ID('dbo.sp_GetAllUsers', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetAllUsers;
GO
CREATE PROCEDURE dbo.sp_GetAllUsers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.UserID, u.Username, u.FullName, u.Email, u.IsActive, u.CreatedDate,
           r.RoleName
    FROM   dbo.UsersSurvey u
    INNER JOIN dbo.Roles r ON u.RoleID = r.RoleID
    ORDER BY u.CreatedDate DESC;
END
GO

PRINT 'SurveyDB created and seeded successfully!';
GO
