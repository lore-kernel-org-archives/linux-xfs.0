Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HD5hKk084150 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 07:05:43 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YurQhXlknnD5ijAg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 05:05:41 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS memory recomendation?
Date: Fri, 17 Feb 2012 14:05:39 +0100
Message-ID: <1410714.dziNWBeyu6@saturn>
In-Reply-To: <20120217024941.GH14132@dastard>
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
	<20120217024941.GH14132@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2550211621977064261=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>


--===============2550211621977064261==
Content-Type: multipart/signed; boundary="nextPart1428770.mZbXiJz7ti"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1428770.mZbXiJz7ti
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 17. Februar 2012, 13:49:41 schrieb Dave Chinner:
> What's a "file allocation table"? XFS doesn't have one.

I guess he means the inode/dentry cache and such.

BTW, what's the difference of inode and dentry caches? I'd like to=20
understand the setting of
/proc/sys/vm/vfs_cache_pressure

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1428770.mZbXiJz7ti
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk8+UKMACgkQzhSR9xwSCbS+xgCg2Bu3xLfTb3WMzm9oaalCGiHc
vcsAoPEnF48olfMrveS8O68rE4YsTUCM
=wY0o
-----END PGP SIGNATURE-----

--nextPart1428770.mZbXiJz7ti--


--===============2550211621977064261==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2550211621977064261==--
