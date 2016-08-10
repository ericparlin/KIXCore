# --
# KIXCore.pm - code run during package de-/installation
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Torsten(dot)Thau(at)cape(dash)it(dot)de
# * Martin(dot)Balzarek(at)cape(dash)it(dot)de
# * Dorothea(dot)Doerffel(at)cape(dash)it(dot)de
#
# --
# $Id$
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package var::packagesetup::KIXCore;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision$) [1];

=head1 NAME

KIXCore.pm - code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::KIXCore');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # always discard the config object before package code is executed,
    # to make sure that the config object will be created newly, so that it
    # will use the recently written new config from the package
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::Config'],
    );

    # create additional objects...
    $Self->{ConfigObject}    = $Kernel::OM->Get('Kernel::Config');
    $Self->{MainObject}      = $Kernel::OM->Get('Kernel::System::Main');
    $Self->{SysConfigObject} = $Kernel::OM->Get('Kernel::System::SysConfig');

    $Self->{SysConfigObject}->WriteDefault();
    my @ZZZFiles = (
        'ZZZAAuto.pm',
        'ZZZAuto.pm',
    );

    # reload the ZZZ files (mod_perl workaround)
    for my $ZZZFile (@ZZZFiles) {
        PREFIX:
        for my $Prefix (@INC) {
            my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
            if ( !-f $File ) {
                next PREFIX
            }
            do $File;
            last PREFIX;
        }
    }
    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    $Self->_PrepareKIXCore();

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    $Self->_PrepareKIXCore();

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    $Self->_RemoveKIXCore();

    return 1;

}

=item _PrepareKIXCore()

Automatically open files which need to be edited for KIX tsunami framework.

    my $Result = $CodeObject->_PrepareKIXCore();

=cut

sub _PrepareKIXCore {
    my ( $Self, %Param ) = @_;

    # initialize KIXCore::Packages as repository for registered packages

    if ( $Self->{MainObject}->Require('Kernel::System::KIXUtils') ) {
        $Self->{KIXUtilsObject} = $Kernel::OM->Get('Kernel::System::KIXUtils');
        $Self->{KIXUtilsObject}->RegisterCustomPackage(
            PackageName => 'KIXCore',
            Priority    => '0000',
        );
    }

    # reload configuration....
    $Self->{SysConfigObject}->WriteDefault();
    my @ZZZFiles = (
        'ZZZAAuto.pm',
        'ZZZAuto.pm',
    );

    # reload the ZZZ files (mod_perl workaround)
    for my $ZZZFile (@ZZZFiles) {
        PREFIX:
        for my $Prefix (@INC) {
            my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
            next PREFIX if ( !-f $File );
            do $File;
            last PREFIX;
        }
    }
    return 1;
}

=item _RemoveKIXCore()

Restores files which were modified by the installation of KIXCore.

    my $Result = $CodeObject->_RemoveKIXCore();

=cut

sub _RemoveKIXCore {
    my ( $Self, %Param ) = @_;

    if ( $Self->{MainObject}->Require('Kernel::System::KIXUtils') ) {
        $Self->{KIXUtilsObject} = $Kernel::OM->Get('Kernel::System::KIXUtils');
        $Self->{KIXUtilsObject}->CleanUpConfigPm();
    }

    # reload configuration....
    $Self->{SysConfigObject}->WriteDefault();
    my @ZZZFiles = (
        'ZZZAAuto.pm',
        'ZZZAuto.pm',
    );

    # reload the ZZZ files (mod_perl workaround)
    for my $ZZZFile (@ZZZFiles) {
        PREFIX:
        for my $Prefix (@INC) {
            my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
            next PREFIX if ( !-f $File );
            do $File;
            last PREFIX;
        }
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION
$Revision$ $Date$
=cut
