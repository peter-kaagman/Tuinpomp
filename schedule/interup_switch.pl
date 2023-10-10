#! /usr/bin/env perl

use feature ":5.10";
use strict;
use warnings;
use RPi::WiringPi;
use RPi::Const qw(:all);
use Data::Dumper;

my $pi = RPi::WiringPi->new();
my $pin = $pi->pin(10);
$pin->set_interrupt(EDGE_RISING, 'main::pin10_int_handler');

sub pin10_int_handler {
  my $ts = time;
  say "Button 10 is pressed at $ts";
}

my $continue = 1;
while ($continue){
  my $ts = time;
  say "Running at $ts";
  sleep(10);
}
