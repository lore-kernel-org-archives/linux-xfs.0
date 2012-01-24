Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OAVEC6239467 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 04:31:14 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id lmOLWNrrlDjMkhew (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 02:31:12 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Optimal XFS formatting options?
Date: Tue, 24 Jan 2012 11:31:07 +0100
References: <33140169.post@talk.nabble.com> <201201201652.10193@zmi.at>
	<4F19EE5E.8030508@hardwarefreak.com>
In-Reply-To: <4F19EE5E.8030508@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201201241131.08645@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6836863657436780476=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, stan@hardwarefreak.com

--===============6836863657436780476==
Content-Type: multipart/signed;
  boundary="nextPart1489778.3zTZaZKNbC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1489778.3zTZaZKNbC
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 20. Januar 2012 Stan Hoeppner wrote:
> If ease (or cost) of filesystem administration is of that much
> greater priority than performance, then why are you using XFS in the
> first place instead of EXT?

Great experience in recovery of disaster filesystem problems on XFS. A=20
switch to another FS costs a lot of time, and why switch if it works=20
great? And administration comes down to mkfs, mount, maybe xfs_fsr, in=20
disaster xfs_repair, and sometimes xfs_growfs. Basically nothing.

Also, this list has been of great help during the years, whenever there=20
were problems they got fixed. That's ease of administration :-)

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1489778.3zTZaZKNbC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk8eiGwACgkQzhSR9xwSCbRLwACgwl7NSMF2VCRSN9Y7nrCNH7WU
VDAAoJ41Qvjs4hCP4rlrcUjZG8yU7YnE
=TIF4
-----END PGP SIGNATURE-----

--nextPart1489778.3zTZaZKNbC--


--===============6836863657436780476==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6836863657436780476==--
