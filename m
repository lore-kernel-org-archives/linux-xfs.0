Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RB2ov5128681 for <xfs@oss.sgi.com>; Thu, 27 May 2010 06:02:50 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB30F1DFD2B6
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 04:05:12 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id bntc98WI167429Jk for
	<xfs@oss.sgi.com>; Thu, 27 May 2010 04:05:12 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 987E4800112
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 13:05:10 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 5C30383C804
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 13:05:10 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: NOW: o_direct   --  WAS: Re: WARNING in xfs_lwr.c, xfs_write()
Date: Thu, 27 May 2010 13:05:09 +0200
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100526070620.GT2150@dastard>
	<4BFD3926.6040208@hardwarefreak.com>
In-Reply-To: <4BFD3926.6040208@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201005271305.09901@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1480264347744582786=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1480264347744582786==
Content-Type: multipart/signed;
  boundary="nextPart1308396.KR7F04zR49";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1308396.KR7F04zR49
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 26. Mai 2010 Stan Hoeppner wrote:
> My apologies for the newbish questions.  If this has all been
>  asked/answered before, please just point me to any papers that
>  explain the pros/cons of o_direct.  Thanks.
=20
I'd recommend the kernel pages on http://lwn.net
=46rom time to time you see the discussions about o_direct, always a=20
subject of discussion. I'm not a programmer so I don't care ;-)


=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1308396.KR7F04zR49
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkv+UeUACgkQzhSR9xwSCbRwhgCeOsCTMmukmgCnakPGG8yOzMIt
V1YAoJnpXwtXAffXzIElq36eeSCaf7Nb
=bKds
-----END PGP SIGNATURE-----

--nextPart1308396.KR7F04zR49--


--===============1480264347744582786==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1480264347744582786==--
