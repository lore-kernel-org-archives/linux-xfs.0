Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q8biL0109213 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 03:37:44 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2ABD471125
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 01:40:46 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id C32t2c6wT99u2DOh for
	<xfs@oss.sgi.com>; Mon, 26 Jul 2010 01:40:46 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1F5AF17D
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 10:40:45 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 4B4E283C804
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 10:39:53 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Mon, 26 Jul 2010 10:40:44 +0200
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100726060604.GF7362@dastard>
	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
In-Reply-To: <F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
MIME-Version: 1.0
Message-Id: <201007261040.44429@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6649953288251505671=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6649953288251505671==
Content-Type: multipart/signed;
  boundary="nextPart64039000.3Y2ujhHKv8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart64039000.3Y2ujhHKv8
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 26. Juli 2010 Eli Morris wrote:
>  let me know if Centos 5.4 is recent enough that it will fix the
>  problem.
=20
If not, maybe just install the latest vanilla kernel, do the growfs, and=20
when it works revert back to your working environment. As the problem=20
only exists for your growsfs, that should be sufficient and less PITA.

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

--nextPart64039000.3Y2ujhHKv8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxNSgwACgkQzhSR9xwSCbToKQCgzzs9C7ze0kBYFYY78wDIZYJk
NiYAoJmNMbr1Y1hszwonXE4AUn4Jm/Gj
=i8gj
-----END PGP SIGNATURE-----

--nextPart64039000.3Y2ujhHKv8--


--===============6649953288251505671==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6649953288251505671==--
