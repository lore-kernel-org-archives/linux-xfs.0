Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41522 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728341AbeJFDpv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 23:45:51 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1AB9FEDE
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 15:45:20 -0500 (CDT)
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 6fc0386
From: Eric Sandeen <sandeen@sandeen.net>
References: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>
Message-ID: <3a645a61-0573-1a46-c7da-cdb450930267@sandeen.net>
Date: Fri, 5 Oct 2018 15:45:25 -0500
MIME-Version: 1.0
In-Reply-To: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cfKSWcIUAFsobvtVuRlOuVZvAJ4dmUWIo"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cfKSWcIUAFsobvtVuRlOuVZvAJ4dmUWIo
Content-Type: multipart/mixed; boundary="m24JttDmo5i0e4k0SToUgPItlfqPPACaZ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <3a645a61-0573-1a46-c7da-cdb450930267@sandeen.net>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 6fc0386
References: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>
In-Reply-To: <2d6cbbca-9a92-4974-ea2c-b8239e121c09@sandeen.net>

--m24JttDmo5i0e4k0SToUgPItlfqPPACaZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



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

And of course by saying that, I invoked it.

Fresh announcement to come.

-Eric


--m24JttDmo5i0e4k0SToUgPItlfqPPACaZ--

--cfKSWcIUAFsobvtVuRlOuVZvAJ4dmUWIo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlu3zWUACgkQIK4WkuE9
3uAEyQ/+NwbyOX6l36Q6GhIUxitaWB8mQ27+t/TbNykhPphBtenwVcqxE18x69uD
MQAqe0h1626qvXaFkwfNF7w9twp7/ZKBYPCuxTP/5pioYQVvXG0XjoMNHFzEyBSL
y6dH4MM4RbBpr/nK5btp3NQ6EPr+sqC5NoH19VcHOloc2AW8ChDfhbNBoP9Pu1+L
J0njrARHZchVon9KkURDlwqpCJAXZx+KtPah7fG4tSDUGuiTna0hNMB8CGd4z3ZM
Sn8I6/szY9RANxjrwRJaEkAoHsxyE1xJRm5KPpVcMsuTcbf4x12zkMdAv0YDzz+m
IWWtyCuqwBav87pQjNPk8C0FMHSoEaGSixcd/2UtBnuymZkD9lEwKpknLgYVYW9X
hVhBetBbqtL3e9VqXckFjVp++fM2knVZM3coCs8++h6Rcx2UwThUIPOJ1MzXpHg9
u0/M0KmGy7M9duVKggZN5NNkGJaPuWPurJw+eaXDsCjbHUf0vUy7GX1kciZI/l7I
9NRgTbHMkdfdl5dzrQP87d83OvNZOJQxKV/H9p3Z5F1BjAruBIzz06kQtz4MpaTt
SBA/WU1naeH8nRBijugTCjbjb2cR9srgVrgXvq2VvDPvl7ZGxxBuNEQDBfUKn7XZ
5j27zkDe9xyQvNCOOkdE4NNkjLDzXm1qAeYExD9q97CcvhoPgWE=
=H0Hk
-----END PGP SIGNATURE-----

--cfKSWcIUAFsobvtVuRlOuVZvAJ4dmUWIo--
