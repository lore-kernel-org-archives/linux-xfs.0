Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9BCUsh150703 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 05:12:31 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5682F4CDC54
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 03:13:55 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id AW950GPOSd1JwCkG for
	<xfs@oss.sgi.com>; Tue, 09 Nov 2010 03:13:55 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: vmap allocation for size 1048576 failed
Date: Tue, 9 Nov 2010 12:13:51 +0100
References: <4CD924A6.6040200@dermichi.com>
In-Reply-To: <4CD924A6.6040200@dermichi.com>
MIME-Version: 1.0
Message-Id: <201011091213.52728@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5058236466226120345=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Michael Weissenbacher <mw@dermichi.com>

--===============5058236466226120345==
Content-Type: multipart/signed;
  boundary="nextPart3632146.bthu5YYcuG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3632146.bthu5YYcuG
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 9. November 2010 Michael Weissenbacher wrote:
> * I'm not sure if the problem is 100% related to the kernel upgrade
> because i didn't use a loop XFS on this machine before the kernel
> upgrade.

You should describe the loop setup and all devices down to the disk.=20
Might be easier for the devs to help then.

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

--nextPart3632146.bthu5YYcuG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzZLPAACgkQzhSR9xwSCbSOswCg6PPKtAuQ1feduCLFc45B8OE3
BMUAniOqMOsVYM00wDewHnRSewqw1dSx
=oCpz
-----END PGP SIGNATURE-----

--nextPart3632146.bthu5YYcuG--


--===============5058236466226120345==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5058236466226120345==--
