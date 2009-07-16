Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6GAuQrK009422
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jul 2009 05:56:27 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 804F5139BE95
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jul 2009 03:57:05 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id DBGXXUSsAgQfFu5N for
	<linux-xfs@oss.sgi.com>; Thu, 16 Jul 2009 03:57:05 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id C973353F0
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jul 2009 12:57:47 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id E9DD3400154
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jul 2009 12:57:03 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: LWN article: A new way to truncate() files
Date: Thu, 16 Jul 2009 12:56:58 +0200
MIME-Version: 1.0
Message-Id: <200907161257.03539@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2557092943771171598=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

--===============2557092943771171598==
Content-Type: multipart/signed;
  boundary="nextPart2305894.SI8GXBnYSp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2305894.SI8GXBnYSp
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm pretty sure the core hackers are on linux-kernel, but for the rest=20
of us LWN provided a good article explaining development, in this case=20
it reaches into XFS that's why I post it here:

http://lwn.net/SubscriberLink/341352/21ab5a5c7158ea80/

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2305894.SI8GXBnYSp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpfB38ACgkQzhSR9xwSCbSIEwCgzL+gAzJTap7szUfdez4tqAfj
UO8AoL0WyykgmLYJzMfXqeOmPCo/IfCQ
=FuUX
-----END PGP SIGNATURE-----

--nextPart2305894.SI8GXBnYSp--


--===============2557092943771171598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2557092943771171598==--
