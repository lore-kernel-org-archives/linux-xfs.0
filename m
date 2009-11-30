Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUDXjNk010739 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 07:33:45 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E05014EAFC6
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 05:34:10 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id MrGEWGR6fn8JGpMA for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2009 05:34:10 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS & LVM: unexpected cp when issuing mv
Date: Mon, 30 Nov 2009 14:32:53 +0100
References: <200911291452.20646@zmi.at> <4B12881B.6080302@shiftmail.org>
In-Reply-To: <4B12881B.6080302@shiftmail.org>
MIME-Version: 1.0
Message-Id: <200911301432.53902@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7022149743125325160=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Asdo <asdo@shiftmail.org>
Cc: xfs@oss.sgi.com

--===============7022149743125325160==
Content-Type: multipart/signed;
  boundary="nextPart3312842.6av6bN3YWe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3312842.6av6bN3YWe
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sonntag, 29. November 2009 Asdo wrote:
> Please paste the output of the following 2 commands:
=20
# df  /disks/sharestore/upload/
=46ilesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/sharestore-public
                     4192254976 1956672968 2235582008  47%=20
/disks/sharestore

# df  /disks/sharestore/download/
=46ilesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/sharestore-public
                     4192254976 1956675156 2235579820  47%=20
/disks/sharestore

Yes, it really *is* the same filesystem.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart3312842.6av6bN3YWe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksTyYUACgkQzhSR9xwSCbRYXgCfedZDG/1FP50rS3zfVVX5R2rL
fYYAoPPKa5oMpnDv6PCww/dvfi/goChK
=GnrC
-----END PGP SIGNATURE-----

--nextPart3312842.6av6bN3YWe--


--===============7022149743125325160==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7022149743125325160==--
