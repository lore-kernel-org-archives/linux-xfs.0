Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29777C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 20:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136C3604D7
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbhKLUpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Nov 2021 15:45:11 -0500
Received: from sandeen.net ([63.231.237.45]:38038 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235659AbhKLUpI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Nov 2021 15:45:08 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A690C7902
        for <linux-xfs@vger.kernel.org>; Fri, 12 Nov 2021 14:42:11 -0600 (CST)
Message-ID: <12630b38-0d4c-52d9-c661-728b2e4b4d14@sandeen.net>
Date:   Fri, 12 Nov 2021 14:42:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.14.0-rc1 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lbjrZFyOQS0f0ZQcYd2qwS9n"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lbjrZFyOQS0f0ZQcYd2qwS9n
Content-Type: multipart/mixed; boundary="------------l24aehtqxUtM0gmh9zYoYSvW";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <12630b38-0d4c-52d9-c661-728b2e4b4d14@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.14.0-rc1 released

--------------l24aehtqxUtM0gmh9zYoYSvW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZm9sa3MsDQoNClRoZSB4ZnNwcm9ncyByZXBvc2l0b3J5IGF0Og0KDQoJZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9mcy94ZnMveGZzcHJvZ3MtZGV2LmdpdA0KDQpoYXMganVz
dCBiZWVuIHVwZGF0ZWQuDQoNClBhdGNoZXMgb2Z0ZW4gZ2V0IG1pc3NlZCwgc28gcGxlYXNl
IGNoZWNrIGlmIHlvdXIgb3V0c3RhbmRpbmcNCnBhdGNoZXMgd2VyZSBpbiB0aGlzIHVwZGF0
ZS4gSWYgdGhleSBoYXZlIG5vdCBiZWVuIGluIHRoaXMgdXBkYXRlLA0KcGxlYXNlIHJlc3Vi
bWl0IHRoZW0gdG8gbGludXgteGZzQHZnZXIua2VybmVsLm9yZyBzbyB0aGV5IGNhbiBiZQ0K
cGlja2VkIHVwIGluIHRoZSBuZXh0IHVwZGF0ZS4NCg0KVGhlIG5ldyBoZWFkIG9mIHRoZSBt
YXN0ZXIgYnJhbmNoIGlzIGNvbW1pdDoNCg0KMmVlNDM3NzIgeGZzcHJvZ3M6IFJlbGVhc2Ug
djUuMTQuMC1yYzENCg0KTmV3IENvbW1pdHM6DQoNCkRhcnJpY2sgSi4gV29uZyAoMik6DQog
ICAgICAgWzI2YTVkMjU3XSB4ZnM6IHN5bmMgeGZzX2J0cmVlX3NwbGl0IG1hY3JvcyB3aXRo
IHVzZXJzcGFjZSBsaWJ4ZnMNCiAgICAgICBbZmMyMzliY2JdIG1rZnM6IHdhcm4gYWJvdXQg
VjQgZGVwcmVjYXRpb24gd2hlbiBjcmVhdGluZyBuZXcgVjQgZmlsZXN5c3RlbXMNCg0KRXJp
YyBTYW5kZWVuICgyKToNCiAgICAgICBbMWZmODhjNjJdIHhmczogI2lmZGVmIG91dCBwZXJh
ZyBjb2RlIGZvciB1c2Vyc3BhY2UNCiAgICAgICBbMmVlNDM3NzJdIHhmc3Byb2dzOiBSZWxl
YXNlIHY1LjE0LjAtcmMxDQoNCg0KQ29kZSBEaWZmc3RhdDoNCg0KICBWRVJTSU9OICAgICAg
ICAgICAgfCA0ICsrLS0NCiAgY29uZmlndXJlLmFjICAgICAgIHwgMiArLQ0KICBkb2MvQ0hB
TkdFUyAgICAgICAgfCA4ICsrKysrKysrDQogIGxpYnhmcy94ZnNfYWcuYyAgICB8IDIgKysN
CiAgbGlieGZzL3hmc19hZy5oICAgIHwgOCArKysrKy0tLQ0KICBsaWJ4ZnMveGZzX2J0cmVl
LmMgfCA0ICsrLS0NCiAgbWtmcy94ZnNfbWtmcy5jICAgIHwgOSArKysrKysrKysNCiAgNyBm
aWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0K

--------------l24aehtqxUtM0gmh9zYoYSvW--

--------------lbjrZFyOQS0f0ZQcYd2qwS9n
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmGO0acFAwAAAAAACgkQIK4WkuE93uCc
SQ/5ARjhTnzGJeSdqagzxWyFM1PgJriCvwnPdK/qLQGYBZr/ZqX9cQf9LgUyZ4Xpsk2pos8JxFWd
N5wyYJfwnVtq4MVvUDXsOKArcri//4pK8HY4WKGhccpGoZjdgmmckakfl37/3odp6ZuBVpb8ejJT
mvNLqLIO9NAF6OnEFW4oeqD3Pw+sHbYjLEl+xiede0+onRrC86Onpp1b5KowbwzrhPzRYdauIi4r
kgSokQWYK1+3h1xx8QKeHwCAYnDfwk8ADceBgCEsb4HWkG5dVS5QX7Eqv8MwBcd6DLWOUhP5Olox
Xn3pgkxjYheViuwa0ehFaraumYddIKYFIiTQSipp9FqgmZc2amaN6vxR+mKD5n7k2uJNcvB4LnEA
jtvT5ZkZkHg486hKTDVmuli2btKkTD03cWJgL5aJXROSYYbG8zCExXwKGGtrthHRYbfPvifxxggP
MEi2R0pbdyzJfGjKPY0DTiQTCm++jWhz8Pj0gh1Azgq/vgmZuiPNFkhxFPhr3EvoTFYMsS7WH01v
1BcPaXoJ+S2xgq1VGHcMgKnBMu1rjR+YTa2/z6Eoy7GxeBYRIJYfs7/HWzzuGDM1BwT7QE4eEqjk
Ph/Egu+PkNx9IGtfsd9vz7RlE8Aq7x+L0veNRhVAm4Nt59x25MoTjNIj6pfksSbSHdV1KKcy778q
F1w=
=Ak5y
-----END PGP SIGNATURE-----

--------------lbjrZFyOQS0f0ZQcYd2qwS9n--
