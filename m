Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S5mdKi089912 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 00:48:39 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D8E5195A34
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 22:48:37 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id qTZVjUD0Bfmrf3i8 for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2011 22:48:37 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 64-bit inodes and back again
Date: Wed, 28 Sep 2011 07:48:32 +0200
References: <4E825C25.6050804@cchtml.com> <4E8278D8.9060309@cchtml.com>
	<4E828BE1.8030003@cchtml.com>
In-Reply-To: <4E828BE1.8030003@cchtml.com>
MIME-Version: 1.0
Message-Id: <201109280748.33889@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0924713586736844624=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Michael Cronenworth <mike@cchtml.com>

--===============0924713586736844624==
Content-Type: multipart/signed;
  boundary="nextPart23133978.De3oOhduY9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart23133978.De3oOhduY9
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 28. September 2011 Michael Cronenworth wrote:
> I did try this tool first, but it didn't seem to work for me:
>=20
> # xfs_reno -vv=20
> /tmp/q.save/7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.f
> c14-x86_64=20
>=20
> xfs_reno: Cannot stat=20

I guess you'd need to mount with inode64 enabled so you can access the=20
files, and after the tool finished to back to 32bit inodes.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart23133978.De3oOhduY9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6CtTEACgkQzhSR9xwSCbQbzACg5FpYHAavMkG247/VXrakorT6
H1oAn1YUw3W/PDN9LQiVkf8ixIUPFwP3
=9uTd
-----END PGP SIGNATURE-----

--nextPart23133978.De3oOhduY9--


--===============0924713586736844624==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0924713586736844624==--
