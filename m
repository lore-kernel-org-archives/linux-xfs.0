Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB29Z9DN005951 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 03:35:11 -0600
Received: from aura.v7w.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFFEF9D20A4
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 01:35:07 -0800 (PST)
Received: from aura.v7w.com (vs832.rosehosting.com [209.135.157.232]) by
	cuda.sgi.com with ESMTP id ZFy9C9Kzb8EQWMtr for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 01:35:07 -0800 (PST)
Date: Tue, 2 Dec 2008 20:33:50 +1100
From: =?iso-8859-1?Q?An=EDbal?= Monsalve Salazar <anibal@debian.org>
Subject: Re: ia32 userland and XFS
Message-ID: <20081202093350.GC20730@debianrules.debiancolombia.org>
References: <4934914C.7050707@cox.net>
MIME-Version: 1.0
In-Reply-To: <4934914C.7050707@cox.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2387623988956847533=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ron Johnson <ron.l.johnson@cox.net>
Cc: debian-amd64@lists.debian.org, xfs@oss.sgi.com

--===============2387623988956847533==
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="kigERAySUJmIn/9g"
Content-Disposition: inline

--kigERAySUJmIn/9g
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

Adding xfs@oss.sgi.com to the cc list so all the XFS folk see this.

On Mon, Dec 01, 2008 at 07:37:16PM -0600, Ron Johnson wrote:
>https://alioth.debian.org/docman/view.php/30192/21/debian-amd64-howto.html#id292806
>
>According to this (seemingly 2+ year old) web page, the XFS file system
>chokes on the combination of 32 bit userland and 64 bit kernel.
>
>Is this still true, and why should a low-level driver hidden under a
>virtual fs care what user apps access it via the vfs?

--kigERAySUJmIn/9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk1APsACgkQgY5NIXPNpFX3TwCeIavSHdthu581b+pWK00X+oeZ
w40AnRzAr9UqI0glKpr2FZsdMlb7sSuC
=7zTP
-----END PGP SIGNATURE-----

--kigERAySUJmIn/9g--


--===============2387623988956847533==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2387623988956847533==--
