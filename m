Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59688 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbdJRV1Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Oct 2017 17:27:24 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BCA39D50
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 16:26:35 -0500 (CDT)
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 9d199c7
From: Eric Sandeen <sandeen@sandeen.net>
References: <4714fdb1-2dac-ffed-07b5-8914db6dbfe7@sandeen.net>
Message-ID: <73c5278e-56e7-0703-8798-29e8cb403ed0@sandeen.net>
Date: Wed, 18 Oct 2017 16:27:22 -0500
MIME-Version: 1.0
In-Reply-To: <4714fdb1-2dac-ffed-07b5-8914db6dbfe7@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uaCDQSWtcnjwtUUwhg134dUvQ5225tiH1"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uaCDQSWtcnjwtUUwhg134dUvQ5225tiH1
Content-Type: multipart/mixed; boundary="fDcC0GN82PjS9308oe7GqT5KmxDUsihEE";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <73c5278e-56e7-0703-8798-29e8cb403ed0@sandeen.net>
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 9d199c7
References: <4714fdb1-2dac-ffed-07b5-8914db6dbfe7@sandeen.net>
In-Reply-To: <4714fdb1-2dac-ffed-07b5-8914db6dbfe7@sandeen.net>

--fDcC0GN82PjS9308oe7GqT5KmxDUsihEE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 10/18/17 2:34 PM, Eric Sandeen wrote:
> Hi folks,
>=20
> The for-next branch of the xfsprogs repository at:
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
> The new head of the for-next branch is commit:
>=20
> 9d199c7 xfs: trim writepage mapping to within eof

make that:

ca75eb2 xfs: trim writepage mapping to within eof

after a rebase, sorry.  Failed to refresh guilt and I ... guess that
means I didn't push pending changes.  Reserved my right to rebase
for-next to avoid the build breakage.

-Eric


--fDcC0GN82PjS9308oe7GqT5KmxDUsihEE--

--uaCDQSWtcnjwtUUwhg134dUvQ5225tiH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlnnxzsACgkQIK4WkuE9
3uCrTBAAkTnV5GtKplGdsjrT2IHkW8cx0wxXjgQCNZczcL8oIvebXTPuHprJkAOv
Z7pz5PHYQXO4ucI8NHtcQiEvYQM0XnaoROvHbv3Zk2Q4t+h2DIfyClLi+TkvV+mn
5xGar3lI3rmrcr92fbWm4R5zHuaN7Xxcmq8D3WzWQ2meBzEN8fDEz1kwsJO2ymeK
C48zmyf7NsDghjbmzLDYsi5OX+90+HD+7p8NQFl67xaeAvpHBCOMq0umYJ8PXX7q
VZqQXKbIlHv8bLUZMoLpaxCwuuhh4cBndM/JtrZVzLhWkKNB/qVCFcoFsY5ofn9j
7sgbvPgWh5hFgsMuVewy2j7TS2Q0RbQDTh4vSuL6Ax8qcOv5/0Vc7hkyHjRZBXtZ
9B9a9kbYbrJvJN8HZ7Xm6tFvyhssKLDEn3BWuIyVvi62fa9bXtmdssUpb2C76lGZ
kOiTQGBevg7jwPXCFu1/k8EHFedtE9PxS3dceSvnIL/HhqU+ClTVtFTyk/PKe8Cb
NGvyHTtgp+UR5fgMYT5sQx3GIOwzf1xKJnnC5XWyrYJ9LOOEGUJPaOEdIy4zGgyC
WvX4dxOjCesi/lrLV84596n4OWj+qn4oC85CoEAozdV0u15mISJTBMd6EFHjBOPB
o8TH/YUNOs2qJOd35AmD8sIrRhqw4WruboSuRdZXxS90YKjn6wA=
=OA+E
-----END PGP SIGNATURE-----

--uaCDQSWtcnjwtUUwhg134dUvQ5225tiH1--
