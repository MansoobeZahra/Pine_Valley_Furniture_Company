USE QuizWizDB;
GO

-- 1. Add more Students
IF NOT EXISTS (SELECT 1 FROM Users2 WHERE Username = 's_fatima')
BEGIN
    INSERT INTO Users2 (FullName, Username, Password, Role, SubjectID) VALUES
    ('Fatima Zahra', 's_fatima', 'Student@4', 'Student', NULL),
    ('Zain Ahmed',   's_zain',   'Student@5', 'Student', NULL),
    ('Hamza Ali',    's_hamza',  'Student@6', 'Student', NULL);
END

-- 2. Add more Questions (CS - UserID 2)
IF NOT EXISTS (SELECT 1 FROM QuestionsTable WHERE QuestionStatement LIKE '%SQL stand for%')
BEGIN
    INSERT INTO QuestionsTable (SubjectID, QuestionStatement, OptionA, OptionB, OptionC, OptionD, CorrectOption, DifficultyLevel, CreatedBy) VALUES
    (1, 'What does SQL stand for?', 'Structured Query Language', 'Simple Query Language', 'Sequential Query Logic', 'Standard Query List', 'A', 'Easy', 2),
    (1, 'Which language is primarily used for Android app development?', 'Swift', 'Kotlin', 'Objective-C', 'C#', 'B', 'Medium', 2),
    (1, 'What is the purpose of a firewall?', 'To speed up the internet', 'To block unauthorized access', 'To store cookies', 'To clean the monitor', 'B', 'Easy', 2),
    (1, 'Which of these is a NoSQL database?', 'MySQL', 'PostgreSQL', 'MongoDB', 'Oracle', 'C', 'Medium', 2),
    (1, 'In Python, which keyword is used to define a function?', 'func', 'define', 'def', 'function', 'C', 'Easy', 2);
END

-- 3. Add more Questions (Math - UserID 3)
IF NOT EXISTS (SELECT 1 FROM QuestionsTable WHERE QuestionStatement LIKE '%square root of 225%')
BEGIN
    INSERT INTO QuestionsTable (SubjectID, QuestionStatement, OptionA, OptionB, OptionC, OptionD, CorrectOption, DifficultyLevel, CreatedBy) VALUES
    (2, 'What is the square root of 225?', '13', '14', '15', '16', 'C', 'Easy', 3),
    (2, 'What is the value of Sin(90°)?', '0', '1', '0.5', '-1', 'B', 'Easy', 3),
    (2, 'If 5x = 40, what is x?', '6', '7', '8', '9', 'C', 'Easy', 3),
    (2, 'What is a prime number?', 'A number divisible by 2', 'A number with exactly two factors', 'A number ending in 1', 'Any odd number', 'B', 'Medium', 3),
    (2, 'What is 7 multiplied by 8?', '54', '56', '58', '62', 'B', 'Easy', 3);
END

-- 4. Create a Quiz (CS Midterm)
IF NOT EXISTS (SELECT 1 FROM Quiz WHERE QuizTitle = 'CS Basics Midterm')
BEGIN
    INSERT INTO Quiz (QuizTitle, SubjectID, StartTime, AllowedTime, TotalQuestions, RandomizeQ, ShuffleOptions, Remarks, ReviewAnswer, IsPublished, CreatedBy)
    VALUES ('CS Basics Midterm', 1, GETDATE(), 15, 5, 1, 1, 'Covers DS, Networks and SQL', 1, 1, 2);

    -- Link questions to the quiz
    DECLARE @QuizID INT = (SELECT TOP 1 QuizID FROM Quiz WHERE QuizTitle = 'CS Basics Midterm' ORDER BY QuizID DESC);
    INSERT INTO QuizQuestions (QuizID, QuestionID, DisplayOrder)
    SELECT @QuizID, QuestionID, ROW_NUMBER() OVER(ORDER BY QuestionID)
    FROM QuestionsTable WHERE QuestionStatement LIKE '%SQL%' OR QuestionStatement LIKE '%Android%' OR QuestionStatement LIKE '%firewall%' OR QuestionStatement LIKE '%NoSQL%' OR QuestionStatement LIKE '%Python%';

    -- 5. Add some mock Results for existing students
    INSERT INTO Results (StudentID, QuizID, TotalMarks, ObtainedMarks, Percentage, AttemptDate)
    VALUES (4, @QuizID, 5, 4, 80.00, DATEADD(day, -1, GETDATE()));

    INSERT INTO Results (StudentID, QuizID, TotalMarks, ObtainedMarks, Percentage, AttemptDate)
    VALUES (5, @QuizID, 5, 3, 60.00, DATEADD(day, -1, GETDATE()));
