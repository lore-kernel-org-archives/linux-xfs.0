Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from buxtehude.debian.org ([209.87.16.39]:49635 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdCQPpa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 11:45:30 -0400
Subject: Bug#766811: spurious library links
Reply-To: Michael Biebl <biebl@debian.org>, 766811@bugs.debian.org
References: <20141026004825.GA27863@bongo.bofh.it>
 <20160124151308.GA7620@jwilk.net> <20160206005821.GA11551@bongo.bofh.it>
 <20160206132241.GA2869@jwilk.net> <20160210031703.GA28092@bongo.bofh.it>
 <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
 <785bca5c-7b92-1c20-7a68-7c8b79419fa4@debian.org>
 <CAFMei7NSLSmONCC6AT1hbyLi18e4MWkYwt9pjqBrWACBEa+AfA@mail.gmail.com>
From: Michael Biebl <biebl@debian.org>
Message-ID: <9f4d18b6-66b9-5014-4c8b-40ad63ecbbe0@debian.org>
Date: Fri, 17 Mar 2017 15:32:00 +0100
MIME-Version: 1.0
In-Reply-To: <CAFMei7NSLSmONCC6AT1hbyLi18e4MWkYwt9pjqBrWACBEa+AfA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l2biDVLEk5miXbHKNLpEjVbSlwx1s8IvA"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nathan Scott <nscott@redhat.com>, 766811 <766811@bugs.debian.org>
Cc: Nathan Scott <nathans@debian.org>, Marco d'Itri <md@linux.it>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l2biDVLEk5miXbHKNLpEjVbSlwx1s8IvA
Content-Type: multipart/mixed; boundary="AC9av7mvNxsH3mku7cjEDaqNCaqr09WT5";
 protected-headers="v1"
From: Michael Biebl <biebl@debian.org>
To: Nathan Scott <nscott@redhat.com>, 766811 <766811@bugs.debian.org>
Cc: Nathan Scott <nathans@debian.org>, Marco d'Itri <md@linux.it>
Message-ID: <9f4d18b6-66b9-5014-4c8b-40ad63ecbbe0@debian.org>
Subject: Re: Bug#766811: spurious library links
References: <20141026004825.GA27863@bongo.bofh.it>
 <20160124151308.GA7620@jwilk.net> <20160206005821.GA11551@bongo.bofh.it>
 <20160206132241.GA2869@jwilk.net> <20160210031703.GA28092@bongo.bofh.it>
 <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
 <785bca5c-7b92-1c20-7a68-7c8b79419fa4@debian.org>
 <CAFMei7NSLSmONCC6AT1hbyLi18e4MWkYwt9pjqBrWACBEa+AfA@mail.gmail.com>
In-Reply-To: <CAFMei7NSLSmONCC6AT1hbyLi18e4MWkYwt9pjqBrWACBEa+AfA@mail.gmail.com>

--AC9av7mvNxsH3mku7cjEDaqNCaqr09WT5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Nathan,

thanks for your quick reply

Am 17.03.2017 um 13:22 schrieb Nathan Scott:
>> So this NMU happened, but unfortunately your followup maintainer uploa=
d,
>> i.e. 4.5.0 did not include the changes from the NMU.
>=20
> (d'oh, these changes needs to be sent upstream to the kernel.org
> <http://kernel.org> XFS list)

I'm not sure about Marco, but I don't know the procedures getting a
patch into xfsprogs. So I would very much prefer if you forward the
patch to the right people.

>> Nathan, could you make another upload including the fix from Marco?
>=20
> I'm currently traveling and will be unable to attend to this for some t=
ime.

Should Marco or myself do another NMU then? I would send you an updated
debdiff in this case.

Regards,
Michael

--=20
Why is it that all of the instruments seeking intelligent life in the
universe are pointed away from Earth?


--AC9av7mvNxsH3mku7cjEDaqNCaqr09WT5--

--l2biDVLEk5miXbHKNLpEjVbSlwx1s8IvA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEECbOsLssWnJBDRcxUauHfDWCPItwFAljL82AACgkQauHfDWCP
ItwwPA//Qi3fjnj9+k8gyLvyF+OCJ3dWhj/jxVbdKTz0rqHfvXzOWgPlIeGXD5MR
s3gpaqHEOLLLJull0UJOwlaNweNzI5SDNHklQGF5VozHddqMF64v0P+k3QNf+h98
7JXtrhPenDwCVgcnEzOp8G6VCjKRBaSqRuUDNq30ragBZba4IBh2o6PLXogIR7cB
lujhcSysk3IXUt4bopJV+Svjjt4HfVJngWas0Xhd+p0GHikBtNJ/z7g7rOQ1XihF
OjkMiPl+xCVhxaPCDqwkJKGeF/xah//44XRJvzwSluntf2dgQsubULdRZD1RrNdo
GC1iMjW0Sam3DkPLiPlTgqZhq9zFvCaYcdH5r47ctZYXgEWZcCRehBboal4T9hlH
mRYGjet5y+Lm5vpEYc1UqFZg1m9n/P0D5xDUgqXrryOGGI0dpH5wSz5DWrKiltNK
dPlvVkNtWd8bfwD5Rcs9elIDn2d89F5yjT/w7LXQ7MKeIYDsL+6K6A/JkyYVby4q
oNO5eEVMxKk1LbTSjtJLgmv0t0i2FUnho0cJk4m/dRWbhs/TksHnfc3Fe/Ia+WGp
cfSgON9TQ5lD98BDOlt1ff36W1kdyIEqB6bNcyiOBO8BhGd9a698u5j3TlhJEPXp
tFmhiYOgvqxoKAh5D1rjqOiptEHYDDVacMjAMEPdjl/LhSjU0ok=
=4ite
-----END PGP SIGNATURE-----

--l2biDVLEk5miXbHKNLpEjVbSlwx1s8IvA--
