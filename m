Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF56D7CA0
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 05:01:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD6C78F8039
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 03:01:32 -0800 (PST)
Received: from smtp.movistar.es (smtp11.acens.net [86.109.99.135]) by
	cuda.sgi.com with ESMTP id HvH0NZZgTBTqVZ1g for
	<xfs@oss.sgi.com>; Wed, 09 Mar 2016 03:01:28 -0800 (PST)
Received: from Telcontar.valinor (88.1.245.4) by smtp.movistar.es (8.6.122.03)
	(authenticated as robin.listas2)
	id 56BC428E021F4D19 for xfs@oss.sgi.com; Wed, 9 Mar 2016 11:01:43 +0000
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id BE48260B8B
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 12:01:27 +0100 (CET)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id oiPins9LMFUf for <xfs@oss.sgi.com>;
	Wed,  9 Mar 2016 12:01:27 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 979D860484
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 12:01:27 +0100 (CET)
Subject: Re: an mount option question and dunno if right here...
References: <08297acdf77244b468e15458f3d78327@zbfmail.de>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <56E00287.8020001@telefonica.net>
Date: Wed, 9 Mar 2016 12:01:27 +0100
MIME-Version: 1.0
In-Reply-To: <08297acdf77244b468e15458f3d78327@zbfmail.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2869163118103904571=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mail list <xfs@oss.sgi.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============2869163118103904571==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4A3F1t6TNsPFXvaRpk8M13Alxnj8mwall"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4A3F1t6TNsPFXvaRpk8M13Alxnj8mwall
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2016-03-09 11:35, Marko Weber | 8000 wrote:

> Why is relatime listed? Or is lazytime override this setting?
> Even when i set "norelatime" in /etc/fstab i get "relatime" listed on
> 'mount'

Because you get a number of default options. Probably depends on the
distribution. I know that on openSUSE you get relatime set, for instance.=


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)


--4A3F1t6TNsPFXvaRpk8M13Alxnj8mwall
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlbgAocACgkQtTMYHG2NR9WxnACfXVwchWLTLBzlQroQble+KGeR
BfcAn3YamDgQ5KctjFL7lTYypqbh3JSQ
=xbps
-----END PGP SIGNATURE-----

--4A3F1t6TNsPFXvaRpk8M13Alxnj8mwall--


--===============2869163118103904571==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2869163118103904571==--
