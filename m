Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PBofYu227376 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:50:41 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 805C5121849
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 04:51:55 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id GUAON8wRGEQvlf2j for
	<xfs@oss.sgi.com>; Mon, 25 Oct 2010 04:51:55 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id D269B17B
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 13:51:54 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id B8AD1401C3E
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 13:51:53 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS Test Results Interpretation
Date: Mon, 25 Oct 2010 13:51:53 +0200
References: <3C5E029826A0704DB5998577FCFF46F0095A278CEB@dagobah>
In-Reply-To: <3C5E029826A0704DB5998577FCFF46F0095A278CEB@dagobah>
MIME-Version: 1.0
Message-Id: <201010251351.53704@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5149828254857995603=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5149828254857995603==
Content-Type: multipart/signed;
  boundary="nextPart1336447.mzGyLK93En";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1336447.mzGyLK93En
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 25. Oktober 2010 Andrew Debenham wrote:
> Any information or recommendations you can provide would be greatly
> appreciated

http://xfs.org/index.php/XFS_FAQ
See about barriers, disk write cache, sunit/swidth parameters, and=20
everything with "performance". That should cover most of your questions.

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

--nextPart1336447.mzGyLK93En
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzFb1kACgkQzhSR9xwSCbTtNACg0VPzANVPo/QvqCba0OAHbrfn
nuIAoORYsMAOGYRgVsY3vu+uicGogD9M
=VNCr
-----END PGP SIGNATURE-----

--nextPart1336447.mzGyLK93En--


--===============5149828254857995603==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5149828254857995603==--
