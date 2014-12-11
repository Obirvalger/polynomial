#! /usr/bin/perl
use v5.14;
use Tk;
use strict;
#~ use warnings; 

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
    #~ say "lol";
    $print_poly->delete('0.0', 'end');
    my ($n, $dp) = 0, "";
    my ($fd_vec, $fd_polar, $fd_out);
    my ($vec_file, $polar_file, $out_file);
    my ($max_len, $max_polar ,$max_func, $max_poly) = -1;
    my ($min_len, $min_polar ,$min_func, $min_poly) = 'none';
    if ($check_inp) {
        my $files = $file_entry->get();
        unless ($files) {
            #~ say "All bad!";
            $print_poly->insert('end', "Enter the filename!");
            return;
        }
        #~ $print_poly->insert('end', "Enter the filename!") unless $files;
        ($vec_file, $polar_file, $out_file) = split(/;\s?/, $files);
        if ($vec_file eq '' and $polar_file eq '' and $out_file eq '') {
            $print_poly->insert('end', "Enter the filename!");
            return;
        }
        #~ say $vec_file =~ /[^\.]/;
        $vec_file .= '.txt' if ($vec_file and index($vec_file, '.') == -1);
        $polar_file .= '.txt' if ($polar_file and index($polar_file, '.') == -1);
        $out_file .= '.txt' if ($out_file and index($out_file, '.') == -1);
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
        #~ say "'$_'";
        $_ = <$fd_vec> if $vec_file;
        #~ return unless defined $_;
        unless (defined $_) {
            $print_poly->insert('end', "max length = $max_len\nmax function = $max_func\nmax polarization = $max_polar\nmax polynomial = $max_poly\n");
            $print_poly->insert('end', "min length = $min_len\nmin function = $min_func\nmin polarization = $min_polar\nmin polynomial = $min_poly\n");
            return;
        }
        s/[\n\r]+$//;
        my $func_sep;
        my $func_vec;
        #~ say "type $type";
        if ($type eq 'period') {
            unless($_) {
                $print_poly->insert('end', "Enter n and weight vector!\n");
                return;
            }
            $n = $1 if s/\A(\d+)[^\d\(]*//;
            #~ say "Period n = $n";
            unless($_) {
                $print_poly->insert('end', "You entered only n.\nEnter weight vector!\n");
                return;
            }
            $func_sep = /\d([ ,]+)\d/ ? $1 : '';
            #~ say "$func_sep";
            $_ = join("", split(/[ ,]+/, s/[\(\)]//gr));
            #~ my $kn = $k ** $n;
            #~ my $x = ($kn % length) ? int($kn/length($_)) + 1 : $kn/length($_);
            #~ say $x;
            #~ $_ x= ($kn % length) ? $kn/length($_) + 1 : $kn/length($_);
            #~ $_ = substr $_, 0, $kn;
            #~ say;
            $func_vec = $_;
        }
        elsif ($type eq 'polynomial') {
            unless($_) {
                $print_poly->insert('end', "Enter polynomial [;polarization]!\n");
                return;
            }
            ($_, $dp) = split /;/;
            #~ say;
            #~ say $dp;
            #~ unless($_) {
                #~ $print_poly->insert('end', "You entered only n.\nEnter the function!\n");
                #~ return;
            #~ }
            $func_sep = /\d([ ,]+)\d/ ? $1 : '';
            #~ say "$func_sep";
            $_ = join("", split(/[ ,]+/, s/[\(\)]//gr));
            $dp = join("", split(/[ ,]+/, $dp));
            #~ say "dp = $dp";
        }
        unless($_) {
                $print_poly->insert('end', "Enter function!\n");
                return;
        }
        #~ print "$_\n";
        $func_sep //= /\d([ ,]+)\d/ ? $1 : '';
        $func_vec //= join("", split(/[ ,]+/, s/[\(\)]//gr));
        $_ = $polar_entry->get();
        $_ = <$fd_polar> if $polar_file;
        unless (defined $_) {
            $print_poly->insert('end', "max length = $max_len\nmax function = $max_func\nmax polarization = $max_polar\nmax polynomial = $max_poly\n");
            $print_poly->insert('end', "min length = $min_len\nmin function = $min_func\nmin polarization = $min_polar\nmin polynomial = $min_poly\n");
            return;
        }
        s/[\n\r]+$//;
        $n ||= int(log(length($func_vec)) / log($k) + 0.5);
        $dp ||= '0' x $n;
        #~ say $n;
        my $polar_vec = '0';
        if ($_) {
            $polar_vec = join("", split(/[ ,]+/, s/[\(\)]//gr));
        } elsif($func_vec) {
            $polar_vec = '0' x $n;
        }
        #~ say "a${polar_vec}a";
        my $k1 = $k - 1;
        #~ print "fv = '$func_vec'\npv = '$polar_vec'\n";
        if ($func_vec =~ /^([0-$k1]+)$/ && $polar_vec =~ /^([0-$k1]+)$/) {
            #~ say $n;
            #~ say $polar_vec;
            #~ say $func_vec;
            #~ say "dp = $dp";
            #~ $_ = system("./polynomial $type $func_vec $k $polar_vec $n $dp") if $^O =~ /Linux/i;
            $_ = `./polynomial $type $func_vec $k $polar_vec $n $dp` if $^O =~ /Linux/i;
            $_ = `polynomial.exe $type $func_vec $k $polar_vec $n $dp` if $^O =~ /Win/i;
            if ($? == 0) {
                #~ say $func_vec;
                my $poly = '' . (join($func_sep, split)) . '';
                #~ say $poly;
                my $l = () = $poly =~ /([1-9])/g;
                if ($max_len < $l) {
                    $max_len = $l;
                    $max_polar = $polar_vec;
                    $max_func = $func_vec;
                    $max_poly = $poly;
                }
                if ($min_len eq 'none' or $min_len > $l) {
                    $min_len = $l;
                    #~ say $min_len unless $l;
                    $min_polar = $polar_vec;
                    #~ say $min_len;
                    $min_func = $func_vec;
                    $min_poly = $poly;
                }
                $poly .= sprintf("\nlength = %d", $l);
                $poly = "Minus" if $poly =~ /-/;
                $print_poly->insert("end", "$poly\n");
                print $fd_out "$poly\n" if $fd_out;
            } else {
                #~ say $?;
                my $err = "Something goes wrong!\n";
                $err = "Wrong number of digits in function!\nMust be the power of $k!\n" if /\A1/;
                $err = "Wrong number of digits in polarization!\n" if /\A2/;
                $err = "Wrong number of digits in polynomial polarization!\n" if /\A3/;
                $print_poly->insert("end", $err);
            }
            
        } else {
            unless($func_vec) {
                $print_poly->insert('end', "Enter the function!\n");
            } elsif($func_vec !~ /^([0-$k1]+)$/) {
                $print_poly->insert('end', "Wrong function!\nFunction must contain only digits in range(0, $k1)\n");
            }
            $print_poly->insert('end', "Wrong polarization!\n") if($polar_vec !~ /^([0-$k1]+)$/);
        }
        last unless $check_inp;
    }
    #~ $print_poly->insert('end', "max length = $max_len\nmax function = $max_func\nmax polarization = $max_polar\n");
    #~ $print_poly->insert('end', "All done\n") if $check_inp;
}

MainLoop;
