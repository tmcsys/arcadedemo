-- There is no base V and E classes in ArcadeDB, but rather vertex and edge are first type citizens types of records. 
-- Use CREATE VERTEX TYPE Product vs OrientDB CREATE CLASS Product EXTENDS V. 
-- Same for edges, use CREATE EDGE TYPE Sold vs OrientDB CREATE CLASS Sold EXTENDS E.

-- SET echo = FALSE
SET verbose = 1

CREATE DOCUMENT TYPE DBInfo;
INSERT INTO DBInfo SET Name='SocialTravelAgency', Version='0.76';

CREATE VERTEX TYPE Countries ;
CREATE PROPERTY Countries.Id LONG;
CREATE INDEX Countries_Id ON Countries(Id) UNIQUE;
CREATE PROPERTY Countries.Name STRING;
CREATE INDEX Countries_Name ON Countries(Name) FULLTEXT;

CREATE VERTEX TYPE Profiles ;
CREATE PROPERTY Profiles.Id LONG;
CREATE PROPERTY Profiles.Name STRING;
CREATE PROPERTY Profiles.Surname STRING;
CREATE PROPERTY Profiles.Email STRING;
CREATE PROPERTY Profiles.Birthday DATE;
CREATE PROPERTY Profiles.Bio STRING;

CREATE INDEX Profiles_Id ON Profiles(Id) UNIQUE;
CREATE INDEX Profiles_Name_Surname ON Profiles(Name,Surname) FULL_TEXT;
CREATE INDEX Profiles_Email ON Profiles(Email) UNIQUE;
CREATE INDEX Profiles_Birthday ON Profiles(Birthday) NOTUNIQUE;
CREATE INDEX Profiles_Bio ON Profiles(Bio) FULL_TEXT;

CREATE VERTEX TYPE Locations ;
CREATE PROPERTY Locations.Id LONG;
CREATE PROPERTY Locations.Type STRING;
CREATE PROPERTY Locations.Name STRING;
CREATE INDEX Locations_Type ON Locations(Type) NOTUNIQUE;
CREATE INDEX Locations_Name ON Locations(Name) FULL_TEXT;

CREATE VERTEX TYPE Services EXTENDS Locations;
CREATE VERTEX TYPE Hotels EXTENDS, Services;
CREATE INDEX Hotels_Id ON Hotels(Id) UNIQUE;

CREATE VERTEX TYPE Restaurants EXTENDS Services;
CREATE INDEX Restaurants_Id ON Restaurants(Id) UNIQUE;

CREATE VERTEX TYPE Attractions EXTENDS Locations;
CREATE VERTEX TYPE Monuments EXTENDS Attractions;
CREATE INDEX Monuments_Id ON Monuments(Id) UNIQUE;

CREATE VERTEX TYPE Castles EXTENDS Attractions;
CREATE INDEX Castles_Id ON Castles(Id) UNIQUE;

CREATE VERTEX TYPE Theatres EXTENDS Attractions;
CREATE INDEX Theatres_Id ON Theatres(Id) UNIQUE;

CREATE VERTEX TYPE ArchaeologicalSites EXTENDS Attractions;
CREATE INDEX ArchaeologicalSites_Id ON ArchaeologicalSites(Id) UNIQUE;

CREATE VERTEX TYPE Customers ;
CREATE PROPERTY Customers.OrderedId LONG;

CREATE VERTEX TYPE Reviews ;
CREATE PROPERTY Reviews.Id LONG;
CREATE PROPERTY Reviews.Text STRING;
CREATE INDEX Reviews_Text ON Reviews(Text) FULL_TEXT;

CREATE VERTEX TYPE Orders ;
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
CREATE PROPERTY IsFromCountry.in LINK OF Countries;
CREATE PROPERTY IsFromCountry.out LINK OF Customers;

CREATE EDGE TYPE HasUsedService;
CREATE PROPERTY HasUsedService.out LINK OF Customers ;

CREATE EDGE TYPE HasStayed EXTENDS HasUsedService;
CREATE PROPERTY HasStayed.in LINK OF Hotels;

CREATE EDGE TYPE HasEaten EXTENDS HasUsedService;
CREATE PROPERTY HasEaten.in LINK OF Restaurants;

CREATE EDGE TYPE HasVisited;
CREATE PROPERTY HasVisited.out LINK OF Customers ;
CREATE PROPERTY HasVisited.in LINK;
CREATE INDEX HasVisited.out_in ON HasVisited (`in`, `out`) UNIQUE;

CREATE EDGE TYPE HasProfile;
CREATE PROPERTY HasProfile.in LINK OF Profiles;
CREATE PROPERTY HasProfile.out LINK OF Customers ;

CREATE EDGE TYPE HasCustomer;
CREATE PROPERTY HasCustomer.in LINK OF Customers;
CREATE PROPERTY HasCustomer.out LINK OF Orders ;

CREATE EDGE TYPE HasReview;
CREATE PROPERTY HasReview.in LINK OF Reviews;
CREATE PROPERTY HasReview.Stars INTEGER;

CREATE EDGE TYPE MadeReview;
CREATE PROPERTY MadeReview.out LINK OF Customers ;

