DROP TABLE IF EXISTS RoomStays;
DROP TABLE IF EXISTS Rooms;

DROP TABLE IF EXISTS Levels;
DROP TABLE IF EXISTS Guests;
DROP TABLE IF EXISTS Classes;
DROP TABLE IF EXISTS GuestStatuses;

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Services;
DROP TABLE IF EXISTS Status;
DROP TABLE IF EXISTS SuppliesReceiving;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Supplies;
DROP TABLE IF EXISTS Rats;
DROP TABLE IF EXISTS Taverns;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS UserRoles;

/* DB Class 1 */

CREATE TABLE UserRoles (
	id int NOT NULL PRIMARY KEY IDENTITY(2,1),
	name varchar(127) NOT NULL,
	descrip varchar(255)
);

INSERT INTO UserRoles (name, descrip) VALUES ('Owner', 'Owner of the tavern');
INSERT INTO UserRoles (name, descrip) VALUES ('Management', 'Runs different aspects of the business');
INSERT INTO UserRoles (name, descrip) VALUES ('Security', 'Protects the tavern from intruders');
INSERT INTO UserRoles (name, descrip) VALUES ('Janitorial', 'Cleans the tavern');
INSERT INTO UserRoles (name, descrip) VALUES ('Guest', 'Buys products and stays the night');

CREATE TABLE Users (
	id int NOT NULL PRIMARY KEY IDENTITY(3,1),
	name nvarchar(255) NOT NULL,
	role int FOREIGN KEY REFERENCES UserRoles(id),
	descrip varchar(255)
);

DECLARE @owner int;
SELECT @owner = id FROM UserRoles WHERE name = 'Owner';
DECLARE @guest int;
SELECT @guest = id FROM UserRoles WHERE name = 'Guest';

INSERT INTO Users (name, role, descrip) SELECT 'John Smith', @owner, 'Owner of the Pompous Tavern';
INSERT INTO Users (name, role, descrip) SELECT 'Madeline Ward', (SELECT id FROM UserRoles WHERE name = 'Management'), 'Manager at the Pompous Tavern';
INSERT INTO Users (name, role, descrip) SELECT 'Joe Sample', @guest, 'Sample customer';
INSERT INTO Users (name, role, descrip) SELECT 'José Cabrera', @owner, 'Owner of La Grande Tavern';
INSERT INTO Users (name, role, descrip) SELECT 'George Jones', (SELECT id FROM UserRoles WHERE name = 'Management'), 'Bartender at La Grande Tavern';
INSERT INTO Users (name, role, descrip) SELECT 'Mary Brown', (SELECT id FROM UserRoles WHERE name = 'Management'), 'Waitress at the Pompous Tavern';
INSERT INTO Users (name, role, descrip) SELECT 'John Rox', (SELECT id FROM UserRoles WHERE name = 'Security'), 'Bouncer at the Pompous Tavern';
INSERT INTO Users (name, role, descrip) SELECT 'Sally Samson', (SELECT id FROM UserRoles WHERE name = 'Janitorial'), 'Janitor at La Grande Tavern';
INSERT INTO Users (name, role, descrip) SELECT 'Valerie Harper', (SELECT id FROM UserRoles WHERE name = 'Security'), 'Bouncer at La Grande Tavern';
INSERT INTO Users (name, role, descrip) SELECT 'Sam Pullman', @guest, 'Guest at La Grande Tavern';

CREATE TABLE Locations (
	id int NOT NULL IDENTITY(20,1),
	address smallint NOT NULL,
	street nvarchar(255) NOT NULL
);

CREATE TABLE Taverns (
	id int NOT NULL PRIMARY KEY IDENTITY(4,1),
	name nvarchar(255) NOT NULL,
	location int NOT NULL,
	owner int NOT NULL FOREIGN KEY REFERENCES Users(id),
	floors tinyint DEFAULT 1
);

/* DB Class 2 alters */
ALTER TABLE Locations ADD PRIMARY KEY (id);
ALTER TABLE Taverns ADD FOREIGN KEY (location) REFERENCES Locations(id);

INSERT INTO Locations (address, street) VALUES (100, 'Baltimore Avenue');
INSERT INTO Locations (address, street) VALUES (100, 'Market Place');
INSERT INTO Locations (address, street) VALUES (150, 'Turnpike Road');
INSERT INTO Locations (address, street) VALUES (200, 'Pure Street');
INSERT INTO Locations (address, street) VALUES (200, 'Turnpike Road');