END

PRINT 'Additional data check completed successfully!';

-- 6. Add more Subjects
IF NOT EXISTS (SELECT 1 FROM Subjects WHERE SubjectName = 'Chemistry')
    INSERT INTO Subjects (SubjectName) VALUES ('Chemistry'), ('General Knowledge'), ('English');

-- 7. Add Physics Questions (SubjectID 3, UserID 2)
IF NOT EXISTS (SELECT 1 FROM QuestionsTable WHERE QuestionStatement LIKE '%Newton%')
BEGIN
    INSERT INTO QuestionsTable (SubjectID, QuestionStatement, OptionA, OptionB, OptionC, OptionD, CorrectOption, DifficultyLevel, CreatedBy) VALUES
    (3, 'Which planet is known as the Red Planet?', 'Venus', 'Mars', 'Jupiter', 'Saturn', 'B', 'Easy', 2),
    (3, 'What is the standard unit of temperature?', 'Celsius', 'Fahrenheit', 'Kelvin', 'Rankine', 'C', 'Medium', 2),
    (3, 'What is the acceleration due to gravity on Earth?', '8.9 m/s²', '9.8 m/s²', '10.5 m/s²', '7.2 m/s²', 'B', 'Easy', 2),
    (3, 'Which of these is a noble gas?', 'Oxygen', 'Nitrogen', 'Helium', 'Chlorine', 'C', 'Easy', 2),
    (3, 'What is the boiling point of water at sea level?', '90°C', '100°C', '110°C', '120°C', 'B', 'Easy', 2);
END

-- 8. Create a Math Quiz (SubjectID 2, UserID 3)
IF NOT EXISTS (SELECT 1 FROM Quiz WHERE QuizTitle = 'Basic Arithmetic Quiz')
BEGIN
    INSERT INTO Quiz (QuizTitle, SubjectID, StartTime, AllowedTime, TotalQuestions, RandomizeQ, ShuffleOptions, Remarks, ReviewAnswer, IsPublished, CreatedBy)
    VALUES ('Basic Arithmetic Quiz', 2, GETDATE(), 10, 5, 1, 1, 'Simple addition, multiplication and roots', 1, 1, 3);

    DECLARE @MathQuizID INT = (SELECT TOP 1 QuizID FROM Quiz WHERE QuizTitle = 'Basic Arithmetic Quiz' ORDER BY QuizID DESC);
    INSERT INTO QuizQuestions (QuizID, QuestionID, DisplayOrder)
    SELECT @MathQuizID, QuestionID, ROW_NUMBER() OVER(ORDER BY QuestionID)
    FROM QuestionsTable WHERE SubjectID = 2 AND (QuestionStatement LIKE '%multiplied%' OR QuestionStatement LIKE '%square root%' OR QuestionStatement LIKE '%3x + 5%');
END

-- 9. Add more Student Results for the new quizzes
-- Zain (UserID 7) took CS Quiz
IF NOT EXISTS (SELECT 1 FROM Results WHERE StudentID = 7 AND QuizID IN (SELECT QuizID FROM Quiz WHERE QuizTitle = 'CS Basics Midterm'))
BEGIN
    DECLARE @CSQuizID INT = (SELECT TOP 1 QuizID FROM Quiz WHERE QuizTitle = 'CS Basics Midterm' ORDER BY QuizID DESC);
    INSERT INTO Results (StudentID, QuizID, TotalMarks, ObtainedMarks, Percentage, AttemptDate)
    VALUES (7, @CSQuizID, 5, 5, 100.00, GETDATE());
END

PRINT 'Extended data expansion completed successfully!';


