#! /usr/bin/env perl

use feature ":5.10";
use strict;
use warnings;
use Daemon::Control;
use File::Basename qw(dirname);
use File::Spec::Functions qw(catfile);

my $dir = dirname(__FILE__);

exit Daemon::Control->new(
  name        => 'PKn Daemon',
  lsb_start   => '$syslog $remote_fs',
  lsb_stop    => '$syslog',
  lsb_sdesc   => 'PKn Daemon Short',
  lsb_desc    => 'Dit is mijn control daemon',
  path        => $dir,

  program     => catfile($dir, 'local.pl'),
  program_args=> [],

  pid_file    => '/tmp/pkndaemon.pid',
  stderr_file => '/tmp/pkndaemon.out',
  stdout_file => '/tmp/pkndaemon.out',

  fork        => 2,
)->run;