INSERT INTO Taverns (name, location, owner, floors) SELECT 'Pompous Tavern', (SELECT id FROM Locations WHERE address = 100 AND street = 'Baltimore Avenue'), (SELECT TOP 1 id FROM Users WHERE name = 'John Smith' AND role = @owner), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT 'La Grande Tavern', (SELECT id FROM Locations WHERE address = 100 AND street = 'Market Place'), (SELECT TOP 1 id FROM Users WHERE name = 'José Cabrera' AND role = @owner), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT 'Bombastic Tavern', (SELECT id FROM Locations WHERE address = 150 AND street = 'Turnpike Road'), (SELECT TOP 1 id FROM Users WHERE name = 'John Smith' AND role = @owner), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT 'Grandiose Tavern', (SELECT id FROM Locations WHERE address = 200 AND street = 'Pure Street'), (SELECT TOP 1 id FROM Users WHERE name = 'John Smith' AND role = @owner), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT 'El Verde Tavern', (SELECT id FROM Locations WHERE address = 200 AND street = 'Turnpike Road'), (SELECT TOP 1 id FROM Users WHERE name = 'José Cabrera' AND role = @owner), 2;

/*CREATE TABLE Rats (
	id int NOT NULL PRIMARY KEY IDENTITY(5,1),
	name varchar(255) NOT NULL,
	tavern int NOT NULL FOREIGN KEY REFERENCES Taverns(id)
);

INSERT INTO Rats (name, tavern) SELECT 'Steve', (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern');
INSERT INTO Rats (name, tavern) SELECT 'Gabe', (SELECT TOP 1 id FROM Taverns WHERE name = 'La Grande Tavern');
INSERT INTO Rats (name, tavern) SELECT 'Joe', (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern');
INSERT INTO Rats (name, tavern) SELECT 'Krill', (SELECT TOP 1 id FROM Taverns WHERE name = 'Grandiose Tavern');
INSERT INTO Rats (name, tavern) SELECT 'Sam', (SELECT TOP 1 id FROM Taverns WHERE name = 'El Verde Tavern');
*/
CREATE TABLE Supplies (
	id int NOT NULL PRIMARY KEY IDENTITY(6,1),
	name varchar(255) NOT NULL,
	unit varchar(16) NOT NULL
);

INSERT INTO Supplies (name, unit) VALUES ('Strong Ale','pint');
INSERT INTO Supplies (name, unit) VALUES ('Glassware','dozen');
INSERT INTO Supplies (name, unit) VALUES ('Whiskey','ounce');
INSERT INTO Supplies (name, unit) VALUES ('Cocktail Napkins','gross');
INSERT INTO Supplies (name, unit) VALUES ('Vodka','ounce');

CREATE TABLE Inventory (
	id int NOT NULL PRIMARY KEY IDENTITY(7,1),
	supplyId int NOT NULL FOREIGN KEY REFERENCES Supplies(id),
	tavernId int NOT NULL FOREIGN KEY REFERENCES Taverns(id),
	lastUpdated datetime,
	count smallint DEFAULT 0
);

INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = 'Strong Ale'), (SELECT id FROM Taverns WHERE name = 'La Grande Tavern'), '2019-03-01 06:30:00';
INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = 'Glassware'), (SELECT id FROM Taverns WHERE name = 'La Grande Tavern'), '2019-02-06 07:00:00';
INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = 'Whiskey'), (SELECT id FROM Taverns WHERE name = 'Pompous Tavern'), '2019-03-03 08:00:00';
INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = 'Glassware'), (SELECT id FROM Taverns WHERE name = 'Pompous Tavern'), '2019-02-28 05:00:00';
INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = 'Cocktail Napkins'), (SELECT id FROM Taverns WHERE name = 'Pompous Tavern'), '2019-02-28 05:00:00';

CREATE TABLE SuppliesReceiving (
	id int NOT NULL PRIMARY KEY IDENTITY(8,1),
	supplyId int NOT NULL FOREIGN KEY REFERENCES Supplies(id),
	tavernId int NOT NULL FOREIGN KEY REFERENCES Taverns(id),
	cost float,
	amount int DEFAULT 1,
	dateReceived datetime
);

INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = 'Glassware'), (SELECT TOP 1 id FROM Taverns WHERE name = 'La Grande Tavern'), 600, 100, '2019-01-11 07:00:00';
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = 'Strong Ale'), (SELECT TOP 1 id FROM Taverns WHERE name = 'La Grande Tavern'), 240, 60, '2019-01-11 06:30:00';
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = 'Glassware'), (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern'), 900, 150, '2019-01-17 05:00:00';
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = 'Whiskey'), (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern'), 400, 1600, '2019-01-17 08:00:00';
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = 'Strong Ale'), (SELECT TOP 1 id FROM Taverns WHERE name = 'La Grande Tavern'), 200, 50, '2019-02-18 06:30:00';
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = 'Cocktail Napkins'), (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern'), 50, 100, '2019-02-20 05:00:00';
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = 'Whiskey'), (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern'), 600, 100, '2019-02-28 08:00:00';

CREATE TABLE Status (
	id int NOT NULL PRIMARY KEY IDENTITY(9,1),
	name varchar(127) NOT NULL
);

INSERT INTO Status (name) VALUES ('Active');
INSERT INTO Status (name) VALUES ('Inactive');
INSERT INTO Status (name) VALUES ('Out of stock');
INSERT INTO Status (name) VALUES ('Discontinued');
INSERT INTO Status (name) VALUES ('In development');

CREATE TABLE Services (
	id int NOT NULL PRIMARY KEY IDENTITY(10,1),
	name varchar(255) NOT NULL,
	status int NOT NULL FOREIGN KEY REFERENCES Status(id)
);

INSERT INTO Services (name, status) SELECT 'Room Service', (SELECT id FROM Status WHERE name = 'Active');
INSERT INTO Services (name, status) SELECT 'Pool', (SELECT id FROM Status WHERE name = 'Inactive');
INSERT INTO Services (name, status) SELECT 'Drinks', (SELECT id FROM Status WHERE name = 'Active');
INSERT INTO Services (name, status) SELECT 'Comedy Night', (SELECT id FROM Status WHERE name = 'Discontinued');
INSERT INTO Services (name, status) SELECT 'Wi-Fi', (SELECT id FROM Status WHERE name = 'Active');

CREATE TABLE Sales (
	id int NOT NULL PRIMARY KEY IDENTITY(11,1),
	guest int NOT NULL FOREIGN KEY REFERENCES Users(id),
	service int NOT NULL FOREIGN KEY REFERENCES Services(id),
	tavern int NOT NULL FOREIGN KEY REFERENCES Taverns(id),
	price float,
	datePurchased datetime,
	amountPurchased int DEFAULT 1
);

INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = 'Joe Sample' AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = 'Room Service'), (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern'), 15, '2019-03-05 18:18:23', 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = 'Joe Sample' AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = 'Drinks'), (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern'), 5, '2019-03-05 21:46:08', 3;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = 'Joe Sample' AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = 'Room Service'), (SELECT TOP 1 id FROM Taverns WHERE name = 'Pompous Tavern'), 15, '2019-03-06 18:09:54', 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = 'Sam Pullman' AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = 'Wi-Fi'), (SELECT TOP 1 id FROM Taverns WHERE name = 'La Grande Tavern'), 20, '2019-03-01 07:44:32', 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = 'Sam Pullman' AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = 'Drinks'), (SELECT TOP 1 id FROM Taverns WHERE name = 'La Grande Tavern'), 6, '2019-03-01 22:01:26', 2;

/* DB Class 2 */

CREATE TABLE GuestStatuses (
	id tinyint NOT NULL PRIMARY KEY IDENTITY(21,1),
	name varchar(64) NOT NULL
);

INSERT INTO GuestStatuses (name) VALUES ('Sick');
INSERT INTO GuestStatuses (name) VALUES ('Fine');
INSERT INTO GuestStatuses (name) VALUES ('Hangry');
INSERT INTO GuestStatuses (name) VALUES ('Raging');
INSERT INTO GuestStatuses (name) VALUES ('Placid');

CREATE TABLE Classes (
	id smallint NOT NULL PRIMARY KEY IDENTITY(12,1),
	name varchar(64) NOT NULL
);

INSERT INTO Classes (name) VALUES ('Freelancer');
INSERT INTO Classes (name) VALUES ('Knight');
INSERT INTO Classes (name) VALUES ('White Mage');
INSERT INTO Classes (name) VALUES ('Black Mage');
INSERT INTO Classes (name) VALUES ('Red Mage');
INSERT INTO Classes (name) VALUES ('Blue Mage');
INSERT INTO Classes (name) VALUES ('Thief');
INSERT INTO Classes (name) VALUES ('Samurai');
INSERT INTO Classes (name) VALUES ('Archer');
INSERT INTO Classes (name) VALUES ('Mimic');

