-- ============================================================
-- QuizWiz Database UPDATE Script
-- Run AFTER QuizWiz_Schema.sql to add new columns
-- ============================================================
USE QuizWizDB;
GO

-- ----------------------------------------------------------
-- QuestionsTable: add QuestionType and CorrectOptions
-- ----------------------------------------------------------
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name='QuestionType' AND Object_ID=OBJECT_ID('QuestionsTable'))
    ALTER TABLE QuestionsTable ADD QuestionType NVARCHAR(20) NOT NULL DEFAULT 'Radio';
GO

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name='CorrectOptions' AND Object_ID=OBJECT_ID('QuestionsTable'))
    ALTER TABLE QuestionsTable ADD CorrectOptions NVARCHAR(500) NULL;
GO

-- Back-fill CorrectOptions from CorrectOption for existing Radio questions
UPDATE QuestionsTable SET CorrectOptions = CorrectOption WHERE CorrectOptions IS NULL AND QuestionType = 'Radio';
GO

-- ----------------------------------------------------------
-- Quiz: add NegativeMarking and NegativeMarks
-- ----------------------------------------------------------
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name='NegativeMarking' AND Object_ID=OBJECT_ID('Quiz'))
    ALTER TABLE Quiz ADD NegativeMarking BIT NOT NULL DEFAULT 0;
GO

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name='NegativeMarks' AND Object_ID=OBJECT_ID('Quiz'))
    ALTER TABLE Quiz ADD NegativeMarks DECIMAL(3,2) NOT NULL DEFAULT 0.25;
GO

-- ----------------------------------------------------------
-- Answers: widen StudentAns to hold text (paragraph) answers
-- ----------------------------------------------------------
-- Drop default constraint if it exists, then alter column
DECLARE @cnAns NVARCHAR(200);
SELECT @cnAns = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('Answers') AND c.name = 'StudentAns';
IF @cnAns IS NOT NULL
    EXEC('ALTER TABLE Answers DROP CONSTRAINT ' + @cnAns);
GO

ALTER TABLE Answers ALTER COLUMN StudentAns NVARCHAR(500) NULL;
GO

PRINT 'QuizWizDB updated successfully!';
PRINT 'New columns: QuestionsTable.QuestionType, QuestionsTable.CorrectOptions';
PRINT 'New columns: Quiz.NegativeMarking, Quiz.NegativeMarks';
PRINT 'Modified:    Answers.StudentAns -> NVARCHAR(500)';
GO
