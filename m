Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6CH1wwK253734 for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 12:01:59 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DD6F130A5C1
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 10:09:55 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id gKNerVbtqgtq3B0y for
	<xfs@oss.sgi.com>; Sun, 12 Jul 2009 10:09:55 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 315F651A9
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 19:03:23 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 11C21400163
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 19:02:33 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: bad fs - xfs_repair 3.01 crashes on it
Date: Sun, 12 Jul 2009 19:02:28 +0200
References: <200907031320.48358@zmi.at> <4A4EEBE6.6060909@sandeen.net>
In-Reply-To: <4A4EEBE6.6060909@sandeen.net>
MIME-Version: 1.0
Message-Id: <200907121902.32599@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0206546897633130829=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0206546897633130829==
Content-Type: multipart/signed;
  boundary="nextPart1339834.XHtPjja0fY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1339834.XHtPjja0fY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 04 Juli 2009 Eric Sandeen wrote:
> Where's Barry when you need him ....

Who's that?

> Also I need to look at when the ASSERTs are active and when they
> should be; the Fedora packaged xfsprogs doesn't have the ASSERT
> active, and so this doesn't trip. =A0After 2 calls to xfs_repair on
> Fedora, w/o the ASSERTs active, it checks clean on the 3rd (!). =A0Not
> great. =A0Not sure how much was cleared out in the process either...

Any ideas/news on this? I'd like to xfs_repair that stuff. It seems to=20
only hit one file, but I don't dare delete it, maybe it makes things=20
worse?

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1339834.XHtPjja0fY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpaFygACgkQzhSR9xwSCbQRvACfaRRccmXKKdFnHPzspRRxwWXP
WKkAoNH+CrfMgMT9e/0N27B5UJhuA+IA
=uwsS
-----END PGP SIGNATURE-----

--nextPart1339834.XHtPjja0fY--


--===============0206546897633130829==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0206546897633130829==--
