Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6UNmAUS108762 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 18:48:11 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D984142E521
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 16:48:54 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id NjXktjO9qMXOgMwq for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 16:48:54 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 3B17E51B9
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 01:49:08 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id BA40240DC06
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 01:48:52 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs i/O error
Date: Fri, 31 Jul 2009 01:48:43 +0200
References: <24747808.post@talk.nabble.com>
In-Reply-To: <24747808.post@talk.nabble.com>
MIME-Version: 1.0
Message-Id: <200907310148.52085@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9020730215566427957=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9020730215566427957==
Content-Type: multipart/signed;
  boundary="nextPart4393049.xgnyC4n4Gt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4393049.xgnyC4n4Gt
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Donnerstag 30 Juli 2009 rnb wrote:
> [70273.864305] sd 8:0:0:0: [sdg] Sense Key : Medium Error [current]
> [70273.864314] Info fld=3D0x0
> [70273.864318] sd 8:0:0:0: [sdg] Add. Sense: Unrecovered read error
> [70273.864327] end_request: I/O error, dev sdg, sector 378206415

Disk is bad, replace it.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart4393049.xgnyC4n4Gt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpyMWQACgkQzhSR9xwSCbRnsACg6+sbfGKqWRgdNpKF9twlZpeM
SosAnjILxXqXBRyK1hjpB/5Y7fMbKnAG
=7Swh
-----END PGP SIGNATURE-----

--nextPart4393049.xgnyC4n4Gt--


--===============9020730215566427957==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9020730215566427957==--
