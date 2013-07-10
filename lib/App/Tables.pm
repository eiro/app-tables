package App::Tables::As::Dir;

sub read {
}


sub write {
}

package App::Tables;
# ABSTRACT: manipulation of tables from any sources  

use Modern::Perl;
use Exporter 'import';
our @EXPORT_OK = qw<
    init
>;

our %EXPORT_TAGS =
( all=> \@EXPORT_OK );

our $VERSION = '0.0';

# possible types are xls, xslx and /
# could be some urlized dsn+query stuff

sub _init_file {
    my ( $put, $type, $desc, $args ) = @_;
    { base => ($$args{$put}  || die "no data while grabbing $desc" )
    , type => ($$args{$type} || do {
        }) }
}

sub extension_of {
    (shift) ~~ qr{
        (?: (?<type> / )
            | [.] (?<type> xlsx? )
        )$
    }x and $+{type};
}

sub _file_spec {
    my ( $desc, $data, $type ) = @_;

    $data or die "no data for $desc";

    for ( $type ||= extension_of($data) || 'dir' ) {
        $_ = 'dir' if  $_ eq '/'
    }

    { base => $data
    , type => $type }

}

sub init {
    my %args = @_ ? @_ : @ARGV;

    my %conf = map {
        $args{$_}
        ? ( $_ => [ split /,/, $args{$_} ] )
        : ()
    } qw< can >;
    $conf{from} = _file_spec input  => @args{qw< from is >};
    $conf{to}   = _file_spec output => @args{qw< to will >};

    map {
        die "overwrite $_"
            if $_ eq $conf{to}{base}
    } $conf{from}{base};
    \%conf
}


1;
