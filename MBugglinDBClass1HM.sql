CREATE TABLE UserRoles (
	id int NOT NULL PRIMARY KEY IDENTITY(2,1),
	name varchar(127) NOT NULL,
	desc varchar(255)
);

INSERT INTO UserRoles (name, desc) VALUES ("Owner", "Owner of the tavern");
INSERT INTO UserRoles (name, desc) VALUES ("Management", "Runs different aspects of the business");
INSERT INTO UserRoles (name, desc) VALUES ("Security", "Protects the tavern from intruders");
INSERT INTO UserRoles (name, desc) VALUES ("Janitorial", "Cleans the tavern");
INSERT INTO UserRoles (name, desc) VALUES ("Guest", "Buys products and stays the night");

CREATE TABLE Users (
	id int NOT NULL PRIMARY KEY IDENTITY(3,1),
	name nvarchar(255) NOT NULL,
	role int FOREIGN KEY REFERENCES UserRoles(id),
	desc varchar(255)
);

DECLARE @owner int;
SELECT @owner = id FROM UserRoles WHERE name = "Owner";
DECLARE @guest int;
SELECT @guest = id FROM UserRoles WHERE name = "Guest";

INSERT INTO Users (name, role, desc) SELECT "John Smith", @owner, "Owner of the Pompous Tavern";
INSERT INTO Users (name, role, desc) SELECT "Madeline Ward", (SELECT id FROM UserRoles WHERE name = "Management"), "Manager at the Pompous Tavern";
INSERT INTO Users (name, role, desc) SELECT "Joe Sample", @guest, "Sample customer";
INSERT INTO Users (name, role, desc) SELECT "José Cabrera", @owner, "Owner of La Grande Tavern";
INSERT INTO Users (name, role, desc) SELECT "George Jones", (SELECT id FROM UserRoles WHERE name = "Management"), "Bartender at La Grande Tavern";
INSERT INTO Users (name, role, desc) SELECT "Mary Brown", (SELECT id FROM UserRoles WHERE name = "Management"), "Waitress at the Pompous Tavern";
INSERT INTO Users (name, role, desc) SELECT "John Rox", (SELECT id FROM UserRoles WHERE name = "Security"), "Bouncer at the Pompous Tavern";
INSERT INTO Users (name, role, desc) SELECT "Sally Samson", (SELECT id FROM UserRoles WHERE name = "Janitorial"), "Janitor at La Grande Tavern";
INSERT INTO Users (name, role, desc) SELECT "Valerie Harper", (SELECT id FROM UserRoles WHERE name = "Security"), "Bouncer at La Grande Tavern";
INSERT INTO Users (name, role, desc) SELECT "Sam Pullman", @guest, "Guest at La Grande Tavern";

CREATE TABLE Taverns (
	id int NOT NULL PRIMARY KEY IDENTITY(4,1),
	name nvarchar(255) NOT NULL,
	location nvarchar(255) NOT NULL,
	owner int NOT NULL FOREIGN KEY REFERENCES Users(id),
	floors tinyint DEFAULT 1
);

INSERT INTO Taverns (name, location, owner, floors) SELECT "Pompous Tavern", "100 Baltimore Avenue", (SELECT id FROM Users WHERE name = "John Smith" AND role = @owner LIMIT 1), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT "La Grande Tavern", "100 Market Place", (SELECT id FROM Users WHERE name = "José Cabrera" AND role = @owner LIMIT 1), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT "Bombastic Tavern", "150 Turnpike Road", (SELECT id FROM Users WHERE name = "John Smith" AND role = @owner LIMIT 1), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT "Grandiose Tavern", "200 Pure Street", (SELECT id FROM Users WHERE name = "John Smith" AND role = @owner LIMIT 1), 2;
INSERT INTO Taverns (name, location, owner, floors) SELECT "El Verde Tavern", "200 Turnpike Road", (SELECT id FROM Users WHERE name = "José Cabrera" AND role = @owner LIMIT 1), 2;

CREATE TABLE Rats (
	id int NOT NULL PRIMARY KEY IDENTITY(5,1),
	name varchar(255) NOT NULL,
	tavern int NOT NULL FOREIGN KEY REFERENCES Taverns(id)
);

