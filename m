Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F4E97F51
	for <xfs@oss.sgi.com>; Mon,  4 May 2015 16:54:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 468EB8F8052
	for <xfs@oss.sgi.com>; Mon,  4 May 2015 14:54:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Rra5D7upNJLAaBNn for <xfs@oss.sgi.com>;
	Mon, 04 May 2015 14:54:01 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YpOIu-0005Zi-LR
	for xfs@oss.sgi.com; Tue, 05 May 2015 07:53:32 +1000
Date: Tue, 5 May 2015 07:53:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: master and for-next branches updated to v4.1-rc2
Message-ID: <20150504215332.GE21261@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6934562423455757526=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6934562423455757526==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I've just updated the kernel.org XFS git tree to v4.1-rc2. Can you
please update your dev trees and rebase you patches against this
updated tree?

-Dave.
--=20
Dave Chinner
david@fromorbit.com

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVR+pcAAoJEK3oKUf0dfodOhsQALwsTqCZCASRC1n72vuJIB9y
dpH37RBzHDieWtCKKJ+SnoWhmVybpI1QW1PKawgvHFm5eSO0suHvYd35pgBElfcy
inWBKCdSeGz6pEBHqwTaWPbvpm6tFrLWzaNJLrSp/EiZUAZ0yLf+IQGvgEVmBiUm
m3w7e/4+2RHJMZEwKi7rK9EO/oL6tP+pEUrCEPZFWpxT7BqIFfAd2OTX9Ow1OiLY
L4fAKOQVxCF/ONbrEp7LFdY0pBzNKfeBNqQNJz+Xt8E/7OLHNY3KyKlAarU3AnJV
axEEGLmbR55SWom2CBzBRt+Wnwebccr7xM0IIAdalo9JEwWJg46FBh45nS9BMux+
rj9Pmds9H5mgWDMOBBwdZ4wt3olWnxCzIws+xN/AvhwtaimH2NJ37v1nDWLrAY//
3QfCLMUYocLje/vr0Yt+CGKFCQ1mmzc2RL8XppjAmQNbocSvD/LXHVGHYp4uLkCm
90Lyno9oV4jT/cYZi5qqXlhHQIH51yF0iE1z3/rxns0FZQx1WxCfNz0yqbSG8IXT
JbnFAwU7Mt29NJhoJaVZhrxWTDXZr92DXZu/bY8xPK6Qyzvc3IWpAS0Gh3y5Ezah
WDPVaDKreEJuAr3op0bKgIvGGV6gQl1N+U664TA8KiX56DDJnLW9Jfktl4uYk6Ak
N0BEs+u903FIayJ8BQIQ
=8hL2
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--


--===============6934562423455757526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6934562423455757526==--
