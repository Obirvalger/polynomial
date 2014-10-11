use v5.14;
use warnings;
use diagnostics;

local $\ = "\n";
local $, = " ";

my ($k,$n) = (2,3);

my @f = (1,0,0,0,0,0,0,0);
print "f = @f";
my @d = (0,0,0);
print "d = @d";
my @c;

for my $a (0..$k**$n-1) {
    my @Ia = I($a);
    print "\@Ia = @Ia";
    #~ $c[$a] = $a;
    #~ print $c[$a];
    #~ $c[$a] *= -1 ** 
}

#~ print conv(33,5);

print @c;

sub conv
{
  my $num = shift;
  my $base = shift;
  return undef if $base>9;
  my @digits = ('0'..'9');
  my $ret = "";
  do {
    $ret = $digits[$num % $base] . $ret;
    $num = int($num / $base);
  } while ($num);

  return $ret;
}

sub I {
    my ($a) = @_;
    $_ = conv($a,$k);
    my @a = /(\d)/g;
    print "\@a = @a";
    my @I;
    while (my ($i,$x) = each @a){
	push(@I,$i) if $x;
    }
    return @I;
}

