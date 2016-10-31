Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp09.acens.net ([86.109.99.133]:57261 "EHLO smtp.movistar.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S947144AbcJaVb1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Oct 2016 17:31:27 -0400
Received: from Telcontar.valinor (88.20.238.12) by smtp.movistar.es (8.6.122.03) (authenticated as robin.listas2)
        id 57A601420475B333 for linux-xfs@vger.kernel.org; Mon, 31 Oct 2016 21:31:25 +0000
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 9C20E120AE1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2016 22:31:24 +0100 (CET)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id AVy7sufaaRYF for <linux-xfs@vger.kernel.org>;
        Mon, 31 Oct 2016 22:31:24 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 6FFF0120AE0
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2016 22:31:24 +0100 (CET)
Subject: Re: Fwd: mounting a xfs file system gives the message: "failure code
 -3003" and "structure needs cleaning"
References: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
 <8bd7b65f-d85d-2958-dd7d-ba97c91ac9ea@telefonica.net>
 <CAPvv1vx-Juge8e=36bq4AFvGxs8Kf7-V_v0j+a9LGWYdDo5h+w@mail.gmail.com>
 <20161031194212.GU14023@dastard>
 <CAPvv1vzDQO9iMNhXByGfXrbLEtMt=F1xFd1Ybr63AAuPfvA6iw@mail.gmail.com>
 <20161031203715.GV14023@dastard>
 <CAPvv1vyGXNHP3pFAB6DAGPWfrwqpV22bS35JUXwwCwRJ-xE8Fg@mail.gmail.com>
 <20161031205810.GW14023@dastard>
 <CAPvv1vxt2MDwf8rXW9HCPprWyg-=h8YFxqhSya9WrKAhMo9kqg@mail.gmail.com>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <4124580a-9694-9ca3-98b1-5c8f1d4a80c1@telefonica.net>
Date: Mon, 31 Oct 2016 22:31:16 +0100
MIME-Version: 1.0
In-Reply-To: <CAPvv1vxt2MDwf8rXW9HCPprWyg-=h8YFxqhSya9WrKAhMo9kqg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="THRNutR7nKvXdNiJUqJKwaqHvofn1EoW5"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--THRNutR7nKvXdNiJUqJKwaqHvofn1EoW5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2016-10-31 22:09, Steffen D. wrote:
> 2016-10-31 21:58 GMT+01:00 Dave Chinner <david@fromorbit.com>:


>> What kernel versions? Both old and new versions are important.
>=20
> old kernel: 3.16
> new kernel: 4.1
>=20
> sorry, I have not more detailed informations

If you upgraded in place (example, zypper dup), the /var/log/zypp/
directory contains all the history of updates and installations.

If you installed new on top of the old install, then no.


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)


--THRNutR7nKvXdNiJUqJKwaqHvofn1EoW5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlgXuCwACgkQtTMYHG2NR9V5TwCfb2yWnKSlPrKHXpZCYe2An8+g
vH8Ani4jX0QovyksIRPzrHEmoi4Iqxl8
=MStg
-----END PGP SIGNATURE-----

--THRNutR7nKvXdNiJUqJKwaqHvofn1EoW5--
