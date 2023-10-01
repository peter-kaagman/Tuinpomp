#! /usr/bin/env perl

use feature ":5.10";
use strict;
use warnings;
use RPi::WiringPi;
use RPi::Const qw(:all);
use Data::Dumper;

use DBI;

my $driver = "SQLite";
my $db = "../db/schedule.db";
my $dsn = "DBI:$driver:dbname=$db";
my $db_user = "";
my $db_pass = "";
my $dbh = DBI->connect($dsn,$db_user,$db_pass, { RaiseError => 1}) or die $DBI::errstr;

my $pi = RPi::WiringPi->new();



my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

my $now = $hour*3600 + $min*60;
my $qry = "Select ROWID,gpio,name From circuit";
my $sth = $dbh->prepare($qry) or die $dbh->errstr;
$sth->execute();
while (my $row = $sth->fetchrow_hashref()){
	# Initialize the pin
	my $pin = $pi->pin($row->{'gpio'});
	$pin->mode(OUTPUT);
	# Should it be on or off?
	my $qry2 =<<"END_QRY";
Select count(circuit) as count 
From schedule
Where circuit = $row->{'rowid'}
And day = $wday
And $now Between start And end
END_QRY
	my $sth2 = $dbh->prepare($qry2) or die $dbh->errstsr;
	$sth2->execute();
	my $row2 = $sth2->fetchrow_hashref();
	if ($row2->{'count'}){
		say "GPIO: ", $row->{'name'}, " moet aan";
		$pin->write(ON);
	}else{
		say "GPIO: ", $row->{'name'}, " moet uit";
		$pin->write(OFF);
	}
	

}
$sth->finish();
