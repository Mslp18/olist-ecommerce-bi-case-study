-- ==========================================
-- REVIEW EDA
-- ==========================================

-- Q1 Total Reviews

SELECT COUNT(*) AS total_reviews
FROM reviews;

-- Result: 99,224

-- Q2 Average Review Score

SELECT ROUND(
       AVG(review_score)::numeric,
       2
) AS avg_review_score
FROM reviews;

-- Result: 4.09 / 5

-- Q3 Review Score Distribution

SELECT review_score,
       COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;

-- Result:
-- 1 Star : 11,424
-- 2 Star : 3,151
-- 3 Star : 8,179
-- 4 Star : 19,142
-- 5 Star : 57,328

-- Key Finding:
-- Positive Reviews (4★ + 5★) ≈ 77.1% of all reviews

-- Q4 Five-Star Review Percentage

SELECT ROUND(
       COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM reviews),
       2
) AS five_star_percentage
FROM reviews
WHERE review_score = 5;

-- Result: 57.78%

-- Q5 Negative Review Percentage

SELECT ROUND(
       COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM reviews),
       2
) AS negative_review_percentage
FROM reviews
WHERE review_score IN (1, 2);

-- Result: 14.69%

-- Q6 Reviews With Written Comments

SELECT COUNT(*) AS reviews_with_comments
FROM reviews
WHERE review_comment_message IS NOT NULL;

-- Result:
-- Reviews with comments : 40,977
-- Percentage : 41.30%

-- Q7 Reviews Without Written Comments

SELECT COUNT(*) AS reviews_without_comments
FROM reviews
WHERE review_comment_message IS NULL;

-- Result:
-- Reviews without comments : 58,247
-- Percentage : 58.70%

-- Q8 Percentage of Reviews with Comments

SELECT ROUND(
       COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM reviews),
       2
) AS comment_review_percentage
FROM reviews
WHERE review_comment_message IS NOT NULL;

-- Result: 41.30%

-- Q9 Average Review Response Time

SELECT ROUND(
       AVG(
           EXTRACT(
               EPOCH FROM (
                   review_answer_timestamp -
                   review_creation_date
               )
           ) / 86400
       )::numeric,
       2
) AS avg_review_response_days
FROM reviews;

-- Result: 3.15 days

-- Q10 Missing Review Comment Percentage

SELECT ROUND(
       COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM reviews),
       2
) AS missing_comment_percentage
FROM reviews
WHERE review_comment_message IS NULL;

-- Result: 58.70%