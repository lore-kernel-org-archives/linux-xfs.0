Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUFUs9j027132 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 09:30:54 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 438ACBF7B7
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 07:31:23 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3fP3GE4Px1hhgKWa for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2009 07:31:23 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS & LVM: unexpected cp when issuing mv
Date: Mon, 30 Nov 2009 16:30:06 +0100
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF3C@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF3C@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Message-Id: <200911301630.06668@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0510985609695523321=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

--===============0510985609695523321==
Content-Type: multipart/signed;
  boundary="nextPart2975643.byuFnropyz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2975643.byuFnropyz
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 30. November 2009 Alex Elder wrote:
> The quota inheritance property Dave described only applies
> to project quotas, not group or user quotas.
>=20
Thanks. I thought about it but can't use them anyway, as I would have to=20
change the owner of files on upload. But I want to keep that=20
information. So turning off quota is our only chance by now :-(

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart2975643.byuFnropyz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksT5P4ACgkQzhSR9xwSCbQo+ACfW6dkzkVPrhm88DsTmph09wwV
4Z8AoPXtWDp9EhtIGfD1lJPmnpsD+DlM
=xM7e
-----END PGP SIGNATURE-----

--nextPart2975643.byuFnropyz--


--===============0510985609695523321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0510985609695523321==--
