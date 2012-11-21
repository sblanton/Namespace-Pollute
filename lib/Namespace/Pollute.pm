package Namespace::Pollute;

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
