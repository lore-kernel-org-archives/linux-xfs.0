Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Sep 2006 02:05:44 -0700 (PDT)
Received: from ipmail01.adl2.internode.on.net (ipmail01.adl2.internode.on.net [203.16.214.140])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8695QDW028542
	for <xfs@oss.sgi.com>; Wed, 6 Sep 2006 02:05:27 -0700
Subject: Re: review: propogate return codes from flush routines
From: Stewart Smith <stewart@flamingspork.com>
In-Reply-To: <44FD476C.3080009@sgi.com>
References: <44FC0D0F.60403@sgi.com>
	 <1157442848.5844.38.camel@localhost.localdomain> <44FD476C.3080009@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gPawd9S+B0i9EHYg4K07"
Date: Wed, 06 Sep 2006 19:04:41 +1000
Message-Id: <1157533481.12018.33.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs@oss.sgi.com

--=-gPawd9S+B0i9EHYg4K07
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-09-05 at 10:46 +0100, Lachlan McIlroy wrote:=20
> What's a really catastrophic error?

I think I've just spent too much time with HA database clusters... good
temporary errors "out of resource", okay temp errors "node failed" or
"lost connection", bad errors "cluster failure", catastrophic "and your
data is gone too and backups haven't been working". :)

I sometimes forget that the rest of the world can just have "errors".
--=20
Stewart Smith (stewart@flamingspork.com)
http://www.flamingspork.com/


--=-gPawd9S+B0i9EHYg4K07
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBE/o8pKglWCUL+FDoRAombAJ0fA7xS8OwxEHxDuvSOqKN94eVLHACeNmbb
iXqYChHx+J7Pv7WAh0b3Xwg=
=cwTV
-----END PGP SIGNATURE-----

--=-gPawd9S+B0i9EHYg4K07--
