Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q5sO1w101927 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 00:54:25 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B1DC132F0E1
	for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 23:04:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id jUWByuhP4ddiPOiB for
	<xfs@oss.sgi.com>; Sun, 25 Jul 2010 23:04:41 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1D24917D
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 07:57:27 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 6156183C804
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 07:56:35 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Mon, 26 Jul 2010 07:57:26 +0200
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
In-Reply-To: <10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
MIME-Version: 1.0
Message-Id: <201007260757.26419@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4072142463758077860=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4072142463758077860==
Content-Type: multipart/signed;
  boundary="nextPart5072175.yPUAvpTk1W";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5072175.yPUAvpTk1W
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 26. Juli 2010 Eli Morris wrote:
> [root@nimbus log]# grep error dmesg
> [root@nimbus log]# grep superblock *

Did you "dmesg >dmesg" before that? Just to be sure every dmesg output=20
is really in that file. Maybe CentOS does this, I don't know, I just=20
wanted to be sure you didn't make a mistake here.

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

--nextPart5072175.yPUAvpTk1W
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxNI8YACgkQzhSR9xwSCbTKLACg8aHKfjneJC5NZ7WfAzQ2NSQm
SwsAnjJr0NMy5seI2mU2M8ROwtlO8AXe
=qV/7
-----END PGP SIGNATURE-----

--nextPart5072175.yPUAvpTk1W--


--===============4072142463758077860==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4072142463758077860==--
