Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55354 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfFYUgD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 16:36:03 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0428978D0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 15:35:52 -0500 (CDT)
Subject: [ANNOUNCE] xfsprogs for-next updated to 78c146f8
From: Eric Sandeen <sandeen@sandeen.net>
References: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
Message-ID: <ced02a94-2445-f35c-0c51-60484937dfb6@sandeen.net>
Date: Tue, 25 Jun 2019 15:36:00 -0500
MIME-Version: 1.0
In-Reply-To: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NTuWkgd6fc6zEY9DHd8sOJJU2dg7lXJhK"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NTuWkgd6fc6zEY9DHd8sOJJU2dg7lXJhK
Content-Type: multipart/mixed; boundary="oVuoffMLXK8RCpp69MjKmsd53QenFtQR3";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <ced02a94-2445-f35c-0c51-60484937dfb6@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 78c146f8
References: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
In-Reply-To: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>

--oVuoffMLXK8RCpp69MjKmsd53QenFtQR3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

And, left one out ;)

The new head of the for-next branch is commit:

78c146f8 (HEAD -> for-next, korg/for-next, refs/patches/for-next/xfs_quot=
a__fix_built-in_help_for_project_setup.patch) xfs_quota: fix built-in hel=
p for project setup

New Commits:

Eric Sandeen (1):
      [78c146f8] xfs_quota: fix built-in help for project setup


Code Diffstat:

 quota/project.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--oVuoffMLXK8RCpp69MjKmsd53QenFtQR3--

--NTuWkgd6fc6zEY9DHd8sOJJU2dg7lXJhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl0ShbEACgkQIK4WkuE9
3uC2XxAAji0yoJKedBGG5jAVIxx4ADHggygXPpYROyZBUbZmxbcrAiIowYX8HS9b
EZCRD+CpfhhY2vvPIFk/t2AcX0DpKX3//jF8LN8hxqZO+uli7C/0vUbSYYpr8qC5
sXollnCqd38Fx+iJeA+cXaPmHE7pOlQ5Ef4pE3GSbtQU0i2iNfivNydIOM/QGxli
dx8Vsq3LD2IUBaOIIrGs7Fs0Qblz6GaZN2tlI+GZe9ee/poAi7NB7y16FS6kC0v7
ZQF7UugrMmbIn1YRfmHmQPrlAaXyon+vY2y6dgsXZy+iG6Y+oty5SmIIAyObLrzw
QkN/+dkjSaq7Rwi2xBGN/cWy/7RLq3U08A4XS4qEYwwk6L4pc7LUdLtFHWszKiqK
dg/YC46qAamFwBCwKr8pznyhlmUJ/0d+1OTFl7VJ2wyowlPnjjtv9kX0ae1ooYlu
xZZsTPG1f262Q6y84u9+riRLT3mfCo/H45AyD3QmkoZ3dT+oBEHNY5S5KXNgaqVY
I5T+RAQcEAKTr6eEmVpORy+tnM1BLL70RIRqxv90Lb2tG2blPefI+CbZ/t8KLZSc
XrTZ8afu/ZK+ZhRai6/8TBRKKmg1jObAxSY11idtOMC/hJ+blzZAFRY+i8ELzwAU
ybApgQWkwiUi6NA2evZcNEyptHdhHiHU3nqFfanZt8HFs0vBaZw=
=2lrz
-----END PGP SIGNATURE-----

--NTuWkgd6fc6zEY9DHd8sOJJU2dg7lXJhK--
