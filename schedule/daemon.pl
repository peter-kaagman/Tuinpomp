#! /usr/bin/env perl

use strict;
use warnings;

main();

sub main {
  my $logfile = 'process.log';
  my $continue = 1;

  $SIG{INT} = sub{
    logger('int received');
    $continue = 0;
  };

  while ($continue){
    logger('');
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
