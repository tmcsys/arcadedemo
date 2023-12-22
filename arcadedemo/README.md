
A project to test the [ArcadeDB](https://arcadedb.com) database.

The scripts will load the OrientDB demo database v.0.76 into ArcadeDB

You can then follow the excellent [OrientDB tutorial](http://www.orientdb.com/docs/last/gettingstarted/demodb/DemoDB-Introduction.html) using ArcadeDB.

The original OrientDB schema can be found at github.com in the project orientechnologies/orientdb in the /distribution/src/main/resources directory.

These scripts were tested using the arcadedb-23.12.1-SNAPSHOT.

### Loading the database

copy the <b>scripts</b> directory to the root directory of your ArcadeDB installation

%: /bin/console.sh

%: load scripts/build.sql - builds the initial OrientDemoDB

%: load scripts/rebuild.sql - drops, creates, and rebuilds OrientDemoDB

