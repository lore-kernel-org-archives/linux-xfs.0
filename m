Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from yrk.mx.bytemark.co.uk ([80.68.81.84]:43819 "EHLO
        yrk.mx.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753667AbdH2Ltj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 07:49:39 -0400
Received: from ratatoskr.bytemark.co.uk ([2001:41c9:0:1017::48] helo=ratatoskr.dh.bytemark.co.uk)
        by yrk.mx.bytemark.co.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <chris.cottam@bytemark.co.uk>)
        id 1dmec1-00023S-M9
        for linux-xfs@vger.kernel.org; Tue, 29 Aug 2017 12:23:17 +0100
Received: from [2001:41c8:3::106]
        by ratatoskr.dh.bytemark.co.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <chris.cottam@bytemark.co.uk>)
        id 1dmec1-0000nw-J1
        for linux-xfs@vger.kernel.org; Tue, 29 Aug 2017 12:23:17 +0100
From: Chris Cottam <chris.cottam@bytemark.co.uk>
Subject: XFS reflinks
Message-ID: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
Date: Tue, 29 Aug 2017 12:23:13 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3fd66VWvWcLWskwJC27W8SvC4Wsuj9JE9"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3fd66VWvWcLWskwJC27W8SvC4Wsuj9JE9
Content-Type: multipart/mixed; boundary="n6eUrucMIDFCLM2S7eTNWBHC6Fnd0JEi1";
 protected-headers="v1"
From: Chris Cottam <chris.cottam@bytemark.co.uk>
To: linux-xfs@vger.kernel.org
Message-ID: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
Subject: XFS reflinks

--n6eUrucMIDFCLM2S7eTNWBHC6Fnd0JEi1
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

I've got a project where being able to take COW copies of a VMs disc
would be really useful (disc snapshots to be then archived off elsewhere)=


How stable is the the experimental reflinks feature and do you have any
idea when it might be declared stable?

Regards

Chris


--n6eUrucMIDFCLM2S7eTNWBHC6Fnd0JEi1--

--3fd66VWvWcLWskwJC27W8SvC4Wsuj9JE9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZpU6lAAoJEFZm4Qf2RyJWPSoP/3UwdMw62p7kAQHhK9P2x1xZ
Gt9+oMbNithPPvxHYg7LZr4SQOZPWWAYtecSFtqcIGEND902P9mUpILSEsGlZqa1
UMjarD30vCW8CEyN2Dq7lbyZJIR19Lj5cFgqweMNgKRX44BEwiUxt/TUOmCNt8Lr
vr23MYyusSarTZKEYGuPUOqOXo66w6EmEnPChZ5wtEJLSuhcYMQAD2ZrTT99Rj8y
U64fjlUFFHJPR2fFL75X6Y4SJIYIH0F2h43jwcycYU2gFr9OWBThMCHY/pek96+D
Um3HY5IU+stbCc70+E2yILdKgHFM2UMRGXC83TspW8kEjmO686t3EmNqnApZOJkK
EJYLWORc7204O1A+pF6YB9rewXbLBm+dfzkPL1rOP+GhgAk3kCEU1hB+V3AV5JL1
SWuIqxz8rNabZ7Di3gIQF60WFyU0+1Zl2de1PSdkOQQOh2BKVxhYUA4ChW9y+H2H
KfxKmp80qckLnCHPPdtERs+8ao8gPczEsz9zDPzKJX6gxxAJQsp0UEIYN4XSjYCF
r7yuGsQn7vNNGpJd2iQuNI8/+EDttj8jj8R4m5+kKK3u/iKMbaIg5t8tDUI+754N
icLEM7Fyv7J9R/j8ksXDBQz4bJ7FcnJXXJKc1Hy2cJ+fdv6K3gJ1W1td2SIpRR0U
YTumOhBvYTFVfHxwYO/a
=oSfO
-----END PGP SIGNATURE-----

--3fd66VWvWcLWskwJC27W8SvC4Wsuj9JE9--
