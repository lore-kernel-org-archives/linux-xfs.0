Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VNC2UM088471 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 18:12:03 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D06DE1239E38
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:23:11 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id pdyVK1h4PPxgPs2X for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:23:11 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 35F1260E
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 01:12:38 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id E2BB0401C2F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 01:12:37 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4K drives, sectsz=512, bsize=4096
Date: Wed, 1 Sep 2010 01:12:37 +0200
References: <201008300956.21264@zmi.at> <201009010007.23899@zmi.at>
	<4C7D7F01.1070003@sandeen.net>
In-Reply-To: <4C7D7F01.1070003@sandeen.net>
MIME-Version: 1.0
Message-Id: <201009010112.37351@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0582063086280980732=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0582063086280980732==
Content-Type: multipart/signed;
  boundary="nextPart1301790.78fbH4LAh7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1301790.78fbH4LAh7
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 1. September 2010 Eric Sandeen wrote:
> the log can do things on sector size boundaries.
=20
Great, thanks to both of you for clarification. Going to reformat now...

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

--nextPart1301790.78fbH4LAh7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx9jGUACgkQzhSR9xwSCbQgpwCeNY7z0AxHODmcOjvenGa7oz3Y
Pb0AoKR1FZy/DBVlz7Izf8IpNNO7xUXF
=q1TA
-----END PGP SIGNATURE-----

--nextPart1301790.78fbH4LAh7--


--===============0582063086280980732==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0582063086280980732==--
