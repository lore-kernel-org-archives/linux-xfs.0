Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75E5C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 16:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE65661B51
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 16:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbhKSQma (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 11:42:30 -0500
Received: from sandeen.net ([63.231.237.45]:53846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235220AbhKSQma (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Nov 2021 11:42:30 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 58C0233E2
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 10:39:12 -0600 (CST)
Message-ID: <02091a18-c936-0cf2-8a42-b6e4c0f2338e@sandeen.net>
Date:   Fri, 19 Nov 2021 10:39:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.14.0 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------QKwtVSzq0P3GwAO9XW5NB1OA"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------QKwtVSzq0P3GwAO9XW5NB1OA
Content-Type: multipart/mixed; boundary="------------IJSkK3FRZ0kH0eHdzMRi4lm2";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <02091a18-c936-0cf2-8a42-b6e4c0f2338e@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.14.0 released

--------------IJSkK3FRZ0kH0eHdzMRi4lm2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZm9sa3MsDQoNClRoZSBtYXN0ZXIgYnJhbmNoIG9mIHRoZSB4ZnNwcm9ncyByZXBvc2l0
b3J5IGF0Og0KDQogICAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vZnMveGZzL3hm
c3Byb2dzLWRldi5naXQNCg0KaGFzIGp1c3QgYmVlbiB1cGRhdGVkIGFuZCB0YWdnZWQgd2l0
aCA1LjE0LjAuIFRoZXJlIGFyZSBvbmx5IERlYmlhbiBwYWNrYWdpbmcNCmNoYW5nZXMgc2lu
Y2UgLXJjMS4NCg0KTk9URTogdGhlcmUgaXMgYSBuZXcgYnVpbGQgZGVwZW5kZW5jeSBvbiB1
c2Vyc3BhY2UgUkNVLCBpLmUuIGxpYnVyY3Ugb24gRGViaWFuLA0KdXNlcnNwYWNlLXJjdSBv
biBGZWRvcmEuDQoNCm1rZnMgd2lsbCBhbHNvIG5vdyB3YXJuIGFib3V0IGNyZWF0aW5nIFY0
IGZpbGVzeXN0ZW1zLCB3aGljaCB3aWxsIGJlIGRlcHJlY2F0ZWQNCmluIHRoZSBmdXR1cmUu
DQoNClRhcmJhbGxzIGFyZSBhdmFpbGFibGUgYXQ6DQoNCmh0dHBzOi8vd3d3Lmtlcm5lbC5v
cmcvcHViL2xpbnV4L3V0aWxzL2ZzL3hmcy94ZnNwcm9ncy94ZnNwcm9ncy01LjE0LjAudGFy
Lmd6DQpodHRwczovL3d3dy5rZXJuZWwub3JnL3B1Yi9saW51eC91dGlscy9mcy94ZnMveGZz
cHJvZ3MveGZzcHJvZ3MtNS4xNC4wLnRhci54eg0KaHR0cHM6Ly93d3cua2VybmVsLm9yZy9w
dWIvbGludXgvdXRpbHMvZnMveGZzL3hmc3Byb2dzL3hmc3Byb2dzLTUuMTQuMC50YXIuc2ln
bg0KDQpUaGUgbmV3IGhlYWQgb2YgdGhlIG1hc3RlciBicmFuY2ggaXMgY29tbWl0Og0KDQo2
MDQwODdjYSB4ZnNwcm9nczogUmVsZWFzZSB2NS4xNC4wDQoNClRoZSBjb25kZW5zZWQgY2hh
bmdlbG9nIHNpbmNlIDUuMTMuMCBpczoNCg0KeGZzcHJvZ3MtNS4xNC4wICgxOSBOb3YgMjAy
MSkNCiAgICAgICAgIC0gZGViaWFuOiBGaXggRlRCRlMgKEJvaWFuIEJvbmV2KQ0KICAgICAg
ICAgLSBkZWJpYW46IFBhc3MgLS1idWlsZCBhbmQgLS1ob3N0IHRvIGNvbmZpZ3VyZSAoQmFz
dGlhbiBHZXJtYW5uKQ0KICAgICAgICAgLSBkZWJpYW46IFVwZGF0ZSBVcGxvYWRlcnMgbGlz
dCAoQmFzdGlhbiBHZXJtYW5uKQ0KDQp4ZnNwcm9ncy01LjE0LjAtcmMxICgxMiBOb3YgMjAy
MSkNCiAgICAgICAgIC0geGZzcHJvZ3M6IGludHJvZHVjZSBsaWJ1cmN1IHN1cHBvcnQgKERh
dmUgQ2hpbm5lcikNCiAgICAgICAgIC0geGZzcHJvZ3M6IGNvbnZlcnQgYXRvbWljIHRvIHVh
dG9taWMgKERhdmUgQ2hpbm5lcikNCiAgICAgICAgIC0geGZzcHJvZ3M6IGNvbnZlcnQgdXRp
bGl0aWVzIHRvIHVzZSAiZmFsbHRocm91Z2g7IiAoRGFycmljayBKLiBXb25nKQ0KICAgICAg
ICAgLSBsaWJ4ZnM6IHBvcnQgeGZzX3NldF9pbm9kZV9hbGxvYyBmcm9tIGtlcm5lbCAoRGFy
cmljayBKLiBXb25nKQ0KICAgICAgICAgLSBta2ZzOiB3YXJuIGFib3V0IFY0IGRlcHJlY2F0
aW9uIChEYXJyaWNrIEouIFdvbmcpDQogICAgICAgICAtIHhmc19kYjogY29udmVydCBhZ3Jl
c3YgdG8gdXNlIGZvcl9lYWNoX3BlcmFnIChEYXJyaWNrIEouIFdvbmcpDQoNCg==

--------------IJSkK3FRZ0kH0eHdzMRi4lm2--

--------------QKwtVSzq0P3GwAO9XW5NB1OA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmGX0z4FAwAAAAAACgkQIK4WkuE93uDA
Lw/8CZsVkOVng3XUBzXewU/V+XlDYFwgFz0Z12EvCTxAk2M6ztDp54YyJeJ6oV6BLg3PxEttk+C+
2+WNM+i1raToGbK2D4Mxs7EQsCe0j1f7A3vvsr5DC9/3onkjN3Uf8tvElioHtBE1Gic/OuXnT9M6
9x4ni8JMXiB7oZYlK5qLqAkJvv8290N+fP1tfCQgA847pdnrnWPLxvWvZtYOo1dZYyoDd4goeF7+
q5beQchOKPREUkyRWPfhPuWgsaWDJ0xePB5ccHem5+veTUDCqQYqwv8nQc3uCkqzzhrgnfUdgaMe
tffoPvh+gzoFhC1V1ilzf5sJMp2UjQJUSxfDeD+IlATc7+S6V3o49TrYpg82J1aoU4tE35aJ0no/
n8wfNQG/uq3KjT6DGTiUsQBFiJjpQuaov7PmG8P7M6h4eUuLjpT/UpKtlBg//PmItnJfWnEkmu5j
tsWBTAcIf4Edzz+HxKcXQYABcAMf9Ln/WesBd7QtMi7VW5zq002cibCLKb9mXytVYLxasRq9UMDn
a6ITfM6UfcUjSwsf98uM495fZOVMi/NukCegrEWBZM22lR46pfCJbYKweanpg0DYb0FBH6JNdRfa
x1sP880vz3Ou7+Lrqm45digtByZm0w5dsWQQCOGpUMj6lj6HN/TzsE0cDQi6yS6cYU7hDIxMaFk6
TJY=
=SDHD
-----END PGP SIGNATURE-----

--------------QKwtVSzq0P3GwAO9XW5NB1OA--
