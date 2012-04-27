Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3RLVioY210410 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 16:31:44 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YssyV1wrgcANa489 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Apr 2012 14:31:43 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Problem recovering XFS filesystem
Date: Fri, 27 Apr 2012 23:31:40 +0200
Message-ID: <18818650.cGNyynGa9I@saturn>
In-Reply-To: <CAK6JqP3ze2pocsgoKUTZx_J6w-Zc9V=StqDnqG0Gx0v5hw=FGQ@mail.gmail.com>
References: <CAK6JqP3ze2pocsgoKUTZx_J6w-Zc9V=StqDnqG0Gx0v5hw=FGQ@mail.gmail.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7069524714964736946=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Aaron Williams <aaron.w2@gmail.com>


--===============7069524714964736946==
Content-Type: multipart/signed; boundary="nextPart1416734.PhrHdecGn4"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1416734.PhrHdecGn4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Donnerstag, 26. April 2012, 13:00:06 schrieb Aaron Williams:
> I was able to recover the filesystem.

So your RAID busted the filesystem. Maybe the devs could want an=20
xfs_metadump of the FS before your repair, so they can inspect it and=20=

improve xfs_repair.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1416734.PhrHdecGn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+bEDwACgkQzhSR9xwSCbTndACgyY+JhM0ZZQXzpJgP39XzcWSX
3MkAoPMZ1CHmtrqtDOKZDCoKp+7dRkPo
=QMjn
-----END PGP SIGNATURE-----

--nextPart1416734.PhrHdecGn4--


--===============7069524714964736946==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7069524714964736946==--
