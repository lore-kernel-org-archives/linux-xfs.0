Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KFtI77112443 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 09:55:18 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id HIIrB081dCfASMDm for
	<xfs@oss.sgi.com>; Fri, 20 Jan 2012 07:55:16 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Optimal XFS formatting options?
Date: Fri, 20 Jan 2012 16:55:13 +0100
References: <33140169.post@talk.nabble.com> <4F192DEC.4030400@tlinx.org>
	<20249.22727.359884.733592@tree.ty.sabi.co.UK>
In-Reply-To: <20249.22727.359884.733592@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Message-Id: <201201201655.14532@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7092368696015141471=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7092368696015141471==
Content-Type: multipart/signed;
  boundary="nextPart3114634.oXA9GcmVNK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3114634.oXA9GcmVNK
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 20. Januar 2012 Peter Grandi wrote:
>   * There be 32b inode numbers, which limit inodes to the first
>     1TB of a filetree if sector size is 512B.
>=20
>   * The 32b block IO subsystems limits partition sizes to 16TiB.

I thought those two have been removed by some updates? I think I=20
remember to have read that. Not that it's too interesting, I've been=20
running on 64b Linux everywhere since AMD has put it in their=20
processors. Should be 10+ years or so.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart3114634.oXA9GcmVNK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk8ZjmIACgkQzhSR9xwSCbTJ5wCfUBwCbZ9KIRAcbbdn3G/WZDXS
OGYAnic3Brmsksv3E+VjDhWFzoBkmYRh
=yq2B
-----END PGP SIGNATURE-----

--nextPart3114634.oXA9GcmVNK--


--===============7092368696015141471==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7092368696015141471==--
