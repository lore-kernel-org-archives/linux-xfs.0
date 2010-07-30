Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o592jNnt037740 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 21:45:24 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44160481D58
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 03:23:14 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id yVfPGoC1AgKc9pPf for
	<xfs@oss.sgi.com>; Fri, 30 Jul 2010 03:23:14 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Fri, 30 Jul 2010 12:23:08 +0200
References: <20100726034545.GE655@dastard>
	<20100730091554.2c9ca1ec@galadriel.home>
	<20100730075746.GA20444@infradead.org>
In-Reply-To: <20100730075746.GA20444@infradead.org>
MIME-Version: 1.0
Message-Id: <201007301223.12134@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2147332782370774020=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============2147332782370774020==
Content-Type: multipart/signed;
  boundary="nextPart1753717.5qSE4ucyiU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1753717.5qSE4ucyiU
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 30. Juli 2010 Christoph Hellwig wrote:
> Recent enough kernel work fine with filesystems that inode64 was used
> on even if it's not specified anymore.
=20
Really? Since when exactly? That would be a nice feature. If we can=20
define it clearly, I could put that on the FAQ.

But how does it truncate the numbers >int32 and avoid collisions?

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

--nextPart1753717.5qSE4ucyiU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxSqBAACgkQzhSR9xwSCbT4kACg3UTEKeWmW8uUAXCMnGO1haDP
bm4AoJ6ufW6GdLQEmek/iddPIyh2RMNY
=5cTA
-----END PGP SIGNATURE-----

--nextPart1753717.5qSE4ucyiU--


--===============2147332782370774020==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2147332782370774020==--
