package Excel::Writer::XLSX::Chart::Scatter;

###############################################################################
#
# Scatter - A writer class for Excel Scatter charts.
#
# Used in conjunction with Excel::Writer::XLSX::Chart.
#
# See formatting note in Excel::Writer::XLSX::Chart.
#
# Copyright 2000-2010, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.010000;
use strict;
use warnings;
use Carp;
use Excel::Writer::XLSX::Chart;

our @ISA     = qw(Excel::Writer::XLSX::Chart);
our $VERSION = '0.16';


###############################################################################
#
# new()
#
#
sub new {

    my $class = shift;
    my $self  = Excel::Writer::XLSX::Chart->new( @_ );

    $self->{_cross_between} = 'midCat';

    bless $self, $class;
    return $self;
}


##############################################################################
#
# _write_chart_type()
#
# Override the virtual superclass method with a chart specific method.
#
sub _write_chart_type {

    my $self = shift;

    # Write the c:scatterChart element.
    $self->_write_scatter_chart();
}


##############################################################################
#
# _write_scatter_chart()
#
# Write the <c:scatterChart> element.
#
sub _write_scatter_chart {

    my $self = shift;

    $self->{_writer}->startTag( 'c:scatterChart' );

    # Write the c:scatterStyle element.
    $self->_write_scatter_style();

    # Write the series elements.
    $self->_write_series();


    $self->{_writer}->endTag( 'c:scatterChart' );
}


##############################################################################
#
# _write_ser()
#
# Over-ridden to write c:xVal/c:yVal instead of c:cat/c:val elements.
#
# Write the <c:ser> element.
#
sub _write_ser {

    my $self       = shift;
    my $index      = shift;
    my $categories = shift;
    my $values     = shift;

    $self->{_writer}->startTag( 'c:ser' );

    # Write the c:idx element.
    $self->_write_idx( $index );

    # Write the c:order element.
    $self->_write_order( $index );

    # Write the c:spPr element.
    $self->_write_sp_pr();

    # Write the c:marker element.
    $self->_write_marker();

    # Write the c:xVal element.
    $self->_write_x_val( $categories );

    # Write the c:yVal element.
    $self->_write_y_val( $values );


    $self->{_writer}->endTag( 'c:ser' );
}


##############################################################################
#
# _write_plot_area()
#
# Over-ridden to have 2 valAx elements for scatter charts instead of
# catAx/valAx.
#
# Write the <c:plotArea> element.
#
sub _write_plot_area {

    my $self = shift;

    $self->{_writer}->startTag( 'c:plotArea' );

    # Write the c:layout element.
    $self->_write_layout();

    # Write the subclass chart type element.
    $self->_write_chart_type();

    # Write the c:catAx element.
    $self->_write_val_axis( 'b', 1 );

    # Write the c:catAx element.
    $self->_write_val_axis( 'l' );

    $self->{_writer}->endTag( 'c:plotArea' );
}


##############################################################################
#
# _write_x_val()
#
# Write the <c:xVal> element.
#
sub _write_x_val {

    my $self    = shift;
    my $formula = shift;

    $self->{_writer}->startTag( 'c:xVal' );

    # Write the c:numRef element.
    $self->_write_num_ref( $formula );

    $self->{_writer}->endTag( 'c:xVal' );
}


##############################################################################
#
# _write_y_val()
#
# Write the <c:yVal> element.
#
sub _write_y_val {

    my $self    = shift;
    my $formula = shift;

    $self->{_writer}->startTag( 'c:yVal' );

    # Write the c:numRef element.
    $self->_write_num_ref( $formula );

    $self->{_writer}->endTag( 'c:yVal' );
}


##############################################################################
#
# _write_scatter_style()
#
# Write the <c:scatterStyle> element.
#
sub _write_scatter_style {

    my $self = shift;
    my $val  = 'lineMarker';

    my @attributes = ( 'val' => $val );

    $self->{_writer}->emptyTag( 'c:scatterStyle', @attributes );
}


1;


__END__


=head1 NAME

Scatter - A writer class for Excel Scatter charts.

=head1 SYNOPSIS

To create a simple Excel file with a Scatter chart using Excel::Writer::XLSX:

    #!/usr/bin/perl -w

    use strict;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart.xls' );
    my $worksheet = $workbook->add_worksheet();

    my $chart     = $workbook->add_chart( type => 'scatter' );

    # Configure the chart.
    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
    );

    # Add the worksheet data the chart refers to.
    my $data = [
        [ 'Category', 2, 3, 4, 5, 6, 7 ],
        [ 'Value',    1, 4, 5, 2, 1, 5 ],
    ];

    $worksheet->write( 'A1', $data );

    __END__

=head1 DESCRIPTION

This module implements Scatter charts for L<Excel::Writer::XLSX>. The chart object is created via the Workbook C<add_chart()> method:

    my $chart = $workbook->add_chart( type => 'scatter' );

Once the object is created it can be configured via the following methods that are common to all chart classes:

    $chart->add_series();
    $chart->set_x_axis();
    $chart->set_y_axis();
    $chart->set_title();

These methods are explained in detail in L<Excel::Writer::XLSX::Chart>. Class specific methods or settings, if any, are explained below.

=head1 Scatter Chart Methods

There aren't currently any scatter chart specific methods. See the TODO section of L<Excel::Writer::XLSX::Chart>.

=head1 EXAMPLE

Here is a complete example that demonstrates most of the available features when creating a chart.

    #!/usr/bin/perl -w

    use strict;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart_scatter.xls' );
    my $worksheet = $workbook->add_worksheet();
    my $bold      = $workbook->add_format( bold => 1 );

    # Add the worksheet data that the charts will refer to.
    my $headings = [ 'Number', 'Sample 1', 'Sample 2' ];
    my $data = [
        [ 2, 3, 4, 5, 6, 7 ],
        [ 1, 4, 5, 2, 1, 5 ],
        [ 3, 6, 7, 5, 4, 3 ],
    ];

    $worksheet->write( 'A1', $headings, $bold );
    $worksheet->write( 'A2', $data );

    # Create a new chart object. In this case an embedded chart.
    my $chart = $workbook->add_chart( type => 'scatter', embedded => 1 );

    # Configure the first series. (Sample 1)
    $chart->add_series(
        name       => 'Sample 1',
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
    );

    # Configure the second series. (Sample 2)
    $chart->add_series(
        name       => 'Sample 2',
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$C$2:$C$7',
    );

    # Add a chart title and some axis labels.
    $chart->set_title ( name => 'Results of sample analysis' );
    $chart->set_x_axis( name => 'Test number' );
    $chart->set_y_axis( name => 'Sample length (cm)' );

    # Insert the chart into the worksheet (with an offset).
    $worksheet->insert_chart( 'D2', $chart, 25, 10 );

    __END__


=begin html

<p>This will produce a chart that looks like this:</p>

<p><center><img src="http://homepage.eircom.net/~jmcnamara/perl/images/scatter1.jpg" width="527" height="320" alt="Chart example." /></center></p>

=end html


=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMX, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

