Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o817cHS4115225 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 02:38:17 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA67F41821
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 00:38:54 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id B68fD3bMbL6vaEHu for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 00:38:54 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id E4A1117F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 09:38:52 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id AB613401C2F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 09:38:52 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4K drives, sectsz=512, bsize=4096
Date: Wed, 1 Sep 2010 09:38:46 +0200
References: <881036.47658.qm@web76207.mail.sg1.yahoo.com>
In-Reply-To: <881036.47658.qm@web76207.mail.sg1.yahoo.com>
MIME-Version: 1.0
Message-Id: <201009010938.51894@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0395196523502237307=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0395196523502237307==
Content-Type: multipart/signed;
  boundary="nextPart2144040.A6xKu4xUom";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2144040.A6xKu4xUom
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 1. September 2010 Gim Leong Chin wrote:
> Should we leave it at the default 256 bytes, or set it to the maximum
>  of 2 kB?
=20
An interesting question. Why are inodes sizes configurable at all? To=20
store ACLs? How would one know when bigger Inodes should be used? And=20
what is the implication when they would be needed but aren't used?

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

--nextPart2144040.A6xKu4xUom
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx+AwsACgkQzhSR9xwSCbTkdQCgo9sp2NBD40VQ9h2LN1njPerH
Ka0AoMdHRpmpaCZxzitefeYDB6fCE1fq
=0dsQ
-----END PGP SIGNATURE-----

--nextPart2144040.A6xKu4xUom--


--===============0395196523502237307==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0395196523502237307==--
