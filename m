Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7BCSApw138109 for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 07:28:10 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ECE01E45347
	for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 05:28:33 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id jwn3qi7pnosX3XFN for
	<xfs@oss.sgi.com>; Wed, 11 Aug 2010 05:28:33 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id EDD9E705
	for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 14:28:31 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id AB69A47EA07
	for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 14:28:31 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: observed significant performance improvement using "delaylog" in
	a real-world application
Date: Wed, 11 Aug 2010 14:28:30 +0200
References: <i3rt4t$46c$1@dough.gmane.org> <201008111003.36890@zmi.at>
	<i3trg6$eps$1@dough.gmane.org>
In-Reply-To: <i3trg6$eps$1@dough.gmane.org>
MIME-Version: 1.0
Message-Id: <201008111428.31196@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3104361418266024283=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3104361418266024283==
Content-Type: multipart/signed;
  boundary="nextPart1357555.5LLqSiQUSt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1357555.5LLqSiQUSt
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 11. August 2010 Peter Niemayer wrote:
> This description is, of course, somewhat simplified, but it should
> get you an idea on the kind of I/O-operations.
=20
Thank you. Are those files located within one dir or do you use a hash=20
structure like squid cache does?

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

--nextPart1357555.5LLqSiQUSt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxil28ACgkQzhSR9xwSCbQ3AwCgybCl8yr9RXaCe050fc+j+9vG
2zgAoNUoM4w3Fmu8Z9wicyQT2VVj3B7X
=gxuw
-----END PGP SIGNATURE-----

--nextPart1357555.5LLqSiQUSt--


--===============3104361418266024283==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3104361418266024283==--
