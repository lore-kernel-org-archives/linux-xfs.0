Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from yrk.mx.bytemark.co.uk ([80.68.81.84]:45234 "EHLO
        yrk.mx.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdH2NkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 09:40:01 -0400
Subject: Re: XFS reflinks
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org>
From: Chris Cottam <chris.cottam@bytemark.co.uk>
Message-ID: <d1c6f429-fc41-0e38-b704-444273aaae9e@bytemark.co.uk>
Date: Tue, 29 Aug 2017 14:39:56 +0100
MIME-Version: 1.0
In-Reply-To: <20170829130046.GA28896@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OdFT5rE7mu3Q2N40DEAtE9k59fqA2r14n"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OdFT5rE7mu3Q2N40DEAtE9k59fqA2r14n
Content-Type: multipart/mixed; boundary="96bRRCvjwHbkNJbPxn0lbGO14PSe3JsGm";
 protected-headers="v1"
From: Chris Cottam <chris.cottam@bytemark.co.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Message-ID: <d1c6f429-fc41-0e38-b704-444273aaae9e@bytemark.co.uk>
Subject: Re: XFS reflinks
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org>
In-Reply-To: <20170829130046.GA28896@infradead.org>

--96bRRCvjwHbkNJbPxn0lbGO14PSe3JsGm
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Could I enquire about the severity of a few issues?

Regard

Chris

On 29/08/17 14:00, Christoph Hellwig wrote:
> On Tue, Aug 29, 2017 at 12:23:13PM +0100, Chris Cottam wrote:
>> I've got a project where being able to take COW copies of a VMs disc
>> would be really useful (disc snapshots to be then archived off elsewhe=
re)
>>
>> How stable is the the experimental reflinks feature and do you have an=
y
>> idea when it might be declared stable?
>=20
> I've got a customer that heavily uses (and tests) reflinks.  They
> initially found a few issues, but these days the QA teams finds
> bugs in decade old XFS code but not related to reflinks..
>=20
> You're mileage my vary, but I think we should be able to drop the
> experimental tag now.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in=

> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Chris Cottam                                   Bytemark Hosting Support
                                             http://www.bytemark.co.uk/
                                              tel: +44 (0) 1904 890 890


--96bRRCvjwHbkNJbPxn0lbGO14PSe3JsGm--

--OdFT5rE7mu3Q2N40DEAtE9k59fqA2r14n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZpW6sAAoJEFZm4Qf2RyJWSMwP/iWMypUjJRDWJumNlyR0ynTA
MPnd0ciDb75axAFuMH2R5oYZxy8/6JDuL34oEcT1cLjMcyP27cCDEK8tthNuvJGf
Idakahav+XpHa0M3YRNjBUm0C73IboGEO09m2h806y//3Mpmd8xw+uMqbYKu+Dg2
/Rry8QLuvSyZ5zYQy2vkp3jzo6IOpZYCskQUnpyU8zN9fZsuzT8g93aGZ6vBe1Hv
dQAAUl/s/src3sn7LUMjOaqeW/YWW8zaGJ9t55S46rP06obx0871Tgm2dcr9JO/U
vl1ZpCFVI+ES/Q9DSepKHSJu02RlXP06DZRYD47TR7obNuFdnKRlco+9r3LIGk1T
dKHFcaSEsUPHxGpZEaRCY2csEhlNEjELsyoWqPJfl1zTCdXHwv1Urg9n1Oel0xqC
oyLgSU81z+DHRLV8SbYkT8HcAfE0ch794GbeW2QagZWo7vG1HGIQzZhErABETx9i
f7HEVZ3/aJYE6Unw46otdufBB8hXgGl9AdMl8o717MVDu1NQo4kVjONuXOG/duBi
AuLdHkB1cRQUtMbL8fsRGPFJatRVCBQqVFsmlBXFYFJDMLKwU6CGZ2J5dGH+fxTT
wNJi0sLkbCtvFgK1Buvg/wbv9+DZb+cdHa8T9tiL7waq73EoqwaFLrFvokg3zex9
nzzH2fGb2xT4f8H24GFd
=f6Aj
-----END PGP SIGNATURE-----

--OdFT5rE7mu3Q2N40DEAtE9k59fqA2r14n--
