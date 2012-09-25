Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8PGbRSB079475 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 11:37:27 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id zpT2LvLGwx8RFgrV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 09:38:41 -0700 (PDT)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/3] rename configure.in to configure.ac
Date: Tue, 25 Sep 2012 12:38:39 -0400
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
	<20120925094113.GJ9189@infradead.org>
In-Reply-To: <20120925094113.GJ9189@infradead.org>
MIME-Version: 1.0
Message-Id: <201209251238.40010.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3903269219482569026=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--===============3903269219482569026==
Content-Type: multipart/signed;
  boundary="nextPart3574428.dq1uN1LbaO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3574428.dq1uN1LbaO
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 25 September 2012 05:41:13 Christoph Hellwig wrote:
> On Mon, Sep 24, 2012 at 07:39:36PM -0400, Mike Frysinger wrote:
> > Newer autotools warn and start to error with the older name.
> >=20
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> >=20
> >  configure.in =3D> configure.ac | 0
> >  1 file changed, 0 insertions(+), 0 deletions(-)
> >  rename configure.in =3D> configure.ac (100%)
> >=20
> > diff --git a/configure.in b/configure.ac
> > similarity index 100%
> > rename from configure.in
> > rename to configure.ac
>=20
> Is there a patch version that can track this now?

`git am` should do the right thing.  patch-2.7 should also process this=20
correctly (although you might want to get the latest 2.7 snapshot since it=
=20
fixes a few bugs in the 2.7 release).
=2Dmike

--nextPart3574428.dq1uN1LbaO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQYd4PAAoJEEFjO5/oN/WBAi0QAMTxxEOGp8MHuLn7p/xgsoMq
S+k9LGJvmVEJ7PaA6QzTuQpAwM/62ttszZmHy22o7lLUAEC3yH4gg4GVycE5MdBB
kaoiYZVXzOfcgq8fMNy52DK1kthOor/gkxUQnc+V/gr/wQqE2uv1GYqZMNEQLx7y
bmHIyrMf9SlkP2a6oBRdXGpbQUTIy9rn08SXogrryCTEQLjGjB/qfrIBmVQa/xD1
O7/9R5CP+6nt9CbZvor1yJgh+syXA1m2o1z1uOCkmQDFzWbKRCUDbCbHaoDFrCAc
sgw2608LAmxB/zG0mgIwV7unyYUTuLEIaC/inw1RIhRF1pfjJM9T37MNInsVPbx0
yJS7p+3fJZtF0VdzbyJn/UgZUZM4Lfqq+Hx7K+uqg1D0gEtblPXrv7kvhvGvZuW+
xss4sxCpqvv2cy3yWx1Djkr20fGUK7cUKLhrAGyMctVoYU3/KuMaC299Uqg+zRRN
Cw1dRDcC2+0unki1uXm1eLMLLyldF1z+/Rssc1QEAWQrrOFBnXkRwxd+E4CSvEik
okZQoTfU5WaTYiECHnvIVd15IVR2nwSPH8ZItk8L2zDBRVzaTTzKfhjG9o/wju2b
O5+y8mvHZxdL41FcReJPzdKRnsfewqU5+3vSg1b+lyeX/gaxNw72TkjaZ+sHEjCe
LcBHvurQK2+qUcDKNxgn
=i7pe
-----END PGP SIGNATURE-----

--nextPart3574428.dq1uN1LbaO--


--===============3903269219482569026==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3903269219482569026==--
