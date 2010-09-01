Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o810mKl0093324 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 19:48:20 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D9001799C48
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:48:57 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id D3UxYqR3ko5GwQ1z for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:48:57 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 95A70616
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 02:48:56 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 49F8A401C2F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 02:48:56 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: ultra fast XFS now - thanks
Date: Wed, 1 Sep 2010 02:48:54 +0200
MIME-Version: 1.0
Message-Id: <201009010248.55140@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6213911237263843828=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6213911237263843828==
Content-Type: multipart/signed;
  boundary="nextPart1451650.LRgksgOnCq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1451650.LRgksgOnCq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I'm on the way to copy the data to the newly formatted drives, and I=20
just got 109MB/s for a 6GB file, copied with rsync from one PC to the=20
other over Gb/s LAN. That's damn pretty close to the 125MB/s you can get=20
from a Gb/s LAN, and it's cool that it's possible to even copy files at=20
that speed.

Great job, all developers of XFS, the networking, and the kernel in=20
general. And of course the hardware from AMD, Asus, Areca... great.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1451650.LRgksgOnCq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx9ovcACgkQzhSR9xwSCbQxOwCbBo/SlVc4xbkbbyHQZ9gOD13c
vGUAniRxELiQo7a9wHc/KgZjR/hB0SSX
=Wwpy
-----END PGP SIGNATURE-----

--nextPart1451650.LRgksgOnCq--


--===============6213911237263843828==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6213911237263843828==--
