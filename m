Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ICcdCL225670 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 07:38:40 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7F59192CFF5
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 05:39:50 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id RPyAgyJN68Qsh4p2 for
	<xfs@oss.sgi.com>; Mon, 18 Oct 2010 05:39:50 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: cannot defrag volume, fragmentation factor 21.73%
Date: Mon, 18 Oct 2010 14:39:43 +0200
References: <4CBC3910.70806@cape-horn-eng.com>
In-Reply-To: <4CBC3910.70806@cape-horn-eng.com>
MIME-Version: 1.0
Message-Id: <201010181439.48143@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8175593656374386354=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Richard Ems <richard.ems@cape-horn-eng.com>

--===============8175593656374386354==
Content-Type: multipart/signed;
  boundary="nextPart1776597.uKTemXtyrE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1776597.uKTemXtyrE
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 18. Oktober 2010 Richard Ems wrote:
> I ran several times xfs_fsr, but the 21.73% factor stays there.

Possibly you have some very big files which cannot be defraged? What=20
output does xfs_fsr -v give?


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

--nextPart1776597.uKTemXtyrE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky8QBQACgkQzhSR9xwSCbQSHgCcCp+2B2t8GFDOzsfyOfkaokVP
nNIAn3ZstMtMtA5WDeSL1bapneJtROpw
=gMsH
-----END PGP SIGNATURE-----

--nextPart1776597.uKTemXtyrE--


--===============8175593656374386354==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8175593656374386354==--
