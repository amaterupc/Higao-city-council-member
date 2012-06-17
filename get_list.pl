#!/usr/local/bin/perl

# See: http://search.cpan.org/~petek/HTML-Tree-3.23/lib/HTML/TreeBuilder.pm
# http://higashiosaka.gijiroku.com/gikai/g07_giinlist.asp?Hmode=20

use strict;
use utf8;
use HTML::TreeBuilder;

foreach my $filename (@ARGV) {
	my $file = '';
	my $tree = HTML::TreeBuilder->new; # empty tree
	# $tree->parse_file($filename);

	open(IN, "< $filename");
	read(IN, $file, (-s "$filename"));
	$file =~ s/\<br \/\>/, /g;
	$tree->parse($file);

	my $member_table = $tree->find('table');	# gets member table
	foreach my $member ( $member_table->find('tr') ) {

		my @data = ();
		foreach my $e ( $member->look_down("_tag", qr/td|th/ ) ) {
			push @data, $e->as_text;
		}
		print join(", ", @data)."\n";
	}

	# Now that we're done with it, we must destroy it.
	$tree = $tree->delete;
	close(IN);
}
