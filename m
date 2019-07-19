Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35890 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729465AbfGSSeB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jul 2019 14:34:01 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1927E2A9C
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2019 13:33:39 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.1.0 released
Message-ID: <bb99bdcc-13f5-467b-3e6d-c789f428fb2b@sandeen.net>
Date: Fri, 19 Jul 2019 13:33:58 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TSyZMTCpRbNvfBBge4H2RRqoQcOme6YNQ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TSyZMTCpRbNvfBBge4H2RRqoQcOme6YNQ
Content-Type: multipart/mixed; boundary="9UsKH62KHiuG6YCFikBlNmfc2pb01SEv1";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <bb99bdcc-13f5-467b-3e6d-c789f428fb2b@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.1.0 released

--9UsKH62KHiuG6YCFikBlNmfc2pb01SEv1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

xfsprogs-5.1.0 has been released.

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.1.0, with tarballs
available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.1.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.1.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.1.0.tar=
=2Esign

Highlights of changes since last release:

xfsprogs-5.1.0 (19 Jul 2019)
        - No further changes

xfsprogs-5.1.0-rc1 (11 Jul 2019)
        - mkfs: enable reflink by default (Darrick Wong)
        - mkfs: fix stripe unit handling (Allison Collins)
        - mkfs: remove useless log options in usage() (Yang Xu)
        - mkfs: validate start and end of aligned logs (Darrick Wong)
        - xfs_quota: fix built-in help for project setup (Eric Sandeen)
        - xfs_io: allow passing an open file to copy_range (Amir Goldstei=
n)
        - xfs_info: limit findmnt to mounted xfs filesystems (Amir Goldst=
ein)
        - man: break out several ioctl man pages (Darrick Wong)
        - man: Fix an inconsistency in the mkfs man page (Alvin Zheng)
        - xfs_scrub: fix background-mode sleep throttling (Darrick Wong)
        - libxfs: sync up xfs_trans_inode.c with the kernel (Eric Sandeen=
)
        - libfrog: fix bitmap return values (Darrick Wong)
        - libfrog: don't set negative errno in conversion f'ns (Darrick W=
ong)



--9UsKH62KHiuG6YCFikBlNmfc2pb01SEv1--

--TSyZMTCpRbNvfBBge4H2RRqoQcOme6YNQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl0yDRcACgkQIK4WkuE9
3uAjLQ//cbsn/wDkJedz4EoPnR1ZIiU5/xJEb3/iAqL9YRZNuUfjQyQvSU0Qaqjd
6xGnh1NQ+ER0QYH27rfdjWnOfV1rdSo8lOLTEw6sflwKPJwZVsSsfRlrgLOF/FMw
qYYN3euolFjQ5oiW8uKlzYBe7pTHduh6TyzxNx5laPuNAKWTUWdc/ji1TPl5LypY
hzEGZTkPZtiYaCQl/rj/XHwNbyudKhTRDMYHFJlXY6YEWUYQEeKPU+2ea9mEaoGr
foFxLthvaIQjGM8a7tmdR3yW3nOvBGeDOvy9hL+JbuUSuwh1EudSK45e9T4j1liN
gLxvtHq4Aw5vs3xtabk8NpqIjJ3tPqrorvy6DlVoTzxlDLMQVwwax1QSPQyt2tZK
KMcqy/ElEqaFyKOuAvpOoz5QYavFevOC+4yxd+pB+XMGK7cnFeRIkGe1wmwGFloV
3hcqhCOLg9PIgC4w2d2HRPHIAIxCIpTUzlbJ7GO+dZVzMEKn8CKl271oVtbYE5D9
cUygm5go2uNs30S2f0eCaByMjdIyauuUgOoZdSctQC4cmktsMyAn+T4k0hTSqdbP
huAYq2UvU7VoDruW+EF8UnwpTTs00sKagQVswJ4NMO6WChs1l38ok5bXVRVQFmSw
UuO9BPWy3+BAGk7PMpeKqwfuG79pAIFvuWwgw20X7okiDQb+x/M=
=564f
-----END PGP SIGNATURE-----

--TSyZMTCpRbNvfBBge4H2RRqoQcOme6YNQ--
