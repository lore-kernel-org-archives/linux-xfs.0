Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5MGXddg246040 for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 11:33:39 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B0C815A08CF
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 09:40:29 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id q9fNyOazlhG2ojhK for
	<xfs@oss.sgi.com>; Tue, 22 Jun 2010 09:40:29 -0700 (PDT)
Date: Tue, 22 Jun 2010 18:35:58 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: advice for repair after IO error on raid device
Message-ID: <20100622183558.537ae596@harpe.intellique.com>
In-Reply-To: <201006221807.19191@zmi.at>
References: <cone.1277217402.916517.87295.1001@bork.lsof.org>
	<201006221807.19191@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1715692168132457326=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

--===============1715692168132457326==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZOw0iRExni2w_Oc/dBNby8U"; protocol="application/pgp-signature"

--Sig_/ZOw0iRExni2w_Oc/dBNby8U
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Tue, 22 Jun 2010 18:07:18 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> The "isr got aborted" sounds like a driver problem

You bet, isr stands for "interrupt system routine", apparently the
driver (or the firmware) seriously shat its pants. Maybe a firmware
and/or kernel upgrade would be good too.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/ZOw0iRExni2w_Oc/dBNby8U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwg5m4ACgkQX3jQXNUicVbvPQCgvZHEDmCeeTzgr1E8psqeHXna
Z+IAoMh3Ip+GmzgbXxdOBNjKks1QSe/N
=QSaf
-----END PGP SIGNATURE-----

--Sig_/ZOw0iRExni2w_Oc/dBNby8U--


--===============1715692168132457326==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1715692168132457326==--
