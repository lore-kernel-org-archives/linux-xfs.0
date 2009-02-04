Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14G2FOI160571 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 10:02:16 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAE8518C1C61
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 08:01:36 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id Yi0G97jFfd1ok8Ff for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 08:01:36 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 3F78B3D50
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 17:01:04 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 0EE29400171
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 17:01:04 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Wed, 4 Feb 2009 17:01:03 +0100
References: <498376CF.8020806@renderforce.de>
	<20090204161559.347679f7@harpe.intellique.com>
	<20090204154153.GQ11617@kyra>
In-Reply-To: <20090204154153.GQ11617@kyra>
MIME-Version: 1.0
Message-Id: <200902041701.03803@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0450468959975581930=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0450468959975581930==
Content-Type: multipart/signed;
  boundary="nextPart2970246.aGHt098iLf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2970246.aGHt098iLf
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 04 Februar 2009 KELEMEN Peter wrote:
> I assume this means you can only set the drive caches and the unit
> caches together.

Should I write an overview as we had it here on the list into the wiki?=20
Could be a quick guide and therefore good I guess.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2970246.aGHt098iLf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmJu78ACgkQzhSR9xwSCbTfagCg2ns7TK8B/h9OGip0uK4hebxW
7MwAoIJL898ADq8KYFhNUtvkdxpP1D5P
=G801
-----END PGP SIGNATURE-----

--nextPart2970246.aGHt098iLf--


--===============0450468959975581930==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0450468959975581930==--
