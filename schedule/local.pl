#! /usr/bin/env perl

use feature ":5.10";
use strict;
use warnings;
use File::Basename qw(dirname);
use File::Spec::Functions qw(catfile);
use RPi::WiringPi;
use RPi::Const qw(:all);
use Data::Dumper;
use DBI;
use Time::HiRes qw(usleep);


my $driver = "SQLite";
my $db = "../db/schedule.db";
my $dsn = "DBI:$driver:dbname=$db";
my $db_user = "";
my $db_pass = "";
my $dbh = DBI->connect($dsn,$db_user,$db_pass, { RaiseError => 1}) or die $DBI::errstr;
my $pi = RPi::WiringPi->new();
my $INTERRUPT=0;

my $config = setup();
loop($config);

sub loop {
  my $config = shift;
  logger('starting');
  my $continue = 1;

  $SIG{TERM} = sub{
      logger('TERM received');
      $continue = 0;
  };
  $SIG{HUP} = sub{
      logger('HUP received');
      $config = setup();
  };
  my $count = 0;
  while ($continue){
    $count++;

    if(! $INTERRUPT){
    checkButtons($config);
    }

    if ($count eq 600){
      $count = 0;
      checkCircuits($config);
      logger("$count Circuits");
    }

    usleep(100000); # 1/10 sec
  }
}
sub checkButtons{ #{{{1
  my $config = shift;
  foreach my $rowid (keys %{$config}){
    my $pin = $pi->pin($config->{$rowid}->{'button'});
    $pin->mode(INPUT);
    my $state = $pin->read;
    if($state){
      $INTERRUPT = 1;
      logger($config->{$rowid}->{'button'}. " is $state");
      $INTER
    }
    $pi->cleanup;
  }
} # }}}

sub checkCircuits{ #{{{1
  my $config = shift;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

  my $now = $hour*3600 + $min*60;
  foreach my $rowid (keys %{$config}){
    say $config->{$rowid}->{'gpio'};
  #while (my $row = $sth->fetchrow_hashref()){
    # Initialize the pin
    my $pin = $pi->pin($config->{$rowid}->{'gpio'});
    $pin->mode(OUTPUT);
    # Should it be on or off?
    my $qry =<<"END_QRY";
Select count(circuit) as count 
From schedule
Where circuit = $rowid
And day = $wday
And $now Between start And end
END_QRY
    my $sth = $dbh->prepare($qry) or die $dbh->errstsr;
    $sth->execute();
    my $row = $sth->fetchrow_hashref();
    if ($row->{'count'}){
      logger("GPIO: ". $config->{$rowid}->{'name'}. " moet aan");
      $pin->write(HIGH);
    }else{
      logger ("GPIO: ". $config->{$rowid}->{'name'}. " moet uit");
      $pin->write(LOW);
    }
    $sth->finish();
  }
  $pi->cleanup;
} #}}}

sub logger {
  my $text = shift;

  if (open FH, '>>', 'process.log'){
    print FH scalar localtime();
    print FH " $text\n";
  }
}

sub setup {
  my $qry = "Select ROWID,gpio,button,name From circuit";
  my $sth = $dbh->prepare($qry) or die $dbh->errstr;
  $sth->execute();
  my $config = $sth->fetchall_hashref("rowid");
  print Dumper $config;
  return $config;
}