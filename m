Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6L9BMlf070111 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 04:11:22 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35ABF1E2F4D9
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 02:14:18 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 5w4TEbEzYRlpfQCo for
	<xfs@oss.sgi.com>; Wed, 21 Jul 2010 02:14:18 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id D0996400
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 11:14:16 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id EBBCA83C82E
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 11:13:27 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4k sector drives
Date: Wed, 21 Jul 2010 11:14:15 +0200
References: <201007211053.45191.eye.of.the.8eholder@gmail.com>
In-Reply-To: <201007211053.45191.eye.of.the.8eholder@gmail.com>
MIME-Version: 1.0
Message-Id: <201007211114.16023@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4309821164000643239=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4309821164000643239==
Content-Type: multipart/signed;
  boundary="nextPart1419485.VEtk1CPmqT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1419485.VEtk1CPmqT
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 21. Juli 2010 Khelben Blackstaff wrote:
> No, don't set the jumper.

OK, luckily I didn't have time until now :-)

> WD EARS drives with 00Y model revision doesn't report the sector size
> properly and only report 512 bytes. (Use hdparm to see it)
> Those with 00Z revision report correctly that they have 4096 physical
> sector size and 512 logical sector size.

I have these:
Model=3DWDC WD20EARS-00MVWB0, FwRev=3D50.0AB50, SerialNo=3DWD-WMAZ20035646
Model=3DWDC WD20EARS-00MVWB0, FwRev=3D50.0AB50, SerialNo=3DWD-WMAZ20028252

Any chance to get Linux know they are 4k sector drives manually?

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

--nextPart1419485.VEtk1CPmqT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxGumcACgkQzhSR9xwSCbREMgCguZkX0sSnUyzNBI7/Yt9gLSUA
gDkAoIoDmmh2obSvGcAMFTzh7kF1zOAf
=s2pq
-----END PGP SIGNATURE-----

--nextPart1419485.VEtk1CPmqT--


--===============4309821164000643239==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4309821164000643239==--