CREATE TABLE Guests (
	id int NOT NULL PRIMARY KEY IDENTITY(13,1),
	name nvarchar(255) NOT NULL,
	notes varchar(MAX),
	birthdate date,
	cakeday date,
	statusId tinyint FOREIGN KEY REFERENCES GuestStatuses(id)
);

INSERT INTO Guests (name, birthdate, cakeday, statusId) SELECT 'Joe Sample', '1960-07-08', '1960-07-11', (SELECT id FROM GuestStatuses WHERE name = 'Fine');
INSERT INTO Guests (name, birthdate, cakeday, statusId) SELECT 'Sam Pullman', '1972-04-01', '1972-04-01', (SELECT id FROM GuestStatuses WHERE name = 'Placid');
INSERT INTO Guests (name, birthdate, cakeday, statusId) SELECT 'Mark Abel', '1955-08-17', '1960-08-16', (SELECT id FROM GuestStatuses WHERE name = 'Hangry');
INSERT INTO Guests (name, birthdate, cakeday, statusId) SELECT 'John Stewart', '1988-11-23', '1988-11-26', (SELECT id FROM GuestStatuses WHERE name = 'Raging');
INSERT INTO Guests (name, birthdate, cakeday, statusId) SELECT 'Cameron Baker', '1969-03-30', '1969-04-01', (SELECT id FROM GuestStatuses WHERE name = 'Sick');

CREATE TABLE Levels (
	guestId int NOT NULL,
	classId smallint NOT NULL,
	currentLevel tinyint DEFAULT 1
);

ALTER TABLE Levels ADD CONSTRAINT PK_Levels PRIMARY KEY (guestId, classId);
ALTER TABLE Levels ADD CONSTRAINT FK_Levels_Guests FOREIGN KEY (guestId) REFERENCES Guests(id);
ALTER TABLE Levels ADD CONSTRAINT FK_Levels_Classes FOREIGN KEY (classId) REFERENCES Classes(id);

INSERT INTO Levels (guestId, classId, currentLevel) SELECT (SELECT id FROM Guests WHERE name = 'Joe Sample'), (SELECT id FROM Classes WHERE name = 'Freelancer'), 3;
INSERT INTO Levels (guestId, classId, currentLevel) SELECT (SELECT id FROM Guests WHERE name = 'Sam Pullman'), (SELECT id FROM Classes WHERE name = 'Knight'), 5;
INSERT INTO Levels (guestId, classId, currentLevel) SELECT (SELECT id FROM Guests WHERE name = 'Mark Abel'), (SELECT id FROM Classes WHERE name = 'Archer'), 9;
INSERT INTO Levels (guestId, classId, currentLevel) SELECT (SELECT id FROM Guests WHERE name = 'Mark Abel'), (SELECT id FROM Classes WHERE name = 'Knight'), 9;
INSERT INTO Levels (guestId, classId, currentLevel) SELECT (SELECT id FROM Guests WHERE name = 'John Stewart'), (SELECT id FROM Classes WHERE name = 'Mimic'), 1;
INSERT INTO Levels (guestId, classId, currentLevel) SELECT (SELECT id FROM Guests WHERE name = 'Cameron Baker'), (SELECT id FROM Classes WHERE name = 'Black Mage'), 7;

/* DB Class 3 */

CREATE TABLE Rooms (
	id int NOT NULL PRIMARY KEY IDENTITY(21,1),
	tavern int NOT NULL FOREIGN KEY REFERENCES Taverns(id),
	status int FOREIGN KEY REFERENCES Status(id)
);

INSERT INTO Rooms (tavern, status) SELECT (SELECT id FROM Taverns WHERE name = 'Pompous Tavern'), (SELECT id FROM Status WHERE name = 'Active'); 
INSERT INTO Rooms (tavern, status) SELECT (SELECT id FROM Taverns WHERE name = 'La Grande Tavern'), (SELECT id FROM Status WHERE name = 'Active');
INSERT INTO Rooms (tavern, status) SELECT (SELECT id FROM Taverns WHERE name = 'Bombastic Tavern'), (SELECT id FROM Status WHERE name = 'Active');
INSERT INTO Rooms (tavern, status) SELECT (SELECT id FROM Taverns WHERE name = 'Grandiose Tavern'), (SELECT id FROM Status WHERE name = 'Active');
INSERT INTO Rooms (tavern, status) SELECT (SELECT id FROM Taverns WHERE name = 'El Verde Tavern'), (SELECT id FROM Status WHERE name = 'Active');

