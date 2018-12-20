Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout03-q01.e.movistar.es ([86.109.101.161]:31309 "EHLO
        relayout03-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbeLTQNH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 11:13:07 -0500
Received: from relayout03-redir.e.movistar.es (unknown [86.109.101.203])
        by relayout03-out.e.movistar.es (Postfix) with ESMTP id 43LGmB3wqyzQl15
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 17:04:26 +0100 (CET)
Received: from Telcontar.valinor (105.red-79-146-214.dynamicip.rima-tde.net [79.146.214.105])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout03.e.movistar.es (Postfix) with ESMTPSA id 43LGmB0Qr4zMlT8
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 17:04:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id A5891322113
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 17:04:25 +0100 (CET)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id YbRUSdt2qXDT for <linux-xfs@vger.kernel.org>;
        Thu, 20 Dec 2018 17:04:25 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 8B66F320608
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 17:04:25 +0100 (CET)
Subject: Re: Same size drive has less usable space
References: <20181220131305.2a84b717@lud1.home>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <5a7813e7-4dc8-767e-2c7c-a7b8ef503bad@telefonica.net>
Date: Thu, 20 Dec 2018 17:04:25 +0100
MIME-Version: 1.0
In-Reply-To: <20181220131305.2a84b717@lud1.home>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="zVwmaKg6hLI7WC24vqcbkGduzsP44k2NM"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zVwmaKg6hLI7WC24vqcbkGduzsP44k2NM
Content-Type: multipart/mixed; boundary="D6LVu4z48O0syHNeQP4DWPmvmSsSYW1jF";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <5a7813e7-4dc8-767e-2c7c-a7b8ef503bad@telefonica.net>
Subject: Re: Same size drive has less usable space
References: <20181220131305.2a84b717@lud1.home>
In-Reply-To: <20181220131305.2a84b717@lud1.home>

--D6LVu4z48O0syHNeQP4DWPmvmSsSYW1jF
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 20/12/2018 16.13, Luciano ES wrote:
> I have a new drive for backups.=20
> I copied everything over and now I have this problem:

=2E..

> I guess at least part of the problem is CRC enabled in the second=20
> one. So, is there anything I can do to make all the data fit in the=20
> new drive?

Clone it... dd, for instance, but then you have the problem of changing
the uuid.

--=20
Cheers / Saludos,

		Carlos E. R.
		(from 42.3 x86_64 "Malachite" at Telcontar)


--D6LVu4z48O0syHNeQP4DWPmvmSsSYW1jF--

--zVwmaKg6hLI7WC24vqcbkGduzsP44k2NM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlwbvYkACgkQtTMYHG2NR9UmNACfTznurcNJdt5R/do5EeSTa9YX
xjcAn2NJDlwrEmCE+mWJYltHJIK67qFV
=PJqV
-----END PGP SIGNATURE-----

--zVwmaKg6hLI7WC24vqcbkGduzsP44k2NM--
