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

INSERT INTO UserRoles (name, descrip) VALUES ("Owner", "Owner of the tavern");
INSERT INTO UserRoles (name, descrip) VALUES ("Management", "Runs different aspects of the business");
INSERT INTO UserRoles (name, descrip) VALUES ("Security", "Protects the tavern from intruders");
INSERT INTO UserRoles (name, descrip) VALUES ("Janitorial", "Cleans the tavern");
INSERT INTO UserRoles (name, descrip) VALUES ("Guest", "Buys products and stays the night");

CREATE TABLE Users (
	id int NOT NULL PRIMARY KEY IDENTITY(3,1),
	name nvarchar(255) NOT NULL,
	role int FOREIGN KEY REFERENCES UserRoles(id),
	descrip varchar(255)
);

DECLARE @owner int;
SELECT @owner = id FROM UserRoles WHERE name = "Owner";
DECLARE @guest int;
SELECT @guest = id FROM UserRoles WHERE name = "Guest";

INSERT INTO Users (name, role, descrip) SELECT "John Smith", @owner, "Owner of the Pompous Tavern";
INSERT INTO Users (name, role, descrip) SELECT "Madeline Ward", (SELECT id FROM UserRoles WHERE name = "Management"), "Manager at the Pompous Tavern";
INSERT INTO Users (name, role, descrip) SELECT "Joe Sample", @guest, "Sample customer";
INSERT INTO Users (name, role, descrip) SELECT "Jos� Cabrera", @owner, "Owner of La Grande Tavern";
INSERT INTO Users (name, role, descrip) SELECT "George Jones", (SELECT id FROM UserRoles WHERE name = "Management"), "Bartender at La Grande Tavern";
INSERT INTO Users (name, role, descrip) SELECT "Mary Brown", (SELECT id FROM UserRoles WHERE name = "Management"), "Waitress at the Pompous Tavern";
INSERT INTO Users (name, role, descrip) SELECT "John Rox", (SELECT id FROM UserRoles WHERE name = "Security"), "Bouncer at the Pompous Tavern";
INSERT INTO Users (name, role, descrip) SELECT "Sally Samson", (SELECT id FROM UserRoles WHERE name = "Janitorial"), "Janitor at La Grande Tavern";
INSERT INTO Users (name, role, descrip) SELECT "Valerie Harper", (SELECT id FROM UserRoles WHERE name = "Security"), "Bouncer at La Grande Tavern";
INSERT INTO Users (name, role, descrip) SELECT "Sam Pullman", @guest, "Guest at La Grande Tavern";

CREATE TABLE Locations (
	id int NOT NULL,
	address smallint NOT NULL,
	street nvarchar(255) NOT NULL
);

INSERT INTO Locations (address, street) VALUES (100, "Baltimore Avenue");
INSERT INTO Locations (address, street) VALUES (100, "Market Place");
INSERT INTO Locations (address, street) VALUES (150, "Turnpike Road");
INSERT INTO Locations (address, street) VALUES (200, "Pure Street");
INSERT INTO Locations (address, street) VALUES (200, "Turnpike Road");

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

INSERT INTO Taverns (name, location, owner, floors) SELECT "Pompous Tavern", (SELECT id FROM Locations WHERE address = 100 AND street = "Baltimore Avenue"), (SELECT TOP 1 id FROM Users WHERE name = "John Smith" AND role = @owner), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT "La Grande Tavern", (SELECT id FROM Locations WHERE address = 100 AND street = "Market Place"), (SELECT TOP 1 id FROM Users WHERE name = "Jos� Cabrera" AND role = @owner), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT "Bombastic Tavern", (SELECT id FROM Locations WHERE address = 150 AND street = "Turnpike Road"), (SELECT TOP 1 id FROM Users WHERE name = "John Smith" AND role = @owner), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT "Grandiose Tavern", (SELECT id FROM Locations WHERE address = 200 AND street = "Pure Street"), (SELECT TOP 1 id FROM Users WHERE name = "John Smith" AND role = @owner), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT "El Verde Tavern", (SELECT id FROM Locations WHERE address = 200 AND street = "Turnpike Road"), (SELECT TOP 1 id FROM Users WHERE name = "Jos� Cabrera" AND role = @owner), 2;

/*CREATE TABLE Rats (
	id int NOT NULL PRIMARY KEY IDENTITY(5,1),
	name varchar(255) NOT NULL,
	tavern int NOT NULL FOREIGN KEY REFERENCES Taverns(id)
);

INSERT INTO Rats (name, tavern) SELECT "Steve", (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern");
INSERT INTO Rats (name, tavern) SELECT "Gabe", (SELECT TOP 1 id FROM Taverns WHERE name = "La Grande Tavern");
INSERT INTO Rats (name, tavern) SELECT "Joe", (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern");
INSERT INTO Rats (name, tavern) SELECT "Krill", (SELECT TOP 1 id FROM Taverns WHERE name = "Grandiose Tavern");
INSERT INTO Rats (name, tavern) SELECT "Sam", (SELECT TOP 1 id FROM Taverns WHERE name = "El Verde Tavern");
*/
CREATE TABLE Supplies (
	id int NOT NULL PRIMARY KEY IDENTITY(6,1),
	name varchar(255) NOT NULL,
	unit varchar(16) NOT NULL
);

