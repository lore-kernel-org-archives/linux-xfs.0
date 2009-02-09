Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n19HdYs7259800 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 11:39:35 -0600
Received: from metis.ext.pengutronix.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9795118F7BA4
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 09:38:56 -0800 (PST)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[92.198.50.35]) by cuda.sgi.com with ESMTP id uBavEepZOENykVVz
	for <xfs@oss.sgi.com>; Mon, 09 Feb 2009 09:38:56 -0800 (PST)
Received: from themisto.ext.pengutronix.de ([92.198.50.58] helo=[127.0.0.1])
	by metis.ext.pengutronix.de with esmtp (Exim 4.63)
	(envelope-from <mkl@pengutronix.de>) id 1LWa5r-0006fH-MT
	for xfs@oss.sgi.com; Mon, 09 Feb 2009 18:38:54 +0100
Message-ID: <49906A23.2010504@pengutronix.de>
Date: Mon, 09 Feb 2009 18:38:43 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
MIME-Version: 1.0
Subject: download of attr_2.4.43-1.tar.gz
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6342241956623357272=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============6342241956623357272==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7478F03FDF2667322631E678"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7478F03FDF2667322631E678
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

is ftp://oss.sgi.com/projects/xfs/cmd_tars/ still the valid download
location for the "attr" package?

The permissions on the ftp server on
ftp://oss.sgi.com/projects/xfs/cmd_tars/ are mixed up, so that download
isn't possible anymore.

ncftp /projects/xfs/cmd_tars > pwd
  ftp://oss.sgi.com/projects/xfs/cmd_tars/
ncftp /projects/xfs/cmd_tars > dir attr_2.4.43-1.tar.gz
-rw-rw----       116991   Jul  3  2008   attr_2.4.43-1.tar.gz
ncftp /projects/xfs/cmd_tars > get attr_2.4.43-1.tar.gz
get attr_2.4.43-1.tar.gz: server said: Can't open attr_2.4.43-1.tar.gz: P=
ermission denied

cheers, Marc

--=20
Pengutronix e.K.                         | Marc Kleine-Budde           |
Linux Solutions for Science and Industry | Phone: +49-231-2826-924     |
Vertretung West/Dortmund                 | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686         | http://www.pengutronix.de   |


--------------enig7478F03FDF2667322631E678
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkmQaisACgkQjTAFq1RaXHMkEACeKnj3FnbKcbN8CfiM3XgvQ91w
tXYAn2B9bAen3e/zZgzs+53eFuuiluz/
=jm49
-----END PGP SIGNATURE-----

--------------enig7478F03FDF2667322631E678--


--===============6342241956623357272==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6342241956623357272==--
