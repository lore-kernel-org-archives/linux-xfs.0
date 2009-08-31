Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VJ1osd117258 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 14:02:00 -0500
Received: from QMTA02.emeryville.ca.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2873D1592B59
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 12:02:19 -0700 (PDT)
Received: from QMTA02.emeryville.ca.mail.comcast.net
	(qmta02.emeryville.ca.mail.comcast.net [76.96.30.24]) by
	cuda.sgi.com with ESMTP id AzGAf6rAWhkYmGCx for
	<xfs@oss.sgi.com>; Mon, 31 Aug 2009 12:02:19 -0700 (PDT)
Date: Mon, 31 Aug 2009 14:02:09 -0500
From: Tim Walberg <twalberg@comcast.net>
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831190209.GD19343@comcast.net>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org>
	<20090831183751.GC19343@comcast.net>
	<20090831184822.GA10393@infradead.org>
	<20090831184918.GB10393@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20090831184918.GB10393@infradead.org>
Reply-To: Tim Walberg <twalberg@comcast.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2141795789753179772=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, Tim Walberg <twalberg@comcast.net>


--===============2141795789753179772==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



On 08/31/2009 14:49 -0400, Christoph Hellwig wrote:
>>	On Mon, Aug 31, 2009 at 02:48:22PM -0400, Christoph Hellwig wrote:
>>	> On Mon, Aug 31, 2009 at 01:37:51PM -0500, Tim Walberg wrote:
>>	> > Linux sparcy 2.6.30.4-sparcy #2 Sat Aug 1 21:14:46 CDT 2009 sparc64 =
GNU/Linux
>>	> > sparcy:~# file $(which xfs_fsr)
>>	> > /usr/sbin/xfs_fsr: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Requi=
red, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux=
 2.6.18, stripped
>>	>=20
>>	> I'll take a look at that, thanks.
>>=09
>>	Err, sorry - is that with the patch I posted in this thread or without?
End of included message


No, that's the generic 2.6.30.4... I can attempt with that patch as well, b=
ut
it might be a day or two...

				tw


--=20
+----------------------+
| Tim Walberg          |
| 830 Carriage Dr.     |
| Algonquin, IL 60102  |
| twalberg@comcast.net |
+----------------------+

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqcHjEACgkQw+Wcj22rJWafGgCfezgV5i6D9BQzkaIjuDF2OaGe
OPMAoL74DPQlOVe+jY1lAVjM+lrj5bDJ
=ucVX
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--


--===============2141795789753179772==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2141795789753179772==--
