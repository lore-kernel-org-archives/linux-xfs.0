Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6CCEPrA027055 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 07:14:25 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B91314B9125
	for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 05:23:14 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id BUpUfxiaIlgGyxGq for
	<xfs@oss.sgi.com>; Mon, 12 Jul 2010 05:23:14 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Slow delete
Date: Mon, 12 Jul 2010 14:17:13 +0200
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
	<20100705233448.GB24712@dastard>
In-Reply-To: <20100705233448.GB24712@dastard>
MIME-Version: 1.0
Message-Id: <201007121417.14097@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2004926320602473969=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lwn@lwn.net

--===============2004926320602473969==
Content-Type: multipart/signed;
  boundary="nextPart3721879.1lt21px7t5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3721879.1lt21px7t5
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 6. Juli 2010 Dave Chinner wrote:
> For a detailed explanation of the concept and how delayed logging
> takes advantage of it to speed up stuff like deleting a large number
> of files, see:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dbl
> ob;f=3DDocumentation/filesystems/xfs-delayed-logging-design.txt
=20
Great docu, although my head still exploded on reading this, and at some=20
point I started to just read over it. Luckily, I'm no dev, otherwise I'd=20
need to grow a second head for the extra brain space needed to=20
understand all that stuff, and that would make my appearance even worse=20
than it is already. Also, I'm not sure if the two-head solution isn't=20
patented by Zaphod Beeblebrox already, at least in the U.S. region.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3721879.1lt21px7t5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkw7B8oACgkQzhSR9xwSCbRCTgCg9W0Q5ZuwfbmsQsOFPm3/DhCA
aLwAoOQrDyQbKVpr1q26Ts1E5Tlt54OB
=JN3p
-----END PGP SIGNATURE-----

--nextPart3721879.1lt21px7t5--


--===============2004926320602473969==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2004926320602473969==--
