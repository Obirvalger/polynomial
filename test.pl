#! /usr/bin/perl

use v5.14;
use warnings;

my $k = 2;
my $n = 5;
my $maxf = 2 ** 2 ** $n - 1;
my $l = length sprintf "%b", $maxf;
my $d = '0' x $n;
#~ print "l = $l\nmaxf = $maxf\n";

for my $i (0 .. $maxf) {
    my $f = sprintf "%0${l}b", $i;
    printf "f   = %s\n", join(" ", split("", $f));
    chomp(my $pos = `./pos $f $k $d`);
    chomp(my $pol = `./polynomial $f $k $d`);
    print "pos = $pos\n";
    print "pol = $pol\n";
    if ($pos ne $pol) {
	print "All bad!";
	last;
    }
}
