Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o859aT92108859 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 04:36:29 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5520D1D8272F
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 02:37:10 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id mpqaX7dhO5M3p5PD for
	<xfs@oss.sgi.com>; Sun, 05 Sep 2010 02:37:10 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS status update for August 2010
Date: Sun, 5 Sep 2010 11:37:03 +0200
References: <20100902145959.GA27887@infradead.org>
	<20100905074457.GC16004@1wt.eu>
In-Reply-To: <20100905074457.GC16004@1wt.eu>
MIME-Version: 1.0
Message-Id: <201009051137.07678@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1783236892823764975=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Willy Tarreau <w@1wt.eu>

--===============1783236892823764975==
Content-Type: multipart/signed;
  boundary="nextPart2616010.3GPcfDxiUP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2616010.3GPcfDxiUP
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sonntag, 5. September 2010 Willy Tarreau wrote:
> I've just installed 2.6.35.4

Try the following mount options:=20
relatime,logbufs=3D8,logbsize=3D256k,attr2,barrier,largeio,swalloc,delaylog

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

--nextPart2616010.3GPcfDxiUP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyDZMMACgkQzhSR9xwSCbSMDwCgptx9Oc8UoiU9daeMYvL05p0I
ty0An0AL+UnHQz3HRchj+3LdyfkRdoXn
=FL3P
-----END PGP SIGNATURE-----

--nextPart2616010.3GPcfDxiUP--


--===============1783236892823764975==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1783236892823764975==--
