# --
# Kernel/Language/de_KIXCore - provides german language translation
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Beatrice(dot)Mueller(at)cape(dash)it(dot)de
# * Dorothea(dot)Doerffel(at)cape(dash)it(dot)de
# * Rene(dot)Boehm(at)cape(dash)it(dot)de
#
# --
# $Id$
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de_KIXCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    # $$START$$

    $Lang->{
        'information: even though this package is not certified by OTRS Group, this does NOT mean that you should NOT use it.'
        }
        = 'Paket ist zwar nicht durch OTRS Gruppe verifiziert - das bedeutet aber NICHT, dass dieses Paket nicht verwendet werden kann oder darf.';
    $Lang->{
        'Disables the unrequested automatic communication of installed packages and other system details to OTRS AG.'
        }
        = 'Deaktiviert die unaufgeforderte automatische Kommunikation, der installierten Pakete und anderer System-Details, zur OTRS AG.';
    $Lang->{
        'Enables the unrequested automatic communication of installed packages and other system details to the path.'
        }
        = 'Aktiviert die unaufgeforderte automatische Kommunikation, der installierten Pakete und anderer System-Details, zum angegebenen Pfad.';
    $Lang->{
        'Even though this package is not certified by OTRS Group, this does NOT mean that you should NOT use it.'
        }
        = 'Das Paket ist zwar nicht durch OTRS Gruppe verifiziert - das bedeutet aber NICHT, dass dieses Paket nicht verwendet werden kann oder darf.';

    $Lang->{'Pre-create loader cache.'} = 'Loadercache vorgenerieren.';

    # $$STOP$$

    return 0;
}

1;
