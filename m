Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46806 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758679AbdAKChL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 21:37:11 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1134F61431E
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 20:36:27 -0600 (CST)
Subject: Re: [ANNOUNCE] xfsPROGS: for-next updated to 3fe4a6d
References: <9cacc38b-ed1a-2954-6d03-99e5570eea12@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c889eef2-ca07-6aa7-090c-ad5b12125739@sandeen.net>
Date: Tue, 10 Jan 2017 20:37:09 -0600
MIME-Version: 1.0
In-Reply-To: <9cacc38b-ed1a-2954-6d03-99e5570eea12@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PTVC2V3JAW76LIOCGDKKurxMBdcLmgUdr"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PTVC2V3JAW76LIOCGDKKurxMBdcLmgUdr
Content-Type: multipart/mixed; boundary="A5j6GEhHgharst2QrrxsWoJhU2md77bHD";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <c889eef2-ca07-6aa7-090c-ad5b12125739@sandeen.net>
Subject: Re: [ANNOUNCE] xfsPROGS: for-next updated to 3fe4a6d
References: <9cacc38b-ed1a-2954-6d03-99e5570eea12@sandeen.net>
In-Reply-To: <9cacc38b-ed1a-2954-6d03-99e5570eea12@sandeen.net>

--A5j6GEhHgharst2QrrxsWoJhU2md77bHD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Of course the $SUBJECT should have been /xfsprogs/, sorry!

On 1/10/17 8:35 PM, Eric Sandeen wrote:
> Hi folks,
>=20
> The xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated.
>=20
> This is the libxfs syncup for 4.10, along with a few precursor
> patches form Darrick to minimize libxfs-diff noise for stuff
> that got missed or mismerged in prior syncs, along with the
> libxfs-diff patch itself, and Darrick's stgit enhancements
> to libxfs-apply.
>=20
> Yes, you have other outstanding patches!  They are not in this
> release!  It is /so/ disappointing!  That update is coming soon.  :)
>=20
> Meanwhile, please check & test this update.  I've got it only
> on for-next for now so that any brown-paper-bag bugs can be
> obliterated with a rebase if needed; if things look good, I'll
> push to master in a few days.
>=20
> The new head of the for-next branch is commit:
>=20
> 3fe4a6d xfs: don't rely on ->total in xfs_alloc_space_available


--A5j6GEhHgharst2QrrxsWoJhU2md77bHD--

--PTVC2V3JAW76LIOCGDKKurxMBdcLmgUdr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYdZpWAAoJECCuFpLhPd7ghYIP/2GTI/oEaGZ39i94+lmMCLQV
yLA0vD2GSZbZglpj2e4NAj6iaIIr3xnwUdV5hIaDFGpqmAjn3hn2VYDS5PKXrP0Q
FCkD1Zt3HrYzYLK87O4eqYTKuJ+p3mnE3LY9S0WnmDVgyiVwmlizV1hjdXiJYTDM
6BDBWYYgHh0R1AE4uP+ZDf3B0ckEf/HKQeOL3xFF0NO5FuhsAGTdqOetQTTei7Wy
uQPS1ssbTvviQk3q+RAMEKl2bfPDiZnzTKKjM3ie7CpxVtN2UqnoJo69r5iGaHR1
8dScpW82yLOxc2yq3vPQl922fAt0J0YtC+hJOjpE97U5UmxGli81mALa9O3vZSOf
1v4iNFu17JBkH1yk4msg/5GJaq3miaKU4ejEZDhEpqhVvN30Ztqn8oxDZCMQOlR5
qdARV1gEzrh2lzdClzdXhuYucCzRI0YBNBEhRfgSHDGx7YN/9S1nlA6HOU3tuD5g
33w4W/WWiW+MABiqXfKiO+0Qftg7ljvZd9ZXO1fq7EOv6qvwugsHv5sNDLaKTWTS
8FLJWO5weVndmGF2ag+Uc7xrVaZcwnkqsIN1Q4M3BljpYSZPcsjrTHnVOhd9Tj4U
i40xtJ7Avz5CfhHWv1tMXIOiyFLV25PdS/j9zv5wSYsvW2HDSe1FX7zqSLvMbrw7
hjnppr8s+nfrTgQ4v8tQ
=frKJ
-----END PGP SIGNATURE-----

--PTVC2V3JAW76LIOCGDKKurxMBdcLmgUdr--
