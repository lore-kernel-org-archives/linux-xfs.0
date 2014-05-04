Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4EFDA7F60
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 18:16:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 470FC304053
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 16:16:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	o4GAHAy5emknm6Pp for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 16:16:02 -0700 (PDT)
Date: Mon, 5 May 2014 09:15:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs: 3.2.0-rc2 release tagged
Message-ID: <20140504231548.GT26353@dastard>
References: <20140502000508.GA26353@dastard> <536437AD.9020303@sandeen.net>
	<20140503025800.GI26353@dastard> <5364654C.3080009@sandeen.net>
MIME-Version: 1.0
In-Reply-To: <5364654C.3080009@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1683991395958769959=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


--===============1683991395958769959==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 10:41:00PM -0500, Eric Sandeen wrote:
> On 5/2/14, 9:58 PM, Dave Chinner wrote:
> > On Fri, May 02, 2014 at 07:26:21PM -0500, Eric Sandeen wrote:
> >> On 5/1/14, 7:05 PM, Dave Chinner wrote:
> >>> Hi folks,
> >>>
> >>> The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
> >>> just been updated.
> >>>
> >>> The new head of the master branch is commit:
> >>>
> >>> 67fcc94 xfsprogs: v3.2.0-rc2 release
> >>>
> >>> This commit has been tagged with v3.2.0-rc2. I'd like everyone who
> >>> can test this to test it, as all the issues that needed to be solved
> >>> before a release coul dbe made have now been addressed. If there are
> >>> no new regressions or critical issues reported in the next week or
> >>> so, I will make an official 3.2.0 release. So, please test. :)
> >>
> >> Any chance for a signed tarball?
> >=20
> > Do we need one? I can generate one, but I'm not 100% sure where we
> > are putting them up online....
>=20
> The others are at ftp://oss.sgi.com/projects/xfs/cmd_tars/
>=20
> I dunno, I think distros usually expect to be able to grab a
> tarball...

OK, I've uploaded a signed tarball to that location with the sha1sum
of:

93f3dd8818a749e718fd75e8dd48c466570a402c  xfsprogs-3.2.0-rc2.tar.gz

FWIW, that set of "release" directories is a wasteland of old
releases, rpms, stuff moved out of the way because of mistakes, etc.
There is no consistent use of permissions or users, README files are
out of date, etc. Any suggestions on what should be done to clean
this up?

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTZsojAAoJEK3oKUf0dfodY+kQALNZCRBxWdnR+WM2Nk7BZR+2
pon/WX8ekmj5DZXJ8Rc+Dw7/eVCpjBuvotT++l/6B4Nl37EnjU504S/JV21Wzxr9
b/bj1L8r4moDzgQP4iLLDLL5JYoktanu53QJo6wSIhR0gbCJBpj6hDgZ+K2zOafo
852PiMEjXl6uN7RkMU83zgRtSRed/rgmu/Y2IbRaSsUPzqfyQwIcaY2anxDSWJwd
x1uwLQ5uUZrSU8REPY48z8pUipyA/v/ZvZT4TYAGz5yXkHYa2T2Ih0Yh1nb+i4JK
iy1D56hUVtk++aDMXTzpgwkhWIz7DA65q2THq7hrZi9meUgV/hEJ0BwXxkDJPDKN
thNEeYv9rq7ZudEa0hwjZOuFE+W9BpSLxGgIxHmw5ND4/H6U0Ux7dL/z1vSu1hOt
2E8ZqZ0aWBHbWxgbQPobLa0Gl8qqVUwLWjZjYlA5lWJQ9LV13hAnBBUQy80nsmVg
uPNMYYpVAc/8qbrsqVDc9qcLYufjhhrlNNZ2qz/ludCLXdGMiPFCGI6wHi+3lpo/
e4VMiyN48T76HT7/43+oVUOCiPJ59X/wKEK7KReeESFET9q12gT/7vEGnJknGltB
Ut8qM8rEzuHtapxlCXDdM685GmzF/CJ+eYZuvf/qgj9ggrQTUzEc7Duv30/rlKdD
ZjjOIYeFg33nsPOdP73n
=DB9P
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--


--===============1683991395958769959==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1683991395958769959==--
