Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:48166 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754709AbdGKNYB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Jul 2017 09:24:01 -0400
Date: Tue, 11 Jul 2017 15:23:52 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170711152340.4cd5dff9@harpe.intellique.com>
In-Reply-To: <20170707153633.GG4103@magnolia>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
        <20170706232803.GF17762@dastard>
        <20170707135009.68c22182@harpe.intellique.com>
        <20170707153633.GG4103@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SMlVXs5EbolIXdQHAY41Tt8"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

--Sig_/SMlVXs5EbolIXdQHAY41Tt8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 7 Jul 2017 08:36:33 -0700
"Darrick J. Wong" <darrick.wong@oracle.com> =C3=A9crivait:

> > fatal error -- name create failed in lost+found (28), filesystem
> > may be out of space =20
>=20
> Would be helpful to have a metadump of this goobered-up lost+found
> fs...
>=20

The metadump is here for anyone who would like to have a look:

http://update2.intellique.com/pub/bign.metadump.xz

The filesystem is about 115 TiB.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/SMlVXs5EbolIXdQHAY41Tt8
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAllk0XMACgkQX3jQXNUicVZI5ACgiV8hE/DwFlQDwVJ5UArrOgBE
gIUAoPdbJa5AMK9xZDYuKY65V2mIfgwp
=KSOd
-----END PGP SIGNATURE-----

--Sig_/SMlVXs5EbolIXdQHAY41Tt8--
