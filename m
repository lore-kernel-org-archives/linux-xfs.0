Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4QEpEdK083996 for <xfs@oss.sgi.com>; Wed, 26 May 2010 09:51:14 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FDE2A4C8C3
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 07:55:21 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 6pNhXzy7grrqtBIA for
	<xfs@oss.sgi.com>; Wed, 26 May 2010 07:55:21 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 91ADC800184
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 16:53:34 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 509DC83C804
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 16:53:34 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: noatime,nodiratime?
Date: Wed, 26 May 2010 16:53:33 +0200
References: <4BF3F212.5030600@hardwarefreak.com> <4BF44105.4040902@sandeen.net>
	<4BF47859.6020808@hardwarefreak.com>
In-Reply-To: <4BF47859.6020808@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201005261653.33774@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3897573994818107245=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3897573994818107245==
Content-Type: multipart/signed;
  boundary="nextPart4048424.WqApMMQSJU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4048424.WqApMMQSJU
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 20. Mai 2010 Stan Hoeppner wrote:
> Yes.  It would be nice to see the settings regardless of default or
>  user defined.
=20
I second that. Because you could use barrier in the fstab options, but=20
it's not supported and so nobarrier is used. It would be good to check=20
that by simply "cat /proc/mounts".

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart4048424.WqApMMQSJU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkv9Ne0ACgkQzhSR9xwSCbRKsgCeNgdBYWAPxzSg8QL/GKFx8UY6
hIkAoKZq1bhFl4LbunRflC5kfI0i3qxN
=ORl0
-----END PGP SIGNATURE-----

--nextPart4048424.WqApMMQSJU--


--===============3897573994818107245==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3897573994818107245==--
