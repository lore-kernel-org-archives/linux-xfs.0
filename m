Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84AFD7F47
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 00:02:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 66A3B8F8035
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 22:02:19 -0700 (PDT)
Received: from nm7-vm10.bullet.mail.sg3.yahoo.com
	(nm7-vm10.bullet.mail.sg3.yahoo.com [106.10.148.185]) by
	cuda.sgi.com with ESMTP id TxXDY56pXbSyrvi8 (version=TLSv1
	cipher=ECDHE-RSA-RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 22:02:17 -0700 (PDT)
Date: Thu, 17 Sep 2015 05:02:10 +0000 (UTC)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Message-ID: <206349252.651888.1442466130259.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <55FA0DA2.5050609@opensuse.org>
References: <55FA0DA2.5050609@opensuse.org>
Subject: Re: XFS FAQ - out of date?
MIME-Version: 1.0
Reply-To: Gim Leong Chin <chingimleong@yahoo.com.sg>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0099162577562659487=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <carlos.e.r@opensuse.org>, XFS mail list <xfs@oss.sgi.com>

--===============0099162577562659487==
Content-Type: multipart/alternative;
	boundary="----=_Part_651887_860286939.1442466130254"

------=_Part_651887_860286939.1442466130254
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have openSUSE 13.2 on two computers, both have XFS V5 with CRC enabled on=
 the root partition and home partition.=C2=A0 There are no other partitions=
 other than swap and vFAT for UEFI boot on one of them.=C2=A0 GRUB is in MB=
R on one and in vFAT for UEFI boot for the new desktop.


Gim Leong

      From: Carlos E. R. <carlos.e.r@opensuse.org>
 To: XFS mail list <xfs@oss.sgi.com>=20
 Sent: Thursday, 17 September 2015, 8:47
 Subject: Re: XFS FAQ - out of date?
  =20
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2015-09-17 02:36, Viktor Trojanovic wrote:
> Hi,
>=20
> I just tried to do a fresh install of Arch Linux using XFS for my
> root system. According to the xfs.org FAQ, this is supported. But
> it didn't work.
>=20
> I later found (very few) sources that confirmed that Grub is not=20
> compatible with the current XFS level 5, that SuSE created a patch
> for the problem but it wasn't adopted upstream. If this is true,
> consider updating the FAQ. If it is not true, I would very much
> appreciate some hints how to do it properly.

I don't know if it is true or not, and I use openSUSE, so I'd have
that patch. However, in the past there have been problems with XFS and
grub, so my routine is to use a separate /boot partition and install
grub there.

- --=20
Cheers / Saludos,

=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Carlos E. R.
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 (from 13.1 x86_64 "Bottle" at Telcont=
ar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlX6DaAACgkQtTMYHG2NR9UlKQCbB4lfGsxqm/Niq6isjNqGn/Bi
n4EAn3t5NgIumeMwgrEnDxd18rPSoOGY
=3DJufm
-----END PGP SIGNATURE-----



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


  
------=_Part_651887_860286939.1442466130254
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:He=
lvetica Neue-Light, Helvetica Neue Light, Helvetica Neue, Helvetica, Arial,=
 Lucida Grande, Sans-Serif;font-size:13px"><div id=3D"yui_3_16_0_1_14424600=
38059_14638" dir=3D"ltr">I have openSUSE 13.2 on two computers, both have X=
FS V5 with CRC enabled on the root partition and home partition.&nbsp; Ther=
e are no other partitions other than swap and vFAT for UEFI boot on one of =
them.&nbsp; GRUB is in MBR on one and in vFAT for UEFI boot for the new des=
ktop.<br></div><div id=3D"yui_3_16_0_1_1442460038059_14653" dir=3D"ltr"><br=
></div><div id=3D"yui_3_16_0_1_1442460038059_14654" dir=3D"ltr"><br></div><=
div id=3D"yui_3_16_0_1_1442460038059_14711" dir=3D"ltr">Gim Leong<br></div>=
<div id=3D"yui_3_16_0_1_1442460038059_14387"><span></span></div><br>  <div =
id=3D"yui_3_16_0_1_1442460038059_14356" style=3D"font-family: Helvetica Neu=
e-Light, Helvetica Neue Light, Helvetica Neue, Helvetica, Arial, Lucida Gra=
nde, Sans-Serif; font-size: 13px;"> <div id=3D"yui_3_16_0_1_1442460038059_1=
4355" style=3D"font-family: HelveticaNeue, Helvetica Neue, Helvetica, Arial=
, Lucida Grande, Sans-Serif; font-size: 16px;"> <div id=3D"yui_3_16_0_1_144=
2460038059_14354" dir=3D"ltr"> <hr size=3D"1">  <font face=3D"Arial" size=
=3D"2"> <b><span style=3D"font-weight:bold;">From:</span></b> Carlos E. R. =
&lt;carlos.e.r@opensuse.org&gt;<br> <b><span style=3D"font-weight: bold;">T=
o:</span></b> XFS mail list &lt;xfs@oss.sgi.com&gt; <br> <b><span style=3D"=
font-weight: bold;">Sent:</span></b> Thursday, 17 September 2015, 8:47<br> =
<b><span style=3D"font-weight: bold;">Subject:</span></b> Re: XFS FAQ - out=
 of date?<br> </font> </div> <div id=3D"yui_3_16_0_1_1442460038059_14697" c=
lass=3D"y_msg_container"><br>-----BEGIN PGP SIGNED MESSAGE-----<br clear=3D=
"none">Hash: SHA1<br clear=3D"none"><br clear=3D"none">On 2015-09-17 02:36,=
 Viktor Trojanovic wrote:<br clear=3D"none">&gt; Hi,<br clear=3D"none">&gt;=
 <br clear=3D"none">&gt; I just tried to do a fresh install of Arch Linux u=
sing XFS for my<br clear=3D"none">&gt; root system. According to the xfs.or=
g FAQ, this is supported. But<br clear=3D"none">&gt; it didn't work.<br cle=
ar=3D"none">&gt; <br clear=3D"none">&gt; I later found (very few) sources t=
hat confirmed that Grub is not <br clear=3D"none">&gt; compatible with the =
current XFS level 5, that SuSE created a patch<br clear=3D"none">&gt; for t=
he problem but it wasn't adopted upstream. If this is true,<br clear=3D"non=
e">&gt; consider updating the FAQ. If it is not true, I would very much<br =
clear=3D"none">&gt; appreciate some hints how to do it properly.<br clear=
=3D"none"><br clear=3D"none">I don't know if it is true or not, and I use o=
penSUSE, so I'd have<br clear=3D"none">that patch. However, in the past the=
re have been problems with XFS and<br clear=3D"none">grub, so my routine is=
 to use a separate /boot partition and install<br clear=3D"none">grub there=
.<br clear=3D"none"><br clear=3D"none">- -- <br clear=3D"none">Cheers / Sal=
udos,<br clear=3D"none"><br clear=3D"none">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; Carlos E. R.<br clear=3D"none">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
(from 13.1 x86_64 "Bottle" at Telcontar)<br clear=3D"none">-----BEGIN PGP S=
IGNATURE-----<br clear=3D"none">Version: GnuPG v2.0.22 (GNU/Linux)<br clear=
=3D"none"><br clear=3D"none">iEYEARECAAYFAlX6DaAACgkQtTMYHG2NR9UlKQCbB4lfGs=
xqm/Niq6isjNqGn/Bi<br clear=3D"none">n4EAn3t5NgIumeMwgrEnDxd18rPSoOGY<br cl=
ear=3D"none">=3DJufm<br clear=3D"none">-----END PGP SIGNATURE-----<div clas=
s=3D"qtdSeparateBR"><br><br></div><div class=3D"yqt8629158387" id=3D"yqtfd5=
5324"><br clear=3D"none"><br clear=3D"none">_______________________________=
________________<br clear=3D"none">xfs mailing list<br clear=3D"none"><a sh=
ape=3D"rect" ymailto=3D"mailto:xfs@oss.sgi.com" href=3D"mailto:xfs@oss.sgi.=
com">xfs@oss.sgi.com</a><br clear=3D"none"><a shape=3D"rect" href=3D"http:/=
/oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http://oss.sgi.com/mai=
lman/listinfo/xfs</a><br clear=3D"none"></div><br><br></div> </div> </div> =
 </div></body></html>
------=_Part_651887_860286939.1442466130254--


--===============0099162577562659487==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0099162577562659487==--
