Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:64017 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732195AbeLURGb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Dec 2018 12:06:31 -0500
Date: Fri, 21 Dec 2018 17:57:37 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Same size drive has less usable space
Message-ID: <20181221175737.1a6022b8@harpe.intellique.com>
In-Reply-To: <20181220131305.2a84b717@lud1.home>
References: <20181220131305.2a84b717@lud1.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+xjUskIDvC.+YfrINYmGDRo"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: linux-xfs@vger.kernel.org

--Sig_/+xjUskIDvC.+YfrINYmGDRo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 20 Dec 2018 13:13:05 -0200
Luciano ES <lucmove@gmail.com> =C3=A9crivait:

> I guess at least part of the problem is CRC enabled in the second=20
> one. So, is there anything I can do to make all the data fit in the=20
> new drive?

Your new drive is using 4K blocks, while the old one uses 512b blocks.
That's why they can't match.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/+xjUskIDvC.+YfrINYmGDRo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAlwdG4IACgkQX3jQXNUicVaRiQCgz6A6PyK5idoTO/hOwNTlLKU8
ye0AoJVN1yGNAGt3Ff7gnxJcjBXaUmuU
=b4S4
-----END PGP SIGNATURE-----

--Sig_/+xjUskIDvC.+YfrINYmGDRo--
