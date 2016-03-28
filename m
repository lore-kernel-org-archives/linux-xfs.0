Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B1D17CB0
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 18:13:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E2C3AC006
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 16:13:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NQa9SDFolhOvHIPm for <xfs@oss.sgi.com>;
	Mon, 28 Mar 2016 16:13:23 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1akgB1-0000CB-O2
	for xfs@oss.sgi.com; Tue, 29 Mar 2016 10:02:27 +1100
Date: Tue, 29 Mar 2016 10:02:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: master, for-next branches updated to 4.6-rc1
Message-ID: <20160328230227.GH11812@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0215400555059756498=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0215400555059756498==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Content-Disposition: inline


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master and for-next branches of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated to 4.6-rc1, ready for the next development
cycle. Please update your trees and send future patches against
these updated branches.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW+bgDAAoJEK3oKUf0dfodhn8QAL4smXL9Cm9kC5UEhgC9vGl0
go/C6RrnkA3avifauuBvPiXac9gXxendN0Vp0AXVClqLZCdAPYBWHAYDVTX+eqmR
maU5pLAsWLlhQ6RGoLJxGDkgl29qM3umNnz+d8IJo6iLYRTcyj3Oqn0N++1jteyQ
RqOQ+ovFdmtWWdQf7Xw+FVVzFsNu7dk3ivOHgb8jnTqRMHQp2QaGe23fO9tRPFiP
MaK+KR2ViKXQYfblaJNBa2bBbc6U1JvoeRND+MrcAqZPFI2FVFusQYSMe/O5LpIA
PyZOtFWiZGGwgR93Mt55NLbAsW9JlxOkkiPGjtjXjg/ysIVY3eugu2gTVA4Qlcju
Y+MWG9HPtuMS+zF5kuLq+JDvgNycDTcPl1+evjWBk/X5MVWZol5yhoWrNSf93K0I
wM4PZdsxY6A0ocEkAypRN4joMgU2fK40nvT5jfJwA9xRCbzG33GE6H+4i6s7WGBI
108fbFtI9JjOnRecN1Pw+yDDEqqotUVrmkup0GIOcfQ75xWgoSu/jfCXx8FPSJtb
euWjOgBm7R/CLW1Kg81z1nUTYeFjmpWM6TkU7v5CqM562x3aPCuU3AYIXX44k+YD
wmWwNvtNJMVKD3azjx4iRBcOR/dec9lzCgpLO0Wh0Rf7AfL8aYn3Rthh6mvTJOW0
vJpr8T7MeQYvMcXfC5YT
=Gi4W
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--


--===============0215400555059756498==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0215400555059756498==--
