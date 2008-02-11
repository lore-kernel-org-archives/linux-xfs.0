Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Feb 2008 22:35:37 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1B6ZEJE003813
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2008 22:35:15 -0800
Received: from amanpulo.fs3.ph (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B97AD5BF5CE
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2008 22:35:38 -0800 (PST)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [202.81.162.101]) by cuda.sgi.com with ESMTP id I3AagPgudgHJ6nc6 for <xfs@oss.sgi.com>; Sun, 10 Feb 2008 22:35:38 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 2056B2806A350
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 14:35:36 +0800 (PHT)
Received: from amanpulo.fs3.ph ([127.0.0.1])
	by localhost (amanpulo.fs3.ph [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Ne6o6Ci3saH2 for <xfs@oss.sgi.com>;
	Mon, 11 Feb 2008 14:35:27 +0800 (PHT)
Received: from humanitas.leathercollection.ph (gusi.leathercollection.ph [202.163.192.10])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by amanpulo.fs3.ph (Postfix) with ESMTP id 1247328056706
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 14:35:26 +0800 (PHT)
Subject: Re: [PATCH] Possible fix for 2.6.24 xfs_file_readdir crash
From: Federico Sevilla III <jijo@fs3.ph>
In-Reply-To: <20080211001727.GO155407@sgi.com>
References: <20080205052418.GU155259@sgi.com>
	 <20080209120423.GA6699@diesel.geggus.net> <20080211001727.GO155407@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B4Z5fp3dsNBz1w9ttDd3"
Date: Mon, 11 Feb 2008 14:35:25 +0800
Message-Id: <1202711725.4679.7.camel@humanitas.fs3.ph>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-B4Z5fp3dsNBz1w9ttDd3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-02-11 at 11:17 +1100, David Chinner wrote:
> > Can we reckon that this patch will get included in one of the next
> > minor releases?
>=20
> Already queued for 2.6.24.2.

2.6.24.2 has been released to address the vmsplice issue. Unfortunately,
no other changes seem to have been included. Hopefully, the
xfs_file_readdir patch will make it to 2.6.24.3.

--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-B4Z5fp3dsNBz1w9ttDd3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHr+yt5rCBSJO3Rr4RAm7bAJ9NzYTg3e+DXaELNycXe0ggWIJ8BgCfQfUR
D79B18ayHjZqGh2BbgNE5WU=
=QVh1
-----END PGP SIGNATURE-----

--=-B4Z5fp3dsNBz1w9ttDd3--
