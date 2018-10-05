Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42238 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbeJFDwh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 23:52:37 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 30E8CEDE
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 15:52:04 -0500 (CDT)
Subject: [ANNOUNCE V2] xfs-linux: for-next updated to 498b6cf
From: Eric Sandeen <sandeen@sandeen.net>
References: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>
Message-ID: <272cc1ad-abde-bffa-d19b-2edac0413118@sandeen.net>
Date: Fri, 5 Oct 2018 15:52:10 -0500
MIME-Version: 1.0
In-Reply-To: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XgbTRAkHRONnNAke51sC3AOsjVyJIosaQ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XgbTRAkHRONnNAke51sC3AOsjVyJIosaQ
Content-Type: multipart/mixed; boundary="DqcSIjst6M6GaixLbMGDM7tdpXKAJLxdE";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <272cc1ad-abde-bffa-d19b-2edac0413118@sandeen.net>
Subject: [ANNOUNCE V2] xfs-linux: for-next updated to 498b6cf
References: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>
In-Reply-To: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>

--DqcSIjst6M6GaixLbMGDM7tdpXKAJLxdE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been rebased & updated.

Darrick caught a dumb error on my part, yay for for-next being
rebaseable.  Everybody knows that, right?  right?  Right.

Same message as before, except:

The new head of the for-next branch is commit:

498b6cf xfsprogs: Release v4.19.0-rc0

Sorry for the trouble.  Luckily Dave slept through it all ;)

On 10/5/18 2:42 PM, Eric Sandeen wrote:
> Hi folks,
>=20
> The for-next branch of the xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated.
>=20
> The new head of the for-next branch is commit:
>=20
> 6fc0386 xfsprogs: Release v4.19.0-rc0
>=20
> This is primarily just the libxfs-4.19 syncup, with Darrick's huge
> assist via libxfs/trans.c updates.  More actual new content to come
> in a couple days, I have most of the pending patches queued up.
>=20
> This also rebsaed the libxfs-4.19-sync branch one last time.  Further
> fixes will just go on top of that, I won't rebase that branch again.
> Barring unexpected disaster anyway.  ;)
>=20
> Thanks,
> -Eric
>=20


--DqcSIjst6M6GaixLbMGDM7tdpXKAJLxdE--

--XgbTRAkHRONnNAke51sC3AOsjVyJIosaQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlu3zvsACgkQIK4WkuE9
3uBS/xAAiRwSsFILACm4zwQvTo1+BYLjdHmDzmpzh+h5ok1Zj/cn0nOR8onScQYg
2eiclqdCiu2Q+sJHFAkkcLyFOFlZI2PpRJVO3/GcmyUZtOwQ5qNn668rwa+scbel
yq7yEj1BrdJ2hp+qpyo+fP+LxFBeNiL2aLAROMfxyPVfsqWmfDtEYLZWkGpPDv8S
BQtqnwasn4SfPmE/aeDsxuGtgrMWMnFqi05gHDrs9akCFRWz844OkUCbhxhrk4Xn
3u6ecn/v5XHaKuYyB796QF/wUgd5k2x1RFo2sxp+dpOGcxRHQ8Pg9KCbD7jBXCV/
FoF3dj6hNC04pR02txv5Y7xieOqirT5NP7cu2ZdThRWQRSqBuFP5xoIwXdfUd8zM
sGEigP0J5sb0Rl+XfSW45SQPBvQV/8JJGo2yOwywhj1VjvNKRV686JMGh6ajgIX/
VzLsYqeyyQ0M00gGnY/KAlsKI5LaY4JzJIGMSXEVLStE6zpGjPbouGDVmtf8AJnt
gOLbML6zR3N+rZvgLHRbXufoUr/EyhKOxTL6//YhoVWDh/M33//CjMGMWQqvlYhj
mQ5RKWCfnnUVIgaGLpCnRWNTHb2iBO4DXcen7ke7veRfYs6Q4j6EiLcc6Ma9OHZD
9DUj3BuYGeIqKJg/59PUwUTJBieBYfJ4Z3w6VSABGpIoB6YOepc=
=utzW
-----END PGP SIGNATURE-----

--XgbTRAkHRONnNAke51sC3AOsjVyJIosaQ--
