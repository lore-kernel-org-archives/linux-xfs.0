Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nALApID6018062 for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 04:51:18 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E20F2A2830
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 02:51:40 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id FGAAHREXB0AXsjds for
	<xfs@oss.sgi.com>; Sat, 21 Nov 2009 02:51:40 -0800 (PST)
Received: from mailsrv.i.zmi.at (unknown [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id B482EC00AC3
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 11:51:39 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 8C9F983C824
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 11:53:20 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: BUG() in end_page_writeback(),
	stack overflows and system speed decrease with XFS over USB
Date: Sat, 21 Nov 2009 11:51:23 +0100
References: <200911190957.45957.JuergenUrban@gmx.de>
	<4B06CCFC.8030309@sandeen.net>
	<200911210200.13438.JuergenUrban@gmx.de>
In-Reply-To: <200911210200.13438.JuergenUrban@gmx.de>
MIME-Version: 1.0
Message-Id: <200911211151.23764@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0517383177723290457=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0517383177723290457==
Content-Type: multipart/signed;
  boundary="nextPart4190082.9rOAfKQ9OJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4190082.9rOAfKQ9OJ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 21. November 2009 Juergen Urban wrote:
> To get the error I just need to play video with mplayer and don't=20
> need to write to the file system at all.

This really sounds like a broken hardware. Have you tried running=20
MEMTEST?

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart4190082.9rOAfKQ9OJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksHxisACgkQzhSR9xwSCbQaMwCgtW8Pd0KEqN9XDXPLI02yHPuO
yUgAn12onwYLtOp0nQltSiHFkzWER3hU
=Xxeu
-----END PGP SIGNATURE-----

--nextPart4190082.9rOAfKQ9OJ--


--===============0517383177723290457==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0517383177723290457==--
