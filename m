Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 21:07:08 -0700 (PDT)
Received: from ipmail01.adl2.internode.on.net (ipmail01.adl2.internode.on.net [203.16.214.140])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9V471Bc014457
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 21:07:03 -0700
Subject: Re: Default mount options (that suck less).
From: Stewart Smith <stewart@flamingspork.com>
In-Reply-To: <4725F732.2060509@sandeen.net>
References: <20071029075657.GA84369978@melbourne.sgi.com>
	 <4725E84D.3030609@sandeen.net> <4725F6C0.3020303@theendofthetunnel.de>
	 <4725F732.2060509@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hUGNsWMUTwMtaamSOwT8"
Date: Tue, 30 Oct 2007 19:40:05 +1100
Message-Id: <1193733605.9551.18.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Hannes Dorbath <light@theendofthetunnel.de>, Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

--=-hUGNsWMUTwMtaamSOwT8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-10-29 at 10:07 -0500, Eric Sandeen wrote:
> Hannes Dorbath wrote:
> > On 29.10.2007 15:03, Eric Sandeen wrote:
> >> Niv Sardi wrote:
> >>> XFS's default mount options are in most cases sub-optimal, we should =
try
> >>> to have more sensible defaults, so far I'm following some quick dave-=
powered
> >>> recomendations:
> >=20
> > Is there any reason to not set the default inode size to 512 bytes? ..a=
s=20
> > suggested in:
> >=20
> > http://www.suse.de/~agruen/acl/linux-acls/online/
>=20
> attr2 should help with the problem now... unless there is some common
> case where attr2+256 still spills out a lot?

Probably SELinux+Beagle attributes?

Attribute "Beagle.Fingerprint" has a 25 byte value
Attribute "Beagle.Uid" has a 22 byte value
Attribute "Beagle.MTime" has a 14 byte value
Attribute "Beagle.Filter" has a 36 byte value
Attribute "Beagle.AttrTime" has a 14 byte value

That's 111bytes just for values...
--=20
Stewart Smith (stewart@flamingspork.com)
http://www.flamingspork.com/


--=-hUGNsWMUTwMtaamSOwT8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUARybt5b3yNwHyU3DLAQJZ3BAAlPp6ANf04XWkdSJMVk2qwPfZwnh/QawC
7RnsoRaeaOBR1mqZIlcF2f6dIuZ+G24G+mPsWhuKVCLtzhJRnjNlT7e9UpQAwpf8
4Q7miKTygp8WOKZ9iiihPe0PrkJOa+hV3qnYYDWQPn7MGWWttistUqp+qim7QKxj
WdujFKl3fondKKhgsi59YNCtxOGhSPUYlQlGmrlcwEAwRyuySmDCsunQcTgHpO48
FN/0nacZkLS+sRK6ry9kV/SJGY7eIjvLqRTleT5ZAcQBBD9led1BJzns3hVF4KeL
jVNOt2lruZrQrH2SiT0QRm6k9jrGKHK3sgrorf1sNWZGtjSqAuGTqxFCV++JY1zM
91J9RteswoQRO1gTax2OdZcAzGJZbg4kXassAZc5+kjQLKXRDJnbCYH5RkR+t8/p
eRDR2HyA76813SGq9bh7n7eGLhYshiyqjUfqMDDpG2pDSJcyK34nlrZuop0QzRLa
+MA7opymuqsESGLHvzyf8TCeKqAXKKGa1XiEtjhpz6ygc1h6DhHLxV71gaPNOBTE
OcBDluUmUNZAhLB2fdalA0+r9DmhYEhMUV52xZHFqr3/p5woaut7VSeyQOkIhZyu
SMoTR0JHY7Rm5XmCbdCJ+wGCHwnXgGYnchteMCaxnbwi0XKwVf33Pg3u0he42vtu
bXZ/wCgfyWc=
=2wFf
-----END PGP SIGNATURE-----

--=-hUGNsWMUTwMtaamSOwT8--
