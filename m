Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBK8vwp9099673 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 02:57:58 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBBA0146A23A
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 00:59:51 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id gmmxLlvOMstYjzhd for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 00:59:51 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Problem with XFS on USB 2TB HD
Date: Mon, 20 Dec 2010 09:59:44 +0100
References: <4D0C9A4F.4040108@pzystorm.de>
In-Reply-To: <4D0C9A4F.4040108@pzystorm.de>
MIME-Version: 1.0
Message-Id: <201012200959.48877@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0511512861052096674=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, xfs@pzystorm.de

--===============0511512861052096674==
Content-Type: multipart/signed;
  boundary="nextPart2195009.57HsRr3vnz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2195009.57HsRr3vnz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Samstag, 18. Dezember 2010 Kevin Richter wrote:
> I have 2.9.8 (http://packages.debian.org/lenny/xfsprogs)

Actual is 3.1.x, which has a *lot* of enhancements especially for speed=20
and memory consumption, and also fixes some additional errors which the=20
older versions couldn't repair.

You've fixed your problem now, but it's really good to get xfs_repair=20
updated.

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

--nextPart2195009.57HsRr3vnz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0PGwQACgkQzhSR9xwSCbTZhwCghfauhayWRIQdrK9TXH1VdO5N
9QkAoNzAqhr2b5xFN4aT+nY4XqiT3QsG
=mz41
-----END PGP SIGNATURE-----

--nextPart2195009.57HsRr3vnz--


--===============0511512861052096674==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0511512861052096674==--
