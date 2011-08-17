Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7HDIxqL060585 for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 08:18:59 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 519DA1E74A4F
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 06:18:56 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id HB4tV433MyMPSAYu for
	<xfs@oss.sgi.com>; Wed, 17 Aug 2011 06:18:56 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Bug#638158: xfsprogs: Damaged filesystem causes xfs_repair to
	sometimes (but not always) segfault
Date: Wed, 17 Aug 2011 15:18:52 +0200
References: <E1QtbO1-0005u8-5N@eamp.org>
In-Reply-To: <E1QtbO1-0005u8-5N@eamp.org>
MIME-Version: 1.0
Message-Id: <201108171518.53374@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6159528999237117938=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Robert Jacobs <debbtsb06@eamp.org>

--===============6159528999237117938==
Content-Type: multipart/signed;
  boundary="nextPart3115770.xd3Vz2ds0f";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3115770.xd3Vz2ds0f
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 17. August 2011 Robert Jacobs wrote:
> I've attached the outputs of xfs_check and three different runs of
> xfs_repair (with backtrace, when available).

Can you provide a XFS metadump? That should help devs to reproduce the=20
error.=20

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart3115770.xd3Vz2ds0f
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk5Lv70ACgkQzhSR9xwSCbR0AACgoSmKFF0FybSyNxhFPzOEpO6a
hmsAoLG/3UTdcAbdprHqlJo5cKKO5J1p
=EQ39
-----END PGP SIGNATURE-----

--nextPart3115770.xd3Vz2ds0f--


--===============6159528999237117938==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6159528999237117938==--
