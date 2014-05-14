Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D5677F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 11:51:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B869AC00C
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 09:51:00 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id GdQskcmekTo2UkTY
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 09:50:58 -0700 (PDT)
Date: Wed, 14 May 2014 11:50:49 -0500
From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: Separate mailing list for xfstests
Message-ID: <20140514165048.GA20454@boyd>
References: <alpine.LFD.2.00.1405141508150.9727@localhost.localdomain>
	<53738316.20601@redhat.com> <53738597.70305@fb.com>
	<20140514160447.GA3974@thunk.org>
MIME-Version: 1.0
In-Reply-To: <20140514160447.GA3974@thunk.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3668249925357043773=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: tytso@mit.edu
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com, Chris Mason <clm@fb.com>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org


--===============3668249925357043773==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2014-05-14 16:04:47, tytso@mit.edu wrote:
> On Wed, May 14, 2014 at 11:02:47AM -0400, Chris Mason wrote:
> > >> linux-fsdevel might seem as a good candidate for it, but still I
> > >> think that it deserves a separate ML to point people to.
>=20
> I'm personally in favor of using linux-fsdevel since it might
> encourage more fs developers who aren't using xfstests yet to start
> using it.
>=20
> For example, we started investigating using xfstests to test unionfs,
> and pretty quickly found problems.  (I suspect the same problem exists
> in AUFS, BTW, but I've been focusing on unionfs because it's simpler
> and less scary.)  The patches to enable the use of xfstests to test
> unionfs are still pretty rough, but hopefully we'll get those sent to
> Dave once they are cleaned up a bit.

Oh, that sounds interesting. I haven't seen these patches, but I expect
they would be pretty easy for me to extend for testing eCryptfs. That
has been on my todo list for a long time but I haven't spent much time
working on eCryptfs lately.

BTW, you can use this email as a supporting data point for your first
paragraph. :)

Tyler

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTc57oAAoJENaSAD2qAscKHiQP/jMiLT4iqu2Fovh9zqIInjpe
tlw+SIdM5e9/s/mG9Gys706Ktvy/LyDAkYcBCNVePu5VlV6BTrXIlkkJwaW2F4wB
zzLm02xzPzq5Z+xnWRpNcscmEz68rzA2ciFVd1PuOqw1TscTNVmfoUUAsMXXUZgv
SD7M43OBHql0mTdPX65xmT2HhyYhnaL2KU1qqRvWcNT1MIuVIJ9GbkrD8sH2GzVn
cM9yvgEIopbijtuLlCTxXIwzPTFZq3oVcX9awEr0Tx1tVB7qM7Bw0OK+jt/wRpDH
NO0KCxGYqs7R223W1E9/pvzFs+A50n9rQihtoZEoieb6u4S/zMhmaSXTT2spOyoJ
t9AkeUJLITrFyzE9V7z3KIumC9de7s1VwhYCx/CjLM+ASVPx19kCH0CnmRapiO6v
zEMTabX23QV6noOI0C8CHpQ8ludLsUwbTKWpLYL6Z0qLCJeBwsVxXOlelDeKO0/6
yD998a6K9ziuJOGg4KjpGuur0QavFApt33D0c7tlRngFv/zT9pUxRSiSD0hjv2yl
vKm7uz60I4OOa6b31OYZrg9S4/0vTOyr1R6PEuBd7Jp8aQ/teUOz1mC7n/nnWlew
2BY8jZZRM3AVRI/Uq+K1axMjwgNUW9Zght1Px4Bd/zszE5yONro8MX18rkTf9HNL
uOmxQlf/VmP0cMFUXd+D
=+lOS
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--


--===============3668249925357043773==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3668249925357043773==--
