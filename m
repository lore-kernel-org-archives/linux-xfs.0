Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9K64FXQ032711 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 01:04:16 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EC7710641D
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 23:05:25 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id BM51HDZPiFo2VVAI for
	<xfs@oss.sgi.com>; Tue, 19 Oct 2010 23:05:25 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Question/Problem: Mounting of XFS filesystem takes a lot of time
Date: Wed, 20 Oct 2010 08:05:22 +0200
References: <1287521058.2000.21.camel@x200>
In-Reply-To: <1287521058.2000.21.camel@x200>
MIME-Version: 1.0
Message-Id: <201010200805.23592@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3316393654148015581=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Andreas Hasenkopf <andreas.hasenkopf@physik.uni-regensburg.de>

--===============3316393654148015581==
Content-Type: multipart/signed;
  boundary="nextPart5462499.EX4YrjMEsE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5462499.EX4YrjMEsE
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 19. Oktober 2010 Andreas Hasenkopf wrote:
> 2x 1TB HDD in RAID1 configuration (xfs)

Check your disks. I've seen harddisks dying in that way. Suddenly access=20
times are horrible. Test random access I/O and compare times, not=20
sequential - those might still look good.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart5462499.EX4YrjMEsE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky+hqMACgkQzhSR9xwSCbRvSwCfcf9yacEhm6kEA0OHNOCYUjnL
rrUAoK38HMXMuRcfJxEDuqKOPWBzuw28
=cS8W
-----END PGP SIGNATURE-----

--nextPart5462499.EX4YrjMEsE--


--===============3316393654148015581==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3316393654148015581==--
