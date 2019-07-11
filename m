Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout03-q01.e.movistar.es ([86.109.101.161]:16603 "EHLO
        relayout03-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727680AbfGKKXs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 06:23:48 -0400
Received: from relayout03-redir.e.movistar.es (unknown [86.109.101.203])
        by relayout03-out.e.movistar.es (Postfix) with ESMTP id 45ksbQ3pcbzQjxf
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 12:23:46 +0200 (CEST)
Received: from Telcontar.valinor (70.red-88-9-30.dynamicip.rima-tde.net [88.9.30.70])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout03.e.movistar.es (Postfix) with ESMTPSA id 45ksbQ2F2VzMlff
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 12:23:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id CBD3A320B3B
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 12:23:45 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Jsk1-TwGO0nf for <linux-xfs@vger.kernel.org>;
        Thu, 11 Jul 2019 12:23:45 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 6FBAC320B2A
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 12:23:45 +0200 (CEST)
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
 <cebdb77b-e175-06a8-a78d-525f86d10457@telefonica.net>
 <438631176.20190711101012@a-j.ru>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <c3597af9-1b57-0b7c-6367-c38c1aea352c@telefonica.net>
Date: Thu, 11 Jul 2019 12:23:45 +0200
MIME-Version: 1.0
In-Reply-To: <438631176.20190711101012@a-j.ru>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="zs7GuCTuqRCslBnR8NBrqW4O4NanMJHFQ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zs7GuCTuqRCslBnR8NBrqW4O4NanMJHFQ
Content-Type: multipart/mixed; boundary="KnWdeAQjEjtB0MRyVM0IHVYxBMMAZdMJz";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: xfs list <linux-xfs@vger.kernel.org>
Message-ID: <c3597af9-1b57-0b7c-6367-c38c1aea352c@telefonica.net>
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
 <cebdb77b-e175-06a8-a78d-525f86d10457@telefonica.net>
 <438631176.20190711101012@a-j.ru>
In-Reply-To: <438631176.20190711101012@a-j.ru>

--KnWdeAQjEjtB0MRyVM0IHVYxBMMAZdMJz
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 11/07/2019 09.10, Andrey Zhunev wrote:
>=20
> Thursday, July 11, 2019, 5:47:36 AM, you wrote:

=2E..

>>> So I wiped them with hdparm:
>>> # hdparm --yes-i-know-what-i-am-doing --write-sector <sector_number> =
/dev/sda
>=20
>> This has always eluded me. How did you know the sector numbers?
>=20
>=20
> When you use ddrescue (or any other tool) to try and read the data
> and there is a read error, an error message is added to your kernel
> log. You can find the sector number there:

Ah, ok, yes, I see. Thanks :-)

=2E..

>>> I then re-read all these sectors, and they were all read correctly.
>>>
>>> The number of pending sectors reported by SMART dropped down to 7.
>>> Interestingly, there are still NO reallocated sectors reported.
>=20
>> I suspect that the figure SMART reports only starts to rise after some=

>> unknown amount of sectors have been remapped, so when the numbers
>> actually appear there, it is serious.
>=20
> Hmmm, this is an interesting thought!
> Everybody lies... :)

It is either that, or the number has a multiplier, and starts counting
at one hundred, two hundred... I don't know.


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 15.0 x86_64 at Telcontar)


--KnWdeAQjEjtB0MRyVM0IHVYxBMMAZdMJz--

--zs7GuCTuqRCslBnR8NBrqW4O4NanMJHFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXScOMQAKCRC1MxgcbY1H
1TW+AJ9ByDzol22zW/o1rTpkizBcZ5dN5wCfd71G4BXTbZi4Y9/kXccvdgCKFzo=
=HJzA
-----END PGP SIGNATURE-----

--zs7GuCTuqRCslBnR8NBrqW4O4NanMJHFQ--