CREATE EDGE TYPE HasFriend;
CREATE PROPERTY HasFriend.in LINK OF Profiles;
CREATE PROPERTY HasFriend.out LINK OF Profiles;
/*
CREATE TYPE _studio;
INSERT INTO _studio SET type='GraphConfig', config = {'TYPES':{'ArchaeologicalSites':{'fill':'#ff7f0e','stroke':'#b25809','display':'Name','iconCss':'icon-bank', 'icon':'\ue950'},'Attractions':{'fill':'#778899','stroke':'#b28254','display':'Name'},'Locations':{'fill':'#FFA07A','stroke':'#b28254','display':'Name'},'Services':{'fill':'#FFDEAD','stroke':'#b28254','display':'Name'},'Castles':{'fill':'#730202','stroke':'#4f3d3d','display':'Name','iconCss':'icon-bookmark', 'icon':'\ue83a'},'Countries':{'fill':'#98df8a','stroke':'#6a9c60','display':'Name','iconCss':'icon-home', 'icon':'\ue82c'},'Customers':{'fill':'#d62728','stroke':'#951b1c','display':'OrderedId','iconCss':'icon-circle', 'icon':'\ue913'},'DBInfo':{'fill':'#aec7e8','stroke':'#798ba2'},'E':{'fill':'#000000','stroke':'#000000'},'HasCustomer':{'fill':'#1e701e','stroke':'#1e701e'},'HasEaten':{'fill':'#c5b0d5','stroke':'#951b1c'},'HasFriend':{'fill':'#5c0c9f','stroke':'#5c0c9f'},'HasProfile':{'fill':'#c49c94','stroke':'#951b1c'},'HasReview':{'fill':'#e377c2','stroke':'#797b7c'},'HasUsedService':{'fill':'#f7b6d2','stroke':'#951b1c'},'HasStayed':{'fill':'#f7b6d2','stroke':'#951b1c'},'HasVisited':{'fill':'#f7b6d2','stroke':'#951b1c'},'Hotels':{'fill':'#1f77b4','stroke':'#15537d','display':'Name','iconCss':'icon-h-sigh', 'icon':'\ue94c'},'IsFromCountry':{'fill':'#7f7f7f','stroke':'#951b1c'},'MadeReview':{'fill':'#c7c7c7','stroke':'#951b1c'},'Monuments':{'fill':'#bcbd22','stroke':'#838417','display':'Name','iconCss':'icon-building-filled', 'icon':'\ue94f'},'OFunction':{'fill':'#dbdb8d','stroke':'#999962'},'OGeometryCollection':{'fill':'#17becf','stroke':'#108590'},'OIdentity':{'fill':'#9edae5','stroke':'#6e98a0'},'OLineString':{'fill':'#1f77b4','stroke':'#15537d'},'OMultiLineString':{'fill':'#aec7e8','stroke':'#798ba2'},'OMultiPoint':{'fill':'#ff7f0e','stroke':'#b25809'},'OMultiPolygon':{'fill':'#ffbb78','stroke':'#b28254'},'OPoint':{'fill':'#2ca02c','stroke':'#1e701e'},'OPolygon':{'fill':'#98df8a','stroke':'#6a9c60'},'ORectangle':{'fill':'#d62728','stroke':'#951b1c'},'ORestricted':{'fill':'#ff9896','stroke':'#b26a69'},'ORole':{'fill':'#9467bd','stroke':'#674884'},'OSchedule':{'fill':'#c5b0d5','stroke':'#897b95'},'OSequence':{'fill':'#8c564b','stroke':'#623c34'},'OShape':{'fill':'#c49c94','stroke':'#896d67'},'OTriggered':{'fill':'#e377c2','stroke':'#9e5387'},'OUser':{'fill':'#f7b6d2','stroke':'#ac7f93'},'Orders':{'fill':'#2ca02c','stroke':'#1e701e','display':'Id','iconCss':'icon-basket', 'icon':'\ue882'},'Locations':{'fill':'#c7c7c7','stroke':'#8b8b8b','display':'Name'},'Profiles':{'fill':'#a922bd','stroke':'#5c0c9f','display':'Name','iconCss':'icon-user','icon':'\ue80c'},'Restaurants':{'fill':'#ec97e9','stroke':'#8e54bf','display':'Name','iconCss':'icon-food','icon':'\ue946'},'Reviews':{'fill':'#d6d9da','stroke':'#797b7c','display':'Id','iconCss':'icon-sliders', 'icon':'\ue881'},'Theatres':{'fill':'#9edae5','stroke':'#6e98a0','display':'Name','iconCss':'icon-music', 'icon':'\ue801'},'V':{'fill':'#000000','stroke':'#000000'},'_studio':{'fill':'#aec7e8','stroke':'#798ba2'}}},user=#5:0;
*/
CREATE INDEX Customers_OrderedId ON Customers(OrderedId) UNIQUE;
CREATE INDEX Reviews_Id ON Reviews(Id) UNIQUE;
CREATE INDEX HasReview_Stars ON HasReview(Stars) NOTUNIQUE;
CREATE INDEX Orders_Id ON Orders(Id) UNIQUE;
CREATE INDEX Orders_Amount ON Orders(Amount) NOTUNIQUE;
CREATE INDEX Orders_OrderDate ON Orders(OrderDate) NOTUNIQUE;
