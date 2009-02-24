Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1ONkXA4173034 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 17:46:33 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A488814CF37
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 15:46:02 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id MXV7fj34DYf0hlzq for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 15:46:02 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Tue, 24 Feb 2009 18:45:25 -0500
References: <200902240010.25434.vapier@gentoo.org>
	<20090224184624.GC28007@infradead.org>
	<200902242322.48314.agruen@suse.de>
In-Reply-To: <200902242322.48314.agruen@suse.de>
MIME-Version: 1.0
Message-Id: <200902241845.27249.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7347422486000734359=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============7347422486000734359==
Content-Type: multipart/signed;
  boundary="nextPart3204449.yacFFphN2U";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3204449.yacFFphN2U
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 24 February 2009 17:22:48 Andreas Gruenbacher wrote:
> On Tuesday, 24 February 2009 19:46:24 Christoph Hellwig wrote:
> > On Tue, Feb 24, 2009 at 10:37:49AM -0500, Mike Frysinger wrote:
> > > but acl/attr have not.  distros care about those packages as well.
> >
> > Andreas who has done most of the maintaince already is taking these over
> > formally, so they won't be released with the xfs tools anymore.  I've
> > put him on Cc so he can say when he expects to clear the backlog.
>
> I think I have caught up with the backlog by now in my current trees:
>
>   http://git.kernel.org/?p=3Dlinux/kernel/git/agruen/attr.git
>   http://git.kernel.org/?p=3Dlinux/kernel/git/agruen/acl.git
>
> The repos are based on Christoph's initial git import, with all additional
> fixes added that I'm aware of. Please let me know if anything is missing.
>
> I expect that those repositories will move from where they are right now =
to
> their permanent new location soon, so please stay tuned ;-)

is this mailing list still going to be used for acl/attr ?

here are the patches i have for acl.git:
http://sources.gentoo.org/sys-apps/acl/files/acl-2.2.45-libtool.patch
http://sources.gentoo.org/sys-apps/acl/files/acl-2.2.45-linguas.patch

and for attr.git:
http://sources.gentoo.org/sys-apps/attr/files/attr-2.4.39-gettext.patch
http://sources.gentoo.org/sys-apps/attr/files/attr-2.4.43-linguas.patch

hopefully they should be self explanatory ... otherwise, feel free to ask o=
f=20
course
=2Dmike

--nextPart3204449.yacFFphN2U
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJpIaXAAoJEEFjO5/oN/WBtwoP/i21UYhLThZHr0fIR7CuJgIE
r38rmGlQ5GQVnKCu9zy0KsEBFZ/AF2akgkxhYp5QqGGNyaDK9Uo06ui4jfyBKomy
EpA6n+gzkGp3rdhLguUB/bvA4uEBTUd0FMdqL5ZkT1uY3MwI/rfBKC1gg5sbb/vD
RjgF2GhtO9cxShfEMzQjOF9FtqKq2BAFLnBZUcqnwnJr8jHEiFoBzXF9a2QBC/zf
B4RmIvMNdmBwF+Bgfa3dyEWt86kpPq8a/J8U7ak1oBxaM/rlYoq3JtdPZcOXzD6n
XI88JP4MCj7L87eMfveA88BIStryCps8VpvaPWQrVj74mooMXqifu8IOs4B5xtUk
pVlZeArYFvgKhsfI+YRVXGxWzDz5FIskgmWCJawXRGi05qTF3HffBRkgEo8NeUPb
8I3hcJkXqgjFVrbugNOVg070e5g1fo61pWmju4TcPq6gzb2VFllKSut+qWoPjZXI
8dbQmijFhbLydRsQDkMyB4pK29HkQn1r5FA4epouqclsIM+/Wx5rbUXVgtrXfnwb
LS+CPfy7CE4tElzDtZl0+xt1YP4aW5q5O1nkXfBKlvAUnvlsw/xkRIqPKzx5IH9r
7/YK8dy071KiOyM1zs3BBpVvyqqLWfRHaLsm429TkxNiQCrV1dgoiXQTxtWP5kMf
K9q9ze5fwTIPGWE7kzcM
=nycN
-----END PGP SIGNATURE-----

--nextPart3204449.yacFFphN2U--


--===============7347422486000734359==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7347422486000734359==--
