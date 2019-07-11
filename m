Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout04-q02.e.movistar.es ([86.109.101.172]:16021 "EHLO
        relayout04-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727315AbfGKCrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 22:47:47 -0400
Received: from relayout04-redir.e.movistar.es (unknown [86.109.101.204])
        by relayout04-out.e.movistar.es (Postfix) with ESMTP id 45kgTG10Cgz24hB
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 04:47:46 +0200 (CEST)
Received: from Telcontar.valinor (70.red-88-9-30.dynamicip.rima-tde.net [88.9.30.70])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout04.e.movistar.es (Postfix) with ESMTPSA id 45kgTF4TxTz127t
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 04:47:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 1D020320B3B
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 04:47:45 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id arXaM1poLxbI for <linux-xfs@vger.kernel.org>;
        Thu, 11 Jul 2019 04:47:44 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 8A3A1320B2A
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 04:47:44 +0200 (CEST)
Subject: Re: Need help to recover root filesystem after a power supply issue
References: <958316946.20190710124710@a-j.ru>
 <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru>
 <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
 <1015034894.20190710190746@a-j.ru>
 <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
 <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
 <816157686.20190710201614@a-j.ru>
 <CAJCQCtQ08-hu7Cr2Li4v07r8v1isxZu=_hP3aQpHqJw4D2jCmg@mail.gmail.com>
 <e1dea87a-a2d8-4f4c-8807-4027a1a03a41@telefonica.net>
 <CAJCQCtS0EfAghBGoL-YVTEANfAXV4Oy7Q+4Q0Jp3xOF-uQhixA@mail.gmail.com>
 <18310556842.20190711024340@a-j.ru>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <cebdb77b-e175-06a8-a78d-525f86d10457@telefonica.net>
Date: Thu, 11 Jul 2019 04:47:36 +0200
MIME-Version: 1.0
In-Reply-To: <18310556842.20190711024340@a-j.ru>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="hf0BluAzSr5j7lnhSidIiFznuRzzbUlvS"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hf0BluAzSr5j7lnhSidIiFznuRzzbUlvS
Content-Type: multipart/mixed; boundary="bO7A8J4h2o6V54vpuvUin2fXs7wglRs3m";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: xfs list <linux-xfs@vger.kernel.org>
Message-ID: <cebdb77b-e175-06a8-a78d-525f86d10457@telefonica.net>
Subject: Re: Need help to recover root filesystem after a power supply issue
References: <958316946.20190710124710@a-j.ru>
 <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru>
 <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
 <1015034894.20190710190746@a-j.ru>
 <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
 <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
 <816157686.20190710201614@a-j.ru>
 <CAJCQCtQ08-hu7Cr2Li4v07r8v1isxZu=_hP3aQpHqJw4D2jCmg@mail.gmail.com>
 <e1dea87a-a2d8-4f4c-8807-4027a1a03a41@telefonica.net>
 <CAJCQCtS0EfAghBGoL-YVTEANfAXV4Oy7Q+4Q0Jp3xOF-uQhixA@mail.gmail.com>
 <18310556842.20190711024340@a-j.ru>
In-Reply-To: <18310556842.20190711024340@a-j.ru>

--bO7A8J4h2o6V54vpuvUin2fXs7wglRs3m
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 11/07/2019 01.43, Andrey Zhunev wrote:
>=20
> Ok, the ddrescue finished copying whatever it was able to recover.
> There were many unreadable sectors near the end of the drive.
> In total, there were over 170 pending sectors reported by SMART.
>=20
> I then ran the following commands:
>=20
> # smartctl -l scterc,900,100 /dev/sda
> # echo 180 > /sys/block/sda/device/timeout
>=20
> But this didn't help at all. The unreadable sectors still remained
> unreadable.
>=20
> So I wiped them with hdparm:
> # hdparm --yes-i-know-what-i-am-doing --write-sector <sector_number> /d=
ev/sda

This has always eluded me. How did you know the sector numbers?

At this point, I typically take the brutal approach of overwriting the
entire partition (or disk) with zeroes using dd, which works as a
destructive write test ;-)

Previous to that, I attempt to create an image with ddrescue, of course.

>=20
> I then re-read all these sectors, and they were all read correctly.
>=20
> The number of pending sectors reported by SMART dropped down to 7.
> Interestingly, there are still NO reallocated sectors reported.

I suspect that the figure SMART reports only starts to rise after some
unknown amount of sectors have been remapped, so when the numbers
actually appear there, it is serious.


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 15.0 x86_64 at Telcontar)


--bO7A8J4h2o6V54vpuvUin2fXs7wglRs3m--

--hf0BluAzSr5j7lnhSidIiFznuRzzbUlvS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXSajSAAKCRC1MxgcbY1H
1Z38AJ0UAEfjQ/eYzkWwTOD4HFzhyKf4EwCeK9STu67OXg8gRhXGi8RnKjubWa0=
=XNca
-----END PGP SIGNATURE-----

--hf0BluAzSr5j7lnhSidIiFznuRzzbUlvS--
