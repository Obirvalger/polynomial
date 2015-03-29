#! /usr/bin/perl
use v5.14;
use Tk;
use strict;

my ($k, $n, $fname);

my $mw = MainWindow->new;
$mw->optionAdd('*font', 'Sans 16');
# $mw->geometry("800x480");
$mw->title("MakePolarization");
my $main_frame = $mw->Frame(-background => "grey75")->pack(-side => 'top', -expand => 1, -fill => 'both');
my $kn_frame = $main_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $k_frame = $kn_frame->Frame(-background => "grey75")->pack(-side => 'left', -fill => 'both');
$k_frame->Label(-text => "k=", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
my $k_entry = $k_frame->Entry(-background => "white",
                                       -foreground => "black")->pack(-side => "right", -expand => 1, -fill => 'x');
				       
my $n_frame = $kn_frame->Frame(-background => "grey75")->pack(-side => 'right', -fill => 'both');
$n_frame->Label(-text => "    n = ", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
my $n_entry = $n_frame->Entry(-background => "white",
                                       -foreground => "black")->pack(-side => "right", -expand => 1, -fill => 'x');

my $fname_frame = $main_frame->Frame(-background => "grey75")->pack(-side => 'top', -expand => 1, -fill => 'both');;
$fname_frame->Label(-text => "filename: ", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
my $fname_entry = $fname_frame->Entry(-background => "white",
                                       -foreground => "black")->pack(-side => "right", -expand => 1, -fill => 'x');

my $run_button = $main_frame->Button(-text => "Run",
                                -command => \&makePolarization)->pack(-side => "bottom", -fill => 'x');

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

sub makePolarization {
    $k = $k_entry->get()+0;
    $n = $n_entry->get()+0;
    $fname = $fname_entry->get() || "polarization_${k}_${n}.txt";
    my $maxPolar = $k ** $n - 1;
    open(my $fd, ">$fname");
    for my $i (0 .. $maxPolar) {
	my $f = conv($i, $k, $n);
	print $fd "$f\n"
    }
}					       

MainLoop;
