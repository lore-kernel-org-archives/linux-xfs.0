Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14FQMH8159273 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 09:26:22 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9816018C252D
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 07:25:43 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id wyaK9ifUWuwblzAX for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 07:25:43 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 932213D51
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 16:25:42 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 67195400171
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 16:25:42 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Wed, 4 Feb 2009 16:25:41 +0100
References: <498376CF.8020806@renderforce.de> <20090204140113.GP11617@kyra>
	<20090204161559.347679f7@harpe.intellique.com>
In-Reply-To: <20090204161559.347679f7@harpe.intellique.com>
MIME-Version: 1.0
Message-Id: <200902041625.42174@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7623500159517656466=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7623500159517656466==
Content-Type: multipart/signed;
  boundary="nextPart2294972.TRfJqUbHsh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2294972.TRfJqUbHsh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 04 Februar 2009 Emmanuel Florac wrote:

[This talk is about which controllers allow individual disk write cache=20
to be turned off]
> 3Ware : no
> Xyratex : no
> Adaptec : yes
> LSI : yes
> Areca : possibly...

correcting:
Areca: yes

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2294972.TRfJqUbHsh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmJs3YACgkQzhSR9xwSCbR/FgCg9zdCkkNmGS61f3sYGWQuKcUP
+SQAoMzmTNnsaIvg2U+e2aDt0bbdlnPQ
=hKuD
-----END PGP SIGNATURE-----

--nextPart2294972.TRfJqUbHsh--


--===============7623500159517656466==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7623500159517656466==--
