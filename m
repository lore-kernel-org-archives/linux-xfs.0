Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8659b0M155962 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 00:09:37 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 479B2D90C8E
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 22:21:17 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ZCoaazOkF5TWjeqV for
	<xfs@oss.sgi.com>; Sun, 05 Sep 2010 22:21:17 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 63DEB12D
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 07:10:15 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 236DC401C2E
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 07:10:15 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS status update for August 2010
Date: Mon, 6 Sep 2010 07:10:10 +0200
References: <20100902145959.GA27887@infradead.org> <201009051137.07678@zmi.at>
	<4C845E71.20902@sandeen.net>
In-Reply-To: <4C845E71.20902@sandeen.net>
MIME-Version: 1.0
Message-Id: <201009060710.14479@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3932805473262371767=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3932805473262371767==
Content-Type: multipart/signed;
  boundary="nextPart1485695.xbcyUirPmP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1485695.xbcyUirPmP
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 6. September 2010 Eric Sandeen wrote:
> People need to read up a little and know what they're tuning;
> repeating this kind of suggestion leads to cargo-cultism for
> performance "tuning"
>=20
> IOW don't turn knobs just because they are there ... :)

Other than most who write here I'm not a developer, but a sysadmin,=20
responsible for servers of all kind of ages, with XFS usage back to the=20
early 2.6 series. Default mount options use to change sometimes, and I=20
can't always check that after a system/kernel upgrade the default=20
options are satisfied or not. So specifying everything is safe, and=20
doesn't do any harm - right?
And as it was Sunday morning, I wanted to help out Willy quickly,=20
without looking specifically which options he would need. I was sure=20
some of you who know it would guide him later, but maybe only on Monday,=20
so I took that quick path to find a solution.

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

--nextPart1485695.xbcyUirPmP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyEd7YACgkQzhSR9xwSCbSmPwCgorWW4gGbiP+Ktm8bdcKRu9aF
u9sAnjDx3B9CnrKZrLlL47HycWW+jlG2
=bWLM
-----END PGP SIGNATURE-----

--nextPart1485695.xbcyUirPmP--


--===============3932805473262371767==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3932805473262371767==--
