Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5B2D7CB8
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 05:51:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 659828F8037
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 03:51:13 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id hfojyt79l5amujJ8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 29 May 2016 03:51:08 -0700 (PDT)
Subject: Bug#822369: fixed in qemu 1:2.6+dfsg-1
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.822369.B822369.146451895122270@bugs.debian.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
From: James Clarke <jrtc27@jrtc27.com>
Date: Sun, 29 May 2016 11:48:57 +0100
Message-Id: <EF224558-AF7E-4737-8B5B-E535D63DE335@jrtc27.com>
References: <573DCFAA.8000500@physik.fu-berlin.de>
	<573DD225.5040502@msgid.tls.msk.ru>
	<573DD3CC.6040608@physik.fu-berlin.de>
	<573DD6AF.5020608@msgid.tls.msk.ru>
Reply-To: James Clarke <jrtc27@jrtc27.com>, 822369@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0677890552914828060=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: 822369@bugs.debian.org


--===============0677890552914828060==
Content-Type: multipart/signed; boundary="Apple-Mail=_A79FCB1A-BC31-4534-96B5-E0403D0211F4"; protocol="application/pgp-signature"; micalg=pgp-sha512


--Apple-Mail=_A79FCB1A-BC31-4534-96B5-E0403D0211F4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Control: affects -1 - src:qemu

On Thu, 19 May 2016 18:07:27 +0300 Michael Tokarev <mjt@tls.msk.ru> wrote:
> Control: affects -1 - qemu
> Control:

That should have been src:qemu; fixed above :)

Regards,
James


--Apple-Mail=_A79FCB1A-BC31-4534-96B5-E0403D0211F4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJXSskdAAoJELGTdwwYahx9uzoP/ArmUpIEvGKbgp/oJjRCXipv
7/A3KADkzt8BsAXpziDuyLl8H7Lfq1kykR6JuRBEZzWyzFXbVw5EFl9tb60lmoH5
CidR4bBuTdoI/fntY8NeCSocYIXosTWcuipS67G6vkqyWuxWckufjEbeJP1DWOpH
UurKT+2MpC8iueGKj5w0q9S9PMtfsujLjOIGk5EBMwgY9lUImswAj9OqIjKiEXZd
aqA7BDuILrCp08uYD9ALygu/iYWbbw4scTpq0DP/UZqS30Gdm/8DqsjFUZEkA4WB
9k9XCHu5flDjUn58QTCxQuBrU54jG/l9GbtcP9UPP2mqvO96SzkImKvKhyeVOe7/
IH7xcAqWpSU1mp2163XcptrOUfJIcQxfHerJfV8BN8gYy7hvardNSfMN0xD1mkud
hqyVHRQG4eqaU21Q1Z02lPJRaWosMK7XLaL5VNsrbOZ/rwR3lgFjwAbRWvb+wIoP
fxIzss5ITUiU2Mc46fuTlahpukqK141gCyMvziEADHDU/3Kz7rahBzcVenIoIXEd
JZgd+naBbS21JIIhKQIYDwteeyKaPwayxgLgXo8000/bhGGppiR6AXmEz8XFCSZT
Qr2KT71viETvWlMVXUfnxWAD+KqXZrM1hoZaTz9iIHaEu9XY9mVgAFQ8HxEdj0GC
8SGLOswXM3HkhH1sKVJO
=M2tZ
-----END PGP SIGNATURE-----

--Apple-Mail=_A79FCB1A-BC31-4534-96B5-E0403D0211F4--


--===============0677890552914828060==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0677890552914828060==--
