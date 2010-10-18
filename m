Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9IHvZGj004538 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 12:57:35 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 378E01935D8B
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 10:58:44 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YjM7EFO8otWRSuUf for
	<xfs@oss.sgi.com>; Mon, 18 Oct 2010 10:58:44 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: cannot defrag volume, fragmentation factor 21.73%
Date: Mon, 18 Oct 2010 19:58:41 +0200
References: <4CBC3910.70806@cape-horn-eng.com> <201010181439.48143@zmi.at>
	<4CBC4FB7.2040206@cape-horn-eng.com>
In-Reply-To: <4CBC4FB7.2040206@cape-horn-eng.com>
MIME-Version: 1.0
Message-Id: <201010181958.42188@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0224208731975406537=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Richard Ems <richard.ems@cape-horn-eng.com>

--===============0224208731975406537==
Content-Type: multipart/signed;
  boundary="nextPart3169839.ShCunjmxHc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3169839.ShCunjmxHc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Montag, 18. Oktober 2010 Richard Ems wrote:
> Attached the gzipped output of 3 runs of xfs_fsr generated with the
> command:

All files reported have "after:1", so where does the fragmentation come=20
from? Interesting. Maybe a umount;mount helps? Could be the info is just=20
wrong until a remount?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3169839.ShCunjmxHc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky8itIACgkQzhSR9xwSCbRT0QCfYwdGe4uE3lTWm6gqvVZLtMgL
XpUAn0dVm7uiQq0ZbjyKdZ9SAt26ago4
=makE
-----END PGP SIGNATURE-----

--nextPart3169839.ShCunjmxHc--


--===============0224208731975406537==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0224208731975406537==--