INSERT INTO Rats (name, tavern) SELECT "Steve", (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1);
INSERT INTO Rats (name, tavern) SELECT "Gabe", (SELECT id FROM Taverns WHERE name = "La Grande Tavern" LIMIT 1);
INSERT INTO Rats (name, tavern) SELECT "Joe", (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1);
INSERT INTO Rats (name, tavern) SELECT "Krill", (SELECT id FROM Taverns WHERE name = "Grandiose Tavern" LIMIT 1);
INSERT INTO Rats (name, tavern) SELECT "Sam", (SELECT id FROM Taverns WHERE name = "El Verde Tavern" LIMIT 1);

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

INSERT INTO Inventory (supplyId, tavernId, lastUpdated, count) SELECT (SELECT id FROM Supplies WHERE name = "Strong Ale"), (SELECT id FROM Taverns WHERE name = "La Grande Tavern"), "2019-03-01 06:30:00";
INSERT INTO Inventory (supplyId, tavernId, lastUpdated, count) SELECT (SELECT id FROM Supplies WHERE name = "Glassware"), (SELECT id FROM Taverns WHERE name = "La Grande Tavern"), "2019-02-06 07:00:00";
INSERT INTO Inventory (supplyId, tavernId, lastUpdated, count) SELECT (SELECT id FROM Supplies WHERE name = "Whiskey"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern"), "2019-03-03 08:00:00";
INSERT INTO Inventory (supplyId, tavernId, lastUpdated, count) SELECT (SELECT id FROM Supplies WHERE name = "Glassware"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern"), "2019-02-28 05:00:00";
INSERT INTO Inventory (supplyId, tavernId, lastUpdated, count) SELECT (SELECT id FROM Supplies WHERE name = "Cocktail Napkins"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern"), "2019-02-28 05:00:00";

CREATE TABLE SuppliesReceiving (
	id int NOT NULL PRIMARY KEY IDENTITY(8,1),
	supplyId int NOT NULL FOREIGN KEY REFERENCES Supplies(id),
	tavernId int NOT NULL FOREIGN KEY REFERENCES Taverns(id),
	cost float,
	amount int DEFAULT 1,
	dateReceived datetime
);

INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Glassware"), (SELECT id FROM Taverns WHERE name = "La Grande Tavern" LIMIT 1), 600, 100, "2019-01-11 07:00:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Strong Ale"), (SELECT id FROM Taverns WHERE name = "La Grande Tavern" LIMIT 1), 240, 60, "2019-01-11 06:30:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Glassware"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1), 900, 150, "2019-01-17 05:00:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Whiskey"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1), 400, 1600, "2019-01-17 08:00:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Strong Ale"), (SELECT id FROM Taverns WHERE name = "La Grande Tavern" LIMIT 1), 200, 50, "2019-02-18 06:30:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Cocktail Napkins"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1), 50, 100, "2019-02-20 05:00:00";
INSERT INTO SuppliesReceiving (supplyId, tavernId, cost, amount, dateReceived) SELECT (SELECT id FROM Supplies WHERE name = "Whiskey"), (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1), 600, 100, "2019-02-28 08:00:00";

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
	name varchar(255) NOT NULL
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

INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT id FROM Users WHERE name = "Joe Sample" AND role = @guest LIMIT 1), (SELECT id FROM Services WHERE name = "Room Service" LIMIT 1), (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1), 15, "2019-03-05 18:18:23", 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT id FROM Users WHERE name = "Joe Sample" AND role = @guest LIMIT 1), (SELECT id FROM Services WHERE name = "Drinks" LIMIT 1), (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1), 5, "2019-03-05 21:46:08", 3;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT id FROM Users WHERE name = "Joe Sample" AND role = @guest LIMIT 1), (SELECT id FROM Services WHERE name = "Room Service" LIMIT 1), (SELECT id FROM Taverns WHERE name = "Pompous Tavern" LIMIT 1), 15, "2019-03-06 18:09:54", 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT id FROM Users WHERE name = "Sam Pullman" AND role = @guest LIMIT 1), (SELECT id FROM Services WHERE name = "Wi-Fi" LIMIT 1), (SELECT id FROM Taverns WHERE name = "La Grande Tavern" LIMIT 1), 20, "2019-03-01 07:44:32", 1;
INSERT INTO Sales (guest, service, tavern, price, datePurchased, amountPurchased) SELECT (SELECT id FROM Users WHERE name = "Sam Pullman" AND role = @guest LIMIT 1), (SELECT id FROM Services WHERE name = "Drinks" LIMIT 1), (SELECT id FROM Taverns WHERE name = "La Grande Tavern" LIMIT 1), 6, "2019-03-01 22:01:26", 2;