package Date;

use 5.14.2;
use Scalar::Util qw(looks_like_number);
use warnings;
use strict;
use overload
	'""' => 'print_date',
	'+' => 'add_days',
	'<=>' => 'leqg_date',
	'-' => 'substract_date'
	;

our @months = (0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

my $is_leap_year = sub {
	my $year = $_[0];
	($year % 4 == 0 && $year % 100 != 0) || $year % 400 == 0; 
};

my $days_in_month = sub {
	my ($month, $year) = @_;
	return 0 if $month <= 0;
	return $is_leap_year->($year) && $month == 2 ? $months[$month] + 1 : $months[$month];
};

my $days_in_months = sub {
	my ($month, $year) = @_;
	my $days = 0;
	for my $i (1..$month - 1) {
		$days += $days_in_month->($i, $year);
	} 
	return $days;};

my $days_in_years = sub  {
	my $year = $_[0];
	my $leap_years = int($year / 4) - int($year / 100) + int($year / 400);
	return ($year - $leap_years) * 365 + $leap_years * 366;
};

my $days_in_date = sub {
	my $d = $_[0];
	return $days_in_years->($d->{_year} - 1) + $days_in_months->($d->{_month} - 1, $d->{_year}) + $d->{_day} - 1;};

sub new {
	my $class = shift;
	my ($day, $month, $year);
	given (scalar @_) {
		when (1) {
			my @tmp = split /\./, $_[0];
			die "wrong format" if scalar(@tmp) != 3;
			($day, $month, $year) = @tmp;
		}
		when (3) {($day, $month, $year) = @_;}
		default {die "too much arguments";}
	}
	die "Month is out of range" if ($month < 0 || $month > 12);
	die "Day is out of range" if ($day < 0 || $day > $days_in_month->($month, $year));
	die "Negative Year" if ($year < 0); 
	my $self = {
		'_day' => $day,
		'_month' => $month,
		'_year' => $year,	};
	bless $self, $class;
}

sub print_date {
	return get_formated_date($_[0]);}

sub get_formated_date {
	my $d = $_[0]; 
	my $s =  $d->{_day} . '.';
	$s .= $d->{_month} < 10 ? '0' . $d->{_month} : $d->{_month};
	return $s . '.' . $d->{_year};
}
sub substract_date { # returns num of days
	my ($d1, $d2) = @_;
	return $days_in_date->($d1) - $days_in_date->($d2);
}

sub add_days {
	my ($self, $other) = @_;
	die "wrong operand" if !looks_like_number($other);
	my $res = Date->new($self->{_day}, $self->{_month}, $self->{_year}); 
	$res->{_day} += $other;
	while ($res->{_day} > $days_in_month->($res->{_month}, $res->{_year})) {
		$res->{_day} -= $days_in_month->($res->{_month}, $res->{_year});
		$res->{_month} = $res->{_month} + 1 > 12 ? 1 : $res->{_month} + 1;
		$res->{_year}++ if $res->{_month} == 1;
	}
	$res;
}

sub leqg_date {
	my ($d1, $d2) = @_;
	my $res = $d1 - $d2;
	return $res == 0 ? $res : $res / abs($res);}

sub day_of_week {
	my @weekdays = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
	my $self = shift;
	my $a = int((14 - $self->{_month}) / 12);
	my $y = $self->{_year} - $a;
	my $m = $self->{_month} + 12 * $a - 2;
	my $res = (7000 + int($self->{_day} + $y + int($y / 4) - int($y / 100) + int($y / 400)+(31 * $m) / 12)) % 7;
	return $weekdays[$res];}
	1;