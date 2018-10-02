Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:25075 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbeJBVPJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Oct 2018 17:15:09 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 9FB7E547678
        for <linux-xfs@vger.kernel.org>; Tue,  2 Oct 2018 10:25:26 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 637B460B374
        for <linux-xfs@vger.kernel.org>; Tue,  2 Oct 2018 10:25:26 -0400 (EDT)
Date: Tue, 2 Oct 2018 16:25:30 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: [somewhat OT] I just discovered that Stratis uses XFS.
Message-ID: <20181002162530.42b30c11@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CcX5WJmarZo+J7pBpwysmk2"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

--Sig_/CcX5WJmarZo+J7pBpwysmk2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,=20
in fact I just discovered that Stratis exists :)
(https://stratis-storage.github.io/relnotes/relnotes-1.0.html) ( details
on https://lwn.net/Articles/755454/)

Reading the FAQ (https://stratis-storage.github.io/FAQ.html) I see that
it uses XFS as a filesystem layer. Furthermore it seems to come from
RedHat. What are the relations with the future XFS capabilities that
Dave (IIRC) demonstrated recently?

Sorry for the OT message :)
--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/CcX5WJmarZo+J7pBpwysmk2
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAluzf9oACgkQX3jQXNUicVa52ACgp6eT1U+NSUj2hGaFlkZwl+jR
B+wAn06Yvx1AsJBKwbuxJAk+90VHnAtm
=2fbT
-----END PGP SIGNATURE-----

--Sig_/CcX5WJmarZo+J7pBpwysmk2--
