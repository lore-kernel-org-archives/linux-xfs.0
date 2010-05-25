Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PJ3sY5033050 for <xfs@oss.sgi.com>; Tue, 25 May 2010 14:03:54 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3708C1440AAF
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 12:06:14 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id NYJBCd7CAjf7kxYd for
	<xfs@oss.sgi.com>; Tue, 25 May 2010 12:06:14 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id B6FA9800183
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 21:06:11 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 617F383C804
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 21:06:11 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: LVM snapshot not mountable
Date: Tue, 25 May 2010 21:06:06 +0200
References: <201005251725.48452@zmi.at> <20100525154927.GA25353@infradead.org>
In-Reply-To: <20100525154927.GA25353@infradead.org>
MIME-Version: 1.0
Message-Id: <201005252106.10889@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8118770672016628030=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8118770672016628030==
Content-Type: multipart/signed;
  boundary="nextPart5316389.8ZGQzqQ1Wc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5316389.8ZGQzqQ1Wc
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 25. Mai 2010 Christoph Hellwig wrote:
> mount -o ro,norecovery,nouuid /dev/db/dbnap /mnt
> or use
>  xfs_admin -U generate /dev/db/dbnap

Gracias, merci, grazie, danke, thanks.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart5316389.8ZGQzqQ1Wc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkv8H6IACgkQzhSR9xwSCbTKHgCgvF5S5QxNcbhL92C0tnfJFdDT
nkQAoNIZ1clJJ3uXpnAoJJ06jMrmhy7O
=wrLC
-----END PGP SIGNATURE-----

--nextPart5316389.8ZGQzqQ1Wc--


--===============8118770672016628030==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8118770672016628030==--
