Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95F387F3F
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 10:24:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6BAAD8F8035
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 08:24:32 -0700 (PDT)
Received: from picconi.debian.org (picconi.debian.org [5.153.231.3]) by
	cuda.sgi.com with ESMTP id Uy51SMVNlK4I14uR (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Jun 2014 08:24:30 -0700 (PDT)
Received: from mail-we0-x22f.google.com ([2a00:1450:400c:c03::22f])
	by picconi.debian.org with esmtps (TLS1.0:RSA_ARCFOUR_SHA1:128)
	(Exim 4.80) (envelope-from <andreimpopescu@gmail.com>)
	id 1WvTL5-0001dg-9Q
	for xfslibs-dev@packages.debian.org; Fri, 13 Jun 2014 15:24:29 +0000
Received: by mail-we0-f175.google.com with SMTP id k48so2188689wev.6
	for <xfslibs-dev@packages.debian.org>;
	Fri, 13 Jun 2014 08:24:17 -0700 (PDT)
Date: Fri, 13 Jun 2014 18:24:14 +0300
From: Andrei POPESCU <andreimpopescu@gmail.com>
Subject: Re: Bug#751511: xfslibs-dev: Incorrect licensing information in
	debian/copyright
Message-ID: <20140613152414.GF2840@sid.nuvreauspam>
References: <20140613142534.8854.10300.reportbug@sibsagar.btc.netapp.com>
MIME-Version: 1.0
In-Reply-To: <20140613142534.8854.10300.reportbug@sibsagar.btc.netapp.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4521904380674678427=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Y Giridhar Appaji Nag <appaji@debian.org>, 751511@bugs.debian.org
Cc: xfslibs-dev@packages.debian.org


--===============4521904380674678427==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KJY2Ze80yH5MUxol"
Content-Disposition: inline


--KJY2Ze80yH5MUxol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Control: reassign -1 xfslibs-dev

On Vi, 13 iun 14, 19:55:34, Y Giridhar Appaji Nag wrote:
> Source: xfslibs-dev
> Severity: serious
> Justification: Policy 4.5
>=20
> It looks like the xfslibs-dev package source files are licensed under LGPL
> v2.1, however the debian/copyright file indicates that only the libhandle
> package is under LGPL and that the rest of the package is licensed under =
GPL.
>=20
> Giridhar
>=20
> -- System Information:
> Debian Release: jessie/sid
>   APT prefers testing-updates
>   APT policy: (500, 'testing-updates'), (500, 'testing')
> Architecture: amd64 (x86_64)
>=20
> Kernel: Linux 3.13-1-amd64 (SMP w/2 CPU cores)
> Locale: LANG=3Den_IN, LC_CTYPE=3Den_IN (charmap=3DUTF-8)
> Shell: /bin/sh linked to /bin/dash
>=20

--=20
http://wiki.debian.org/FAQsFromDebianUser
Offtopic discussions among Debian users and developers:
http://lists.alioth.debian.org/mailman/listinfo/d-community-offtopic
http://nuvreauspam.ro/gpg-transition.txt

--KJY2Ze80yH5MUxol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJTmxeeAAoJEP/HhUTvIjQcv6cQAIVvnh272Yr6opa8k2zam+3K
tzb/t867AvW5gw9rlZ5D57wpkkTzrvtexGn1HAiE+AJDXvdAypQ6wHBw/zE9sA66
cx/LnyGW47sHqYKZ5PoL5i9wOrLmAx4AveIFGuMJKMKTEq0MgeNncbiZx1yX0+4J
gp/A51GCHJT+mcELP5FDrgvYsDUOnljkBG750jkuU56SysfLMWjypSnJgZpYOXOV
FLsWHH4vrF5nkOEcgvtQRBIehRjUuuMed6SHf61OAJ6I09eP74e9f27ziTV7nxoX
lzM1OLPhmTKrU9pcmHgjvagobGgTcj3rHTdkWWy4iHSlyc2mQQjfOyDhElcPHPp9
rcfJiU6x8r/4qhQxZKsD1Qm7NF/I3p/i2/8Nh571dK6oTyLhZ0ya3ois2cByQZsf
TCW3K5fDA8ovtgUHere7Q9OTfShJugY3RHagVWT9ewO+0IomHt4j78VZ1wSTHFOY
alYeIw9lNF+swf7cuq6kbhoSwe7HheZeix9R0zNVWRPiK7NOsPTpxaLKAg7NAdAE
QYKV9XOw12GLiQ+DoCfff+Empa7mkPyc0AFe+42vBSbRKt/K6aAXrHe5InDEi+uu
9ndcz2oHHOiYZAhRGAryfy54ZqfDLqqQTY8rNPaVsRuHAjGjdYwhx5r6/I+eEvwJ
y+wgli186CIALRpPhdBx
=dUOr
-----END PGP SIGNATURE-----

--KJY2Ze80yH5MUxol--


--===============4521904380674678427==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4521904380674678427==--
