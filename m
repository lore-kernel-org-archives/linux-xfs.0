Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GLNAVc017402 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 16:23:10 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 613BCDFB15C
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 14:35:56 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id qYci5Bn1CvquKIOK for
	<xfs@oss.sgi.com>; Thu, 16 Sep 2010 14:35:56 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id B98C412D
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 23:23:56 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id A51D8401C3D
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 23:23:54 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: System partially unusable after power loss...
Date: Thu, 16 Sep 2010 23:23:53 +0200
References: <i6ttq6$41d$1@dough.gmane.org>
In-Reply-To: <i6ttq6$41d$1@dough.gmane.org>
MIME-Version: 1.0
Message-Id: <201009162323.54133@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3941617611869468017=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3941617611869468017==
Content-Type: multipart/signed;
  boundary="nextPart4195562.T40Uu7kZ94";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4195562.T40Uu7kZ94
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 16. September 2010 Manuel Reimer wrote:
> it found some zero byte files=20
=20
I've had the same issues, that's why I now run my KDE directory on an=20
ext4 partition again. I really love XFS, but KDE it seems doesn't sync=20
enough, or always changes some files, as I've had crashes at a time=20
where nobody worked still some KDE config files were 0 afterwards.=20
Luckily, I do a nightly backup of all those files too.

Sorry this is no help for you, I know. But a nightly rsync of the KDE=20
dir would be good to do, just in case...

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

--nextPart4195562.T40Uu7kZ94
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkySiuoACgkQzhSR9xwSCbR1xgCg1AWa5fc+veEP8nXyfadaQwF5
TX4AoMnp/K+8U0A+R443HrM0QCNbAhpw
=9wNl
-----END PGP SIGNATURE-----

--nextPart4195562.T40Uu7kZ94--


--===============3941617611869468017==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3941617611869468017==--
