Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SJG3sX169737 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 13:16:04 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C81894D8ADA
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 11:18:27 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 91Z1WOyDLpWcHCcA for
	<xfs@oss.sgi.com>; Fri, 28 Jan 2011 11:18:27 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs: very slow after mount, very slow at umount
Date: Fri, 28 Jan 2011 20:18:11 +0100
References: <4D40C8D1.8090202@teksavvy.com> <4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	(sfid-20110127_220503_352851_8BD9DFC6)
In-Reply-To: <4D41CA16.8070001@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201101282018.12247.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0216488086236673682=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Mark Lord <kernel@teksavvy.com>, Stan Hoeppner <stan@hardwarefreak.com>

--===============0216488086236673682==
Content-Type: multipart/signed;
  boundary="nextPart3926807.QEyy5ibxh2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3926807.QEyy5ibxh2
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Thursday 27 January 2011 schrieb Stan Hoeppner:
> Trust the defaults.  If they give you problems (unlikely) then we can't
> talk. ;)

With one addition: Use a recent xfsprogs! ;)

Earlier ones created more AGs, didn't activate lazy super block counter=20
(likely no issue here) and whatnot...

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3926807.QEyy5ibxh2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk1DFnQACgkQmRvqrKWZhMc2qwCgrnlXK8kUFcYrtLFEyX6XzsW3
tU0AoKhzXci4d/RObXp7lZnjWofQXv7y
=FYnv
-----END PGP SIGNATURE-----

--nextPart3926807.QEyy5ibxh2--


--===============0216488086236673682==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0216488086236673682==--
