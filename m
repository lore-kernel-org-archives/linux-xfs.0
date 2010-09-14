Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8E5dUjW111353 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 00:39:30 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4050C17EF63E
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 22:40:16 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id UNZ9eG18t2PSPry1 for
	<xfs@oss.sgi.com>; Mon, 13 Sep 2010 22:40:16 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS Filesystem not mounting
Date: Tue, 14 Sep 2010 07:40:13 +0200
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705139.post@talk.nabble.com>
In-Reply-To: <29705139.post@talk.nabble.com>
MIME-Version: 1.0
Message-Id: <201009140740.14482@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5751180595800798742=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: pbrunnen <PBrunnen@bccnetworks.net>

--===============5751180595800798742==
Content-Type: multipart/signed;
  boundary="nextPart1498708.UgAuLeas0H";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1498708.UgAuLeas0H
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 14. September 2010 pbrunnen wrote:
> > What kernel version is that?
>=20
> 1.6.18.2-34-smp 32bit PAE
=20
I guess that should be 2.6.18 ;-)
So it sould like a very old and outdated openSUSE 10.x that doesn't=20
receive any updates since a long time. You should upgrade.

The xfsprogs you have will be very, very old too. Try downloading the=20
latest version. Also, can you install an actual kernel? I'm not a dev,=20
but there's a lot of activity going on in XFS, and trying the newest=20
kernel and newest xfsprogs often helps.

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

--nextPart1498708.UgAuLeas0H
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyPCr4ACgkQzhSR9xwSCbSWnwCgoauZk9sW2KVeFGg02uR3Mm/2
ta0AoNbc8yK7QZjpwGCbPqBSihl1asoH
=Y4g6
-----END PGP SIGNATURE-----

--nextPart1498708.UgAuLeas0H--


--===============5751180595800798742==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5751180595800798742==--
