Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:34965 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932127AbdJZPVl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 11:21:41 -0400
Date: Thu, 26 Oct 2017 17:21:44 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Possible to mount this XFS at least temporarily to retrieve
 files?
Message-ID: <20171026172144.130ca6f8@harpe.intellique.com>
In-Reply-To: <CAAxjCEz0VbGJvq7S09hDcEBkomMGTeCXKHvxrV8BQ1+pXY49qA@mail.gmail.com>
References: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
        <CAAxjCEwEH-OsH_z=OWg0R7XoOzyWeUQsmTp1r8Fdp-JU11eX4Q@mail.gmail.com>
        <8d15394e-1dd6-ced0-7af1-fb538c60bb58@aei.mpg.de>
        <CAAxjCEz78rDh-DfO7zXn_GFLagZFUsJbKi63bw8SgDECq62c8Q@mail.gmail.com>
        <CAAxjCEz0VbGJvq7S09hDcEBkomMGTeCXKHvxrV8BQ1+pXY49qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.NKNR5n0MkByc/t5+RK.XL3"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-xfs@vger.kernel.org

--Sig_/.NKNR5n0MkByc/t5+RK.XL3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 25 Oct 2017 16:56:31 +0200
Stefan Ring <stefanrin@gmail.com> =C3=A9crivait:

> Anyway, it would be good to know if the RAID got mixed up somehow or
> not. In the former case, I would kiss the data good bye. Otherwise it
> should be recoverable, although it might be time consuming.

The Adaptec RAID have a clear tendancy not to report overheating, but
nonetheless badly eating data when doing so...

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/.NKNR5n0MkByc/t5+RK.XL3
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlnx/YgACgkQX3jQXNUicVYlEACgmYZ9Icjp+XEGYeq6AoMiQfFa
pXYAn3wsAneHbTjHQ58V8MyWt4vlTaQ+
=Re0u
-----END PGP SIGNATURE-----

--Sig_/.NKNR5n0MkByc/t5+RK.XL3--
