Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SAZBL1249010 for <xfs@oss.sgi.com>; Thu, 28 May 2009 05:35:12 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 845061A34BB5
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 03:35:23 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id g8HLruO8o9OLRJIU for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 03:35:23 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH 7/9] Set default extN mount options
Date: Thu, 28 May 2009 12:35:12 +0200
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<200905281111.32011@zmi.at> <20090528100246.GH651@infradead.org>
In-Reply-To: <20090528100246.GH651@infradead.org>
MIME-Version: 1.0
Message-Id: <200905281235.21485@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8327195945232536030=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--===============8327195945232536030==
Content-Type: multipart/signed;
  boundary="nextPart1284756.k9QK0TVIHt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1284756.k9QK0TVIHt
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Donnerstag 28 Mai 2009 Christoph Hellwig wrote:
> > The same for reiserfs, but I don't know if that is wanted/needed.
>
> From a look at the point option parser it would need the same
> options.

Sorry, didn't express it well. Try to clear up: I know the options are=20
needed for ACLs, as I use reiserfs a lot, but I don't know if it's in=20
the list of FSs that are to be directly supported.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1284756.k9QK0TVIHt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkoeaOkACgkQzhSR9xwSCbS1JACfby41CpvGw92qEm9b3iUb+nHL
+LoAmwQTI6AyNoCz/Yc/8bAcsRDlmKxJ
=MxBR
-----END PGP SIGNATURE-----

--nextPart1284756.k9QK0TVIHt--


--===============8327195945232536030==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8327195945232536030==--
