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
#~ $mw->geometry("550x200");
$mw->title("Polynomial");


my $main_frame = $mw->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'x');
my $inp_frame = $main_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $func_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $fradio_frame = $inp_frame->Frame()->pack(-side => "top", -fill => 'x');
#~ $fradio_frame->Label(-text=>"The value of logic: ", -background => "grey75")->pack(-side => "left");
my $fradio_2 = $fradio_frame->Radiobutton(-text => "function", -value => "function", -width => 0,
                                           -variable=> \$type)->pack(-side => "left");
my $fradio_3 = $fradio_frame->Radiobutton(-text => "polynomial", -value => "polynomial", -width => 0,
                                             -variable=> \$type)->pack(-side => "left");
my $fradio_5 = $fradio_frame->Radiobutton(-text => "period", -value => "period", -width => 0,
                                          -variable=> \$type)->pack(-side => "left");
my $polar_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $radio_frame = $inp_frame->Frame()->pack(-side => "top", -fill => 'x');
my $file_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'x');
my $check_frame = $file_frame->Frame(-background => "grey75")->pack(-side => "left");
my $enter_file_frame = $file_frame->Frame(-background => "grey75")->pack(-side => "right");
my $file_entry = $enter_file_frame->Entry(-background => "white", -width => $iwidth - 5,
                                       -foreground => "black")->pack(-side => "right");
$check_frame->Label(-text=>"Input from file? ", -background => "grey75")->pack(-side => "left")->pack(-side => "left");
my $chk = $check_frame->Checkbutton(-variable => \$check_inp, -onvalue => 1, -offvalue => 0, -background => "grey75")->pack();
$radio_frame->Label(-text=>"The value of logic: ")->pack(-side => "left");
my $radio_2 = $radio_frame->Radiobutton(-text => "2", -value => "2",
                                           -variable=> \$k)->pack(-side => "left");
my $radio_3 = $radio_frame->Radiobutton(-text => "3", -value => "3",
                                             -variable=> \$k)->pack(-side => "left");
my $radio_5 = $radio_frame->Radiobutton(-text => "5", -value => "5",
                                          -variable=> \$k)->pack(-side => "left");
my $out_frame = $main_frame->Frame(-background => "grey75")->pack(-side => "left");
$func_frame->Label(-text =>  "      Vector: ", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
$polar_frame->Label(-text => "Polarization: ", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
$out_frame->Label(-text => "Output: ", -background => "grey75",
                      -foreground => "black")->pack(-side => "left");
my $func_entry = $func_frame->Entry(-background => "white", -width => $iwidth,
                                       -foreground => "darkred")->pack(-side => "right", -fill => 'x');
my $polar_entry = $polar_frame->Entry(-background => "white", -width => $iwidth,
                                       -foreground => "darkred")->pack(-side => "right", -fill => 'x');
my $run_button = $inp_frame->Button(-text => "Run", -width => $bwidth,
                                -command => \&runprog)->pack(-side => "bottom", -fill => 'x');
my $print_poly = $out_frame->Text(-background => "white", -height => 4, -width => $owidth,
                                       -foreground => "black")->pack(-side => "top");                                                            

sub runprog {
    $_ = $func_entry->get();
    my $func_vec = join("", split(/[ ,]+/, s/[\(\)]//gr));
    $print_poly->delete('0.0', 'end');
    my $k1 = $k - 1; 
    if ($func_vec =~ /^([0-$k1]+)$/) {
        #~ say $func_vec;
        #~ say $^O;
        $_ = `./pos $func_vec $k $type` if $^O =~ /Linux/i;
        $_ = `pos.exe $func_vec $k $type` if $^O =~ /Win/i;
        if ($? == 0) {
            my $poly = '' . (join("", split)) . '';
            #~ say $poly;
            $print_poly->insert("end", $poly);
        } else {
            say $?;
            my $err = "Something goes wrong!";
            $err = "Wrong number of digits!\nMust be the power of $k!" if /^1$/;
            $print_poly->insert("end", $err);
        }
        
    } elsif($func_vec =~ /\A\Z/) {
        $print_poly->insert('end', "Enter the function!");
    } else {
        $print_poly->insert('end', "Wrong function!");
    }
    
}

MainLoop;
