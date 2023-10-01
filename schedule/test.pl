#! /usr/bin/env perl

use feature ":5.10";
use strict;
use warnings;
use RPi::WiringPi;
use RPi::Const qw(:all);

my $pi = RPi::WiringPi->new();

say $pi->gpio_info;

my $pin0 = $pi->pin(17);
$pin0->mode(OUTPUT);
$pin0->write(HIGH);

my $pin2 = $pi->pin(27);
$pin2->mode(OUTPUT);
$pin2->write(HIGH);

my $pin3 = $pi->pin(22);
$pin3->mode(OUTPUT);
$pin3->write(HIGH);
