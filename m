Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9JLWKGA243120 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 16:32:20 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 375771946482
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 14:33:32 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id W7npsMJtSNCKBe3w for
	<xfs@oss.sgi.com>; Tue, 19 Oct 2010 14:33:32 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Question/Problem: Mounting of XFS filesystem takes a lot of time
Date: Tue, 19 Oct 2010 23:33:22 +0200
References: <1287521058.2000.21.camel@x200>
	(sfid-20101019_233100_875702_7CA6A63B)
In-Reply-To: <1287521058.2000.21.camel@x200>
MIME-Version: 1.0
Message-Id: <201010192333.30449.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2735562276365964811=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Andreas Hasenkopf <andreas.hasenkopf@physik.uni-regensburg.de>

--===============2735562276365964811==
Content-Type: multipart/signed;
  boundary="nextPart2899637.LamJNCuCzP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2899637.LamJNCuCzP
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag 19 Oktober 2010 schrieb Andreas Hasenkopf:
> Hello,

Hi!

> since today I have quite a big problem and I'd like to get some
> opinions from experts on how to proceed in solving the problem.
>=20
> The Problem:
> Since today mounting and unmounting of any XFS partition on my system
> takes (depending on size of partition) up to 15 minutes and more.
[...]
> And now to my question:
> Could my problem be a software related problem (Linux, XFS, something
> else) or should I consider hardware problems?

Anything in syslog or messages (like I/O errors or such)? Are harddisk(s)=20
fine (smartctl)?

Is it fast as usual after the mount succeeds?

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2899637.LamJNCuCzP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAky+DqIACgkQmRvqrKWZhMcP1wCgp+6Zn3/Iikex179OUStHJOPe
lVYAn2Pxv/igReUFdTLk/WD1+eJWqdbH
=xMw1
-----END PGP SIGNATURE-----

--nextPart2899637.LamJNCuCzP--


--===============2735562276365964811==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2735562276365964811==--
