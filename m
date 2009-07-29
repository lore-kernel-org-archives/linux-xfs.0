Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6TIph9u007374 for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 13:51:43 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D72614202D0
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 11:52:29 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id UuvNV7r8O3FrWDai for
	<xfs@oss.sgi.com>; Wed, 29 Jul 2009 11:52:29 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 0F7205543
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 20:52:45 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 7A3D940016D
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 20:52:27 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [xfs crash] Kernel BUG at /fs/xfs/support/debug.c:57
Date: Wed, 29 Jul 2009 20:52:26 +0200
References: <200907271657.55226.Christian.Fischer@easterngraphics.com>
	<4A705160.7040709@sandeen.net>
	<200907291659.41314.Christian.Fischer@easterngraphics.com>
In-Reply-To: <200907291659.41314.Christian.Fischer@easterngraphics.com>
MIME-Version: 1.0
Message-Id: <200907292052.27008@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7005562908025327960=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7005562908025327960==
Content-Type: multipart/signed;
  boundary="nextPart6704500.zg6SogyYyq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6704500.zg6SogyYyq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 29 Juli 2009 Christian Fischer wrote:
> 2.6.18 is the official xen kernel for now.

Yes, that's a pity. We also use XenServer, even in the actual version=20
5.5 the kernel is still 2.6.18. And that's why they only use ext3, I=20
guess.

I really hope for the Xen Server patches to arrive in standard kernels=20
once [ASAP], but the merge is always pushed back... lwn.net has good=20
articles about that.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart6704500.zg6SogyYyq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpwmmsACgkQzhSR9xwSCbTaJQCeNhbsQ605EK5Uz8rF1+BvWrfZ
3hQAoLbWfxYCEWKQ+/c+beidGr1aKpCQ
=Q9I5
-----END PGP SIGNATURE-----

--nextPart6704500.zg6SogyYyq--


--===============7005562908025327960==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7005562908025327960==--
