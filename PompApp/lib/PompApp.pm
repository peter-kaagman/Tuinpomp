package PompApp;
use Dancer2;
use Dancer2::Plugin::Database;
use RPi::WiringPi;
use RPi::WiringPi::Core;
use RPi::Const qw(:all);
use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
  template 'index' => { 
	  'title' => 'PompApp',
  };
};

get '/api/getStatus' => sub {
  my $qry =<<"ENDQRY";
Select circuit.name,
       circuit.gpio,
       color.vallue as color
From circuit
Join color On circuit.color = color.ROWID
ENDQRY
  my $sth = database->prepare($qry);
  $sth->execute();
  my @result;
  my $pi = RPi::WiringPi->new();
  while (my $row = $sth->fetchrow_hashref()){
	  my $pin = $pi->pin($row->{'gpio'});
	  $row->{'status'} = $pin->read;
	  push(@result, $row);
  }
  $pi->cleanup;
  print Dumper \@result;
  send_as JSON => \@result;
};

true;
