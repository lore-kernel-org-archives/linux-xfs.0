Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5976XLm000817 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 02:06:33 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6118B10D1030
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 00:12:03 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id rQUQBKv3q13312zV for
	<xfs@oss.sgi.com>; Wed, 09 Jun 2010 00:12:03 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 2C68317B
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 09:09:02 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id D735783C804
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 09:09:01 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs,
	aacraid 2.6.27 => 2.6.32 results in 6 times slowdown]
Date: Wed, 9 Jun 2010 09:09:01 +0200
References: <4C0E13A7.20402@msgid.tls.msk.ru> <20100608231845.GG7869@dastard>
	<4C0F3819.4000409@msgid.tls.msk.ru>
In-Reply-To: <4C0F3819.4000409@msgid.tls.msk.ru>
MIME-Version: 1.0
Message-Id: <201006090909.01354@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3160174285242857231=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3160174285242857231==
Content-Type: multipart/signed;
  boundary="nextPart16165749.FA3z0o6Q28";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart16165749.FA3z0o6Q28
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 9. Juni 2010 Michael Tokarev wrote:
> AAC0: kernel 5.1-0[8832] Feb  1 2006
=20
Damn old piece of controller. Maybe you can try a firmware upgrade? I=20
use Areca controllers, and that helped a lot with them. Maybe something=20
between 2.6.27 and 2.6.32 exploited a firmware problem.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart16165749.FA3z0o6Q28
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwPPg0ACgkQzhSR9xwSCbSvoQCg4WAEQrZu+8uyVBiYMsopHOTJ
frQAnA7LVJ7RIa0Lew8yCZwnhNu1mnFl
=uNwe
-----END PGP SIGNATURE-----

--nextPart16165749.FA3z0o6Q28--


--===============3160174285242857231==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3160174285242857231==--