CREATE TABLE RoomStays (
	id int NOT NULL PRIMARY KEY IDENTITY(22,1),
	sale money NOT NULL,
	guest int NOT NULL FOREIGN KEY REFERENCES Guests(id),
	room int NOT NULL FOREIGN KEY REFERENCES Rooms(id),
	dateStayed date,
	rate money
);

INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 300, (SELECT id FROM Guests WHERE name = 'Joe Sample'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'Pompous Tavern'), '2019-03-05', 100;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 160, (SELECT id FROM Guests WHERE name = 'Sam Pullman'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'La Grande Tavern'), '2019-03-01', 80;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 190, (SELECT id FROM Guests WHERE name = 'Mark Abel'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'Bombastic Tavern'), '2019-02-27', 95;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 330, (SELECT id FROM Guests WHERE name = 'John Stewart'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'Grandiose Tavern'), '2019-03-02', 110;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 225, (SELECT id FROM Guests WHERE name = 'Cameron Baker'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'El Verde Tavern'), '2019-03-07', 75;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 200, (SELECT id FROM Guests WHERE name = 'Joe Sample'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'Pompous Tavern'), '2019-03-20', 100;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 95, (SELECT id FROM Guests WHERE name = 'Mark Abel'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'Bombastic Tavern'), '2019-03-13', 95;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 220, (SELECT id FROM Guests WHERE name = 'John Stewart'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'Grandiose Tavern'), '2019-03-09', 110;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 80, (SELECT id FROM Guests WHERE name = 'Joe Sample'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'Grandiose Tavern'), '2019-04-01', 80;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 150, (SELECT id FROM Guests WHERE name = 'Cameron Baker'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'El Verde Tavern'), '2019-04-04', 75;
INSERT INTO RoomStays (sale, guest, room, dateStayed, rate) SELECT 240, (SELECT id FROM Guests WHERE name = 'Sam Pullman'), (SELECT R.id FROM Rooms R JOIN Taverns T ON R.tavern = T.id WHERE T.name = 'La Grande Tavern'), '2019-04-05', 80;

/* #2 */
SELECT * FROM Guests WHERE birthdate < '2000-01-01';

/* #3 */
SELECT * FROM RoomStays WHERE rate > 100;

/* #4 */
SELECT DISTINCT name FROM Guests;

/* #5 */
SELECT * FROM Guests ORDER BY name ASC;

/* #6 */
SELECT TOP 10 sale FROM RoomStays GROUP BY sale ORDER BY sale DESC;

/* #7 */
SELECT name FROM Status
UNION
SELECT street FROM Locations
UNION
SELECT name FROM Services
UNION
SELECT name FROM GuestStatuses
UNION
SELECT name FROM Classes;

/* #8 */
SELECT C.name AS Class, L.currentLevel AS Level, CASE
	WHEN L.currentLevel > 0 AND L.currentLevel <= 10 THEN '1-10'
	WHEN L.currentLevel > 10 AND L.currentLevel <= 20 THEN '11-20'
	WHEN L.currentLevel > 20 AND L.currentLevel <= 30 THEN '21-30'
	WHEN L.currentLevel > 30 AND L.currentLevel <= 40 THEN '31-40'
	WHEN L.currentLevel > 40 AND L.currentLevel <= 50 THEN '41-50'
	WHEN L.currentLevel > 50 AND L.currentLevel <= 60 THEN '51-60'
	WHEN L.currentLevel > 60 AND L.currentLevel <= 70 THEN '61-70'
	WHEN L.currentLevel > 70 AND L.currentLevel <= 80 THEN '71-80'
	WHEN L.currentLevel > 80 AND L.currentLevel <= 90 THEN '81-90'
	WHEN L.currentLevel > 90 AND L.currentLevel <= 99 THEN '91-99'
	ELSE '0'
END AS LevelGrouping
FROM Classes C JOIN Levels L ON L.classId = C.id;

/* #9 */
DECLARE @destTable varchar(100);
SELECT @destTable = TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Status';

