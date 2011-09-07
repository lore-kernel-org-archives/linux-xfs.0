Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p879AWAG145108 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 04:10:32 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C14213C2EBF
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 02:14:33 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id FyjKLxcjoGEjC8CF for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2011 02:14:33 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS frozen on one directory
Date: Wed, 7 Sep 2011 11:10:25 +0200
References: <OF62081B23.59A4BF92-ONC1257903.003AB613-C1257903.003D9151@grpldc.com>
In-Reply-To: <OF62081B23.59A4BF92-ONC1257903.003AB613-C1257903.003D9151@grpldc.com>
MIME-Version: 1.0
Message-Id: <201109071110.26655@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4270031298567385162=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Boris.SANEGRE@agis-sa.fr

--===============4270031298567385162==
Content-Type: multipart/signed;
  boundary="nextPart2197084.fzT0hdGSSu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2197084.fzT0hdGSSu
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 6. September 2011 Boris.SANEGRE@agis-sa.fr wrote:
> Any help to find "why" and "how to resolve" will be very nice.

Did you try to run xfs_repair? If that doesn't solve it, try upgrading=20
it, the actual version is 3.1.5, you have a stone-old 2.9.8 version.=20
Then run xfs_repair again.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart2197084.fzT0hdGSSu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk5nNQIACgkQzhSR9xwSCbT05ACgyrbBGOtZL2tDLnCdlfFEEdQ2
UpQAoLUx9JXlrvJxssHLbJXJj5iuhbe5
=MfUJ
-----END PGP SIGNATURE-----

--nextPart2197084.fzT0hdGSSu--


--===============4270031298567385162==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4270031298567385162==--
