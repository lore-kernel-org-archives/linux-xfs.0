Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LAV16W072844 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 05:31:02 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 844D21606FD3
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 03:33:58 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id EkJbdqVltdXc6YpR for
	<xfs@oss.sgi.com>; Wed, 21 Jul 2010 03:33:58 -0700 (PDT)
Date: Wed, 21 Jul 2010 12:33:49 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 4k sector drives
Message-ID: <20100721123349.1042fdd1@harpe.intellique.com>
In-Reply-To: <201007211114.16023@zmi.at>
References: <201007211053.45191.eye.of.the.8eholder@gmail.com>
	<201007211114.16023@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3515301273299319572=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

--===============3515301273299319572==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wF7UWuI=8A89rjU3KEVqbIE"; protocol="application/pgp-signature"

--Sig_/wF7UWuI=8A89rjU3KEVqbIE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Wed, 21 Jul 2010 11:14:15 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> I have these:
> Model=3DWDC WD20EARS-00MVWB0, FwRev=3D50.0AB50, SerialNo=3DWD-WMAZ20035646
> Model=3DWDC WD20EARS-00MVWB0, FwRev=3D50.0AB50, SerialNo=3DWD-WMAZ20028252
>=20
> Any chance to get Linux know they are 4k sector drives manually?

=46rom what I've read here and there, apparently they'll always present
512 bytes blocks, bu the system is somehow aware that the underlying
block is 4K large, apparently. It isn't very clear...=20

BTW, I suppose that with such a drive, it's highly commendable to use
4K FS blocks (or larger) instead of the common 1K ones...

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/wF7UWuI=8A89rjU3KEVqbIE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkxGzQ0ACgkQX3jQXNUicVZLmwCfdRpzAynajn3oXRWhKJFalmJE
NKUAoIE5AvntkRDJPs4orJbw/xKHJJGD
=qPxZ
-----END PGP SIGNATURE-----

--Sig_/wF7UWuI=8A89rjU3KEVqbIE--


--===============3515301273299319572==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3515301273299319572==--
