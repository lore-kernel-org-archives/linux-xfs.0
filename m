Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45692 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbdBHT6T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Feb 2017 14:58:19 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8295D747820
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2017 13:47:53 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsdump: master updated to 25195eb
Message-ID: <6013e914-5134-51b1-32c2-9ef793fa00de@sandeen.net>
Date: Wed, 8 Feb 2017 13:47:45 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NjUDX6x21uAGqrx5S3lmaCd8INnIF1JhK"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NjUDX6x21uAGqrx5S3lmaCd8INnIF1JhK
Content-Type: multipart/mixed; boundary="8N4vQ3Ahqiogpt8ipt37QUbMFFEDpGgqt";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <6013e914-5134-51b1-32c2-9ef793fa00de@sandeen.net>
Subject: [ANNOUNCE] xfsdump: master updated to 25195eb

--8N4vQ3Ahqiogpt8ipt37QUbMFFEDpGgqt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

25195eb xfsdump: handle bind mount targets

New Commits:

Eric Sandeen (1):
      [25195eb] xfsdump: handle bind mount targets


Code Diffstat:

 dump/content.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)


--8N4vQ3Ahqiogpt8ipt37QUbMFFEDpGgqt--

--NjUDX6x21uAGqrx5S3lmaCd8INnIF1JhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYm3XpAAoJECCuFpLhPd7g+PcP/1KFtG8lHsPG1SrGvY21t9Ql
R0F4oUWMVXxJ/FsBAicKiLOwVEi1GuKZH+b6ktndhqTqkN2xTrqA80Ld6x6cum3N
d9Pt1xKybcyVPgYmJqqOMnwEta8JRXFd978M5+dimnD16BwkSNTuVjcNJy3rHg+p
Po7i7UNfrN4MbcJL70LlZPSaf3Jb7cKG0r+eMdkTXRHzb6Pgy/W/h73pWtjaIFfr
FPAa9jl863+fqk/uZNB26vLAGESmDUyNyDh1pIDIOsETYCgXg7szBKx/hQP31Eix
XxZTtAey4ceCZAcWmNtbx+c/HTxllIxPFPxRrGErEGjwqVaurXogw/NdDB5n5qbt
SLQ+kjps8r1THuSTYGa9BGcOd/qNcpUeKohJ7S38f8BqR19GIMpj+ovZNSvP41yH
4yMpi5BNzzywaTYAAYSjLChohDIGggNkTxygy120YWzCJ+8X1I0TcIJSpXKI/pDh
TlPe1eaFLBoAZ/AbQjPtp/UqVEucR8/9eFBkuJHrkgDLyQ1zSJnt+KbHhj51PaS3
8m2qiSIVeDoNV1eWrPFh7x9Es3s+hAsb4Rbxxs+zwyIn5IlY7tnyQsX510vt8H5D
+sNi57Yve38b3sBTfUWgUlQc/mYFLtrgre6WI9LNwf1HAaxhSIPTpZ1wX59rVQ5d
dDeEJtTNtuFmzRw4VIqI
=PZ6S
-----END PGP SIGNATURE-----

--NjUDX6x21uAGqrx5S3lmaCd8INnIF1JhK--
