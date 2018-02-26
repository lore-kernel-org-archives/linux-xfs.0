Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35604 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751448AbeBZRcH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 12:32:07 -0500
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5FAAE325433
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 11:31:12 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs libxfs-4.16-sync branch pushed
Message-ID: <216787d2-6727-f943-9b3b-c815445c6f8f@sandeen.net>
Date: Mon, 26 Feb 2018 11:32:05 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2iTwkitZOspgLpjpVvIEBRKEgZTI1ODsw"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2iTwkitZOspgLpjpVvIEBRKEgZTI1ODsw
Content-Type: multipart/mixed; boundary="SADR8aTYC6uk4O909iBKZ09PJB7S2BOia";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <216787d2-6727-f943-9b3b-c815445c6f8f@sandeen.net>
Subject: [ANNOUNCE] xfsprogs libxfs-4.16-sync branch pushed

--SADR8aTYC6uk4O909iBKZ09PJB7S2BOia
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

I've pushed up a preliminary libxfs-4.16-sync branch for xfsprogs to
pull in all the kernel 4.16 changes.  No detailed changelog here as it's
just the kernel sync-up.

This is just my first pass at it, the branch will almost certainly
be rebased before I merge it to for-next, but if anyone spots any
issues please feel free to let me know.

Thanks,
-Eric


--SADR8aTYC6uk4O909iBKZ09PJB7S2BOia--

--2iTwkitZOspgLpjpVvIEBRKEgZTI1ODsw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlqURJYACgkQIK4WkuE9
3uAmYw//VYBWc+2LDHB/4YJtLB9Bv9ti7+Ct0vZoZeflpJOtnoh5EB5KRxrMXIOG
lIC8/bV3UKOhI2WdDtlpmlsGKBf5yva3kGdrEUTAay/Sl/E+ExfQcPLQOaOSmHV0
FXIJiA/h3biwW71gQepmQUXb2dnTP2BkNFvTremtWr9Mgpeor4oXYvTjMrngM75w
K/mpm4krT6QsDemmDfHw2zWcgFwHDpH+RbfjAulIwFkytP3dbT35+NproKxWN1Jo
bZvj5rCCAmdfev1HAanh25HyzX9HieBdhT2ScbGVQI/16vbww9pLw/doisdyDenv
Q3ccopo6gnqJ0jODXcWhcuVmAqG8SA1kCyXhKiczjn1dsdQVSGqrpJIxJCENZ6Vw
EV82IoE4vM/ADShdHfNM1YnXstvdnN3PoAmuRAkOI76N9GFL68KVjVFxMAC0UcFX
dwMftxGgGks/8wBFUoCAA0ITadAiLVtXjgoxT1o49b64Wvxr+oc85JOVqHxTGl4i
39KXn8UJloN6xS6VgcOq5/Y35MaIg1VVkQj0SFV+fGjQASLrsVl0V0AIM/JTgnbg
vCWEz3+rrPIL4DYjv2WiKffLFjmnTu8qiKxZyIJl2R7UNpe/Q6yf+rIoo8PdmZTe
jhVvDomf9fAzU8VDuOkuK17Mv7xvam4ZIkB32hd/TGijla9lggc=
=4opU
-----END PGP SIGNATURE-----

--2iTwkitZOspgLpjpVvIEBRKEgZTI1ODsw--
