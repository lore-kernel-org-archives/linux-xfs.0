Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60416 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbeHYAxO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Aug 2018 20:53:14 -0400
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3579B4CA
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 16:16:40 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.18.0 released
Message-ID: <a321ed92-a87b-5a32-2aa2-61b1b89bdf00@sandeen.net>
Date: Fri, 24 Aug 2018 16:16:52 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5Y0LRFsOOdkAW4wbWlwK4VR33EP4JfjZZ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5Y0LRFsOOdkAW4wbWlwK4VR33EP4JfjZZ
Content-Type: multipart/mixed; boundary="zkhSeXs6zmSEsqMBO0uXzhA7dO9E147bR";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <a321ed92-a87b-5a32-2aa2-61b1b89bdf00@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.18.0 released

--zkhSeXs6zmSEsqMBO0uXzhA7dO9E147bR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.18.0, with tarballs
available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.18.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.18.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.18.0.ta=
r.sign

There are no functional changes since -rc1.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update^Wrelease cycle.

The new head of the master branch is commit:

3caeb69 xfsprogs: Release v4.18.0

Abbreviated changelog follows.

CHANGELOG:

xfsprogs-4.18.0 (24 Aug 2018)
        - Tweak SPDX license in xfs_cksum.h (Darrick Wong)

xfsprogs-4.18.0-rc1 (01 Aug 2018)
        - xfs_repair: notify user if free inodes are corrupt (Eric Sandee=
n)
        - xfs_repair: use extent size validation helpers (Darrick Wong)
        - xfs_quota: don't stop the directory tree walk at DEPTH (Kazuya =
Mio)
        - xfs_scrub: ongoing updates (Darrick Wong)
        - xfs_io: document shutdown -f (Carlos Maiolino)
        - xfs_io: wire up online repair ioctls (Darrick Wong)
        - misc: adddebian initramfs hook to package (Darrick Wong)
        - misc: remove unused macros (Eric Sandeen)
        - misc: remove many XFS_BUF macros (Carlos Maiolino)
        - misc: convert to SPDX license tags (Dave Chinner)

xfsprogs-4.18.0-rc0 (05 Jul 2018)
        - Majority of 4.18 libxfs changes merged from kernel



--zkhSeXs6zmSEsqMBO0uXzhA7dO9E147bR--

--5Y0LRFsOOdkAW4wbWlwK4VR33EP4JfjZZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAluAdcUACgkQIK4WkuE9
3uBSvA//XR7ifEL09PQ/5uh9uUe7unTauqpjX3dLUQj+ngSodeMTLVxt8yWTvmqr
KetVnABR+OUeO1A4A224Nchhq6os4j1+rC4HMRvk+hcax+TXCqHqISuZOFLe//lQ
QPxarEYjjYf1sBPTdP0TaGFvFX+rBC0VLyvLGHHVkcWpjMLZM5wC4Y3jGBGFC96D
arlSA5ixqe1WDOz74OHn9RgbJdiZzMlaPxvH4Dm6x0ExP6Wp2io1ZsC9HnRLTPwK
A4HNSm0kiY3Hg6KDTcvVr7DTZbpL6xYx04a0YGaacECPauFcQyb3V8aBOoU0TeWR
trdO3xVE45cquPdYwqzYDsQKcJTofzTirZPi4pV5iShPnS+bxux1cq/cQ3bzc52X
PO4FnhEPpe3k49ywvIHRMb50hJYEiRmF3mWix0WsVLqngAHoIyRNb3DM4ZZqck8B
HJLtnmyuVj3nj30QU+0RuFz7qqFcPV8Ub6UBmnH4sGKTelGZI/tRvMWchsAwKJWl
cq6ERD97HVvHFWPkdoIOtwvCtPm4KcH/q2sN7yGHZlAcTAVO8DZigHNyxCRocfH6
w6yrlbKrxRS9FtWRc4oVgCTZOTI3OU9i1AJu+lmOxjtxQJzWnB/vJKVfagk8CDqX
oWhrsOVHsue2+5y2yZxkSSYzRz1bUGT2ij7zvwAMQXheavMtRCg=
=ACJb
-----END PGP SIGNATURE-----

--5Y0LRFsOOdkAW4wbWlwK4VR33EP4JfjZZ--
