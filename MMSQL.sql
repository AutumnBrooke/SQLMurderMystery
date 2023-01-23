--Locate the report outlining the murder for the known date.

SELECT *
FROM crime_scene_report
WHERE date IN ('20180115') AND type IN ('murder') AND city IN ('SQL City');

Return:

date         type        description                                                                  city
20180115     murder      Security footage shows that there were 2 witnesses.                          SQL City
                         The first witness lives at the last house on "Northwestern Dr". 
                         The second witness, named Annabel, lives somewhere on "Franklin Ave".




--Pull up the witness that lives on Northwestern Dr.

SELECT *
FROM person
WHERE address_street_name IN ('Northwestern Dr')
ORDER BY address_number DESC
LIMIT 1;

Return - First Witness:

id         name                  license_id        address_number        address_street_name       ssn
14887      Morty Schapiro        118009            4919                  Northwestern Dr           111564949




--Find the witness named Anabel who lives on Franklin Ave.

SELECT *
FROM person
WHERE address_street_name IN ('Franklin Ave') AND name LIKE 'Annabel %'

Return - Second Witness:

id         name                   license_id       address_number        address_street_name       ssn
16371      Annabel Miller         490173           103                   Franklin Ave              318771143


--Get interview from each suspect:

SELECT name,
	 transcript
FROM person
	LEFT JOIN interview 
		ON id=person_id
WHERE name IN ('Annabel Miller', 'Morty Schapiro');


Return:

name               transcript
Morty Schapiro     I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
                   The membership number on the bag started with "48Z". Only gold members have those bags. 
                   The man got into a car with a plate that included "H42W".
Annabel Miller     I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.


--Following up on Morty’s interview:

SELECT m.name,
	   ci.membership_id,
	   m.membership_status,
	   d.plate_number,
	   ci.check_in_date
FROM get_fit_now_check_in AS ci
	JOIN get_fit_now_member AS m
		ON ci.membership_id = m.id
	JOIN person AS p
		ON m.person_id = p.id
	JOIN drivers_license AS d
		ON p.license_id = d.id
WHERE ci.check_in_date IN ('20180109')
	AND m.membership_status IN ('gold')
	AND m.id LIKE '48Z%'


Return - Killer:
name             membership_id   membership_status   plate_number   check_in_date
Jeremy Bowers    48Z55           gold                0H42W2         20180109



Check your solution
Did you find the killer?

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
       SELECT value FROM solution;

Congrats, you found the murderer! But wait, there's more... 
If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. 
If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. 
Use this same INSERT statement with your new suspect to check your answer.


--Look up Jeremy's interview

SELECT p.name,
	   i.transcript
FROM person AS p
	JOIN interview AS i
		ON p.id = i.person_id
WHERE p.name = "Jeremy Bowers"

Return:

name	            transcript
Jeremy Bowers	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
                  She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.




--Using that information, look for the woman who hired him.

SELECT p.name,
	   e.event_name,
	   d.height,
	   d.hair_color,
	   d.car_model
FROM facebook_event_checkin AS e
	JOIN person AS p
		ON e.person_id = p.id
	JOIN drivers_license AS d
		ON p.license_id = d.id
WHERE event_name LIKE '%concert%' 
	AND height BETWEEN 65 AND 67
	AND hair_color = 'red'
	AND d.gender = 'female'
	AND car_model = 'Model S'


Return - Person who hired the hitman:

name                 event_name              height   hair_color      car_model
Miranda Priestly     SQL Symphony Concert    66       red             Model S



Did you find the killer?

INSERT INTO solution VALUES (1, 'Miranda Priestly');
       SELECT value FROM solution;

Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!

