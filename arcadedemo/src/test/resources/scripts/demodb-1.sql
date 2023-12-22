-- There is no base V and E classes in ArcadeDB, but rather vertex and edge are first type citizens types of records. 
-- Use CREATE VERTEX TYPE Product vs OrientDB CREATE CLASS Product EXTENDS V. 
-- Same for edges, use CREATE EDGE TYPE Sold vs OrientDB CREATE CLASS Sold EXTENDS E.

-- SET echo = FALSE
SET verbose = 1

CREATE DOCUMENT TYPE DBInfo;
INSERT INTO DBInfo SET Name='SocialTravelAgency', Version='0.76';

CREATE VERTEX TYPE Countries;
CREATE PROPERTY Countries.Id LONG;
CREATE INDEX ON Countries(Id) UNIQUE;
CREATE PROPERTY Countries.Name STRING;
CREATE INDEX ON Countries(Name) FULL_TEXT;

CREATE VERTEX TYPE Profiles;
CREATE PROPERTY Profiles.Id LONG;
CREATE PROPERTY Profiles.Name STRING;
CREATE PROPERTY Profiles.Surname STRING;
CREATE PROPERTY Profiles.Email STRING;
CREATE PROPERTY Profiles.Birthday DATE;
CREATE PROPERTY Profiles.Bio STRING;
CREATE PROPERTY Profiles.Gender STRING;

CREATE INDEX ON Profiles(Id) UNIQUE;
CREATE INDEX ON Profiles(Name,Surname) NOTUNIQUE;
CREATE INDEX ON Profiles(Email) UNIQUE;
CREATE INDEX ON Profiles(Birthday) NOTUNIQUE;
CREATE INDEX ON Profiles(Bio) FULL_TEXT;

CREATE VERTEX TYPE Locations;
CREATE PROPERTY Locations.Id LONG;
CREATE PROPERTY Locations.Type STRING;
CREATE PROPERTY Locations.Name STRING;
CREATE INDEX ON Locations(Type) NOTUNIQUE;
CREATE INDEX ON Locations(Name) FULL_TEXT;

CREATE VERTEX TYPE Services EXTENDS Locations;
CREATE VERTEX TYPE Hotels EXTENDS Services;
CREATE INDEX ON Hotels(Id) UNIQUE;

CREATE VERTEX TYPE Restaurants EXTENDS Services;
CREATE INDEX ON Restaurants(Id) UNIQUE;

CREATE VERTEX TYPE Attractions EXTENDS Locations;
CREATE VERTEX TYPE Monuments EXTENDS Attractions;
CREATE INDEX ON Monuments(Id) UNIQUE;

CREATE VERTEX TYPE Castles EXTENDS Attractions;
CREATE INDEX ON Castles(Id) UNIQUE;

CREATE VERTEX TYPE Theatres EXTENDS Attractions;
CREATE INDEX ON Theatres(Id) UNIQUE;

CREATE VERTEX TYPE ArchaeologicalSites EXTENDS Attractions;
CREATE INDEX ON ArchaeologicalSites(Id) UNIQUE;

CREATE VERTEX TYPE Customers;
CREATE PROPERTY Customers.OrderedId LONG;

CREATE VERTEX TYPE Reviews;
CREATE PROPERTY Reviews.Id LONG;
CREATE PROPERTY Reviews.Text STRING;
CREATE INDEX ON Reviews(Text) FULL_TEXT;

CREATE VERTEX TYPE Orders;
CREATE PROPERTY Orders.Id LONG;
CREATE PROPERTY Orders.Amount LONG;
CREATE PROPERTY Orders.OrderDate DATE;

-- Edge Constraints
-- ArcadeDB supports edge constraints, which means limiting the admissible vertex types that can be connected by an edge type. 
-- To this end the implicit metadata properties @in and @out need to be made explicit by creating them. 
-- For example, for an edge type HasParts that is supposed to connect only from vertices of type Product to vertices of type Component, this can be schemed by:

-- CREATE EDGE TYPE HasParts;
-- CREATE PROPERTY HasParts.`@out` link OF Product;
-- CREATE PROPERTY HasParts.`@in` link OF Component;

CREATE EDGE TYPE IsFromCountry;
CREATE PROPERTY IsFromCountry.`@in` LINK OF Countries;
CREATE PROPERTY IsFromCountry.`@out` LINK OF Customers;

CREATE EDGE TYPE HasUsedService;
CREATE PROPERTY HasUsedService.`@out` LINK OF Customers ;

CREATE EDGE TYPE HasStayed EXTENDS HasUsedService;
CREATE PROPERTY HasStayed.`@in` LINK OF Hotels;

CREATE EDGE TYPE HasEaten EXTENDS HasUsedService;
CREATE PROPERTY HasEaten.`@in` LINK OF Restaurants;

CREATE EDGE TYPE HasVisited;
CREATE PROPERTY HasVisited.`@out` LINK OF Customers ;
CREATE PROPERTY HasVisited.`@in` LINK;
CREATE INDEX ON HasVisited (`@in`, `@out`) UNIQUE;

CREATE EDGE TYPE HasProfile;
CREATE PROPERTY HasProfile.`@in` LINK OF Profiles;
CREATE PROPERTY HasProfile.`@out` LINK OF Customers ;

CREATE EDGE TYPE HasCustomer;
CREATE PROPERTY HasCustomer.`@in` LINK OF Customers;
CREATE PROPERTY HasCustomer.`@out` LINK OF Orders ;

CREATE EDGE TYPE HasReview;
CREATE PROPERTY HasReview.`@in` LINK OF Reviews;
CREATE PROPERTY HasReview.Stars INTEGER;

CREATE EDGE TYPE MadeReview;
CREATE PROPERTY MadeReview.`@out` LINK OF Customers ;

CREATE EDGE TYPE HasFriend;
CREATE PROPERTY HasFriend.`@in` LINK OF Profiles;
CREATE PROPERTY HasFriend.`@out` LINK OF Profiles;

CREATE INDEX ON Customers(OrderedId) UNIQUE;
CREATE INDEX ON Reviews(Id) UNIQUE;
CREATE INDEX ON HasReview(Stars) NOTUNIQUE;
CREATE INDEX ON Orders(Id) UNIQUE;
CREATE INDEX ON Orders(Amount) NOTUNIQUE;
CREATE INDEX ON Orders(OrderDate) NOTUNIQUE;
