Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout02-q01.e.movistar.es ([86.109.101.151]:26981 "EHLO
        relayout02-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727641AbfGJSff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 14:35:35 -0400
Received: from relayout02-redir.e.movistar.es (unknown [86.109.101.202])
        by relayout02-out.e.movistar.es (Postfix) with ESMTP id 45kSYJ5S21zhYSw
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 20:35:32 +0200 (CEST)
Received: from Telcontar.valinor (70.red-88-9-30.dynamicip.rima-tde.net [88.9.30.70])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout02.e.movistar.es (Postfix) with ESMTPSA id 45kSYJ3NhGzdbHF
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 20:35:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id EA1E3320B3B
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 20:35:31 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id bZ8OXrx0Rl8w for <linux-xfs@vger.kernel.org>;
        Wed, 10 Jul 2019 20:35:31 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id B7411320B2A
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 20:35:31 +0200 (CEST)
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
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <e1dea87a-a2d8-4f4c-8807-4027a1a03a41@telefonica.net>
Date: Wed, 10 Jul 2019 20:35:31 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ08-hu7Cr2Li4v07r8v1isxZu=_hP3aQpHqJw4D2jCmg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Zk0ru7DmSMb2ECek6lcwQ6JdiZExfBVxm"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: xfs list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Zk0ru7DmSMb2ECek6lcwQ6JdiZExfBVxm
Content-Type: multipart/mixed; boundary="zZ8RlCyMkwXHFlofuSQuOPApbK55GikJS";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
Cc: xfs list <linux-xfs@vger.kernel.org>
Message-ID: <e1dea87a-a2d8-4f4c-8807-4027a1a03a41@telefonica.net>
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
In-Reply-To: <CAJCQCtQ08-hu7Cr2Li4v07r8v1isxZu=_hP3aQpHqJw4D2jCmg@mail.gmail.com>

--zZ8RlCyMkwXHFlofuSQuOPApbK55GikJS
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 10/07/2019 20.03, Chris Murphy wrote:
> On Wed, Jul 10, 2019 at 11:16 AM Andrey Zhunev <a-j@a-j.ru> wrote:

=2E..

>> When reallocated sectors appear - it's clearly a bad sign. If the
>> number of reallocated sectors grow - the drive should not be used.
>> But it's not that obvious for the pending sectors...
>=20
> They're both bad news. It's just a matter of degree. Yes a
> manufacturer probably takes the position that pending sectors is and
> even remapping is normal drive behavior. But realistically it's not
> something anyone wants to have to deal with. It's useful for
> curiousity. Use it for Btrfs testing :-D

I have used some disks with some reallocated sectors for several years
after the "event", with not even a single failure afterwards. It should
not be fatal. For me, the criteria is that the number does not increase,
and that it is not large.


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 15.0 x86_64 at Telcontar)


--zZ8RlCyMkwXHFlofuSQuOPApbK55GikJS--

--Zk0ru7DmSMb2ECek6lcwQ6JdiZExfBVxm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXSYv8wAKCRC1MxgcbY1H
1W7RAKCJeWrhkHC7FXZbjjS6DBxKxZEIngCfSv6jW2uqai9CnQ9T9d9gzvEgAiM=
=BDEw
-----END PGP SIGNATURE-----

--Zk0ru7DmSMb2ECek6lcwQ6JdiZExfBVxm--
