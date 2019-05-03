Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41714 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfECUIc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 May 2019 16:08:32 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1E9C3560
        for <linux-xfs@vger.kernel.org>; Fri,  3 May 2019 15:08:29 -0500 (CDT)
Subject: Re: [ANNOUNCE] xfsprogs master updated to 65dcd3b
From: Eric Sandeen <sandeen@sandeen.net>
References: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>
Message-ID: <2092fa5f-d87f-bac9-8091-ed2a9e64fe01@sandeen.net>
Date: Fri, 3 May 2019 15:08:31 -0500
MIME-Version: 1.0
In-Reply-To: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XsEsrDGhE9cSz8iL8psJM1WElKNhbwdXA"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XsEsrDGhE9cSz8iL8psJM1WElKNhbwdXA
Content-Type: multipart/mixed; boundary="ENQF41FoByJVxUdJLhxXttxlktMpIGaoq";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <2092fa5f-d87f-bac9-8091-ed2a9e64fe01@sandeen.net>
Subject: Re: [ANNOUNCE] xfsprogs master updated to 65dcd3b
References: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>
In-Reply-To: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>

--ENQF41FoByJVxUdJLhxXttxlktMpIGaoq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/3/19 3:06 PM, Eric Sandeen wrote:
> Hi folks,
>=20
> The xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated.

Forgot to sign that one, so I'll sign a reply, just in case anyone
was worried.

-Eric
=20
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
>=20
> The new head of the master branch is commit:
>=20
> Hi folks,
>=20
> The xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated.
>=20
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
>=20
> The new head of the master branch is commit:
>=20
> 65dcd3b xfsprogs: Release v5.0.0
>=20
> New Commits:
>=20
> Eric Sandeen (2):
>       [868d0cc] xfs_io: rework includes for statx structures
>       [65dcd3b] xfsprogs: Release v5.0.0
>=20
> Jorge Guerra (1):
>       [0c1d691] xfs_db: scan entire file system when using 'frag'
>=20
>=20
> Code Diffstat:
>=20
>  VERSION          | 2 +-
>  configure.ac     | 2 +-
>  db/frag.c        | 2 +-
>  debian/changelog | 6 ++++++
>  doc/CHANGES      | 4 ++++
>  io/stat.c        | 3 ---
>  io/statx.h       | 7 +++++++
>  7 files changed, 20 insertions(+), 6 deletions(-)
>  xfsprogs: Release v5.0.0
>=20
> New Commits:
>=20
> Eric Sandeen (2):
>       [868d0cc] xfs_io: rework includes for statx structures
>       [65dcd3b] xfsprogs: Release v5.0.0
>=20
> Jorge Guerra (1):
>       [0c1d691] xfs_db: scan entire file system when using 'frag'
>=20
>=20
> Code Diffstat:
>=20
>  VERSION          | 2 +-
>  configure.ac     | 2 +-
>  db/frag.c        | 2 +-
>  debian/changelog | 6 ++++++
>  doc/CHANGES      | 4 ++++
>  io/stat.c        | 3 ---
>  io/statx.h       | 7 +++++++
>  7 files changed, 20 insertions(+), 6 deletions(-)
>=20


--ENQF41FoByJVxUdJLhxXttxlktMpIGaoq--

--XsEsrDGhE9cSz8iL8psJM1WElKNhbwdXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzMn78ACgkQIK4WkuE9
3uD5Rg/9EpoSGEDem2Zo0CZPFKoLpjd4VHJe/ghTrruhx9wfB8bitn9RfGNNbr9z
x7vNgKNFQYn7A4I3H0ri0B7hmtr9iWnOjz/+A1tckXufNQ1S52doBcWvfwHEchC5
Db1hASpcrIwSIroa6J82SAw7KB/r1lWVLIBLma7OrMN3g7Jm+TMIE3WYK45qHFBo
NVzGlAEuDPXwnzpvOjT/i4I15dwQVIOZdMHFlNyWKtBHlLojKs49V8WsSahui4iL
0u9i2qFFw4QMevLqproo6g4UX17WBKAUzEa4Pi+ZO43jgnyP0qxmzwNrRwpZdqgV
np8n0M939aC4yd9uXhM2GSrO8MeJOY3sPexdKpnbpJIsfIWTO4z0xlar68rBZCrY
0CtQ4bLQgg1AnweoyhGT1oV2IDEDLpZqYgglAbFZNZqISvUhafbFGIZ8b62DHY3W
u/y5UaXX4/dqnkD9kvv9A5cSXn+1VDLXJruK0L1gRXHFsoNV3HYkw/5xj7EL9Un9
B4q1TTrcikIcJKGcBIvAEEb4cpPb1I1r2OgSD35pVMwdVjXVM3uQiNph5/jatr6c
6vGA/YsBv9Rs724Uqy3StnD3SKT5lw1gmOQ4MzWvUtA4gPaGmdklwKsQkgrg8Ri0
bA79pKHTDkW/sHB/lYVAhrVRjJgQzcd34eX/DucYNiqsZXmFv+Y=
=HPpB
-----END PGP SIGNATURE-----

--XsEsrDGhE9cSz8iL8psJM1WElKNhbwdXA--
