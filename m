Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59GUYos187882 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 11:30:35 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10E63D961C2
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 09:30:32 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YRXGy65V4Fxwd7Gs for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2011 09:30:32 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Small files perform much faster on newly formatted fs?
Date: Thu, 9 Jun 2011 18:30:28 +0200
References: <20110607163742.GH28625@pyre.virge.net>
	<20110609012907.GR32466@dastard>
	<20110609134811.GI28625@pyre.virge.net>
In-Reply-To: <20110609134811.GI28625@pyre.virge.net>
MIME-Version: 1.0
Message-Id: <201106091830.29491@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4162489986853499953=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Norbert Veber <nveber@pyre.virge.net>

--===============4162489986853499953==
Content-Type: multipart/signed;
  boundary="nextPart27839233.5sKfQIQnPV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart27839233.5sKfQIQnPV
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 9. Juni 2011 Norbert Veber wrote:
> In these kinds of cases maybe there should be an error logged instead
> of just silently ignoring them?

And also don't show them in the mount options when calling "mount" or=20
"cat /proc/mount".

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart27839233.5sKfQIQnPV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3w9SUACgkQzhSR9xwSCbRSLQCfX8QG/Ftp1KSpNsbkTMtrI5Aj
pA4AnjEFNx53bj61dE6uC7VadYzVgu6o
=MNDW
-----END PGP SIGNATURE-----

--nextPart27839233.5sKfQIQnPV--


--===============4162489986853499953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4162489986853499953==--
