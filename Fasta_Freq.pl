#!/usr/bin/perl

# Enrique Hernandez Lemus, ehernandez@inmegen.gob.mx
# 1 June 2011

use strict;
use Getopt::Std;

my %options;
getopts("p:f:l:h",\%options);
if(defined $options{"h"}) {
        print "Syntax: $0 -p <permutation file> -f <fasta file> -l
<length>\nEnrique Hernandez Lemus, ehernandez\@inmegen.gob.mx\n";
        exit;
}
my $fast_file = $options{"f"} if defined $options{"f"} ||
die("Syntax: $0 -f <fasta file> -l <length> [ -p <permutation file>
]\nEnrique Hernandez Lemus, ehernandez\@inmegen.gob.mx\n");
my $length = $options{"l"} if defined $options{"l"} || die("Syntax:
$0 -f <fasta file> -l <length> [ -p <permutation file> ]\nEnrique
Hernandez Lemus, ehernandez\@inmegen.gob.mx\n");
my $perm_file = $options{"p"} if defined $options{"p"};

if(defined $options{"p"}) {
        open(FPERM,"<$perm_file") or die("ERROR: Could not open 
permutation file: $perm_file\n");
}

open(FFAST,"<$fast_file") or die("ERROR: Could not open fasta file: 
$fast_file\n");


###
# Set up variables
###
my %items;
my @fasta;
my $read_ammount = $length*10;
my $read_thresh  = $length*2;
my $end_found = 0;
my $total_items = 0;

###
# Read initial data
###
read(FFAST,$_,$length*10);
push @fasta,split(//,$_);

###
# Extract groups of $length bases
###
while($#fasta >= $length) {
        my $item;
        for(my $j=0; $j<$length; $j++) {
                $item=$item.$fasta[$j];
        }
        #print "DEBUG: item = $item\n";
        $items{$item}++;
        $total_items++;
        shift(@fasta);
        if( !$end_found && ($#fasta < $read_thresh) ) {
                if(read(FFAST,$_,$read_ammount) < $read_ammount) {
                        $end_found=1;
                }
                push @fasta,split(//,$_);
        }
}

close(FFAST);

###
# Display results
###
my $found_items = 0;
my $percent;

if(defined $options{"p"}) {
        while(<FPERM>) {
                chop;
                if(defined($items{$_})) {
                        $percent = 
sprintf("%2.2f",100*$items{$_}/$total_items);
                        print "$_\t$items{$_}\t$percent \%\n";
                        $found_items++;
                } else {
                        print "$_\t0\t0\n";
                }
        }
        close(FPERM);

} else {

        foreach my $item (sort(keys %items)) {
                $percent = 
sprintf("%2.2f",100*$items{$item}/$total_items);
                print "$item\t$items{$item}\t$percent \%\n";
                $found_items++;
        }

}

print "# Total items = $total_items\n";
print "# Total unique items = $found_items\n";

