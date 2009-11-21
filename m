Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nALAl4XD017745 for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 04:47:05 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08D221BB5E31
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 02:47:27 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3JdtcJCcacO3FMqU for
	<xfs@oss.sgi.com>; Sat, 21 Nov 2009 02:47:27 -0800 (PST)
Received: from mailsrv.i.zmi.at (unknown [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 5166AC00AC3
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 11:47:25 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 2397783C824
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 11:49:06 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS, NFS and inode64 on 2.6.27
Date: Sat, 21 Nov 2009 11:47:09 +0100
References: <200911201152.43809@zmi.at> <4B0708C5.7000307@houseofnate.net>
In-Reply-To: <4B0708C5.7000307@houseofnate.net>
MIME-Version: 1.0
Message-Id: <200911211147.09368@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2751952240855841603=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2751952240855841603==
Content-Type: multipart/signed;
  boundary="nextPart1423993.oadIMYekuh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1423993.oadIMYekuh
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 20. November 2009 Nathaniel W. Turner wrote:
> Just out of curiosity, is your NFS client also running a 64-bit
>  kernel?

Yep. I've used 64bit since years, as AMD has that since a long time in=20
all their CPUs (there have just been some Semprons 32bit only). And now=20
since every PC has >3GB RAM it's nearly a must.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart1423993.oadIMYekuh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksHxS0ACgkQzhSR9xwSCbTsPACgmhX308ZEI0buR6nYn89WTdO/
XrAAnA1J6DS9MopHriWc6fcaSaikvmJV
=u2qm
-----END PGP SIGNATURE-----

--nextPart1423993.oadIMYekuh--


--===============2751952240855841603==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2751952240855841603==--
