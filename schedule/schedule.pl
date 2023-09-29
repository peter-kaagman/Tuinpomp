#! /usr/bin/env perl

use feature ":5.10";
use RPi::WiringPi;
use RPi::Const qw(:all);

my $pi = RPi::WiringPi->new();

say $pi->core_temp;
say $pi->cpu_percent;
say $pi->network_info;
say $pi->pi_details;

my $pin = $pi->pin(5);
say "mode: ",$pin->mode;
$pin->mode(OUTPUT);
say "mode: ",$pin->mode;
say "status: ",$pin->read;
$pin->write(ON);
say "status: ",$pin->read;
$pin->write(OFF);
say "status: ",$pin->read;

my $gpio_17 = $pi->pin(0);
my $gpio_27 = $pi->pin(2);
my $gpio_22 = $pi->pin(3);


