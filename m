Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4L7ivDN075423 for <xfs@oss.sgi.com>; Mon, 21 May 2012 02:44:58 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id av5aEu4ekbecwuuz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 May 2012 00:44:54 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106014.dyn.cm.kabsi.at [81.217.106.14])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id ADC15182242E
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 09:44:51 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id 29250CD7C8C
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 09:45:30 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: How to recover data from an xfs partition
Date: Mon, 21 May 2012 09:44:44 +0200
Message-ID: <2867697.yP7s3MR3RI@saturn>
In-Reply-To: <4FB6B7AB.8030405@linuxsystems.it>
References: <4FAE9DBF.1090505@linuxsystems.it> <4FB68AF6.1090303@sandeen.net>
	<4FB6B7AB.8030405@linuxsystems.it>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0793615804806394363=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0793615804806394363==
Content-Type: multipart/signed; boundary="nextPart2178272.M5aujiIMs3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart2178272.M5aujiIMs3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 18. Mai 2012, 22:57:15 schrieb Niccol=C3=B2 Belli:
> I had to use magic sysrq=20
> keys (remount read-only, sync, reboot).

Shouldn't that be sync, remount r/o, reboot instead? If you remount r/o=
,=20
the cache in the system wouldn't be written anymore.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart2178272.M5aujiIMs3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+58nIACgkQzhSR9xwSCbS75gCgr4dwrqQUuYb2Zqt/JobTU7Kd
2IUAnRWKp3sn2RonuQNtOmbz1soTf3hP
=KfWC
-----END PGP SIGNATURE-----

--nextPart2178272.M5aujiIMs3--


--===============0793615804806394363==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0793615804806394363==--
