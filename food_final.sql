-- Checking if the database has been correctly imported
SELECT *
FROM food_schema.food_table;

-- 125 participants 
SELECT count(*)
from food_schema.food_table;

-- 76 females (gender=1) and 49 males (gender=2) participated in this study
SELECT Gender, COUNT(Gender) 
FROM food_schema.food_table
GROUP BY Gender; 

-- Participants with the highest weights
/* Among the participants with the highest weights, the top three consist of men who engage in cooking exclusively during holidays or not at all. 
 * One individual characterizes their dietary habits as unclear, while the other two describe theirs as healthy, balanced, or moderated. 
 * Additionally, two believe their eating habits have improved since college, while the third perceives them to be unchanged. In terms of physical 
 * activity, one participant exercises daily, another does so weekly, and the remaining individual did not provide a response. Notably, one of the 
 * participants never checks nutritional values, while the other two do so selectively, focusing on specific products.*/
SELECT gender, weight, cook,  diet_current_coded, eating_changes_coded,  exercise, nutritional_check
FROM food_schema.food_table
WHERE weight != -1
ORDER BY weight DESC
LIMIT 3;

/* The 66% of the students weight 156 pounds, 54% between 56 and 210 pounds and 5% between 211-265 pounds */
select 
	case
		when weight <= 155 then 'Group A (<=155 pounds)'
		when weight <= 210 then 'Group B (156-210 pounds)'
		when weight <= 265 then 'Group C (211-265 pounds)'
		else 'Group D (>265 pounds)'
	end Weight_group,
	count (*) as Frequency
from food_schema.food_table ft 
group by weight_group
order by weight_group;

-- The most common reason to eat comfort food is boredom, while the less common is hunger, excluding the NAs(-1) and the ones that answer none.
SELECT comfort_food_reasons_coded, COUNT(comfort_food_reasons_coded) AS Frequency
FROM food_schema.food_table
WHERE comfort_food_reasons_coded != -1 AND comfort_food_reasons_coded != 9
GROUP BY comfort_food_reasons_coded
ORDER BY Frequency DESC;

/* Of the total participants, comprising 125 individuals, 48% or 60 people work part-time, while 43%, equivalent to 54 participants, do not work. 
 * A small portion, 7% or 9 participants, did not provide a response to the question. Interestingly, only 1%, represented by 2 participants, engage in 
 * full-time employment.  */
SELECT employment, COUNT(employment) as frequency, COUNT(employment) * 100 / (SELECT COUNT(*) from food_schema.food_table) as percentage
FROM food_schema.food_table
GROUP BY employment
ORDER BY Frequency DESC;

-- 57 of the 125 participants exercise everyday, 44 participants do it twice or three times per week, 11 once a week and the rest didn't answer
SELECT exercise, COUNT(exercise) as frequency 
FROM food_schema.food_table
GROUP BY exercise
ORDER BY frequency DESC;

/* The majority, comprising 73 respondents, express a preference for homemade food. This is followed by 38 participants who favor a combination 
 * of store-bought and homemade meals. Interestingly, only 12 participants indicate a preference for solely store-bought food.*/
SELECT fav_food, COUNT(fav_food) AS frequency 
FROM food_schema.food_table
GROUP BY fav_food 
ORDER BY frequency DESC;


/* Based on the responses, Italian cuisine emerges as the most commonly consumed among the participants, followed by ethnic dishes. 
Conversely, Persian cuisine appears to be the least preferred among the respondents. */
with ethnic_food_likeliness as (
	select ethnic_food as likely, count(ethnic_food) as ethnic_frequency
	from food_schema.food_table ft 
	group by likely 
),
greek_food_likeliness as (
	select greek_food as likely, count(greek_food) as greek_frequency
	from food_schema.food_table ft 
	group by likely
),
indian_food_likeliness as (
	select indian_food as likely, count(indian_food) as indian_frequency
	from food_schema.food_table ft 
	group by likely
),
italian_food_likeliness as (
	select italian_food as likely, count(italian_food) as italian_frequency
	from food_schema.food_table ft 
	group by likely
),
persian_food_likeliness as (
	select persian_food as likely, count(persian_food) as persian_frequency
	from food_schema.food_table ft 
	group by likely
),
thai_food_likeliness as (
	select thai_food as likely, count(thai_food) as thai_frequency
	from food_schema.food_table ft 
	group by likely
)
select ethnic_food_likeliness.likely as likely, ethnic_food_likeliness.ethnic_frequency , greek_food_likeliness.greek_frequency,
indian_food_likeliness.indian_frequency, italian_food_likeliness.italian_frequency, persian_food_likeliness.persian_frequency,
thai_food_likeliness.thai_frequency
from greek_food_likeliness
left join ethnic_food_likeliness on ethnic_food_likeliness.likely = greek_food_likeliness.likely
left join indian_food_likeliness on indian_food_likeliness.likely = ethnic_food_likeliness.likely
left join italian_food_likeliness on italian_food_likeliness.likely =  ethnic_food_likeliness.likely
left join persian_food_likeliness on persian_food_likeliness.likely = ethnic_food_likeliness.likely
left join thai_food_likeliness on thai_food_likeliness.likely =  ethnic_food_likeliness.likely
order by ethnic_food_likeliness.likely asc ;


/* The 32% of the students have incomes higher than 100,000 USD, representing the majority of the participants*/
select income, count(income) as frequency, count(income) * 100 / (select count(*) 
from food_schema.food_table) as percentage
from food_schema.food_table ft 
where income != -1
group by income
order by frequency desc;

/* The majority, accounting for 60% of the respondents, prefer to dine out 1-2 times per week. Following this, 
 * 24% or 19 students opt for dining out 2-3 times weekly, while 12% never choose this option. Additionally, 
 * 13 respondents, representing a minority, dine out from 3 to 5 times per week, whereas 9% do so every day.*/
select eating_out , count(eating_out) as frequency, count(eating_out) * 100 / 
(select count(*) from food_schema.food_table) as percentage
from food_schema.food_table ft 
where eating_out != -1
group by eating_out 
order by frequency desc;
	
/* Most of the participants, comprising 45%, perceive their weight as just right. Meanwhile, 31% view themselves as slightly 
 * overweight, with an equal percentage feeling very fit. Interestingly, 6% consider themselves slim, while another 6% feel 
 * overweight. Only a small proportion, 5%, do not categorize themselves using these terms. */
select self_perception_weight, count(self_perception_weight)
from food_schema.food_table ft 
where self_perception_weight != -1
group by self_perception_weight
order by count(self_perception_weight) desc ;
