#! /usr/bin/perl

use v5.14;
use warnings;

open (my $ifd, "<$ARGV[0]");
open (my $ffd, "<$ARGV[1]");
open (my $ofd, ">$ARGV[2]");
open (my $pfd, ">$ARGV[3]");
my @functions = <$ffd>;
my @polarizations = <$ifd>;
my $npol = @polarizations;
my $len = length($polarizations[0]) - 1;

for (@functions) {
    for my $polar (@polarizations) {
	print $ofd "$len $_";
	print $pfd $polar;
    }
}