INSERT INTO Supplies (name, unit) VALUES ("Strong Ale","pint");
INSERT INTO Supplies (name, unit) VALUES ("Glassware","dozen");
INSERT INTO Supplies (name, unit) VALUES ("Whiskey","ounce");
INSERT INTO Supplies (name, unit) VALUES ("Cocktail Napkins","gross");
INSERT INTO Supplies (name, unit) VALUES ("Vodka","ounce");

CREATE TABLE Inventory (
	id int NOT NULL PRIMARY KEY IDENTITY(7,1),
	supplyId int NOT NULL FOREIGN KEY REFERENCES Supplies(id),
	tavernId int NOT NULL FOREIGN KEY REFERENCES Taverns(id),
	lastUpdated datetime,
	count smallint DEFAULT 0
);

INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = "Strong Ale"), (SELECT id FROM Taverns WHERE name = "La Grande Tavern"), "2019-03-01 06:30:00";
INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = "Glassware"), (SELECT id FROM Taverns WHERE name = "La Grande Tavern"), "2019-02-06 07:00:00";
INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = "Whiskey"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern"), "2019-03-03 08:00:00";
INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = "Glassware"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern"), "2019-02-28 05:00:00";
INSERT INTO Inventory (supplyId, tavernId, lastUpdated) SELECT (SELECT id FROM Supplies WHERE name = "Cocktail Napkins"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern"), "2019-02-28 05:00:00";

CREATE TABLE SuppliesReceiving (
	id int NOT NULL PRIMARY KEY IDENTITY(8,1),
	supplyId int NOT NULL FOREIGN KEY REFERENCES Supplies(id),
	tavernId int NOT NULL FOREIGN KEY REFERENCES Taverns(id),
	cost float,
	amount int DEFAULT 1,
	dateReceived datetime
);

INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Glassware"), (SELECT TOP 1 id FROM Taverns WHERE name = "La Grande Tavern"), 600, 100, "2019-01-11 07:00:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Strong Ale"), (SELECT TOP 1 id FROM Taverns WHERE name = "La Grande Tavern"), 240, 60, "2019-01-11 06:30:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Glassware"), (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern"), 900, 150, "2019-01-17 05:00:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Whiskey"), (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern"), 400, 1600, "2019-01-17 08:00:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Strong Ale"), (SELECT TOP 1 id FROM Taverns WHERE name = "La Grande Tavern"), 200, 50, "2019-02-18 06:30:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Cocktail Napkins"), (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern"), 50, 100, "2019-02-20 05:00:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Whiskey"), (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern"), 600, 100, "2019-02-28 08:00:00";

CREATE TABLE Status (
	id int NOT NULL PRIMARY KEY IDENTITY(9,1),
	name varchar(127) NOT NULL
);

INSERT INTO Status (name) VALUES ("Active");
INSERT INTO Status (name) VALUES ("Inactive");
INSERT INTO Status (name) VALUES ("Out of stock");
INSERT INTO Status (name) VALUES ("Discontinued");
INSERT INTO Status (name) VALUES ("In development");

CREATE TABLE Services (
	id int NOT NULL PRIMARY KEY IDENTITY(10,1),
	name varchar(255) NOT NULL,
	status int NOT NULL FOREIGN KEY REFERENCES Status(id)
);

INSERT INTO Services (name, status) SELECT "Room Service", (SELECT id FROM Status WHERE name = "Active");
INSERT INTO Services (name, status) SELECT "Pool", (SELECT id FROM Status WHERE name = "Inactive");
INSERT INTO Services (name, status) SELECT "Drinks", (SELECT id FROM Status WHERE name = "Active");
INSERT INTO Services (name, status) SELECT "Comedy Night", (SELECT id FROM Status WHERE name = "Discontinued");
INSERT INTO Services (name, status) SELECT "Wi-Fi", (SELECT id FROM Status WHERE name = "Active");

CREATE TABLE Sales (
	id int NOT NULL PRIMARY KEY IDENTITY(11,1),
	guest int NOT NULL FOREIGN KEY REFERENCES Users(id),
	service int NOT NULL FOREIGN KEY REFERENCES Services(id),
	tavern int NOT NULL FOREIGN KEY REFERENCES Taverns(id),
	price float,
	datePurchased datetime,
	amountPurchased int DEFAULT 1
);

INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = "Joe Sample" AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = "Room Service"), (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern"), 15, "2019-03-05 18:18:23", 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = "Joe Sample" AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = "Drinks"), (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern"), 5, "2019-03-05 21:46:08", 3;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = "Joe Sample" AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = "Room Service"), (SELECT TOP 1 id FROM Taverns WHERE name = "Pompous Tavern"), 15, "2019-03-06 18:09:54", 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = "Sam Pullman" AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = "Wi-Fi"), (SELECT TOP 1 id FROM Taverns WHERE name = "La Grande Tavern"), 20, "2019-03-01 07:44:32", 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT TOP 1 id FROM Users WHERE name = "Sam Pullman" AND role = @guest), (SELECT TOP 1 id FROM Services WHERE name = "Drinks"), (SELECT TOP 1 id FROM Taverns WHERE name = "La Grande Tavern"), 6, "2019-03-01 22:01:26", 2;