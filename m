Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q76BgI9V121978 for <xfs@oss.sgi.com>; Mon, 6 Aug 2012 06:42:19 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id cXNhIRL9Ad4JfOGK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Aug 2012 04:42:15 -0700 (PDT)
Received: from mailsrv.i.zmi.at (mailgate.i.zmi.at [10.72.17.3])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPS id BBA49182242B
	for <xfs@oss.sgi.com>; Mon,  6 Aug 2012 13:42:13 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id 26DEDC8C449
	for <xfs@oss.sgi.com>; Mon,  6 Aug 2012 13:42:21 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_growfs / planned resize / performance impact
Date: Mon, 06 Aug 2012 13:42:09 +0200
Message-ID: <1862116.UCdvhtskSU@saturn>
In-Reply-To: <501E9734.8020905@profihost.ag>
References: <5017E426.2040709@profihost.ag>
	<201208051303.09337.Martin@lichtvoll.de>
	<501E9734.8020905@profihost.ag>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0607381690762266191=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0607381690762266191==
Content-Type: multipart/signed; boundary="nextPart3897121.DipcIJHeJD"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart3897121.DipcIJHeJD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Sonntag, 5. August 2012, 17:54:28 schrieb Stefan Priebe:
> I do not use thin provisioning as dm thin is not production ready
> isn't it?

So you're using Linux as virtualization host? Because with VMware your=20=

argument would be wrong.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart3897121.DipcIJHeJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAfrZUACgkQzhSR9xwSCbQjpACfXG24+hTy4SOUFbhtdgU5+kZd
BNUAn2eQFFrq7qupD2eDcFqrbpiN3Hd1
=Zd+H
-----END PGP SIGNATURE-----

--nextPart3897121.DipcIJHeJD--


--===============0607381690762266191==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0607381690762266191==--
