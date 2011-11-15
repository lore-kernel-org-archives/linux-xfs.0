Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFBSeUp044537 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 05:28:40 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 219588CA645
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 03:28:38 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id wzbAkOkjvwUcqSBh for
	<xfs@oss.sgi.com>; Tue, 15 Nov 2011 03:28:38 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 3CF1D1828D91
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 12:28:36 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 4EB51E18C15
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 12:28:39 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair believes filesystem is mounted
Date: Tue, 15 Nov 2011 12:28:34 +0100
References: <201111151113.52228@zmi.at>
In-Reply-To: <201111151113.52228@zmi.at>
MIME-Version: 1.0
Message-Id: <201111151228.35360@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6191491843044477296=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6191491843044477296==
Content-Type: multipart/signed;
  boundary="nextPart1409587.T7zkh2aZQY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1409587.T7zkh2aZQY
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 15. November 2011 Michael Monnerie wrote:
> xfs_repair: /dev/xvdc1 contains a mounted and writable filesystem

Ha, got it: Got a bind mount on that fs. Sorry for the noise.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1409587.T7zkh2aZQY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk7CTOMACgkQzhSR9xwSCbRFjwCgrUwVvWISSY95EWZrD7pH6VIt
BsYAn3dtf1WxYukBAHsnKIpPKGHsUsev
=j8/T
-----END PGP SIGNATURE-----

--nextPart1409587.T7zkh2aZQY--


--===============6191491843044477296==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6191491843044477296==--
