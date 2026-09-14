--Step 1 create a catalog
CREATE CATALOG IF NOT EXISTS exercise4;

--Step 2 create a schema
CREATE SCHEMA IF NOT EXISTS exercise4.joins;

--Step 3 create a table
CREATE TABLE IF NOT EXISTS exercise4.joins.users (user_id INT,user_name STRING,country STRING);

--Step 4 insert data into the table
INSERT INTO exercise4.joins.users 
VALUES (1,'Nomvula','Johannesburg'),
(2,'David','Capetown'),
(3,'Anele','Durban'),
(4,'Kabelo','Pretoria'),
(5,'Lerato','Port Elizabeth');

SELECT *
FROM exercise4.joins.users;

--TABLE 2 PLANS

CREATE TABLE IF NOT EXISTS exercise4.joins.plans (plan_id INT,plan_name STRING,monthly_price INT);

INSERT INTO exercise4.joins.plans
VALUES (10,'Basic',79),
(11,'Standard',129),
(12,'Premium',199),
(13,'Family',249),
(14,'Mobile',59);

SELECT*
FROM exercise4.joins.plans;

--TABLE 3 SUBSCRIPTIONS
CREATE TABLE IF NOT EXISTS exercise4.joins.subscriptions (subscription_id INT,user_id INT,plan_id INT,start_date DATE);

INSERT INTO exercise4.joins.subscriptions
VALUES (501,1,10,'2026-01-15'),
(502,2,11,'2026-02-01'),
(503,1,12,'2026-03-10'),
(504,6,11,'2026-03-20'),
(505,3,13,'2026-04-05');

SELECT*
FROM exercise4.joins.subscriptions;

--TABLE 4 SHOWS
CREATE TABLE IF NOT EXISTS exercise4.joins.shows (show_id INT,show_title STRING,genre STRING);

--Loading the table
INSERT INTO exercise4.joins.shows
VALUES (701,'Comedy Hour','Comedy'),
(702,'Crime Time','Drama'),
(703,'Tech Tales','Documentary'),
(704,'Cooking Lab','Lifestyle'),
(706,'Wild Earth','Documentary');

SELECT*
FROM exercise4.joins.shows;

--TABLE 5 Viewing_sessions
CREATE TABLE IF NOT EXISTS exercise4.joins.viewing_sessions (session_id INT,user_id INT,show_id INT,watch_minutes INT);

--Loading Table
INSERT INTO exercise4.joins.viewing_sessions
VALUES (901,1,701,45),
(902,2,703,30),
(903,1,702,60),
(904,7,701,20),
(905,3,705,90);

SELECT*
FROM exercise4.joins.viewing_sessions;

--QUESTIONS 
--QUESTION 1 Show every user who has a subscription. Match users to subscriptions

SELECT A.user_id,
       user_name,
       B.subscription_id,
       start_date
FROM exercise4.joins.users AS A
INNER JOIN exercise4.joins.subscriptions AS B
ON A.user_id=B.user_id;

--QUESTION 2 Show every subscription with its matching plan name and monthly price
SELECT A.subscription_id,
       A.user_id,
       plan_name,
       monthly_price
FROM exercise4.joins.subscriptions AS A
INNER JOIN exercise4.joins.plans AS B
ON A.plan_id=B.plan_id;

--QUESTION 3 Show every viewing session that has a matching show. Include the show title and genre
SELECT A.session_id,
       A.user_id,
       B.show_title,
       B.genre,
       watch_minutes
FROM exercise4.joins.viewing_sessions AS A
INNER JOIN exercise4.joins.shows AS B
ON A.show_id=B.show_id;

--QUESTION 4 Show every viewing session with the user who watched it. Only show sessions with a matching user
SELECT B.user_name,
       country,
       A.session_id,
       A.show_id,
       watch_minutes
FROM exercise4.joins.viewing_sessions AS A
INNER JOIN exercise4.joins.users AS B
ON A.user_id=B.user_id;

--QUESTION 5 Show users along with their subscriptions, the plan name, and the price. Use only users who have both a subscription and a valid plan
SELECT A.user_name,
       country,
       C.plan_name,
       monthly_price,
       start_date
FROM exercise4.joins.users AS A
INNER JOIN exercise4.joins.subscriptions AS B
ON A.user_id=B.user_id
INNER JOIN exercise4.joins.plans AS C
ON B.plan_id=C.plan_id;

