Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:24384 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932842AbdGJR3c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 13:29:32 -0400
Date: Mon, 10 Jul 2017 19:29:29 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170710192929.5c459615@harpe.intellique.com>
In-Reply-To: <20170707153633.GG4103@magnolia>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
        <20170706232803.GF17762@dastard>
        <20170707135009.68c22182@harpe.intellique.com>
        <20170707153633.GG4103@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/m59CjheuuOoWyetTDXczpQz"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

--Sig_/m59CjheuuOoWyetTDXczpQz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 7 Jul 2017 08:36:33 -0700
"Darrick J. Wong" <darrick.wong@oracle.com> =C3=A9crivait:

> > disconnected inode 180399699751, moving to lost+found
> > disconnected inode 180399699752, moving to lost+found
> >=20
> > fatal error -- name create failed in lost+found (28), filesystem
> > may be out of space =20
>=20
> Would be helpful to have a metadump of this goobered-up lost+found
> fs...
>=20

Well, annoyingly this FS is really big, and the metadump is 5.3GB. It
will be several days before I make it available somewhere online...

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/m59CjheuuOoWyetTDXczpQz
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlljuXkACgkQX3jQXNUicVYr+QCeMrUFiN1Qx2pcJPFclZRqzeiq
qtIAoKFnxdRRGeV23MW4cXniAzC8OnET
=yv1L
-----END PGP SIGNATURE-----

--Sig_/m59CjheuuOoWyetTDXczpQz--
