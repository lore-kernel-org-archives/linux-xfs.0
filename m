Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58744 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755096AbeBWUHE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Feb 2018 15:07:04 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4626B182EA
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 14:06:13 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.15.0 released
Message-ID: <64d0cfb4-a800-1183-c1b6-efbbfb839bc4@sandeen.net>
Date: Fri, 23 Feb 2018 14:07:02 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RI3x2lLFx9GSWFuMnrYl0D2bqc7DUWMlp"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RI3x2lLFx9GSWFuMnrYl0D2bqc7DUWMlp
Content-Type: multipart/mixed; boundary="kZnctMewwjH39e2hDCOXGQM2635UJhz4f";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <64d0cfb4-a800-1183-c1b6-efbbfb839bc4@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.15.0 released

--kZnctMewwjH39e2hDCOXGQM2635UJhz4f
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.15.0 release.

Tarballs are on kernel.org:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.15.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.15.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.15.0.ta=
r.sign

Patches often get missed, so please check if your outstanding
patches were in this release. If they have not been in this release,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

bc95a6f5b xfsprogs: Release v4.15.0

A very brief summary of major changes in this release:

xfsprogs-4.15.0 (23 Feb 2018)
        - various debian-related packaging fixes (Nathan Scott)

xfsprogs-4.15.0-rc1 (13 Feb 2018)
        - xfs_scrub: experimental new tool added (Darrick Wong)
        - xfs_metadump: fix issues with -i flag (Marco Benatto)
        - mkfs.xfs: don't allow creation of realtime+reflink (Darrick Won=
g)
        - mkfs.xfs: don't crash on dswidth overflow (Darrick Wong)
        - mkfs.xfs: much refactoring (Dave Chinner)
        - xfs_copy: fix copy of v5 filesystems (Eric Sandeen)
        - xfs_io: add a new 'log_writes' command (Ross Zwisler)
        - xfs_io: add MAP_SYNC support to mmap() (Ross Zwisler)
        - libxfs: memory zone handling cleanups (Eric Sandeen)


--kZnctMewwjH39e2hDCOXGQM2635UJhz4f--

--RI3x2lLFx9GSWFuMnrYl0D2bqc7DUWMlp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlqQdGcACgkQIK4WkuE9
3uBloA/9ETA7OZY9suJMBRXS9vSJoC6YB8EO3mRjAvGD1i8Omf/yF/oUC1Y8gCk1
slyZRUMbIzfp7psj6lexAkSv8QvxP8aEl/f8o0850BXxpF+wBdM5BnWG9epBGi1z
qdXYH1dzHFOwQEgh0acyd7lFgcmF46hHSz9g7ARy/k9BwhuNDa+GfKwr85RkDR4z
Ts9Y5y36i/PpiEyxz0ekLRn2mOlc3LvD3OThc+/OrAitUCRrrAILLUSyiShrBEB2
ITGkfBD8/XEK/jtiqN8Ub3IhxZ+glbyLwgXijC12xb3F9ze+m+3x95mS6dCXM/39
RJVeQN90oStHlUL0nHtlSK49lYrcRJlvIwF4rtg1zw0TR8xCLDITZ19KowxES7kI
IgMAxNURu2cbz5hcNy+5JEA0LXogXwRVMmB96heqkb6ihCCbfP8o5dGMKB19uu3n
ZyV08cTLz99YRwRaSVUcgEsEqYJq26I1ATT8dYUzCEgBd4NQekjYOBQReA/nmank
bxubKNIEfqQhX4RwOD1wL6DtwQd4ypNbaHQ37L854qbmVyaVAZ2vPl8BiqBSAg0N
WBEyHh7sPsQl55AZ7BewXwfkvCG0QvOt3jR+MCLTdHKMIaFAX+loP2UBDpOdhABO
6VAirkrPTGO9aPFicFCscSLqis18a3/37ho3RXlO950c6n1kfgo=
=hh9Z
-----END PGP SIGNATURE-----

--RI3x2lLFx9GSWFuMnrYl0D2bqc7DUWMlp--
