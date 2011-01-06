Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p06Gmdp3090222 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 10:48:40 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9949FAE25E
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 08:50:46 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id lkuleEo39XiF3UIh for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 08:50:46 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs: add FITRIM support
Date: Thu, 6 Jan 2011 17:50:42 +0100
References: <20101125112304.GA4195@infradead.org> <201101060910.34534@zmi.at>
	<20110106091707.GH8322@dastard>
In-Reply-To: <20110106091707.GH8322@dastard>
MIME-Version: 1.0
Message-Id: <201101061750.43556@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4723055644652226630=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Lukas Czerner <lczerner@redhat.com>

--===============4723055644652226630==
Content-Type: multipart/signed;
  boundary="nextPart1517145.QbsRH8ghIt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1517145.QbsRH8ghIt
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 6. Januar 2011 Dave Chinner wrote:
> Realistically, we have
> to design for how we expect devices to behave in 2-3 years time, not
> waste time trying to optimise for fundamentally broken devices that
> nobody will be using in 2-3 years time...

I see, thanks for the explanation. I hope that there will be a solution=20
that allows us to FITRIM on Saturday "in the background", so the thin=20
provisioned VMs are smaller and faster to back up. That's my immediate=20
wish, as we currently don't use SSDs.

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

--nextPart1517145.QbsRH8ghIt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0l8uMACgkQzhSR9xwSCbTlgQCguppaHz/R8WuueGf23gBxZQRT
CVEAoKQjouvGCMtZm3FZqnZ2671PA1AB
=32Ue
-----END PGP SIGNATURE-----

--nextPart1517145.QbsRH8ghIt--


--===============4723055644652226630==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4723055644652226630==--
