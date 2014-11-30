#! /usr/bin/perl

use v5.14;
use warnings;

sub conv {
    my $num = shift;
    my $base = shift;
    my $digits = shift;
    #~ $digits \\= -1;
    return undef if $base>9;
    my @digits = ('0'..'9');
    my $ret = "";
    do {
	$ret = $digits[$num % $base] . $ret;
	$num = int($num / $base);
    } while ($num);
    if (defined $digits) {
	$ret = '0' x ($digits - length $ret) . $ret;
    }
    return $ret;
}

die "To run programm type: \"program_name k n [filename]\"" if @ARGV < 2;
my $k = $ARGV[0];
my $n = $ARGV[1];
my $fname = (@ARGV > 2) ? $ARGV[2] : "polarization_${k}_${n}.txt";
my $maxPolar = $k ** $n - 1;
#~ my $l = length conv($maxPolar, ;
open(my $fd, ">$fname");
for my $i (0 .. $maxPolar) {
    my $f = conv($i, $k, $n);
    print $fd "$f\n"
}
