Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88NXY8f071839 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 18:33:35 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7216214EE68A
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 16:45:33 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id jBxNcQLEshwjqK1r for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 16:45:33 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Date: Thu, 9 Sep 2010 01:34:16 +0200
References: <20100902145959.GA27887@infradead.org>
	<20100908145148.GB705@dastard>
	<20100908172431.4a0dbbe5@harpe.intellique.com>
In-Reply-To: <20100908172431.4a0dbbe5@harpe.intellique.com>
MIME-Version: 1.0
Message-Id: <201009090134.16690@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7871706885813399364=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7871706885813399364==
Content-Type: multipart/signed;
  boundary="nextPart9897476.2FNNPLM36t";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9897476.2FNNPLM36t
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 8. September 2010 Emmanuel Florac wrote:
> True, this is incredibly long. Adding two disks to an 8 drives array
> easily needs 72 hours.
=20
Agreed. But how long does the process=20
=2D backup
=2D build new RAID with more disks
=2D restore
take on the same storage? It's not that much faster, and during the time=20
of RAID setup you can't work, if you are very serious about your data.=20
Yes, you can build a raid in background and already move data into it,=20
but you're not secured during that time. I don't take that risk.

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

--nextPart9897476.2FNNPLM36t
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyIHXgACgkQzhSR9xwSCbSlsQCggh9uzIUJpa/ojuMNFQjwssDR
6hIAnj1SKl1OF7uYu54BIbBGr+2JOfXP
=ZhkM
-----END PGP SIGNATURE-----

--nextPart9897476.2FNNPLM36t--


--===============7871706885813399364==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7871706885813399364==--
