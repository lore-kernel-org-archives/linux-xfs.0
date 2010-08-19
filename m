Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7JDAZV7172502 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 08:10:36 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3BCD1E4CA3E
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 06:11:04 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id C9Ry6QHacbSAH87u for
	<xfs@oss.sgi.com>; Thu, 19 Aug 2010 06:11:04 -0700 (PDT)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 2DFAC4C8155
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 15:10:56 +0200 (CEST)
Date: Thu, 19 Aug 2010 15:10:50 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Message-ID: <20100819151050.04d71e1f@harpe.intellique.com>
In-Reply-To: <201008191312.49346@zmi.at>
References: <201008191312.49346@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4489664161513717915=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4489664161513717915==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_1fLZiziONhlE401MG3.ibF"; protocol="application/pgp-signature"

--Sig_/_1fLZiziONhlE401MG3.ibF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Thu, 19 Aug 2010 13:12:45 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> The subject is a bit harsh, but overall the article says:
> XFS is slowest on creating and deleting a billion files
> XFS fsck needs 30GB RAM to fsck that 100TB filesystem.

Too bad I haven't got a 100 TB machine at hand. However I have a 24TB
system dedicated to tests. I'm pretty sure we can do much better with
XFS and the proper mount options :)

In fact, I have an unused 40 TB array too. See this one later...

Stay tuned :)

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/_1fLZiziONhlE401MG3.ibF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkxtLVoACgkQX3jQXNUicVYdkwCg2e/nPbuckZSnq8IptdJsRnmw
fEMAoOpym/fDALIw1uisvTGp1B72gv+Q
=sYp5
-----END PGP SIGNATURE-----

--Sig_/_1fLZiziONhlE401MG3.ibF--


--===============4489664161513717915==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4489664161513717915==--
