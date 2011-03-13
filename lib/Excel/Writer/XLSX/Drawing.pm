package Excel::Writer::XLSX::Drawing;

###############################################################################
#
# Drawing - A class for writing the Excel XLSX drawing.xml file.
#
# Used in conjunction with Excel::Writer::XLSX
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
use Excel::Writer::XLSX::Package::XMLwriter;

our @ISA     = qw(Excel::Writer::XLSX::Package::XMLwriter);
our $VERSION = '0.16';


###############################################################################
#
# Public and private API methods.
#
###############################################################################


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;
    my $self  = Excel::Writer::XLSX::Package::XMLwriter->new();

    $self->{_writer} = undef;

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self = shift;

    return unless $self->{_writer};

    $self->_write_xml_declaration;

    # Write the xdr:wsDr element.
    $self->_write_drawing_workspace();

    # Write the xdr:twoCellAnchor element.
    $self->_write_two_cell_anchor();

    $self->{_writer}->endTag( 'xdr:wsDr' );

    # Close the XM writer object and filehandle.
    $self->{_writer}->end();
    $self->{_writer}->getOutput()->close();
}


###############################################################################
#
# _set_dimensions()
#
# Set the dimensions of the drawing.
#
sub _set_dimensions {

    my $self = shift;

    $self->{_col_from}        = shift;
    $self->{_row_from}        = shift;
    $self->{_col_from_offset} = shift;
    $self->{_row_from_offset} = shift;
    $self->{_col_to}          = shift;
    $self->{_row_to}          = shift;
    $self->{_col_to_offset}   = shift;
    $self->{_row_to_offset}   = shift;
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# XML writing methods.
#
###############################################################################


##############################################################################
#
# _write_drawing_workspace()
#
# Write the <xdr:wsDr> element.
#
sub _write_drawing_workspace {

    my $self      = shift;
    my $schema    = 'http://schemas.openxmlformats.org/drawingml/';
    my $xmlns_xdr = $schema . '2006/spreadsheetDrawing';
    my $xmlns_a   = $schema . '2006/main';

    my @attributes = (
        'xmlns:xdr' => $xmlns_xdr,
        'xmlns:a'   => $xmlns_a,
    );

    $self->{_writer}->startTag( 'xdr:wsDr', @attributes );
}


##############################################################################
#
# _write_two_cell_anchor()
#
# Write the <xdr:twoCellAnchor> element.
#
sub _write_two_cell_anchor {

    my $self = shift;

    $self->{_writer}->startTag( 'xdr:twoCellAnchor' );

    # Write the xdr:from element.
    $self->_write_from(
        $self->{_col_from},
        $self->{_row_from},
        $self->{_col_from_offset},
        $self->{_row_from_offset},

    );

    # Write the xdr:from element.
    $self->_write_to(
        $self->{_col_to},
        $self->{_row_to},
        $self->{_col_to_offset},
        $self->{_row_to_offset},

    );

    # Write the xdr:graphicFrame element.
    $self->_write_graphic_frame();

    # Write the xdr:clientData element.
    $self->_write_client_data();

    $self->{_writer}->endTag( 'xdr:twoCellAnchor' );
}


##############################################################################
#
# _write_from()
#
# Write the <xdr:from> element.
#
sub _write_from {

    my $self       = shift;
    my $col        = shift;
    my $row        = shift;
    my $col_offset = shift;
    my $row_offset = shift;

    $self->{_writer}->startTag( 'xdr:from' );

    # Write the xdr:col element.
    $self->_write_col( $col );

    # Write the xdr:colOff element.
    $self->_write_col_off( $col_offset );

    # Write the xdr:row element.
    $self->_write_row( $row );

    # Write the xdr:rowOff element.
    $self->_write_row_off( $row_offset );

    $self->{_writer}->endTag( 'xdr:from' );
}


##############################################################################
#
# _write_to()
#
# Write the <xdr:to> element.
#
sub _write_to {

    my $self       = shift;
    my $col        = shift;
    my $row        = shift;
    my $col_offset = shift;
    my $row_offset = shift;

    $self->{_writer}->startTag( 'xdr:to' );

    # Write the xdr:col element.
    $self->_write_col( $col );

    # Write the xdr:colOff element.
    $self->_write_col_off( $col_offset );

    # Write the xdr:row element.
    $self->_write_row( $row );

    # Write the xdr:rowOff element.
    $self->_write_row_off( $row_offset );

    $self->{_writer}->endTag( 'xdr:to' );
}


##############################################################################
#
# _write_col()
#
# Write the <xdr:col> element.
#
sub _write_col {

    my $self = shift;
    my $data = shift;

    $self->{_writer}->dataElement( 'xdr:col', $data );
}


##############################################################################
#
# _write_col_off()
#
# Write the <xdr:colOff> element.
#
sub _write_col_off {

    my $self = shift;
    my $data = shift;

    $self->{_writer}->dataElement( 'xdr:colOff', $data );
}


##############################################################################
#
# _write_row()
#
# Write the <xdr:row> element.
#
sub _write_row {

    my $self = shift;
    my $data = shift;

    $self->{_writer}->dataElement( 'xdr:row', $data );
}


##############################################################################
#
# _write_row_off()
#
# Write the <xdr:rowOff> element.
#
sub _write_row_off {

    my $self = shift;
    my $data = shift;

    $self->{_writer}->dataElement( 'xdr:rowOff', $data );
}


##############################################################################
#
# _write_graphic_frame()
#
# Write the <xdr:graphicFrame> element.
#
sub _write_graphic_frame {

    my $self  = shift;
    my $macro = '';

    my @attributes = ( 'macro' => $macro );

    $self->{_writer}->startTag( 'xdr:graphicFrame', @attributes );

    # Write the xdr:nvGraphicFramePr element.
    $self->_write_nv_graphic_frame_pr();

    # Write the xdr:xfrm element.
    $self->_write_xfrm();

    # Write the a:graphic element.
    $self->_write_atag_graphic();

    $self->{_writer}->endTag( 'xdr:graphicFrame' );
}


##############################################################################
#
# _write_nv_graphic_frame_pr()
#
# Write the <xdr:nvGraphicFramePr> element.
#
sub _write_nv_graphic_frame_pr {

    my $self = shift;

    $self->{_writer}->startTag( 'xdr:nvGraphicFramePr' );

    # Write the xdr:cNvPr element.
    $self->_write_c_nv_pr( 2, 'Chart 1' );

    # Write the xdr:cNvGraphicFramePr element.
    $self->_write_c_nv_graphic_frame_pr();

    $self->{_writer}->endTag( 'xdr:nvGraphicFramePr' );
}


##############################################################################
#
# _write_c_nv_pr()
#
# Write the <xdr:cNvPr> element.
#
sub _write_c_nv_pr {

    my $self = shift;
    my $id   = shift;
    my $name = shift;

    my @attributes = (
        'id'   => $id,
        'name' => $name,
    );

    $self->{_writer}->emptyTag( 'xdr:cNvPr', @attributes );
}


##############################################################################
#
# _write_c_nv_graphic_frame_pr()
#
# Write the <xdr:cNvGraphicFramePr> element.
#
sub _write_c_nv_graphic_frame_pr {

    my $self = shift;

    $self->{_writer}->emptyTag( 'xdr:cNvGraphicFramePr' );
}


##############################################################################
#
# _write_xfrm()
#
# Write the <xdr:xfrm> element.
#
sub _write_xfrm {

    my $self = shift;

    $self->{_writer}->startTag( 'xdr:xfrm' );

    # Write the xfrmOffset element.
    $self->_write_xfrm_offset();

    # Write the xfrmOffset element.
    $self->_write_xfrm_extension();

    $self->{_writer}->endTag( 'xdr:xfrm' );
}


##############################################################################
#
# _write_xfrm_offset()
#
# Write the <a:off> xfrm sub-element.
#
sub _write_xfrm_offset {

    my $self = shift;
    my $x    = 0;
    my $y    = 0;

    my @attributes = (
        'x' => $x,
        'y' => $y,
    );

    $self->{_writer}->emptyTag( 'a:off', @attributes );
}


##############################################################################
#
# _write_xfrm_extension()
#
# Write the <a:ext> xfrm sub-element.
#
sub _write_xfrm_extension {

    my $self = shift;
    my $x    = 0;
    my $y    = 0;

    my @attributes = (
        'cx' => $x,
        'cy' => $y,
    );

    $self->{_writer}->emptyTag( 'a:ext', @attributes );
}


##############################################################################
#
# _write_atag_graphic()
#
# Write the <a:graphic> element.
#
sub _write_atag_graphic {

    my $self = shift;

    $self->{_writer}->startTag( 'a:graphic' );

    # Write the a:graphicData element.
    $self->_write_atag_graphic_data();

    $self->{_writer}->endTag( 'a:graphic' );
}


##############################################################################
#
# _write_atag_graphic_data()
#
# Write the <a:graphicData> element.
#
sub _write_atag_graphic_data {

    my $self = shift;
    my $uri  = 'http://schemas.openxmlformats.org/drawingml/2006/chart';

    my @attributes = ( 'uri' => $uri, );

    $self->{_writer}->startTag( 'a:graphicData', @attributes );

    # Write the c:chart element.
    $self->_write_c_chart( 'rId1' );

    $self->{_writer}->endTag( 'a:graphicData' );
}


##############################################################################
#
# _write_c_chart()
#
# Write the <c:chart> element.
#
sub _write_c_chart {

    my $self    = shift;
    my $r_id    = shift;
    my $schema  = 'http://schemas.openxmlformats.org/';
    my $xmlns_c = $schema . 'drawingml/2006/chart';
    my $xmlns_r = $schema . 'officeDocument/2006/relationships';


    my @attributes = (
        'xmlns:c' => $xmlns_c,
        'xmlns:r' => $xmlns_r,
        'r:id'    => $r_id,
    );

    $self->{_writer}->emptyTag( 'c:chart', @attributes );
}


##############################################################################
#
# _write_client_data()
#
# Write the <xdr:clientData> element.
#
sub _write_client_data {

    my $self = shift;

    $self->{_writer}->emptyTag( 'xdr:clientData' );
}

1;


__END__

=pod

=head1 NAME

Drawing - A class for writing the Excel XLSX drawing.xml file.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

� MM-MMXI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::Writer::XLSX>.

=cut
