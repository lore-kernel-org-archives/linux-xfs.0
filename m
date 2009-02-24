Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OFcNIK151454 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 09:38:24 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59ED6149290
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:37:51 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id difxL1b8tLcXB55t for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:37:51 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Tue, 24 Feb 2009 10:37:49 -0500
References: <200902240010.25434.vapier@gentoo.org>
	<200902240953.56992.vapier@gentoo.org>
	<3C7B0B6E-1316-41CC-8846-356FDC780287@sgi.com>
In-Reply-To: <3C7B0B6E-1316-41CC-8846-356FDC780287@sgi.com>
MIME-Version: 1.0
Message-Id: <200902241037.50534.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2396425896862149427=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============2396425896862149427==
Content-Type: multipart/signed;
  boundary="nextPart2485465.scAhZf2ki8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2485465.scAhZf2ki8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 24 February 2009 10:14:13 Felix Blyakher wrote:
> On Feb 24, 2009, at 8:53 AM, Mike Frysinger wrote:
> > the xfs.org wiki talks about git trees on sgi.com,
>
> Yes, they're still there.
>
> > but some of them are old
> > and/or moved (like the xfs-cmds one) ...
>
> xfs-cmds was split into separate repos for xfsprogs, xfsdump,
> and dmapi. And that info is on xfs.org.

but acl/attr have not.  distros care about those packages as well.

> Here is the excerpt from the following page:

yes, i was reading the page.  i was also pointing out the broken link to th=
e=20
xfs-cmds repo (which is after everything you quoted) and that that repo see=
ms=20
to be dead now.  which means there is no up-to-date place for acl/attr on t=
hat=20
page.

> At times though the repos on kernel.org could be ahead of sgi ones.

well if people are going to try to help in development, the kernel.org tree=
s=20
would be good to mention on that page as well with a note as to which tree =
is=20
preferred (sgi.com or kernel.org).
=2Dmike

--nextPart2485465.scAhZf2ki8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJpBROAAoJEEFjO5/oN/WBUwEQANoGAxDqt82JUWxEOzddkK1P
pPbPVw3UEGfCJLyLRchHOcUVL4tApcPhsL0k1INlILYKKzs5/Z+hYSsEOCnoYJOV
2DJ0BsQIOPrn6srrsktwLoE+U+n2Oly89+SHPdufTSak9FGzaEeXZ4sj9C3448BV
QqkoiXykC0eCX2D+E4n4QdIqy4uBzf0+a3dJsNAtnhp8UYp1CHCRN57IF6WyQpef
cBBtZLgjDu2cpeyHWKZ7X3Q9B1vQf7hRrXiIruUOKOAfLpo0WjGJRPQ/CkL3qvk6
5fWF7OnRDHJJ22wM3jZU9FvxNm5KJSN5RrTGM0R71Se0xTEnYHQuN5EY7GyyIgOi
+6x7G1qpQlKrzdNnnudLDeIuUGQKgBdQ5BNSojvk+UY9Sus6QaOZW1PfKsqBBUha
XbxNS7rihjYwkZlAcORCtDW6zsi3RoTRrHXXQ+hXozwNGZlJ6tg1NkcPgJnzqVQC
g9hT9lmyNGb7DUepIYcKuYsYEHA5Jqajh/7CwRbcqQsFBmTu0keBSuB0CEdAqP22
RGe3V2Pj9RZcv7sFCIRdyCBJ7tvdh6rC0p1o1w/jGeATR5A2UJK5pYlMpZKlnKd2
wxdLxaJw0cgOvbrm21LpTy72/AVUonPYJ+W/Sgy0mIok02EQxxhNbxt/lQr1g709
Ey8GPjWzueouYFx/riX/
=5QV7
-----END PGP SIGNATURE-----

--nextPart2485465.scAhZf2ki8--


--===============2396425896862149427==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2396425896862149427==--
