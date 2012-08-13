Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DFlkYk017671 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 10:47:47 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 5nwAoP850Yf6V3xQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Aug 2012 08:47:43 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs warnings on kernel 3.2.15
Date: Mon, 13 Aug 2012 17:47:40 +0200
Message-ID: <3610628.Nzf1PdJg2L@saturn>
In-Reply-To: <20120811225742.GH2877@dastard>
References: <1918987.4hlisJiio3@saturn> <6314061.2K1xYxIYlT@saturn>
	<20120811225742.GH2877@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7636234261546047871=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7636234261546047871==
Content-Type: multipart/signed; boundary="nextPart23599331.t6FivW6bF2"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart23599331.t6FivW6bF2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Sonntag, 12. August 2012, 08:57:42 schrieb Dave Chinner:
> It's a problem that has been around for, well, since freeze was
> first introduced many, many years ago. And the complexity of the fix
> (20+ patch series, IIRC) makes it a difficult and time consuming fix
> that requires a lot of testing - it touches the VFS and has changes
> all through different filesystems, including XFS. I just can't see
> anyone other than enterprise distro vendors spending that much
> effort to back port such an intrusive fix....

Je compris. As it's such a longstandig bug, I guess it won't happen too=
=20
often worldwide. Or at least doesn't get reportet. I've had it twice in=
=20
several months, and I'll run 3.6 ASAP. Thanks for investigating!

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart23599331.t6FivW6bF2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlApIZwACgkQzhSR9xwSCbSSMQCghd8ZPOpAQSb2umH7BVymn7/z
R3sAoOk2gLVcItHK0sZ8sLX9kZVsSwgW
=bdBx
-----END PGP SIGNATURE-----

--nextPart23599331.t6FivW6bF2--


--===============7636234261546047871==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7636234261546047871==--
