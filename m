Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2BVTh4014138 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 05:31:30 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA99E1C883BB
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 03:33:11 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id eHYkEGr4gWzzTT4h for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 03:33:11 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair of critical volume
Date: Thu, 2 Dec 2010 12:33:02 +0100
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<20101117074708.GP22876@dastard>
	<BA70F631-15CB-4E52-913A-3715CC9678A0@ucsc.edu>
In-Reply-To: <BA70F631-15CB-4E52-913A-3715CC9678A0@ucsc.edu>
MIME-Version: 1.0
Message-Id: <201012021233.07213@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9167459286273024371=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eli Morris <ermorris@ucsc.edu>

--===============9167459286273024371==
Content-Type: multipart/signed;
  boundary="nextPart2592691.X4ZIO1cIyr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2592691.X4ZIO1cIyr
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 30. November 2010 Eli Morris wrote:
> Thanks for your help with this. I wrote the program and ran it
> through and it looks like we have we able to preserve 44 TB of valid
> data, while removing the corrupted files, which is a great result,
> considering the circumstances.=20

Eli, could you post the relevant program here so others can use it if=20
needed? There are requests from time to time, and it would be good if=20
such a program were available (like I'm sure you'd been happy if it=20
already existed the time you needed it).

Thanks, and wow: what an amazing filesystem can recover such an event!

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart2592691.X4ZIO1cIyr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkz3g/MACgkQzhSR9xwSCbSqfACg3RkCYB+j5dLKRL3PTvGvmA7H
Rw8An24uOFEeD0Kgzxb6Wug0hvbNuJXi
=wvwl
-----END PGP SIGNATURE-----

--nextPart2592691.X4ZIO1cIyr--


--===============9167459286273024371==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9167459286273024371==--
