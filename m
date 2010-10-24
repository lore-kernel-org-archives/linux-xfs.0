Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9OIQn18147497 for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 13:26:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 080CAF5D217
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 11:43:25 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id FIH9KBV3zNx7AzPw for
	<xfs@oss.sgi.com>; Sun, 24 Oct 2010 11:43:25 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 6131442B
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 20:28:01 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 63105401C3E
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 20:28:00 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Best filesystems ?
Date: Sun, 24 Oct 2010 20:27:59 +0200
References: <4CBE2403.8070108@hardwarefreak.com>
	<Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
	<19651.9652.631329.903552@tree.ty.sabi.co.uk>
In-Reply-To: <19651.9652.631329.903552@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Message-Id: <201010242028.00106@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3359793112558971107=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3359793112558971107==
Content-Type: multipart/signed;
  boundary="nextPart3718428.blGH6C1jkH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3718428.blGH6C1jkH
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 23. Oktober 2010 Peter Grandi wrote:
> * Reiser3 is nice with the right parameters for the few cases
>   where there is a significant number of small files on a small
>   storage system accessed by a single process.

I still use reiser3 for all servers root filesystems, it's very good for=20
that. Never had a problem.=20

=46or anything else I use XFS for performance reasons. Except for my KDE=20
/home partition, that stays on reiserfs because KDE seems to rely on=20
O_PONIES and crashes lead to zero size config files which is not a lot=20
of fun.

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

--nextPart3718428.blGH6C1jkH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzEerAACgkQzhSR9xwSCbRANwCgsenGzp5Dq4qmeNrBvTf07Ka8
ylwAniimwPyoWT6P59EidRUBXcaT4TZo
=t/gq
-----END PGP SIGNATURE-----

--nextPart3718428.blGH6C1jkH--


--===============3359793112558971107==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3359793112558971107==--
