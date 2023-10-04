package PompApp;
use Dancer2;
use Dancer2::Plugin::Database;
use RPi::WiringPi;
use RPi::WiringPi::Core;
use RPi::Const qw(:all);
use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
  my $sth = database->prepare('Select * From circuit');
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
  template 'index' => { 
	  'title' => 'PompApp',
	  'circuits' => \@result
  };
};

get '/api/getStatus' => sub {
	my %data = (
		name => 'Peter',
		status => 'Cool'
	);
	send_as JSON => \%data;
};

true;
