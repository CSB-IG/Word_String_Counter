#!/usr/bin/perl
# Enrique Hernandez-Lemus
# Parses a file and prints each word it found
# with the number of appearances

use strict;

if(@ARGV < 1) {
	die("ERROR: need file to read from\n");
}

open(INPUT,"<$ARGV[0]") || die("ERROR: could not open file $ARGV[0] for reading\n");

my %words;

while(<INPUT>) {
	chomp;
	s///;
	my @tmp = split(/\s+/, $_);
	foreach my $item (@tmp) {
		if( ($item =~ m/([a-z]+)/i) ) {
			$item = lc($1);
			$words{$item}++;
		}
	}
}

foreach my $word (sort keys %words) {
	print "$word\t$words{$word}\n";
}

close(INPUT);
