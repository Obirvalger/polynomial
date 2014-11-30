#! /usr/bin/perl

use v5.14;
use warnings;

my ($k, $n) = @ARGV;
my $kn = $k ** $n;

while(<STDIN>) {
    chomp;
    $_ = join("", split(/[ ,]+/, s/[\(\)]//gr));
    $_ x= ($kn % length) ? $kn/length($_) + 1 : $kn/length($_);
    $_ = substr $_, 0, $kn;
    my $f = $_;
    print "$f\n";
}
