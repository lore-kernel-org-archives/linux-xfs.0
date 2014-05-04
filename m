Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E0F47F5E
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 17:53:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4AFB4304043
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 15:53:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HLqEKxi9FGpTEVUD for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 15:53:48 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Wh5Hq-0006mv-LN
	for xfs@oss.sgi.com; Mon, 05 May 2014 08:53:34 +1000
Date: Mon, 5 May 2014 08:53:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs; master branch updated to 75b480d
Message-ID: <20140504225334.GS26353@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7849706544388641849=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7849706544388641849==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

75b480d Update debian changelog in preparation for pending release

New Commits:

Nathan Scott (3):
      [b47c8ca] Fix 32 bit build warning in libxfs, xfs_daddr_t printing
      [ce5da12] Fix msgfmt warning when building the German translation
      [75b480d] Update debian changelog in preparation for pending release


Code Diffstat:

 debian/changelog | 7 +++++++
 libxfs/rdwr.c    | 5 +++--
 po/de.po         | 1 +
 3 files changed, 11 insertions(+), 2 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTZsTtAAoJEK3oKUf0dfodtBsP/2qDZ1tIm/jCmEmQY/7Fb5sM
Kb4U99nv9KBNEalHDnBURZsiIYWhazC/DnRQAwCR6UrGPPN2ou1O0gWIudmk8zrR
5AXRnEF9DP3c8+u0WMtGjSksQvFxwSyg72AhiXbJwcpsO5l1RfuTXI7GJelGPPbW
PUF3EMMs71JonTnDQtstD6++kzqHPOzG8hJRYbVbVYBiAkCqh8tjoEBFSLOX2WBr
1KEA5W3yQsTefCiMOgqXh4FoIDxyRdDrZpkJX180VbMu+25IiJ9GaRdH8ZbttDUf
yYGVoRQK7ikbiGlVVXDzHRsBNJpua+0upkMcSTAjgnZ7bB7DDA8Kxqgi7Ngh0qD2
hs+Gb6bjgCXjPMjfcuSYeyQMgXT6kGVXPMD/d5Xmg3RxCYsKj6ex+uzQjyUOfJy6
/c/e8zF19loMpnhboY633jivNeuN8XBUz7drPMoZ1P5d0q0hwCTA6Ai50HHaLBxV
5tsmCosFgFk3RwusETcyOSM7pCoXcDK/XfPdC43lq4eRukUU5AeN00wZKhnWJ58Q
rFvoFogZ/6uhtJsSpJtc5MYCrtmPjl8gtdcguTVgQiwYlJNmQgHZjfpCkFkcpCSf
rEL5u/jIX7yPYkzFUmD1tcQTHgjn0NLah3e1VqDh0x8b95PO2ESaMZojPWvM8RaK
m+FFvqc5WPPUG3n9SkKH
=y4KD
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--


--===============7849706544388641849==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7849706544388641849==--
