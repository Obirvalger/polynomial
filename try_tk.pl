#! /usr/bin/perl
use v5.14;
use Tk;
use strict;
use warnings; 

my $k = 2;
my $type = "function";
my $check_inp = 0;
my $iwidth = 45;
my $owidth = 53;
my $bwidth = 0;
my $mw = MainWindow->new;
$mw->optionAdd('*font', 'Sans 16');
#~ $mw->geometry("600x250");
$mw->title("Polynomial");


my $main_frame = $mw->Frame(-background => "grey75")->pack(-side => 'top', -expand => 1, -fill => 'both');
my $inp_frame = $main_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $func_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $fradio_frame = $inp_frame->Frame()->pack(-side => "top", -expand => 1, -fill => 'x');
#~ $fradio_frame->Label(-text=>"The value of logic: ", -background => "grey75")->pack(-side => "left");
my $fradio_func = $fradio_frame->Radiobutton(-text => "function", -value => "function", -width => 0,
                                           -variable=> \$type)->pack(-side => "left", -expand => 1);
my $fradio_poly = $fradio_frame->Radiobutton(-text => "polynomial", -value => "polynomial", -width => 0,
                                             -variable=> \$type)->pack(-side => "left", -expand => 1);
my $fradio_period = $fradio_frame->Radiobutton(-text => "period", -value => "period", -width => 0,
                                          -variable=> \$type)->pack(-side => "left", -expand => 1);
my $polar_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $radio_frame = $inp_frame->Frame()->pack(-side => "top", -fill => 'x');
my $file_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'x');
my $check_frame = $file_frame->Frame(-background => "grey75")->pack(-side => "left");
my $enter_file_frame = $file_frame->Frame(-background => "grey75")->pack(-side => "right", -expand => 1, -fill => 'x');
my $file_entry = $enter_file_frame->Entry(-background => "white", -width => $iwidth - 5,
                                       -foreground => "black")->pack(-side => "right", -expand => 1, -fill => 'x');
$check_frame->Label(-text=>"Input from file? ", -background => "grey75")->pack(-side => "left")->pack(-side => "left");
my $chk = $check_frame->Checkbutton(-variable => \$check_inp, -onvalue => 1, -offvalue => 0, -background => "grey75")->pack();
$radio_frame->Label(-text=>"The value of logic: ")->pack(-side => "left");
my $radio_2 = $radio_frame->Radiobutton(-text => "2", -value => "2",
                                           -variable=> \$k)->pack(-side => "left", -expand => 1);
my $radio_3 = $radio_frame->Radiobutton(-text => "3", -value => "3",
                                             -variable=> \$k)->pack(-side => "left", -expand => 1);
my $radio_5 = $radio_frame->Radiobutton(-text => "5", -value => "5",
                                          -variable=> \$k)->pack(-side => "left", -expand => 1);
my $radio_7 = $radio_frame->Radiobutton(-text => "7", -value => "7",
                                          -variable=> \$k)->pack(-side => "left", -expand => 1);
my $out_frame = $main_frame->Frame(-background => "grey75")->pack(-side => "top", -expand => 1, -fill => 'both');
$func_frame->Label(-text =>  "Vector: ", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
$polar_frame->Label(-text => "Polarization: ", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
$out_frame->Label(-text => "Output: ", -background => "grey75",
                      -foreground => "black")->pack(-side => "left", -anchor => 'n');
my $func_entry = $func_frame->Entry(-background => "white", -width => $iwidth,
                                       -foreground => "darkred")->pack(-side => "right", -expand => 1, -fill => 'x');
my $polar_entry = $polar_frame->Entry(-background => "white", -width => $iwidth,
                                       -foreground => "darkred")->pack(-side => "right", -expand => 1, -fill => 'x');
my $run_button = $inp_frame->Button(-text => "Run", -width => $bwidth,
                                -command => \&runprog)->pack(-side => "bottom", -fill => 'x');
my $print_poly = $out_frame->Text(-background => "white", -height => 4, -width => $owidth,
                                       -foreground => "black")->pack(-side => "top", -expand => 1, -fill => 'both');                                                            

sub runprog {
    $_ = $func_entry->get();
    my $func_vec = join("", split(/[ ,]+/, s/[\(\)]//gr));
    $_ = $polar_entry->get();
    my $polar_vec = join("", split(/[ ,]+/, s/[\(\)]//gr));
    $print_poly->delete('0.0', 'end');
    my $k1 = $k - 1; 
    if ($func_vec =~ /^([0-$k1]+)$/) {
        #~ say $func_vec;
        #~ say $^O;
        $_ = `./polynomial $func_vec $k $polar_vec $type` if $^O =~ /Linux/i;
        $_ = `polynomial.exe $func_vec $k $polar_vec $type` if $^O =~ /Win/i;
        if ($? == 0) {
            my $poly = '' . (join("", split)) . '';
            #~ say $poly;
            $print_poly->insert("end", $poly);
        } else {
            say $?;
            my $err = "Something goes wrong!";
            $err = "Wrong number of digits in function!\nMust be the power of $k!" if /1/;
            $err = "Wrong number of digits in polarization!\n" if /2/;
            $print_poly->insert("end", $err);
        }
        
    } elsif($func_vec =~ /\A\Z/) {
        $print_poly->insert('end', "Enter the function!");
    } else {
        $print_poly->insert('end', "Wrong function!");
    }
    
}

MainLoop;
