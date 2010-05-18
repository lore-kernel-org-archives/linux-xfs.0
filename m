Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4IAESLt046005 for <xfs@oss.sgi.com>; Tue, 18 May 2010 05:14:28 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBABA1DF208A
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 03:16:44 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id F1vIaRPTvnHaF06K for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 03:16:44 -0700 (PDT)
Date: Tue, 18 May 2010 12:16:25 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair 3.1.1 doesnt repair broken filesystem
Message-ID: <20100518121625.41050392@harpe.intellique.com>
In-Reply-To: <201005180953.51892@zmi.at>
References: <201005180953.51892@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2220867777218245238=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

--===============2220867777218245238==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/q21y55Dpc8WJYoKm5a0EYyx"; protocol="application/pgp-signature"

--Sig_/q21y55Dpc8WJYoKm5a0EYyx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Tue, 18 May 2010 09:53:47 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> I do a repair on a broken filesystem, which reports no problems. Then
> I mount and "ls -l", and you can easily see all those broken entries,=20
> which should be directories. They are not repaired. What could I do?

What is your xfs_repair version? (-V option). I guess 3.0.1 or more
should be better.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/q21y55Dpc8WJYoKm5a0EYyx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvyaPkACgkQX3jQXNUicVb15wCgilcCEHyzetg4NoJ2OPO8Yadd
COoAoJ25GwdFU2Na9HTu74UMVfVDFQhX
=Gch2
-----END PGP SIGNATURE-----

--Sig_/q21y55Dpc8WJYoKm5a0EYyx--


--===============2220867777218245238==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2220867777218245238==--
