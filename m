Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41672 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfECUHt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 May 2019 16:07:49 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D63C6560
        for <linux-xfs@vger.kernel.org>; Fri,  3 May 2019 15:07:45 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.0.0 released
Message-ID: <86bfcc3d-129a-7394-b97a-f328c8d1964c@sandeen.net>
Date: Fri, 3 May 2019 15:07:47 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LnyqsBi3QhoQud2HIpHvlZD9c9LYvikdL"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LnyqsBi3QhoQud2HIpHvlZD9c9LYvikdL
Content-Type: multipart/mixed; boundary="gqmRxcvIcqW3iLcZuHjkOw0Hpx8f13fyf";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <86bfcc3d-129a-7394-b97a-f328c8d1964c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.0.0 released

--gqmRxcvIcqW3iLcZuHjkOw0Hpx8f13fyf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

=46rom the "It's Friday" department:

xfsprogs-5.0.0 is out!  Before kernel 5.1 was released!  *phew*

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.0.0, with tarballs
available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.0.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.0.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.0.0.tar=
=2Esign

Highlights of changes since last release:

xfsprogs-5.0.0 (03 May 2019)
        - xfs_db: scan all sparse inodes when using 'frag' (Jorge Guerra)=

        - Fix build with newer statx headers (Eric Sandeen)

xfsprogs-5.0.0-rc1 (26 Apr 2019)
        - mkfs: validate extent size hint parameters (Darrick Wong)
        - xfs_repair: bump on-disk nlink when adding lost+found (Darrick =
Wong)
        - xfs_repair: reinitialize root directory nlink correctly (Darric=
k Wong)
        - xfs_repair: use lenient verifiers for half-fixed inodes (Darric=
k Wong)
        - xfs_repair: acct for btree shrinks when fixing freelist (Darric=
k Wong)
        - xfs_repair: better cli option parameter checking (Darrick Wong)=

        - xfs_repair: fix deadlock due to failed inode flushes (Dave Chin=
ner)
        - xfs_info: handle devices, mountpoints, and loop files (Darrick =
Wong)
        - xfs_metadump: fix symlink handling (Darrick Wong)
        - xfs_io: fix label parsing and validation (Darrick Wong)
        - xfs_io: print attributes_mask in statx (Darrick Wong)
        - xfs_scrub: fix Make targets which depend on builddefs (Darrick =
Wong)
        - xfs_scrub: check label for misleading characters (Darrick Wong)=

        - xfs_scrub: parallelize based on storage not CPUS (Darrick Wong)=

        - xfs_scrub: activate timer only after system is up (Darrick Wong=
)
        - libxfs: fix buffer & inode lifetimes (Darrick Wong)
        - misc: fix strncpy length complaints from gcc (Darrick Wong)
        - debian build & packaging fixes (Darrick Wong)
        - Merge libxfs from kernel 5.0



--gqmRxcvIcqW3iLcZuHjkOw0Hpx8f13fyf--

--LnyqsBi3QhoQud2HIpHvlZD9c9LYvikdL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzMn5QACgkQIK4WkuE9
3uAzFRAAqLaSXGLoLugWW/xjOE+sK3VeDf+ZmhxUQiJ6NRTkK5GcXeoc2SkqUdtT
8qjWbOgIiPbO7JvEov0gTs5fZsfSOf9nVPaXpn9PjfBY3TZMrYYqFZHvI5NOlUGB
0ATaTBz3VBtZ/JoZF++oIEG/fyPG4Wl7kcGlO1+8Ul9LW+L0e3Lba6usZNx8WVQG
+Ya955kzmCXY71qxRPV1uPLMX0/ZLd8gTcJVTSsSAGZYrIGeSxDMYzAvqQLa2GdS
v1McjJFmLceOobIFOiSiy9q2pZ/d/rKptfWTjGJJN50duuqYTurYi+u5U0Yw5aJS
l/if1xMLXBNdTIKOKRjHSATEhbYXvJSJEKrvDC7HHV6J5CpZIdH4TXRoEfjbFeYk
rLd9hOWgNmx0tsIBNWY+r3Wo4riUfKRajDLy+7PkXdCLOroleO3iD5FuHd7CjQIp
zR+NhDKHaxXoeegMHfSk0Gq20Q/8+Jgig6x/Wfnrf2zUJskJg/yRMOgXML/t/DYx
mZax4dp/I0+sE63GpfSHNMxZVvk208hhkB7oitDjwQq2DuSzDuldJ2QcRo49USV/
+RfpY/40O6chlp2i2gde1wzHHSUhM940M+XetSE+vYYMxn4MNvjVmzmdyJOu0WTU
OPzEieATamx4dXS+PgjvLxP68jlE8zqL3mUv/NPNMzjmTl9Egvw=
=YdY1
-----END PGP SIGNATURE-----

--LnyqsBi3QhoQud2HIpHvlZD9c9LYvikdL--
