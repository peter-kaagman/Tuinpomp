#! /usr/bin/env perl

use feature ":5.10";
use strict;
use warnings;
use File::Basename qw(dirname);
use File::Spec::Functions qw(catfile);

main();

my $code;

sub main {
    $code = read_config();
    logger('starting');
    my $continue = 1;

    $SIG{TERM} = sub{
        logger('TERM received');
        $continue = 0;
    };
    $SIG{HUP} = sub{
        logger('HUP received');
        $code = read_config();
    };

  while ($continue){
    logger($code);
    sleep 1;
  }
}

sub logger {
  my $text = shift;

  if (open FH, '>>', 'process.log'){
    print FH scalar localtime();
    print FH " $text\n";
  }
}

sub read_config {
    my $config_file = 'config.txt';
    open FH, '<', $config_file or die("Could not open $config_file");
    my $code = <FH>;
    chomp $code;
    return $code;
}