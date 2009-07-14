Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6E655DX093635 for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 01:05:06 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E58D13659DD
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 23:05:43 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id lqw5jjwwEtZJlXbS for
	<xfs@oss.sgi.com>; Mon, 13 Jul 2009 23:05:43 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id C9F195380
	for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 08:06:29 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 1D3F4400154
	for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 08:05:42 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] xfs_repair - do not attempt to set shortform attr header
	when clearing
Date: Tue, 14 Jul 2009 08:05:35 +0200
References: <200907031320.48358@zmi.at> <4A5C0606.4030102@sandeen.net>
In-Reply-To: <4A5C0606.4030102@sandeen.net>
MIME-Version: 1.0
Message-Id: <200907140805.40854@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5489020220715345788=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5489020220715345788==
Content-Type: multipart/signed;
  boundary="nextPart1550117.u71uDh1I6J";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1550117.u71uDh1I6J
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Dienstag 14 Juli 2009 Eric Sandeen wrote:
> Whew.

It's people like you I'm afraid of ;-) Is there still blood in your=20
vains or was it replaced with silicone once?

To ask in a simple way: Will this version fix the problem on my disk? If=20
yes, where could I download it? (git ..?)

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1550117.u71uDh1I6J
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpcIDQACgkQzhSR9xwSCbQSgACfQEivU6R7aEMszohMpSPnWiva
niwAoKkqGhwEnRjYRmy/YvjXvJi1KdIc
=SoMX
-----END PGP SIGNATURE-----

--nextPart1550117.u71uDh1I6J--


--===============5489020220715345788==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5489020220715345788==--
