###############################################################################
#
# Tests for Excel::Writer::XLSX::Package::Styles methods.
#
# reverse('�'), September 2010, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions '_new_style';
use strict;
use warnings;

use Test::More tests => 1;


###############################################################################
#
# Tests setup.
#
my $expected;
my $got;
my $caption;
my $style;


###############################################################################
#
# Test the _write_fill() method.
#
$caption  = " \tStyles: _write_fill()";
$expected = '<fill><patternFill patternType="none" /></fill>';

$style = _new_style(\$got);

$style->_write_fill('none');

is( $got, $expected, $caption );

__END__


