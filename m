Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT8bOIH132651 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 02:37:24 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A6301B0339
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 00:39:03 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id cWW5GnB2F5xUH4Sw for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 00:39:03 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS: performance
Date: Mon, 29 Nov 2010 09:38:55 +0100
References: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>
	<AANLkTikw086Z_66cz_U-EdFQx14TXP6XmiG-KyLN4BLo@mail.gmail.com>
	<AANLkTi=-y0v4MzyU+qWPmvazouDu0N3gqSvVTU1z4Gke@mail.gmail.com>
In-Reply-To: <AANLkTi=-y0v4MzyU+qWPmvazouDu0N3gqSvVTU1z4Gke@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201011290939.00248@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3785346923102446002=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Yclept Nemo <orbisvicis@gmail.com>

--===============3785346923102446002==
Content-Type: multipart/signed;
  boundary="nextPart1385557.7WaNLa23WL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1385557.7WaNLa23WL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Montag, 29. November 2010 Yclept Nemo wrote:
>   -If not, are there any reasons to nonetheless prefer
> xfsdump/xfsrestore over rsync?

Just do an rsync. As this copies data new, XFS can arrange them in order=20
anyway. No need for special tools.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1385557.7WaNLa23WL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzzZqQACgkQzhSR9xwSCbRibQCgweWUhI3lEf6e/WzwwjTs/zg7
siIAoLapiopr2KqO9y4ihtEfaUGxEg8X
=yjH+
-----END PGP SIGNATURE-----

--nextPart1385557.7WaNLa23WL--


--===============3785346923102446002==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3785346923102446002==--
