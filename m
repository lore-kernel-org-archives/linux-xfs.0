Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NGQmiu100669 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 10:26:48 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEA941978FAA
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 08:26:16 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id 5wbASbrT5UWnaAhd for
	<xfs@oss.sgi.com>; Mon, 23 Feb 2009 08:26:16 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: xfsprogs/xfsdump release process
Date: Mon, 23 Feb 2009 11:25:43 -0500
References: <200902221348.51905.vapier@gentoo.org>
	<20090223072207.GA4112@infradead.org>
	<DCA2D97E-F9A4-4A9E-BC39-CFFF1D0AD2CD@sgi.com>
In-Reply-To: <DCA2D97E-F9A4-4A9E-BC39-CFFF1D0AD2CD@sgi.com>
MIME-Version: 1.0
Message-Id: <200902231125.44076.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0095341227722160345=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

--===============0095341227722160345==
Content-Type: multipart/signed;
  boundary="nextPart1397339.pXsarFde7N";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1397339.pXsarFde7N
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 23 February 2009 11:10:44 Felix Blyakher wrote:
> On Feb 23, 2009, at 1:22 AM, Christoph Hellwig wrote:
> > On Sun, Feb 22, 2009 at 11:00:45PM -0600, Felix Blyakher wrote:
> >> Mike, you're absolutely right here. The config files got into the
> >> dmapi tarball by mistake, sorry for this. I verified that neither
> >> xfsprogs nor xfsdump have any extra files. New (clean) dmapi tarball
> >> will be on the oss site shortly.
> >
> > Please don't overwrite already uploaded tarballs.  Let's make a 2.2.10
> > release instead.  We might just use the Makepkgs script for it after
> > fixing it.  See the question and patch on the list for xfsprogs for
> > that, haven't checked dmapi works right yet.
>
> Didn't think that removing the unneeded files from the package
> justifies the version bump. It doesn't change anything for people
> who already downloaded unclean dmapi tarballs.
> Though, if opinion on this matter is that strong, I'd definitely
> bump the version, and will use updated Makepkgs.

the problem is for people (like Gentoo) who already fetched the tarball,=20
hashed it, and posted the resulting URL/hash to their packaging systems ...
=2Dmike

--nextPart1397339.pXsarFde7N
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJos4IAAoJEEFjO5/oN/WB8aAP/RrJaLZLuK/L2U7phewUfZ2/
LmR8sLgP2eVk1Zo2h+QyqE+xMgDrRhcISGvhqW4rdev9wdjVdYp9hPWBDsX0PhWw
l67u555d4ie1s/0sMfhR6enwhyxWy2LQGYHUDN3X605aWlhFJQknGNOkvKjS10Pw
xYI4TkqZ/Ag+tHjdeXAGxQJwrA77JRyCVwiG22/9gcnA0Jmw3xqhn4rJDk1g8mmS
K/ujuzIZDpmr1f7xw/JTVa19LKZeyuIPs4vaIqWsz70WORYWvp5uUmEmzYxcMjH0
ZHFktrR83UESuB5OUNtbYUnrNYZhpoC/CXe98NMLw3NX4JVXjUIHRxoVgwGSSWbr
f13HqCmaZfKVw2b6jEa6LgcA4Pb/lly2DBFjgyLdy8QHWgxEVTMK8KqRaB8GvD+Z
ZLbGyc91jatGaTjNNIzi39QMUYLYVXQshQJbJiQ/5ha+mw/o+10l4ddmcvWDo46s
dXLVj0LD7tvUcqluiGcqzGV4Qs2rQaPzTPJA8HBcOSwVyDZlXI//1qcPYBimSHyl
bIQC/Xwg4sGDvndh4WfboYv5+0zIzeVh+4KrTHWMA3erElkbGR1qejgaQlzv6HXT
svIYeaYI+eXYlsAV6LYtHW5JphMizlsAJbLrVDtrmEd+Ud6bBeDmQ3VczSkVmYPq
rw50bvDzW9QboPnf9hrJ
=uwN7
-----END PGP SIGNATURE-----

--nextPart1397339.pXsarFde7N--


--===============0095341227722160345==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0095341227722160345==--
