Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:34206 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753181AbdDKQSH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 12:18:07 -0400
Date: Tue, 11 Apr 2017 18:18:08 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: allow mounting w/crc-checking disabled? (was Re: filesystem
 dead, xfs_repair won't help)
Message-ID: <20170411181808.6d755674@harpe.intellique.com>
In-Reply-To: <7847f469-6a83-8a35-360d-13a0e0341f5d@sandeen.net>
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
        <58EB53CA.7030608@tlinx.org>
        <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
        <58EBC972.6040509@tlinx.org>
        <20170411145721.7d3676a1@harpe.intellique.com>
        <7847f469-6a83-8a35-360d-13a0e0341f5d@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/KU+W2Cu27qF_4jbw2iyEyjw"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: L A Walsh <xfs@tlinx.org>, linux-xfs@vger.kernel.org

--Sig_/KU+W2Cu27qF_4jbw2iyEyjw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 11 Apr 2017 08:34:44 -0500
Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:

> Three, none of this has anything to do with the email that started
> this thread.  Bad firmware turned Avi's SSD into a vat of goo, and
> CRCs are not in any way related to his inability to recover his
> filesystem.

OK, but xfs_db finds and reads the sb OK, and it looks fine at first
look; why does xfs_repair fail completely? I'm not actually certain
that Avi's SSD is a "vat of goo"...=20

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/KU+W2Cu27qF_4jbw2iyEyjw
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljtAcAACgkQX3jQXNUicVZV5gCgqZUc/qZrDL5sUEh2B4xkq+KA
J+wAoOUsnJzCWVikgF0NQtpP0xNA7e23
=Y11d
-----END PGP SIGNATURE-----

--Sig_/KU+W2Cu27qF_4jbw2iyEyjw--
