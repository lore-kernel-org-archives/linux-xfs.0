Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D9A287F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 21:08:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B9A938F8037
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 19:08:05 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WyWnDT8eobiD7DrO for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 19:08:01 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZeZTT-0001zp-Ox
	for xfs@oss.sgi.com; Wed, 23 Sep 2015 12:07:59 +1000
Date: Wed, 23 Sep 2015 12:07:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: master, for-next branches updated to v4.3-rc2
Message-ID: <20150923020759.GJ3902@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1415851979794386765=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1415851979794386765==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVHblb/y9DPlgkHs"
Content-Disposition: inline


--qVHblb/y9DPlgkHs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I've just updated the master and for-next branches of the XFs
repository here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

to v4.3-rc2. Please update your local dev trees and rebase your
current patches against this.

Thanks!

-Dave.
--=20
Dave Chinner
david@fromorbit.com

--qVHblb/y9DPlgkHs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAgl/AAoJEK3oKUf0dfodDv4P/0kNljxs0RQrHARIjM0bCKz2
gMvFX226nBHaDhNwvRmbMLU/JVcPs83rASG6Q8MMWw9XSqB1AlqUZCf65nvlzDpi
qyouR8EQ1+Sg3u7MxEOo5PBr2YixJvmQgxVDo2asEb53fWjFbYikPXm9CcQOmET8
Fj5NPPeskMxE1YgrEMeJ3hHdkd55zPNFv14EnLN7Up0n/g4iMgsrR+cE0jE7ebDR
4yJpvAdcVA3PDDVIQBACkruiuHVWSY5oceyAD9+LEmga9KUw03KqiRCFXuwU1TIy
6yp4LAZfqNofMKBsJoV5VyvbOlWZ6Kotp0gfwBzg+qpOpnM5bpQgFusfdtD8Dvwy
En1m1C+8QlHusZnVWayIeMvji6bLDdTRUmxqgwgorcBp+8bB8PJPwJCsZNcoCrMj
bmlmCyoLOghpiI6t6owqpUkUiRhahVhIKXt+lPzb4J2/pMI/eZ9OhaxW5807Ng8o
172npSv+WdHKBONq6HtP+vUYsEmP+22yk/RcCd4Rg/4NEAvHZt7vUExfwtJ7Co01
b1HAnw7AUk9tpLw8z67oZKiscPN9EAmkhFBjn4OsyXRlXykUJi+N+/f+aCCnP+lQ
37R/lO42JfxVCdTup9szXufQ/n6r8LEv7pmygGbjl4mLT7eILFWFkaZTmSBN+qgn
v4T4uAjHlmVda/gCKQC+
=Suz+
-----END PGP SIGNATURE-----

--qVHblb/y9DPlgkHs--


--===============1415851979794386765==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1415851979794386765==--
