Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2297B7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 18:27:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D82C1304043
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 16:27:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SaAyzGgi3mCrtXVz for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2016 16:27:00 -0700 (PDT)
Date: Tue, 30 Aug 2016 09:26:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 17de0a9
Message-ID: <20160829232658.GR19025@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5817204658817114668=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-xfs@vger.kernel.org


--===============5817204658817114668==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sw7tCqrGA+HQ0/zt"
Content-Disposition: inline


--Sw7tCqrGA+HQ0/zt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

-Dave.

The new head of the for-next branch is commit:

17de0a9 iomap: don't set FIEMAP_EXTENT_MERGED for extent based filesystems

New Commits:

Christoph Hellwig (1):
      [17de0a9] iomap: don't set FIEMAP_EXTENT_MERGED for extent based file=
systems


Code Diffstat:

 fs/iomap.c            | 5 ++++-
 include/linux/iomap.h | 8 +++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--Sw7tCqrGA+HQ0/zt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxMTCAAoJEK3oKUf0dfodhAUP/jcofy10tyqEdkXshhC9GLlF
4Kls0FWopRHhKxbr3ahH5NxQhHmNGOv2ZIzUF7+T3j4gxAzvA8JiNgIxIoU6iw5x
OxzYl+IrGzEfMSB8H9LGEPJLeFkEc3tggkfqYjB0CFMciIU8UqH0FcvrxhcgQnJf
kVs6kqYzo4bKTuRGd6agA18rqi/KrI+yQap1xLzvoxWhtS6UWFKke8gWrxN8wws3
6ncEGQekn9r6EnYTtVynUhA+ML9q7anOEyRmIj5LVQCiK2k9rEZLdyB4LiyWP6hg
iZCqk/Up9OEKG8M4D0D8+XnMywFB2cCuEekTy72iT5dJA8h93IBicmpic1h4UvcT
eT3FZ0kV6aWGAtxYSHwy4O/hNIUT0A7O+HjjT88GvJK5/m2i6fcg56jB9J/CPFhc
nVUikXxGz3wxkm7QvXIBY8b5lMYZ0QPb1g/sehCRVFTG2aSdBAVY00hObkEzWJZc
reuUrXmcsn2z/5lSvxYxzlszakJ12LDFRrlbxqXX29nnmPXwy0RdRCt4LD5z63xE
5cpFNBC4X9ZrqhC2JBcnf+Al7k2OkW/j8KLKbyJnT7mekk5l0rLRcKThfigrAjjo
FAn3OAaUrqeBXEpeV4YZIUoytwB0Lf/vAZUf43xjj41ny3tzi+wkd+G/SnBuazEH
9sz+1FLCn1dUwDr46OeS
=d/eI
-----END PGP SIGNATURE-----

--Sw7tCqrGA+HQ0/zt--


--===============5817204658817114668==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5817204658817114668==--
