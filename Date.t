use Date;
use Test::More;
use Test::Exception;
my $date1, my $date2;

subtest 'Date creation' => sub {
	throws_ok(sub {Date->new(50,10,2016)}, qr/Day is out of range/, 'Date creation 1');
	throws_ok(sub {Date->new(15,14,2016)}, qr/Month is out of range/, 'Date creation 2');
	throws_ok(sub {Date->new(15,11,-2016)}, qr/Negative Year/, 'Date creation 3');
	$date1 = Date->new('2.11.2016');
	$date2 = Date->new('2.10.2016');
	is $date1, '2.11.2016', 'Date creation 4';
	is $date2, '2.10.2016', 'Date creation 5';
	$date1->set_date('2.10.2016');
	is $date1, $date2, "Date creation 6";
	$date1->set_date('2.11.2016');
};

subtest 'Date comparison' => sub {
	ok $date1 > $date2, 'Date comparison 1';
	ok $date2 < $date1, 'Date comparison 2';
	ok $date2 <= $date1, 'Date comparison 3';
	ok $date1 >= $date2, 'Date comparison 4';
	ok $date1 != $date2, 'Date comparison 5';
	$date2 = $date2 + 31;
	ok $date1 == $date2, 'Date comprasion 6';
	ok $date1 <= $date2, 'Date comparison 7';
	ok $date1 >= $date2, 'Date comparison 8';
};

subtest 'Date addition/substraction/printing' => sub {
	$date2 = Date->new('2.10.2016');
	is $date2 + 31, $date1, 'Date addition 1';
	is $date1 + 60, Date->new('1.1.2017'), 'Date addition 2';
	is "$date1", '2.11.2016', 'Date printing 1';
	is "$date2", '2.10.2016', 'Date printing 2';
	is $date1 - $date2, 31, 'Date substraction 1';
	$date1->set_date('8.9.1941');
	$date2->set_date('27.1.1944');
	is $date2 - $date1, 871, 'Date substraction 2';
	$date1->set_date('11.11.1918');
	$date2->set_date('28.7.1914');
	is $date2 - $date1, -1567, "Date substraction 3";
	is $date1 - $date2, 1567, "Date substraction 4";
	$date1->set_date("25.6.1950");
	$date2->set_date("27.7.1953");
	is $date2 - $date1, 1128, "Date substraction 5";
	is $date1 - $date2, -1128, "Date substraction 6";
};

subtest 'Date day_of_week' => sub {
	$date2->set_date('27.11.2016');
	my @mnth = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
	for my $i (0..100){		
		is $date2->day_of_week(), $mnth[$i % 7], "Date day_of_week $i";
		$date2 = $date2 + 1;
	}
};

done_testing();