SELECT CONCAT('INSERT INTO ', @destTable, ' VALUES (', id, ', ''', name, ''');') AS InsertStatements FROM GuestStatuses;

/* DB Class 4 */

SELECT U.name, R.name AS role FROM Users U INNER JOIN UserRoles R ON U.role = R.id WHERE R.name = 'Owner' OR R.name = 'Management';

/* #2 */
SELECT U.name AS owner, T.name AS tavern, T.floors FROM Users U INNER JOIN UserRoles R ON U.role = R.id INNER JOIN Taverns T ON T.owner = U.id;

/* #3 */
SELECT G.name, G.birthdate, G.notes, C.name, L.currentLevel FROM Guests G LEFT JOIN Levels L ON G.id = L.guestId INNER JOIN Classes C ON L.classId = C.id
	ORDER BY G.name ASC;

/* #4 */
SELECT TOP 10 P.price, S.name FROM Sales P INNER JOIN Services S ON P.service = S.id ORDER BY P.price DESC;

/* #5 */
SELECT G.name, COUNT(L.guestId) AS numOfClasses FROM Guests G INNER JOIN Levels L ON G.id = L.guestId
	GROUP BY G.name, L.guestId HAVING COUNT(L.guestId) >= 2;

/* #6 */
SELECT G.name, COUNT(L.guestId) AS numOfClasses FROM Guests G INNER JOIN Levels L ON G.id = L.guestId
	WHERE L.currentLevel > 5 GROUP BY G.name, L.guestId HAVING COUNT(L.guestId) >= 2;

/* #7 */
SELECT G.name, C.name AS highestLeveledClass, L.currentLevel AS level FROM Guests G INNER JOIN Levels L ON G.id = L.guestId INNER JOIN Classes C ON L.classId = C.id
	WHERE L.currentLevel IN (
		SELECT MAX(currentLevel) FROM Levels GROUP BY guestId
	);

/* #8 */
SELECT G.name, R.dateStayed FROM Guests G INNER JOIN RoomStays R ON G.id = R.guest WHERE R.dateStayed BETWEEN '2019-03-01' AND '2019-03-31';

/* #9 */
DECLARE @TableName varchar(100);
SELECT @TableName = TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Taverns';
DECLARE @LastColumn varchar(100);
SELECT @LastColumn = COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName ORDER BY ORDINAL_POSITION ASC;

SELECT CONCAT('CREATE TABLE ', @TableName,' (') AS CreateStatement
UNION ALL
SELECT CONCAT(C.COLUMN_NAME, ' ', C.DATA_TYPE, CASE
	WHEN C.CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN CONCAT('(',C.CHARACTER_MAXIMUM_LENGTH,')')
	ELSE ''
END, CASE
	WHEN C.IS_NULLABLE = 'NO' THEN ' NOT NULL'
	ELSE ''
END, CASE
	WHEN (SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
		WHERE TABLE_NAME = @TableName AND COLUMN_NAME = C.COLUMN_NAME)
	LIKE 'PK__%' THEN ' PRIMARY KEY'
	WHEN (SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
		WHERE TABLE_NAME = @TableName AND COLUMN_NAME = C.COLUMN_NAME)
	LIKE 'FK__%' THEN CONCAT(
		' FOREIGN KEY REFERENCES ',(
			SELECT CONCAT(TABLE_NAME,'(',COLUMN_NAME,')') FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME IN (
				SELECT K.CONSTRAINT_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE K JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R
					ON K.CONSTRAINT_NAME = R.UNIQUE_CONSTRAINT_NAME JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE F
					ON R.CONSTRAINT_NAME = F.CONSTRAINT_NAME WHERE F.TABLE_NAME = @TableName AND F.COLUMN_NAME = C.COLUMN_NAME
			)
		)
	)
	ELSE ''
END, CASE
	WHEN COLUMNPROPERTY(object_id(C.TABLE_SCHEMA+'.'+@TableName), C.COLUMN_NAME, 'IsIdentity') = 1 THEN ' IDENTITY'
	/*WHEN EXISTS (
		SELECT sysObj.name FROM sys.objects sysObj
		INNER JOIN sys.columns sysCol ON sysObj.object_id = sysCol.object_id
		INNER JOIN sys.objects sysTab ON sysObj.parent_object_id = sysTab.object_id
		WHERE sysCol.is_identity = 1 AND sysTab.name = @TableName AND sysCol.name = C.COLUMN_NAME
	) THEN ' IDENTITY'*/
	ELSE ''
END, CASE
	WHEN C.COLUMN_NAME = @LastColumn THEN ''
	ELSE ','
END) AS CreateStatement
FROM INFORMATION_SCHEMA.COLUMNS C
WHERE C.TABLE_NAME = @TableName
UNION ALL
SELECT ');' AS CreateStatement;