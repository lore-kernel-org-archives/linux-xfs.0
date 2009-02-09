Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n198f21G234899 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 02:41:02 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47E6BFD288
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 00:40:24 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id dMqO4BCc1Uhe9Zq4 for
	<xfs@oss.sgi.com>; Mon, 09 Feb 2009 00:40:24 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 72F313E70
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 09:40:23 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id EB75E400160
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 09:40:23 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Date: Mon, 9 Feb 2009 09:40:23 +0100
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208221625.GB8830@disturbed>
	<1234135463.12370.47.camel@champagne.cantina>
In-Reply-To: <1234135463.12370.47.camel@champagne.cantina>
MIME-Version: 1.0
Message-Id: <200902090940.23561@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8112734255919553977=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8112734255919553977==
Content-Type: multipart/signed;
  boundary="nextPart1498478.VM3jkeMBfU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1498478.VM3jkeMBfU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Montag 09 Februar 2009 Alessandro Bono wrote:
> If needed I can replace memory dimm, this is my principal notebook
> and I need it to work

Go download an openSUSE 11.1 DVD from opensuse.org, boot from that DVD=20
and select "memory test" and let it run several hours. Of course you=20
could also get a copy of "memtest86" somewhere, but that DVD thingy=20
might be simpler.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1498478.VM3jkeMBfU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmP6/cACgkQzhSR9xwSCbSy/ACgm72adEuRD1jESqHW6ysEcZGg
7TYAoKf/FFpRQfAssvBQA0bynKB6us8y
=9BEY
-----END PGP SIGNATURE-----

--nextPart1498478.VM3jkeMBfU--


--===============8112734255919553977==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8112734255919553977==--
