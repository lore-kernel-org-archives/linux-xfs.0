Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p438sq4c007710 for <xfs@oss.sgi.com>; Tue, 3 May 2011 03:54:52 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5613611C291C
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 01:58:26 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id tVw2hU2xsKHoSxvB for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 01:58:26 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS/Linux Sanity check
Date: Tue, 3 May 2011 10:58:22 +0200
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
	<20110503031856.GA9114@dastard>
In-Reply-To: <20110503031856.GA9114@dastard>
MIME-Version: 1.0
Message-Id: <201105031058.23294@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1209916091383618866=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1209916091383618866==
Content-Type: multipart/signed;
  boundary="nextPart3373778.hURPxmJAeC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3373778.hURPxmJAeC
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 3. Mai 2011 Dave Chinner wrote:
> > We're running Ubuntu 10.04 LTS, and have tried either the stock
> > kernel (2.6.32-30) or 2.6.35 from linux.org.
>=20
> (OT: why do people install a desktop OS on their servers?)

I can only tell for us: We use openSUSE, and tried with SLES, but=20
support on openSUSE is better despite you pay for SLES, and openSUSE is=20
(by nature) newer in every package. And that gives you (nearly) actual=20
XFS improvements due to newer kernels and therefore more performance=20
(e.g. delaylog).

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart3373778.hURPxmJAeC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk2/w68ACgkQzhSR9xwSCbR1CQCg6deu7s+swqH7OvxTvqKW5DZI
yl8AniADU95X8WGW/IS8F0vyYAt+CrZd
=+9jw
-----END PGP SIGNATURE-----

--nextPart3373778.hURPxmJAeC--


--===============1209916091383618866==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1209916091383618866==--
