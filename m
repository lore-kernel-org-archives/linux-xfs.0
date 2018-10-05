Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34626 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbeJFCm1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 22:42:27 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0799D2AEC
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 14:42:08 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6fc0386
Message-ID: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>
Date: Fri, 5 Oct 2018 14:42:12 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="En8yt1Y1JRsHejUu3CAaSVM4M47r0l6ZQ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--En8yt1Y1JRsHejUu3CAaSVM4M47r0l6ZQ
Content-Type: multipart/mixed; boundary="UpRoZFN2A9Q2yViWFml6dwboeQgOgFQjH";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6fc0386

--UpRoZFN2A9Q2yViWFml6dwboeQgOgFQjH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

The new head of the for-next branch is commit:

6fc0386 xfsprogs: Release v4.19.0-rc0

This is primarily just the libxfs-4.19 syncup, with Darrick's huge
assist via libxfs/trans.c updates.  More actual new content to come
in a couple days, I have most of the pending patches queued up.

This also rebsaed the libxfs-4.19-sync branch one last time.  Further
fixes will just go on top of that, I won't rebase that branch again.
Barring unexpected disaster anyway.  ;)

Thanks,
-Eric


--UpRoZFN2A9Q2yViWFml6dwboeQgOgFQjH--

--En8yt1Y1JRsHejUu3CAaSVM4M47r0l6ZQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlu3vpUACgkQIK4WkuE9
3uBGMQ//V6wv3+rj9Hw/VSCNejvgT2vy3GIHzquvAf+iKf2jqBbcMWeYjidatrpi
6xJQqOkeg4+oB4SfJyFviPCmTwpo2QkkBAZ7h1JLLAcjL58M1WyZqgzWN4TqS7Pr
VBaUnoyLjkfJ9DkPi12Lcd0PRU2GJlz0PVk39CC26tHaGDRgtdYT3TTbhuYPJQtG
YjIiGJ4X7Y2e2nAIDgU+oWj4pqnhOQL9nLX4TAmPr3oJuo2WNcV1z7sG3ejxQLzw
h39G5z3Sfmd/9jTF0HirTuO3SYBz+khb0XAnQgtC01d79GY3AZgKMwNGC5Jxagjw
SPA3ZdfXRJLHYlN3axae0EKfzUOl7IxnrQO321q5blbT+qy86ZgdLH+Gz0FDPYsg
wKweZY9cxHOE/bjgP98t2HSL+NvF7SdlcQgHgyLzt16kOz/xIXz2mPl+OBxwjTml
jM+3ugKWEolkA6/VLHRgkMZAQ2lMYppyJazLOIbYndT9D9i2O/ufOjQRmxTI59q3
JAon1ddFxueNBcGqk4XbDsmNyJZQ99PK12kSmvH/fdegNYatcocc5nTujDn4UYew
uYHEMElpLEmxmCDr8x7VGMa3KVUkBvSgzC08qQXi2LUJmMoNc7S/lCigWrnfQily
JH4jK+ZVSFH2RI72/rIAUe2iT9gPgenHXxmG9iClZDQUbdwz4Ck=
=4ncN
-----END PGP SIGNATURE-----

--En8yt1Y1JRsHejUu3CAaSVM4M47r0l6ZQ--
