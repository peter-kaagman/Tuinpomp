#! /usr/bin/env perl
use feature ":5.10";

use DBI;
use strict;

my $driver = "SQLite";
my $db = "../db/schedule.db";
my $dsn = "DBI:$driver:dbname=$db";
my $db_user = "";
my $db_pass = "";
my $dbh = DBI->connect($dsn,$db_user,$db_pass, { RaiseError => 1}) or die $DBI::errstr;

my $qry = "Select rowid,* From color";
my $sth = $dbh->prepare($qry) or die $dbh->errstr;
$sth->execute() or die $sth->errstr;

while (my $row = $sth->fetchrow_hashref()){
  print "Row id: ",$row->{'rowid'};
  print " Name: ",$row->{'name'};
  print " Vallue: ",$row->{'vallue'},"\n";
}
print "\n";

$qry = "Select rowid,* From circuit";
$sth = $dbh->prepare($qry) or die $dbh->errstr;
$sth->execute() or die $sth->errstr;

while (my $row = $sth->fetchrow_hashref()){
  print "Row id: ",$row->{'rowid'};
  print " Name: ",$row->{'name'};
  print " Color: ",$row->{'color'};
  print " GPIO: ",$row->{'gpio'},"\n";
}

$dbh->do('Delete From schedule');
$qry = "Insert Into schedule values(?,?,?,?)";
$sth = $dbh->prepare($qry) or die $dbh->errstr;

for (my $circuit = 1; $circuit <= 3; $circuit++){
	for (my $day = 0; $day <= 6; $day++){
		for (my $hour = 0; $hour <= 23; $hour++){
			for (my $minute = 0; $minute < 60; $minute+=5){
				printf("%d  => %d:%d:%d\n",$circuit,$day,$hour,$minute);
				$sth->execute($circuit,
					      $day,
					      ($hour*3600+$minute*60),
					      ($hour*3600+$minute*60+3*60)
				) or die $sth->errstr;
			}
		}
	}
}

$dbh->disconnect();

