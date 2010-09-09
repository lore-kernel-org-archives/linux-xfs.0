Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o898Sh6q091936 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 03:28:43 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBDCC5BB6D
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 01:29:26 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3k64mXQxI06nmABS for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 01:29:26 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Date: Thu, 9 Sep 2010 10:29:23 +0200
References: <20100902145959.GA27887@infradead.org> <201009090130.22983@zmi.at>
	<20100909072726.GB7032@dastard>
In-Reply-To: <20100909072726.GB7032@dastard>
MIME-Version: 1.0
Message-Id: <201009091029.23333@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8035237673989317073=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8035237673989317073==
Content-Type: multipart/signed;
  boundary="nextPart2211801.QSd6tmYC89";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2211801.QSd6tmYC89
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 9. September 2010 Dave Chinner wrote:
> That is, if you have SATA drives then running them for 3 or 4 days
> at 100% duty cycle while a reshape takes place is putting them far
> outside their design limits.
=20
Your arguments are all valid. Our hardware supplier recommended one=20
drive type, and we only buy these and really they work very well. For=20
the BER, I really hope the controller does read-after-write during=20
rebuild. When I see the time it takes to resize an array, I think and=20
hope they do it. That said, I've never had a problem on resize, and hope=20
it stays like that :-)

There are other reasons to do a resize, which I don't want to discuss in=20
public.

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

--nextPart2211801.QSd6tmYC89
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyImuMACgkQzhSR9xwSCbSGqQCffZOsLHxZnJET+6pXkqR5aawL
bX8AoLO4Q2lZ+jMYOI2YuP1CVHmHbIrt
=1rqO
-----END PGP SIGNATURE-----

--nextPart2211801.QSd6tmYC89--


--===============8035237673989317073==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8035237673989317073==--
