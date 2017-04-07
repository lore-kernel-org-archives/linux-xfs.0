Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:23958 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933874AbdDGO4N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Apr 2017 10:56:13 -0400
Date: Fri, 7 Apr 2017 16:56:16 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Processes stuck in D state when accessing XFSv5 filesystem
Message-ID: <20170407165616.2269260a@harpe.intellique.com>
In-Reply-To: <C1597D74-938F-4236-91F0-4CA1D6907F50@jabberwocky.com>
References: <C1597D74-938F-4236-91F0-4CA1D6907F50@jabberwocky.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/H0K74aPPDhYatRMJ7wdWK.V"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Shaw <dshaw@jabberwocky.com>
Cc: linux-xfs@vger.kernel.org

--Sig_/H0K74aPPDhYatRMJ7wdWK.V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 6 Apr 2017 14:41:45 -0400
David Shaw <dshaw@jabberwocky.com> =C3=A9crivait:

> I'm having a problem with processes getting "stuck" when accessing an
> XFS (v5) filesystem.  When it happens, I start getting the "blocked
> for more than 120 seconds" error, and the process stays in that state
> until I reboot.  The kernel is 3.10.0-514.2.2 and the xfsprogs is
> 4.5.0-9 (both Centos 7.3).
>=20

Could it be that your system is under high IO load?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/H0K74aPPDhYatRMJ7wdWK.V
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljnqJAACgkQX3jQXNUicVZUsQCbBw+J62GTlU4oWXUiOLslWFbz
9NcAn3uPQ7t73FPkg3cjWpIXtRO9X/YT
=aU9+
-----END PGP SIGNATURE-----

--Sig_/H0K74aPPDhYatRMJ7wdWK.V--
