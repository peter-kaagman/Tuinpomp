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


my $qry = "Select rowid,* From circuit";
my $sth = $dbh->prepare($qry) or die $dbh->errstr;
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
$sth->execute(1, 0, (18*3600+15*60), (18*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(1, 1, (18*3600+15*60), (18*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(1, 2, (18*3600+15*60), (18*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(1, 3, (18*3600+15*60), (18*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(1, 4, (18*3600+15*60), (18*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(1, 5, (18*3600+15*60), (18*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(1, 6, (18*3600+15*60), (18*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(2, 0, (19*3600+15*60), (19*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(2, 1, (19*3600+15*60), (19*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(2, 2, (19*3600+15*60), (19*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(2, 3, (19*3600+15*60), (19*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(2, 4, (19*3600+15*60), (19*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(2, 5, (19*3600+15*60), (19*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(2, 6, (19*3600+15*60), (19*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(3, 0, (20*3600+15*60), (20*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(3, 1, (20*3600+15*60), (20*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(3, 2, (20*3600+15*60), (20*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(3, 3, (20*3600+15*60), (20*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(3, 4, (20*3600+15*60), (20*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(3, 5, (20*3600+15*60), (20*3600+15*60+120*60)) or die $sth->errstr;
$sth->execute(3, 6, (20*3600+15*60), (20*3600+15*60+120*60)) or die $sth->errstr;
$dbh->disconnect();

