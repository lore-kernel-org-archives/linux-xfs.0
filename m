Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Sep 2006 09:52:09 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8FGpvZd020208
	for <linux-xfs@oss.sgi.com>; Fri, 15 Sep 2006 09:51:58 -0700
Subject: Re: Mounting IRIX disk on Linux
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <45097256.4060601@crc.dk>
References: <45053B2D.50203@crc.dk> <4505712E.5070801@oss.sgi.com>
	 <4506529F.9030109@crc.dk> <4506831A.3000001@sgi.com>
	 <4506D66D.8060206@sandeen.net> <450758E2.30408@sgi.com>
	 <45097256.4060601@crc.dk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3V+vRC0rbAZqcNDsUe5K"
Date: Fri, 15 Sep 2006 11:50:49 -0500
Message-Id: <1158339049.25151.3.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mogens Kjaer <mk@crc.dk>
Cc: linux-xfs@oss.sgi.com

--=-3V+vRC0rbAZqcNDsUe5K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-09-14 at 17:16 +0200, Mogens Kjaer wrote:
> Timothy Shimmin wrote:
> ..
> >                         "file system using version 1 directory format");
>=20
> > Did this not happen, Mogens?
>=20
> No. Nothing in /var/log/messages, and the only thing I
> get on the screen when I mount is "Function not implemented".

BTW older versions xfs did have limited support for v1 directories.
It didn't work in all cases (nfs was a big problem) but it should
would well enough to get your data off.
I would grab an older kernel off the oss ftp site.

>=20
> Mogens
>=20

--=-3V+vRC0rbAZqcNDsUe5K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFCtnpNRmM+OaGhBgRApw7AJ9BIhSCEOs22TqqwhcWLmWYiyrMKACdE5oK
pr9637dc6abb1Pj3te1PtwI=
=mkdu
-----END PGP SIGNATURE-----

--=-3V+vRC0rbAZqcNDsUe5K--
