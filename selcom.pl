# Quick and approximate check of RIPE meeting attendance
# for choosing eligibility criteria for selection committe
#
# This is not production level code.  Uses many globals.
# It has had no review!
#
# dfk@ripe.net
# February 2019

use String::Compare;
use Getopt::Std;

sub unique { # return array with duplicate elements removed
    my %seen;
    grep !$seen{$_}++, @_;
}

sub eligible {  # return names of eligible attenders as of $mtg
        my($mtg, $minattended, $window) = @_;
        my @all = ();
        my @eligibles = ();

        for (my $m=$mtg;  $mtg-$m<$window; $m--) {      # attendee names for all meetings
                die "no data for meeting $m" unless $attendees{$m};
                @all = (@all, @{$attendees{$m}});
        }
        foreach my $f (sort keys %meetings) {           # select eligibles
                push(@eligibles, $f) if ((grep {$_ eq $f} @all) >= $minattended);
        }
        return(@eligibles);
}

sub print_ranges { # print integers in array as ranges (no sort!)
        my @numbers = @_;
        my @ranges;
        for (@numbers) {
           if (@ranges && $_ == $ranges[-1][1]+1) {
              ++$ranges[-1][1];
           } else {
              push @ranges, [ $_, $_ ];
           }
        }
        return(join ',', map { $_->[0] == $_->[1] ? $_->[0] : "$_->[0]-$_->[1]" } @ranges);
}

sub print_meetings { # print the meetings attended by all attenders
        foreach my $f (sort keys %meetings) {
                my @mtgs = sort(@{$meetings{$f}});
                printf "%2d ", $#mtgs+1;
                printf "%-30.30s\t", $f;
                print join(',', @mtgs);
                print "\n";
        }
}

sub print_all { # print all data we have for all attenders
        my @k = (sort keys %meetings);
        my $d = 0;

        foreach my $f (@k) {
                printf "%2d ", $#{$meetings{$f}}+1;
                printf "%-30s\t", $f;
                print "[";
                print print_ranges(sort(@{$meetings{$f}}));
                print "] (";
                print join(',', unique(sort(@{$affils{$f}})));
                print ")\n";
        }
}

sub print_similar_names { # print relevant data for similar names, first column is similarity index
        my @k = (sort keys %meetings);
        my $d = 0;

        foreach my $f (@k) {
            foreach my $g (@k) {
                $d = compare($f, $g, {char_by_char});
                if ($d>0.66 && $d!=1) {
                        printf "%4.2f ", $d;
                        printf "%2d:%-2d ", $#{$meetings{$f}}+1, $#{$meetings{$g}}+1;
                        printf "%-50s\t", (sprintf "%s:%s", $f, $g);
                        print "[";
                        print print_ranges(sort(@{$meetings{$f}}));
                        print ':';
                        print print_ranges(sort(@{$meetings{$g}}));
                        print "] (";
                        print join(',', unique(sort(@{$affils{$f}})));
                        print ':';
                        print join(',', unique(sort(@{$affils{$g}})));
                        print ")\n";
                }
            }
        }
}

sub read_canonical_names {      # this file is selected manually from the output of (-s) p..g. print_name_similarities()
        my $f = "canonical-names.csv";
        my %can_name = {};
        open ($FILE, $f) || die "could not open $f";

        while (<$FILE>) {
                chop();
                my ($canon, @aliases) = split(/,/);
                foreach $a (@aliases) {
                        $can_name{$a} = $canon;
                }
        }

        close($FILE);
        return(%can_name);
}

sub print_line { # print one line of results

        my @vals = @_;

        for (my $i=0; $i<=$#vals; $i++) {
                printf ",%7d", $vals[$i];
        }
}


sub print_results { # print results for att attended meetings out of win for mtg meetings
        my($att, $win, $mtg) = @_;

        my @ep = ();
        my @ecc = ();

        foreach $m (@mtgs[reverse(0..$mtg-1)]) {
                my @e = eligible($m, $att, $win);
                push(@ep, $#e+1);
        }
        printf "%8.8s", sprintf( "%d of %d", $att, $win);
        print_line(@ep);
        print "\n";
}

######## main #########

getopts("a:m:w:s") || die(
        "RIPE Selection Coimmittee Analysis\n",
        "usage: selcom [-m #meetings] [-a #attended] [-w #window]\n",
        "-s     print similar names\n"
);
$opt_m = 10 unless length($opt_m);

my %can_name = read_canonical_names();

opendir($DIR, '.') || die "could not open current directory";

while ($f = readdir($DIR)) {
        next unless $f =~ /^ripe([0-9]+).*\.csv/;
        $mtg = $1;
        open ($FILE, $f) || die "could not open $f";
        while (<$FILE>) {
                ($fn, $ln, $af, $cc) = split(/,/);
                $fulln = lc("$fn $ln");
                $fulln = $can_name{$fulln} if $can_name{$fulln};
                push(@{$meetings{$fulln}}, $mtg);
                push(@{$attendees{$mtg}}, $fulln);
                $mtgcount{$mtg}++;
                push(@{$affils{$fulln}}, $af);
                push(@{$ccs{$fulln}}, $cc);
        }
        close($FILE);
}
printf "Loaded meetings %s.\n", print_ranges(sort(keys(%mtgcount)));

select((select(STDOUT), $|=1)[0]);

if ($opt_s) {
        print_similar_names();
        exit(0);
}

@mtgs = reverse sort keys %mtgcount;

print "attended";
foreach $m (@mtgs[reverse(0..$opt_m-1)]) {
        printf ", RIPE%2d", $m;
}
print "\n";

if ( $opt_a || $opt_w ) {
        $opt_a = 3 unless length($opt_a);
        $opt_w = 5 unless length($opt_w);

        print_results($opt_a, $opt_w, $opt_m);
}
else {
        print_results(5,5,10);
        print_results(4,5,10);
        print_results(3,5,10);
        print_results(2,5,10);
        print_results(1,5,10);
        print_results(4,4,10);
        print_results(3,4,10);
        print_results(2,4,10);
        print_results(1,4,10);
        print_results(3,3,10);
        print_results(2,3,10);
        print_results(1,3,10);
        print_results(2,2,10);
        print_results(1,2,10);
        print_results(1,1,10);
}
