Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R8IOKj174317 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 03:18:25 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 630551BE8447
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:21:28 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 9XVGf3TiVO2Xl13s for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:21:28 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Tue, 27 Jul 2010 10:21:22 +0200
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100726230653.5da272c1@galadriel.home>
	<89B1ECDD-E9F4-4044-953A-76987AAF8EFE@ucsc.edu>
In-Reply-To: <89B1ECDD-E9F4-4044-953A-76987AAF8EFE@ucsc.edu>
MIME-Version: 1.0
Message-Id: <201007271021.26258@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1857394867323454339=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eli Morris <ermorris@ucsc.edu>

--===============1857394867323454339==
Content-Type: multipart/signed;
  boundary="nextPart12950003.9bv3RsQ7RH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart12950003.9bv3RsQ7RH
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 27. Juli 2010 Eli Morris wrote:
> Thanks. I tried a Knoppix live DVD (latest version) today and it does
>  seem to have xfs-progs, but I can't get it to recognize the lvm
>  volume that the filesystem is on. LVM2 programs are available, but
>  'vgscan  --mknodes' turns up nothing. I'll continue to look into it,
>  but if anyone has any ideas, please let me know.
=20
A plain openSUSE DVD http://opensuse.org/ has a "rescue system" on it,=20
available in every language. It has LVM and XFS support with it.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart12950003.9bv3RsQ7RH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxOlwYACgkQzhSR9xwSCbTKMACgwbnfnasBWrUYzeUsE6DTU023
cP0An0Nodxu84cz4sJ1ZR+tzTa4Asrza
=nozq
-----END PGP SIGNATURE-----

--nextPart12950003.9bv3RsQ7RH--


--===============1857394867323454339==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1857394867323454339==--
