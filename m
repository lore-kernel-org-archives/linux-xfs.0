Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38096 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751829AbeADUKw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 15:10:52 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9739E2AB8
        for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2018 14:10:51 -0600 (CST)
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to 532d03d
From: Eric Sandeen <sandeen@sandeen.net>
References: <edd1c5b5-1cb7-d777-1f9a-ca3e48263050@sandeen.net>
Message-ID: <ce766319-0d58-496c-236a-da9843aa663e@sandeen.net>
Date: Thu, 4 Jan 2018 14:10:51 -0600
MIME-Version: 1.0
In-Reply-To: <edd1c5b5-1cb7-d777-1f9a-ca3e48263050@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hhbDBoZlXOKM5KusxWOscwSObi3FLlhQO"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hhbDBoZlXOKM5KusxWOscwSObi3FLlhQO
Content-Type: multipart/mixed; boundary="QZ8EX6zh0t5mkuizmLoiTqldYctsdmYq2";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <ce766319-0d58-496c-236a-da9843aa663e@sandeen.net>
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to 532d03d
References: <edd1c5b5-1cb7-d777-1f9a-ca3e48263050@sandeen.net>
In-Reply-To: <edd1c5b5-1cb7-d777-1f9a-ca3e48263050@sandeen.net>

--QZ8EX6zh0t5mkuizmLoiTqldYctsdmYq2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/4/18 2:07 PM, Eric Sandeen wrote:
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
> 532d03d xfs_repair: fix libxfs namespace problems

Make that:

128491c find-api-violations: fix a broken grep pattern

now ;)  Missed that one somehow, sorry, so pushed it as well.

-Eric


--QZ8EX6zh0t5mkuizmLoiTqldYctsdmYq2--

--hhbDBoZlXOKM5KusxWOscwSObi3FLlhQO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlpOiksACgkQIK4WkuE9
3uBNGxAAnUqmuLCY6b+udZng1bgIaHVV9nwDRFJOwQYf6IkT0g5LP3TwrKvvweY6
HFEjMlbvAJdnDRw07W9SHQuzNykZ8ICQ4dy1jE+AhzwfCVV1xIgBnw3c1cxmleqb
8pstCtAw+YwEsTAqsoQ7k16dcLrCyDFoSX4Q53kATrf6ihuQ02ll0D8xVTO8PxP/
KKDml+6R2r2eaPsoMEUtEocTXeo3ELQ8YnkXfPTf1upoQDKvKFjs02KcsKoIpqXJ
68GtN4Oc1Q53oVC9UfqY4OKZj/aKE5exh63h71WKEI7TZ5G6wa+G5eiUrJlvwV6f
BYpdJv/Y4vMbjWTbfuVeSzrcErLzh3G+m+8LjG4Dl8mTUIMLjFRPo+6ByqtZtR1T
yoPX7fyL+P1QgPyAtpWiE7fN3VnqyK2prVBowTYSD4hAx+Z5hBGyE5LdOXCz7vwu
KDBcNHmHZxgtkqLnLshUsdlhxDFbl+GaYseuvieXCzhfGntYrEWv+Jpqp40rY/gy
dv0kSzte/Hnmnhw025a5FoEnFyGPozhYk37GPmbULuXMYDVTXLkkoV9k7Gr4bL9N
mZC+WWHNUypf71JgDTUA9fP9OjY3XV+vmkQWdF2EYZIPPBPw5yvEtKkd6/fckz2A
Q7qqe8CDlphpbmpvrQcoIeXsFmzXyyMsPLsz/7aZTsSeTCRv+fE=
=Sg1j
-----END PGP SIGNATURE-----

--hhbDBoZlXOKM5KusxWOscwSObi3FLlhQO--
