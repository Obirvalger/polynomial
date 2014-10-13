#! /usr/bin/perl
use v5.14;
use Tk;
use strict;
use warnings; 

my $wwidth = 40;
my $mw = MainWindow->new;
$mw->optionAdd('*font', 'Verdana 16');
#~ $mw->geometry("850x115");
$mw->title("Polynomial");


my $main_frame = $mw->Frame()->pack(-side => 'top', -fill => 'x');
my $inp_frame = $main_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $func_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $polar_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $out_frame = $main_frame->Frame(-background => "white")->pack(-side => "left");
$func_frame->Label(-text => "Function:", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
$polar_frame->Label(-text => "Polar vector:", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
$out_frame->Label(-text => "Output:", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
my $func_entry = $func_frame->Entry(-background => "white", -width => $wwidth,
                                       -foreground => "darkred")->pack(-side => "right");
my $polar_entry = $polar_frame->Entry(-background => "white", -width => $wwidth,
                                       -foreground => "darkred")->pack(-side => "right");
my $run_button = $inp_frame->Button(-text => "Run", -width => $wwidth + 10,
                                -command => \&runprog)->pack(-side => "top");
my $print_poly = $out_frame->Text(-background => "white", -height => 1, -width => $wwidth + 4,
                                       -foreground => "black")->pack(-side => "top");                                                            

sub runprog {
    my $k = 2;
    $_ = $func_entry->get();
    my $func_vec = join("", split(/[ ,]+/, s/[\(\)]//gr));
    $print_poly->delete('0.0', 'end');
    if ($func_vec =~ /^([01]+)$/) {
        #~ say $func_vec;
        $_ = `./pos $func_vec` if $^O =~ /Linux/;
        $_ = `pos.exe $func_vec` if $^O =~ /Win/;
        if ($? == 0) {
            my $poly = '' . (join("", split)) . '';
            #~ say $poly;
            $print_poly->insert("end", $poly);
        } else {
            say $?;
            my $err = "Something goes wrong!";
            $err = "Wrong number of digits! Must be the power of $k!" if /^1$/;
            $print_poly->insert("end", $err);
        }
        
    } else {
        $print_poly->insert('end', "wrong function");
    }
    
}

MainLoop;
