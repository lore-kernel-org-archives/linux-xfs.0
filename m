Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7CJ5Hur236103 for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 14:05:17 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8C0B4AFF15
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 12:05:38 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id sAeC3VQSqmF3JIEk for
	<xfs@oss.sgi.com>; Thu, 12 Aug 2010 12:05:38 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id AFBBD17F
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 21:05:36 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 53231401C2E
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 21:05:36 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: observed significant performance improvement using "delaylog" in
Date: Thu, 12 Aug 2010 21:05:35 +0200
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>
In-Reply-To: <201008121346.30760.eye.of.the.8eholder@gmail.com>
MIME-Version: 1.0
Message-Id: <201008122105.35787@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0526552923721286178=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0526552923721286178==
Content-Type: multipart/signed;
  boundary="nextPart2301956.zxzAzIfnxN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2301956.zxzAzIfnxN
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 12. August 2010 Khelben Blackstaff wrote:
> Here is my post with the results of the benchmark.
> http://lordkhelben.wordpress.com/2010/07/08/xfs-delayed-logging/
=20
Wow, BTRFS rocks. I guess I'll use it once it's released. But I'm=20
stunned that XFS is that much slower than ext4 in many tests.

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

--nextPart2301956.zxzAzIfnxN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxkRf8ACgkQzhSR9xwSCbRmrwCfRXRm0LhqVC4RUcP8bR7XrAww
Q/kAn27cR9q6j4+JDZu9OJ0mg+dYEvw5
=en7I
-----END PGP SIGNATURE-----

--nextPart2301956.zxzAzIfnxN--


--===============0526552923721286178==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0526552923721286178==--
