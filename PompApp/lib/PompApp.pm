package PompApp;
use Dancer2;
use Dancer2::Plugin::Database;
use RPi::WiringPi;
use RPi::WiringPi::Core;
use RPi::Const qw(:all);
use Data::Dumper;

our $VERSION = '0.1';
# Routes {{{1
get '/' => sub {
  template 'index' => { 
	  'title' => 'PompApp',
  };
};
#}}}1

#Api routes {{{1
get '/api/getStatus' => sub { #{{{2
  my $qry =<<"ENDQRY";
Select circuit.name,
       circuit.gpio,
       circuit.color
From circuit
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
  $sth->finish();
  print Dumper \@result;
  send_as JSON => \@result;
};#}}}2

get '/api/getSchedule' => sub {#{{{2
  my $qry =<<"ENDQRY";
Select 
       circuit.rowid as c_id,
       circuit.name,
       circuit.color,
       schedule.rowid as s_id,
       schedule.day,
       schedule.start,
       schedule.end
From circuit
Left Join schedule on circuit.rowid = schedule.circuit
ENDQRY
  my $sth = database->prepare($qry);
  $sth->execute();
  my %result;
#circuit_id
#    schedule_id
#      start
#      end
#      color
#      name
#      day
  while (my $row = $sth->fetchrow_hashref()){
    $result{$row->{'c_id'}}{'name'} = $row->{'name'};
    $result{$row->{'c_id'}}{'color'} = $row->{'color'};
    $result{$row->{'c_id'}}{'schedules'}{$row->{'s_id'}}{'start'} = $row->{'start'};
    $result{$row->{'c_id'}}{'schedules'}{$row->{'s_id'}}{'end'} = $row->{'end'};
    $result{$row->{'c_id'}}{'schedules'}{$row->{'s_id'}}{'day'} = $row->{'day'};
  }
  $sth->finish();
  print Dumper \%result;
  send_as JSON => \%result;
};#}}}}2
#}}}1
true;
# vim: set foldmethod=marker
