Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF5E87CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 08:44:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FBF4304062
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 06:44:08 -0700 (PDT)
Received: from mail.somenet.org (mail.somenet.org [213.143.98.34]) by
	cuda.sgi.com with ESMTP id zZIDtal5vHNguFnu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 06:44:01 -0700 (PDT)
Subject: Re: remounting with "errors=remount-ro" in fstab fails.
References: <5746FBD1.8010605@jvales.net> <20160526134257.GA2272@infradead.org>
From: Jan Vales <jan@jvales.net>
Message-ID: <5746FD9A.4020309@jvales.net>
Date: Thu, 26 May 2016 15:43:54 +0200
MIME-Version: 1.0
In-Reply-To: <20160526134257.GA2272@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6042471143775682220=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============6042471143775682220==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rXK7ltT6Dp12ndm65pomOaqJci8KHfgCJ"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rXK7ltT6Dp12ndm65pomOaqJci8KHfgCJ
Content-Type: multipart/mixed; boundary="1hkWTEITB1QN3DuprWv3xvN7hjxWlsdH2"
From: Jan Vales <jan@jvales.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com
Message-ID: <5746FD9A.4020309@jvales.net>
Subject: Re: remounting with "errors=remount-ro" in fstab fails.
References: <5746FBD1.8010605@jvales.net>
 <20160526134257.GA2272@infradead.org>
In-Reply-To: <20160526134257.GA2272@infradead.org>

--1hkWTEITB1QN3DuprWv3xvN7hjxWlsdH2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/26/2016 03:42 PM, Christoph Hellwig wrote:
> The option was never actually supported.  We used to ignore unknown
> options for remount only, I guess that's why it used to work for you.
>=20
> So yes, you can safely remove the option.
>=20
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>=20

ty.

cheers,
Jan Vales
--
I only read plaintext emails.



--1hkWTEITB1QN3DuprWv3xvN7hjxWlsdH2--

--rXK7ltT6Dp12ndm65pomOaqJci8KHfgCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXRv2eAAoJEERD22thjA7qoVUQANF+o8rz9kZO7lvXZ1mstzhh
9iM9vjvvcAeGlMBqFjmt3XOVsUuRBro4YyhPeo2ptZkAhRut3XipDPrNwrWgrKZy
e+X0QHFCNbR/biYGuqVRjbLOE1nqoH/aDdz7b7BAePQC1/i862odMSUCAZXlh70B
cn1hCJbs9sQhZyqnpkdk1DPBRuVShyXSg6LkzuLQ39WuSFbUUXZCudO+xjvGUzEr
swvjFCJjYl2AdKU55aLettMZMmlsjNtR9zpXOpUq39eb6i5KHicsAlbPk6PXwYV0
ZHYzebmk/OVSGcclr4/7k6qb8SpQV8cJtp5cj5a+efbU4Ec62D+fU+GQRuYcwr53
fzp8Dc5FcNQlYm87WRTJZgNaK1r0YfQIjxR+Nhtue7nOcASJO8FYwYbREiDH3hBT
DqwNO75aVt+N0TZRM9izC4MSb494tDlXI5JVfDeY0H9aAmEknxs7xY8MkZf3VriV
Mt7D7hXmgh7F7Ylp9wvJRmrH+EBXrYmggCeLJoRUYziJYVa0WA36vDMp4x3dOq8G
evnS7TIx8haDZRloPRgxds+B4KxOAVo+4ry1/KcD00CmGze8zSfiN+1JqwwWfFOS
BQCjh6Ep/C6hC18F/9TUsLRvwMRS0aolcfoVgPDNjBI7RC2tPOX6KfAYUuEudWdC
0VRqqE1DjW75SSx2APaB
=pe7E
-----END PGP SIGNATURE-----

--rXK7ltT6Dp12ndm65pomOaqJci8KHfgCJ--


--===============6042471143775682220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6042471143775682220==--
