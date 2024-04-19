-- checking if the database has been correctly imported
SELECT *
FROM food_schema.food_table;

-- 125 participants 
SELECT count(*)
from food_schema.food_table;

-- 76 females (gender=1) and 49 males (gender=2) participated 
SELECT Gender, COUNT(Gender) 
FROM food_schema.food_table
GROUP BY Gender; 

-- Participants with the highest weights
/* The first 3 participants with the highest weights are men that cook only during holidays or never, one describes their diet as uncluear and the 
 * other two as healthy/balanced/moderated, 2 believe their eating changes since their were in college are better and the 3rd one thinks is the 
 * same, one of them excercises everyday another one once a week and the last one didn't answer,  one of the never checks the nutritional values 
 * and the other two on certain products only*/
SELECT gender, weight, cook,  diet_current_coded, eating_changes_coded,  exercise, nutritional_check
FROM food_schema.food_table
WHERE weight != -1
ORDER BY weight DESC
LIMIT 3;

/* The 66% of the students have a weight under 156 pounds, 
 * 54% between 56 and 210 pounds and 5% between 211-265 pounds */
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

-- The most common reason to eat comfort food is boredom, while the less common is hunger, excludind the NAs(-1) and the ones that answer none
SELECT comfort_food_reasons_coded, COUNT(comfort_food_reasons_coded) AS Frequency
FROM food_schema.food_table
WHERE comfort_food_reasons_coded != -1 AND comfort_food_reasons_coded != 9
GROUP BY comfort_food_reasons_coded
ORDER BY Frequency DESC;

/* The 48% of the total participants, which are 60 people, work part-time; while 54 participants (43%) do not work. 7% (9 participants) did not respond to 
 * the question, and only 1%, which is 2 participants, work full-time. So we can infer that */
SELECT employment, COUNT(employment) as frequency, COUNT(employment) * 100 / (SELECT COUNT(*) from food_schema.food_table) as percentage
FROM food_schema.food_table
GROUP BY employment
ORDER BY Frequency DESC;

-- 57 of the 125 participants exercise everyday, 44 participants do it twice or three times per week, 11 once a week and the rest didn't answer
SELECT exercise, COUNT(exercise) as frequency 
FROM food_schema.food_table
GROUP BY exercise
ORDER BY frequency DESC;

/* The majority (73 respondents) prefer the food cooked at home, follow by 38 participants prefering both bought at store and cooked at home and
* only 12 participants prefer th food store bought */
SELECT fav_food, COUNT(fav_food) AS frequency 
FROM food_schema.food_table
GROUP BY fav_food 
ORDER BY frequency DESC;


-- The most probably food that the respondents eat is italian, followed by ethnic, and the less one is persian.
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


/* The 32% of the students have incomes higher than 100,000 USD, representing the 
majority of the participants*/
select income, count(income) as frequency, count(income) * 100 / (select count(*) 
from food_schema.food_table) as percentage
from food_schema.food_table ft 
where income != -1
group by income
order by frequency desc;

/* They prefer to eat out 1-2 times per week with the 60% of frequency*/
select eating_out , count(eating_out) as frequency, count(eating_out) * 100 / 
(select count(*) from food_schema.food_table) as percentage
from food_schema.food_table ft 
where eating_out != -1
group by eating_out 
order by frequency desc;
	
/* Most of the participants, 45%, perceive their weight as just right, 31% as slightly overweight, 
 * the same percentage feel very fit, while 6% feel slim,  and another 6% feel overweight. 
 * Only 5% don't think of themselves in these terms. */
select self_perception_weight, count(self_perception_weight)
from food_schema.food_table ft 
where self_perception_weight != -1
group by self_perception_weight
order by count(self_perception_weight) desc ;


