#! /usr/bin/perl
use v5.14;
use Tk;
use strict;
use warnings; 

my $k = 2;
my $type = "function";
my $check_inp = 0;
#~ my $iwidth = 45;
#~ my $owidth = 53;
#~ my $bwidth = 0;
my $mw = MainWindow->new;
$mw->optionAdd('*font', 'Sans 16');
$mw->geometry("800x480");
$mw->title("Polynomial");


my $main_frame = $mw->Frame(-background => "grey75")->pack(-side => 'top', -expand => 1, -fill => 'both');
my $inp_frame = $main_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $func_frame = $inp_frame->Frame(-background => "grey75")->pack(-side => 'top', -fill => 'both');
my $fradio_frame = $inp_frame->Frame()->pack(-side => "top", -expand => 1, -fill => 'x');
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
my $file_entry = $enter_file_frame->Entry(-background => "white",
                                       -foreground => "black")->pack(-side => "right", -expand => 1, -fill => 'x');
$check_frame->Label(-text=>"Input from file? ", -background => "grey75")->pack(-side => "left")->pack(-side => "left");
my $chk = $check_frame->Checkbutton(-variable => \$check_inp, -onvalue => 1, -offvalue => 0,
                                            -background => "grey75")->pack(-anchor => 'e');
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
my $func_entry = $func_frame->Entry(-background => "white",
                                       -foreground => "darkred")->pack(-side => "right", -expand => 1, -fill => 'x');
my $polar_entry = $polar_frame->Entry(-background => "white",
                                       -foreground => "darkred")->pack(-side => "right", -expand => 1, -fill => 'x');
my $run_button = $inp_frame->Button(-text => "Run",
                                -command => \&runprog)->pack(-side => "bottom", -fill => 'x');
my $print_poly = $out_frame->Text(-background => "white", -height => 4,
                                       -foreground => "black")->pack(-side => "top", -expand => 1, -fill => 'both');                                                            

sub runprog {
    $print_poly->delete('0.0', 'end');
    my ($fd_vec, $fd_polar, $fd_out);
    my ($vec_file, $polar_file, $out_file);
    if ($check_inp) {
        my $files = $file_entry->get();
        unless ($files) {
            #~ say "All bad!";
            $print_poly->insert('end', "Enter the filename!");
            return;
        }
        #~ $print_poly->insert('end', "Enter the filename!") unless $files;
        ($vec_file, $polar_file, $out_file) = split(/;\s?/, $files);
        #~ print("vf = '$vec_file'\npf = '$polar_file'\nof = '$out_file'\n");
        unless (open($fd_vec, "<$vec_file")) {
            $print_poly->insert('end', "Couldn't open file $vec_file!\n") if $vec_file;
        }
        unless (open($fd_polar, "<$polar_file")) {
            $print_poly->insert('end', "Couldn't open file $polar_file!\n") if $polar_file;
        }
        unless (open($fd_out, ">$out_file")) {
            $print_poly->insert('end', "Couldn't open file $out_file!\n") if $out_file;
        }
    }
    for(;;) {
        $_ = $func_entry->get();
        chomp($_ = <$fd_vec>) if $vec_file;
        return unless defined $_;
        my $func_sep;
        my $func_vec;
        #~ say "type $type";
        if ($type eq 'period') {
            my $n = $1 if s/\A(\d+)[^\d\(]*//;
            #~ say "Period n = $n";
            $func_sep = /\d([ ,]+)\d/ ? $1 : '';
            #~ say "$func_sep";
            $_ = join("", split(/[ ,]+/, s/[\(\)]//gr));
            my $kn = $k ** $n;
            my $x = ($kn % length) ? int($kn/length($_)) + 1 : $kn/length($_);
            #~ say $x;
            $_ x= ($kn % length) ? $kn/length($_) + 1 : $kn/length($_);
            $_ = substr $_, 0, $kn;
            #~ say;
            $func_vec = $_;
        }
        #~ print "$_\n";
        $func_sep //= /\d([ ,]+)\d/ ? $1 : '';
        $func_vec //= join("", split(/[ ,]+/, s/[\(\)]//gr));
        $_ = $polar_entry->get();
        chomp($_ = <$fd_polar>) if $polar_file;
        return unless defined $_;
        my $polar_vec = '0';
        if ($_) {
            $polar_vec = join("", split(/[ ,]+/, s/[\(\)]//gr));
        } else {
            $polar_vec = '0' x (log(length($func_vec)) / log($k)) if $func_vec;
        }
        my $k1 = $k - 1;
        #~ print "fv = '$func_vec'\npv = '$polar_vec'\n";5
        if ($func_vec =~ /^([0-$k1]+)$/ && $polar_vec =~ /^([0-$k1]+)$/) {
            $_ = `./polynomial $func_vec $k $polar_vec $type` if $^O =~ /Linux/i;
            $_ = `polynomial.exe $func_vec $k $polar_vec $type` if $^O =~ /Win/i;
            if ($? == 0) {
                my $poly = '' . (join($func_sep, split)) . '';
                #~ say $poly;
                $print_poly->insert("end", "$poly\n");
                print $fd_out "$poly\n" if $fd_out;
            } else {
                #~ say $?;
                my $err = "Something goes wrong!\n";
                $err = "Wrong number of digits in function!\nMust be the power of $k!\n" if /1/;
                $err = "Wrong number of digits in polarization!\n" if /2/;
                $print_poly->insert("end", $err);
            }
            
        } else {
            unless($func_vec) {
                $print_poly->insert('end', "Enter the function!\n");
            } elsif($func_vec !~ /^([0-$k1]+)$/) {
                $print_poly->insert('end', "Wrong function!\n");
            }
            $print_poly->insert('end', "Wrong polarization!\n") if($polar_vec !~ /^([0-$k1]+)$/);
        }
        last unless $check_inp;
    }
    #~ $print_poly->insert('end', "All done\n") if $check_inp;
}

MainLoop;
