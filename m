Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84AF57F4E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 17:21:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6237B8F8087
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 15:21:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	8ViAbzSfO1FhBbIG for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 15:21:10 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Yy6An-0006UM-Iw
	for xfs@oss.sgi.com; Fri, 29 May 2015 08:21:09 +1000
Date: Fri, 29 May 2015 08:21:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to cddc116
Message-ID: <20150528222109.GC4316@dastard>
References: <20150528215309.GA15721@dastard>
MIME-Version: 1.0
In-Reply-To: <20150528215309.GA15721@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5305168196240055515=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5305168196240055515==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2015 at 07:53:09AM +1000, Dave Chinner wrote:
> Hi folks,
>=20
> The for-next branch of the xfs kernel repository at
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
>=20
> has just been updated.
>=20
> The new head of the for-next branch is commit:
>=20
> cddc116 xfs: xfs_iozero can return positive errno

Note: i just updated it again with a patch I missed in the
xfs-for-linus-v4.1-rc6 branch:

Brian Foster (1):
      [22419ac] xfs: fix broken i_nlink accounting for whiteout tmpfile ino=
de

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVZ5TVAAoJEK3oKUf0dfodNG8P/1l3p9OmkYlqsG33lvhm8VQq
gLkUKjoLHTfLCyf73HlVrmAd/om9JMrFDO1wbQtqwMok3EWJYbBN3pvqYfspSY4n
PHy8rIoeyWNBZA+ykW5mzChzDyYVzfU8sBsn9Pj5KMcolZ6dbXJrcOcytqstih6e
v+SyzSAb3zgHD4+L87guN18MS9y6iXibnrDs0F8OmL89dJ4uj3+REdwjbvbHMTxG
Gr5HIjE5cBnsc5jpvh110JKtzaoVJEz5EXEx6ryssK37KtqeeqKttNh3vKzLRFgl
Z9333D2g2g792HBYDohGJJsop8Tb1XZbWL55qBIyDQdTwXAwAgL7CIKU6XuHYl39
k78q3Nh4uLYctELQQMi8G/RqtZXNwldL068DLZelvxdNFap8z8WbrxPbtO+EbJpv
X3h2DbelGXD6uQoHwIMZAYU/rk4zXXIR3XMLgTbtpSnNJltF2T48x+wTlWqudY0x
tAkQkvaULW78sbWCluqTGBzUVXJfFrPvCF6pqGvRadZGPjPnetcbvHt0mfLGHiB9
cNBbQFaMVlGyWWv1mIZQ1Jfzk/56IxD6/v33MByFOlYF6sS12PTf9PW6KY9Iq+sf
ysTDRWxbP4oBQs8msfpJooFr0VWcfCNrMI4y0vBPBk6u5XUL3yfl3BdiHxk+c4qN
MhSdOP8Er89G5CT+iDa7
=6rlP
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--


--===============5305168196240055515==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5305168196240055515==--
