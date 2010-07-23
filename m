Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NCriaZ201199 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 07:53:44 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5D6146C115
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:56:44 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id xrUBOKka68o1iP5i for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:56:44 -0700 (PDT)
Date: Fri, 23 Jul 2010 14:56:23 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 4k sector drives
Message-ID: <20100723145623.0e5cef50@harpe.intellique.com>
In-Reply-To: <201007231259.11714@zmi.at>
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<201007230809.28111@zmi.at> <20100723095832.GA23174@infradead.org>
	<201007231259.11714@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5457880071123188327=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

--===============5457880071123188327==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RLcwhEwr1Crs4vS8XmG0z.A"; protocol="application/pgp-signature"

--Sig_/RLcwhEwr1Crs4vS8XmG0z.A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Fri, 23 Jul 2010 12:59:07 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> Thanks for clarification. Should I use "-s size=3D4096" despite the
> drive saying 512b sectors? It's a "hidden" 4K sector drive, so maybe
> declaring it extra for XFS helps performance? Or does it not matter
> at all?

I'd say it's the right time for a benchmark :)

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/RLcwhEwr1Crs4vS8XmG0z.A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkxJkXcACgkQX3jQXNUicVakAwCcCExNnLXpvkpOG8WGpmLjeU3O
TwYAnjxXwOCxaIGTdihb5hVZ74yLjXbF
=vlDw
-----END PGP SIGNATURE-----

--Sig_/RLcwhEwr1Crs4vS8XmG0z.A--


--===============5457880071123188327==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5457880071123188327==--
