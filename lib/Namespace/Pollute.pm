package Namespace::Pollute;
# ABSTRACT: Loads and imports the default exported symbols of a list of modules

use Exporter;
@ISA = qw(Exporter);

sub import {

	shift;    #-- The first one is our own class name

	if ( $_[0] eq '-verbose' ) {
		$VERBOSE = 1;
		shift;
	}

	foreach my $module (@_) {
		eval "require $module";

		if ( eval { $module->isa('Exporter') } ) {
			print "ISA Exporter: $module\n" if $VERBOSE;

			@EXPORT = @{"${module}::EXPORT"};

			$module->import(@EXPORT);

			foreach my $symbol (@EXPORT) {
				print "\tExporting: $module::$symbol\n" if $VERBOSE;
				Namespace::Pollute->export_to_level( 1,, ($symbol) );
			}

		} elsif (
			eval {
				$module->can('import');
			}
		  )
		{
			print "Calling $module->import\n" if $VERBOSE;

			#-- Things that have an import sub:
			$module->import;
		}
	}

}

1;

__END__

=head1 SYNOPSIS

  use Namspace::Pollute qw(-verbose My::Exporter1 My::Exporter2);

=head1 DESCRIPTION

Takes a list of modules, loads them, and exports their symbols into the current namespace. This first version provides only
a small advantage in brevity over a list of 'use' statements, but has the ability to print out the symbols as they are exported
for modules that inherit from 'Exporter'.

For modules that don't inherit from 'Exporter', those modules' 'import' method will be called.

=head1 TODO

1) Make it work for Exporter's EXPORT_OK. 2) Export symbols to a variable number of levels.

=cut
