package SHARYANTO::Locale::Util;

our $DATE = '2014-08-06'; # DATE
our $VERSION = '0.76'; # VERSION

use 5.010001;
use strict;
use warnings;

use vars '@posix_consts';
BEGIN {
    @posix_consts = qw(
                          LC_ALL LC_COLLATE LC_CTYPE LC_MESSAGES LC_MONETARY
                          LC_NUMERIC LC_TIME
                  );
}
use POSIX (@posix_consts);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = ('setlocale', @posix_consts);
our %EXPORT_TAGS = (
    all      => ['setlocale', @posix_consts],
    locale_h => ['setlocale', @posix_consts],
);

sub setlocale {
    my $cat = shift;
    state %mem;

    return POSIX::setlocale($cat) if !@_;
    my $locale = shift;
    if ($locale =~ /\./) {
        return POSIX::setlocale($cat, $locale);
    } elsif ($mem{$locale}) {
        return POSIX::setlocale($cat, $mem{$locale});
    } elsif (my $res = POSIX::setlocale($cat, $locale)) {
        # first try without encoding code
        return $res;
    } else {
        my $enc;
        # try to find suitable encoding from env
        if (($ENV{LANG} // "") =~ /\.(\S+)\z/) {
            $enc = $1;
        } else {
            # hard-coded default. XXX better heuristic
            $enc = "UTF-8";
        }
        $mem{$locale} = "$locale.$enc";
        return POSIX::setlocale($cat, $mem{$locale});
    }
}

1;
# ABSTRACT: Locale utilities

__END__

=pod

=encoding UTF-8

=head1 NAME

SHARYANTO::Locale::Util - Locale utilities

=head1 VERSION

This document describes version 0.76 of SHARYANTO::Locale::Util (from Perl distribution SHARYANTO-Locale-Util), released on 2014-08-06.

=head1 SYNOPSIS

 use SHARYANTO::Locale::Util qw(setlocale LC_ALL);
 setlocale(LC_ALL, "en_US") or warn "Can't setlocale: $!";

=head1 EXPORTS

=head2 LC_*

Imported from L<POSIX>.

=head2 setlocale($category, $locale)

A wrapper around POSIX's setlocale(). When given a locale in the form of
"en_US", some systems fail. This wrapper tries to find a suitable encoding and
retries with e.g. setlocale($category, "en_US.UTF-8").

=head1 EXPORT TAGS

=head2 :locale_h

=head2 :all

=head1 SEE ALSO

L<POSIX>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/SHARYANTO-Locale-Util>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-SHARYANTO-Locale-Util>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=SHARYANTO-Locale-Util>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
