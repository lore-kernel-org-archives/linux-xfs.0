Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3G88LDA233804 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:08:21 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2344012A82E8
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 01:10:16 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 5uZWpMW3n2KVtULb for
	<xfs@oss.sgi.com>; Fri, 16 Apr 2010 01:10:16 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS hang during xfs_fsr run
Date: Fri, 16 Apr 2010 10:10:14 +0200
References: <4B8F871C.60802@dermichi.com>
In-Reply-To: <4B8F871C.60802@dermichi.com>
MIME-Version: 1.0
Message-Id: <201004161010.14607@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4502153713021322765=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Michael Weissenbacher <mw@dermichi.com>

--===============4502153713021322765==
Content-Type: multipart/signed;
  boundary="nextPart2579376.P8WhBqMqhM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2579376.P8WhBqMqhM
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 4. M=E4rz 2010 Michael Weissenbacher wrote:
> Is there anything i could try to rectify or at least narrow down
>  this  problem?

Sorry I only found this thread now after looking for xfs_fsr related=20
threads, and I don't follow the list regularly currently.

I've had crashes once with xfs_fsr, only to find that my filesystem was=20
a bit broken (which lead to an improved xfs_repair, btw).

Michael, did you try to xfs_repair once to check if you got errors?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2579376.P8WhBqMqhM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvIG2YACgkQzhSR9xwSCbSKCgCg0zzjDFdkTPMiHqnWnjNfXezF
r2oAoIKxcrqTMb7exUdHTXDRbIH9H0og
=3RK8
-----END PGP SIGNATURE-----

--nextPart2579376.P8WhBqMqhM--


--===============4502153713021322765==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4502153713021322765==--