--QUESTION 6 Show every user and any subscriptions they have. Users without subscriptions must still appear 
SELECT A.user_id,
       user_name,
       B.subscription_id,
       start_date
FROM exercise4.joins.users AS A
LEFT JOIN exercise4.joins.subscriptions AS B
ON A.user_id=B.user_id;

--QUESTION 7 Show every plan and the subscriptions on it. Plans with no subscribers must still appear 
SELECT A.plan_id,
       plan_name,
       subscription_id,
       user_id
FROM exercise4.joins.plans AS A
LEFT JOIN exercise4.joins.subscriptions AS B
ON A.plan_id=B.plan_id;

--QUESTION 8 Show every show and any viewing sessions on it. Shows that were never watched must still appear.
SELECT A.show_id,
       show_title,
       B.session_id,
       watch_minutes
FROM exercise4.joins.shows AS A
LEFT JOIN exercise4.joins.viewing_sessions AS B
ON A.show_id=B.show_id;

--QUESTION 9
--Show every viewing session and the user who watched it. Sessions referencing users that do not exist must still appear (with NULL user details).
SELECT A.session_id,
       show_id,
       watch_minutes,
       B.user_id,
       user_name
 FROM exercise4.joins.viewing_sessions AS A
 LEFT JOIN exercise4.joins.users AS B
 ON A.user_id=B.user_id;      

--QUESTION 10 Show every user, the plan they are on (if any), and the monthly price. Users without a subscription must still appear.

SELECT A.user_name,
       country,
       C.plan_name,
       C.monthly_price
FROM exercise4.joins.users AS A
LEFT JOIN exercise4.joins.subscriptions AS B
ON A.user_id=B.user_id
LEFT JOIN exercise4.joins.plans AS C
ON B.plan_id=C.plan_id;

--QUESTION 11 Show every user and every subscription, including users without subscriptions AND subscriptions referencing users that do not exist.
SELECT A.user_id,
       A.user_name,
       subscription_id,
       start_date
FROM exercise4.joins.users AS A
FULL JOIN exercise4.joins.subscriptions AS B
ON A.user_id=B.user_id;

--QUESTION 12 Show every plan and every subscription, including plans without subscribers AND any  subscription referencing a plan that does not exist.

SELECT DISTINCT plans.plan_id,
       plan_name,
       subscription_id,
       user_id
FROM exercise4.joins.subscriptions
FULL JOIN exercise4.joins.plans
ON subscriptions.plan_id=plans.plan_id;

--QUESTION 13 Show every show and every viewing session, including shows that were never watched AND sessions referencing shows that do not exist.
SELECT shows.show_id,
       show_title,
       session_id,
       watch_minutes
FROM exercise4.joins.shows
FULL JOIN exercise4.joins.viewing_sessions
ON shows.show_id=viewing_sessions.show_id;

--QUESTION 14 Show every user and every viewing session, including users with no sessions AND sessions referencing users who do not exist.
SELECT users.user_id,
       user_name,
       session_id,
       show_id,
       watch_minutes
FROM exercise4.joins.users
FULL JOIN exercise4.joins.viewing_sessions
ON users.user_id=viewing_sessions.user_id;

--QUESTION 15 Show every user, every subscription, and every plan in one query — using FULL OUTER JOIN throughout. This is the hardest question — get all gaps visible at once.
SELECT users.user_id,
       user_name,
       subscription_id,
       plans.plan_id,
       plan_name
 FROM exercise4.joins.users
 FULL JOIN exercise4.joins.subscriptions
 ON users.user_id=subscriptions.user_id
 FULL JOIN exercise4.joins.plans
 ON subscriptions.plan_id=plans.plan_id; 

 --Bonus Challenge
 --Question1 Which users have not subscribed to any plan?
-- Kabelo and Lerato have not subscribed to any plan

--Question 2 Which subscriptions reference users that do not exist in the users table?
--Subscription ID:504/User ID:6

--Question 3 Which shows have never been watched?
-- The cooking lab and wild earth have never been watched

--Question 4 Which viewing session reference shows that do not exist?
--Show ID 705 and session ID 905

--Question 5 which plans have no subscribers
--Mobile plan has no subscribers
