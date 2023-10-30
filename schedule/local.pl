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
my $ButtonActive=0;

my $config = setup();
# Maak objecten voor de pins in de config

foreach my $circuit (keys %{$config->{'circuits'}}){
  $config->{'pins'}->{$config->{'circuits'}->{$circuit}->{'gpio'}} = $pi->pin($config->{'circuits'}->{$circuit}->{'gpio'});
  $config->{'pins'}->{$config->{'circuits'}->{$circuit}->{'button'}} = $pi->pin($config->{'circuits'}->{$circuit}->{'button'});
}
#print Dumper $config;
loop($config);

sub loop {
  my $config = shift;
  logger('starting');
  my $continue = 1;

  $SIG{TERM} = sub{
      logger('TERM received');
      $pi->cleanup;
      $continue = 0;
  };
  $SIG{HUP} = sub{
      logger('HUP received');
      $config = setup();
  };
  my $count = 0;
  while ($continue){
    $count++;

    checkButtons($config);

    if ($count eq 600){
      logger("$count Circuits");
      checkCircuits($config);
      $count = 0;
    }

    usleep(100000); # 1/10 sec
  }
}
sub checkButtons{ #{{{1
  my $config = shift;
  if($ButtonActive){
    #Check of hij nog steeds aktief is
    #my $pin = $pi->pin($ButtonActive);
    $config->{'pins'}->{$ButtonActive}->mode(INPUT);
    my $state = $config->{'pins'}->{$ButtonActive}->read;
    if (!$state){
      logger("Clearing Active state pin $ButtonActive");
      $ButtonActive = 0;
    }
  }else{
    # Geen pins aktief dus checken
    foreach my $rowid (keys %{$config->{'circuits'}}){
      #my $pin = $pi->pin($config->{'circuits'}->{$rowid}->{'button'});
      $config->{'pins'}->{ $config->{'circuits'}->{$rowid}->{'button'} }->mode(INPUT);
      my $state = $config->{'pins'}->{ $config->{'circuits'}->{$rowid}->{'button'} }->read;
      if($state){
        $ButtonActive = $config->{'circuits'}->{$rowid}->{'button'};
        logger($config->{'circuits'}->{$rowid}->{'button'}. " is $state");
      }
    }
  }
} # }}}

sub checkCircuits{ #{{{1
  my $config = shift;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

  my $now = $hour*3600 + $min*60;
  foreach my $rowid (keys %{$config->{'circuits'}}){
    # Initialize the pin
    #my $pin = $pi->pin($config->{'circuits'}->{$rowid}->{'gpio'});
    $config->{'pins'}->{$config->{'circuits'}->{$rowid}->{'gpio'}}->mode(OUTPUT);
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
      logger("GPIO: ". $config->{'circuits'}->{$rowid}->{'name'}. " moet aan");
      $config->{'pins'}->{$config->{'circuits'}->{$rowid}->{'gpio'}}->write(HIGH);
    }else{
      logger ("GPIO: ". $config->{'circuits'}->{$rowid}->{'name'}. " moet uit");
      $config->{'pins'}->{$config->{'circuits'}->{$rowid}->{'gpio'}}->write(LOW);
    }
    $sth->finish();
  }
} #}}}

sub logger {
  my $text = shift;

  if (open FH, '>>', 'process.log'){
    FH->autoflush;
    print FH scalar localtime();
    print FH " $text\n";
  }
}

sub setup {
  my $qry = "Select ROWID,gpio,button,name From circuit";
  my $sth = $dbh->prepare($qry) or die $dbh->errstr;
  $sth->execute();
  my $circuits = $sth->fetchall_hashref("rowid");
  my $config->{'circuits'} = $circuits;
  return $config;
}