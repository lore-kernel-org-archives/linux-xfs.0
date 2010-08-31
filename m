Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VL131M082597 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:01:04 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E02B1239EA2
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 14:12:11 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id zMpMGHARMLHgHQ2n for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 14:12:11 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 0457E616
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 23:01:38 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id AFAA9401C3D
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 23:01:38 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4K drives, sectsz=512, bsize=4096
Date: Tue, 31 Aug 2010 23:01:34 +0200
References: <201008300956.21264@zmi.at>
In-Reply-To: <201008300956.21264@zmi.at>
MIME-Version: 1.0
Message-Id: <201008312301.38103@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3508048409415386583=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3508048409415386583==
Content-Type: multipart/signed;
  boundary="nextPart4789981.Hv5HgZVOYP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4789981.Hv5HgZVOYP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Montag, 30. August 2010 Michael Monnerie wrote:
> Will there be any real difference if I re-format with sectsz=3D4096?=20
> AFAIK, XFS will do I/O based on block size, so the sector size
>  doesn't  do any harm. Is that correct?
=20
Nobody? Is my assumption correct that a change in sectsz from 512 to=20
4096 would be of no difference for the filesystem?


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

--nextPart4789981.Hv5HgZVOYP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx9bbIACgkQzhSR9xwSCbSSlwCg4fgx6/x7zRWPoxiJAMLTiBZg
5vIAnj55XDF+cvyNkzRydIufR6eZon38
=B8Ki
-----END PGP SIGNATURE-----

--nextPart4789981.Hv5HgZVOYP--


--===============3508048409415386583==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3508048409415386583==--
