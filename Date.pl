use 5.14.2;
use warnings;
use strict;
use Data::Dumper qw(Dumper);
use Date;

my $date1 = Date->new('2.11.2016');
my $date2 = Date->new('2.10.2016');
say $date1 - $date2;

say "$date1";
my $date3 = $date2;
$date2->{_day} = 10;
say "$date3";
say "$date2";