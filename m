Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9MKsW9U217480 for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 15:54:32 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE5E511D93D
	for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 13:55:43 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 5OUhdKp3cdd0iUMj for
	<xfs@oss.sgi.com>; Fri, 22 Oct 2010 13:55:43 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1510560B
	for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 22:55:42 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 5E8AD401C3E
	for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 22:55:41 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Implementing checksums in XFS
Date: Fri, 22 Oct 2010 22:55:40 +0200
References: <4CC14C1B.5060409@ics.forth.gr>
	<20101022124928.GA16437@infradead.org>
In-Reply-To: <20101022124928.GA16437@infradead.org>
MIME-Version: 1.0
Message-Id: <201010222255.40861@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8346304268078069745=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8346304268078069745==
Content-Type: multipart/signed;
  boundary="nextPart3710564.P20eEUWALY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3710564.P20eEUWALY
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 22. Oktober 2010 Christoph Hellwig wrote:
> Yes, it's work in progress that has been stalled a little.  See:
> http://oss.sgi.com/archives/xfs/2009-02/msg00200.html for some more
> details.

Oh that would be very welcome. A "secure" filesystem sounds really good,=20
especially if it's fast as XFS is :-)
I'd implement it everywhere immediately as soon as it's available. Will=20
existing XFS's be upgradeable in some way other that backup/restore?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3710564.P20eEUWALY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzB+kwACgkQzhSR9xwSCbRs6QCeOCygdslexebnswqXRQD+lv+P
1agAn0La5okQpjt92VRwnEp1yDY01EqZ
=iQuP
-----END PGP SIGNATURE-----

--nextPart3710564.P20eEUWALY--


--===============8346304268078069745==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8346304268078069745==--
