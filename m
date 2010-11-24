Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO6Gl7m070581 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 00:16:47 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC0231C6CF9A
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 22:18:22 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id vBrpAuTCdeJKhRVC for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 22:18:22 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 30A24400
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 07:18:21 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 38359401C3A
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 07:18:20 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Xfs delaylog hanged up
Date: Wed, 24 Nov 2010 07:18:19 +0100
References: <4CEAC412.9000406@shiftmail.org>
	<20101123234811.0ea3c41c@galadriel.home>
	<4CEC5E15.7080307@shiftmail.org>
In-Reply-To: <4CEC5E15.7080307@shiftmail.org>
MIME-Version: 1.0
Message-Id: <201011240718.19849@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7725974725873108283=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7725974725873108283==
Content-Type: multipart/signed;
  boundary="nextPart10687476.L6XcIqtAqJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart10687476.L6XcIqtAqJ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 24. November 2010 Spelic wrote:
> What would be the advantage of using hardware raid?

Better broken drive detection (hw raid controllers are more picky than=20
linux), server CPU offload, out-of-band notification of problems, and=20
broken disks don't lead to a non-bootable system - what if your boot=20
disk crashes?

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

--nextPart10687476.L6XcIqtAqJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzsrisACgkQzhSR9xwSCbSRfACeP4Uhbmwllu5A4wSInRbsNG1x
KUsAoPJlmp0rig2DzGp8hlTlM5AlPed+
=WkfJ
-----END PGP SIGNATURE-----

--nextPart10687476.L6XcIqtAqJ--


--===============7725974725873108283==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7725974725873108283==--
