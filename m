Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34338 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755839AbeDWPeD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 11:34:03 -0400
Received: from Liberator-5.local (unknown [198.233.165.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C18BA46C7FA
        for <linux-xfs@vger.kernel.org>; Mon, 23 Apr 2018 10:33:00 -0500 (CDT)
Subject: Re: [ANNOUNCE] xfsprogs-4.16.0-rc1 released
From: Eric Sandeen <sandeen@sandeen.net>
References: <9673fe5a-6350-e469-28c3-7427af1bba18@sandeen.net>
Message-ID: <a5de3bdd-903a-fb26-ac27-e46ccc51003c@sandeen.net>
Date: Mon, 23 Apr 2018 09:34:00 -0600
MIME-Version: 1.0
In-Reply-To: <9673fe5a-6350-e469-28c3-7427af1bba18@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5AzpZPTdsDysiP2vYEzBegGpBj3eRIzIZ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5AzpZPTdsDysiP2vYEzBegGpBj3eRIzIZ
Content-Type: multipart/mixed; boundary="HZhBc78G5iS8gvUgtLvSk9uxVNHwVVecR";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <a5de3bdd-903a-fb26-ac27-e46ccc51003c@sandeen.net>
Subject: Re: [ANNOUNCE] xfsprogs-4.16.0-rc1 released
References: <9673fe5a-6350-e469-28c3-7427af1bba18@sandeen.net>
In-Reply-To: <9673fe5a-6350-e469-28c3-7427af1bba18@sandeen.net>

--HZhBc78G5iS8gvUgtLvSk9uxVNHwVVecR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/12/18 3:39 PM, Eric Sandeen wrote:
> Hi folks,
>=20
> The master branch of the xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated and tagged with v4.16.0-rc1

I plan to release this as 4.16.0 in the next day or two, unless anyone
has found issues with -rc1 that must be fixed before a point release.

Thanks,
-Eric


--HZhBc78G5iS8gvUgtLvSk9uxVNHwVVecR--

--5AzpZPTdsDysiP2vYEzBegGpBj3eRIzIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlrd/OkACgkQIK4WkuE9
3uAQkg/9HivPC+oldoMLApIyGpCg/RJaCEUAqyYpPgz3rq9JdjF2v9JMqRRZVDis
zIZhexYnW1gpCQiMthPQGh2CRggYUhalBrvIZPSTiJg5m/DDk+mqeSPCWQzuBpGE
pVvBSHbBO9qezvHf5V6JRtcn+viQ82mDIRbL5a2A9bRYLnZlvbtvozjDdOhWqoP7
zFPl9Nkx4w6EzT6PrDhz+MaPEDUs0EXzAA/rdQyR9Ck7I7BcC5dUrQd4GnT2etiE
T/TniRAvklM94h0Yx/i8AcfRQ37boi0RFXSupFZatXZvjS7K3fB/A9i8QMAz2czH
hnX6427D7K+FxzdwxenS4pXbvwd/SyC8s6TRFr1JcIPo37znlEjsdD64xEAwAaZb
/isc1+qX9+phhmt52UqhYaMUDqnKvarAMKAi0nZcxpStXFk8KKxdJjLLSYRZDqjJ
dlnG0jtresKWwk6tdN8bm4zWpdWACdTqaMnu+o0GtnZPjdLlD3BT4DRT2cfCOQYV
8TlbJKFtfg4FF48TVy+mZIeu7uXMCVpKghWvM+ZKy4vr23olbRoVT3J4qFTFrjD2
zp8dv69+DjhnFVDt5GudWx+f7IMr8Vx5sGnqlMJ3TuRfA3s4HPZwAJEiaqxiPhp3
XIEKPwQ2uOjEAtHunBpwObmLAZchlDIVLVGEeTdxn5Is9dVL0yA=
=HH5W
-----END PGP SIGNATURE-----

--5AzpZPTdsDysiP2vYEzBegGpBj3eRIzIZ--
