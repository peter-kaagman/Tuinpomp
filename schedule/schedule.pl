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


main();

sub main { #{{{1
  logger("Starting");
  my $continue = 1;

  $SIG{TERM} = sub {
    logger("Terminating signal");
    # ToDo
    # Hier moeten de circuit nog uitgezet worden
    $continue = 0;
  };

  $SIG{HUP} = sub {
    logger("Restart signal");
    # ToDo
    # Hier moeten de circuit nog uitgezet worden
    # en manuals verwijdert
  };

  my $btnCircuit1 = $pi->pin(9);
  $btnCircuit1->mode(INPUT);
  $btnCircuit1->write(LOW);
  $btnCircuit1->set_interrupt(EDGE_RISING, 'main::interruptCircuitEen'); # Kan ik ook een pinnummer meegeven?

  my $btnCircuit2 = $pi->pin(10);
  $btnCircuit2->mode(INPUT);
  $btnCircuit2->write(LOW);
  $btnCircuit2->set_interrupt(EDGE_RISING, 'main::interruptCircuitTwee');

  my $btnCircuit3 = $pi->pin(11);
  $btnCircuit3->mode(INPUT);
  $btnCircuit3->write(LOW);
  $btnCircuit3->set_interrupt(EDGE_RISING, 'main::interruptCircuitDrie');

  while ($continue) {
    checkCircuits();
    sleep(10);
  }
} # }}}
sub checkCircuits{ #{{{1
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
      $pin->write(HIGH);
    }else{
      say "GPIO: ", $row->{'name'}, " moet uit";
      $pin->write(LOW);
    }
    $sth2->finish();
  }
  $sth->finish();
  $pi->cleanup;
} #}}}

sub interruptCircuitEen { # {{{1
  say "1";
  logger("Circuit 1 gaat aan");
  $pi->cleanup;
} #}}}

sub interruptCircuitTwee { # {{{1
  say "2";
  logger("Circuit 2 gaat aan");
  $pi->cleanup;
} #}}}

sub interruptCircuitDrie { # {{{1
  say "3";
  logger("Circuit 3 gaat aan");
  $pi->cleanup;
} #}}}

sub logger { # {{{{1
  my $msg = shift;
  my $ts = time;
  say "$ts\tdaemon\t$msg";
} # }}}
