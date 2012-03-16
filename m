Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2GBA9we046797 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 06:10:09 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id pGtv9eUJbS4b0Efx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Mar 2012 04:10:07 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs on 13 TB Storage
Date: Fri, 16 Mar 2012 12:10:05 +0100
Message-ID: <4102777.3DKsSuy5JZ@saturn>
In-Reply-To: <20120316083401.37063vtvgebrbyzt@webmail.tuwien.ac.at>
References: <20120316083401.37063vtvgebrbyzt@webmail.tuwien.ac.at>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6844091700804797519=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Michael Weingartner <michael.weingartner@tuwien.ac.at>


--===============6844091700804797519==
Content-Type: multipart/signed; boundary="nextPart8597513.BWh4CQzYKO"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart8597513.BWh4CQzYKO
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 16. M=C3=A4rz 2012, 08:34:01 schrieb Michael Weingartner:
> Filesystem "cciss/c0d0p1":XFS internal error xfs_trans_cancel at
> line   1731 of file
> /build/buildd/linx-lts-backport-maverick-2.6.35/fs/xfs/xfs_trans.c =20=

> Caller 0xf917d8b8

Did you try xfs_repair -n? Maybe this tells you what's going on.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart8597513.BWh4CQzYKO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk9jH40ACgkQzhSR9xwSCbQFhgCgy8bXgvug0VGGKCKEbm4AOEt/
aRIAoK5uu7/wB4mXRtkrpSzaiuxVKIDk
=CsIk
-----END PGP SIGNATURE-----

--nextPart8597513.BWh4CQzYKO--


--===============6844091700804797519==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6844091700804797519==--
