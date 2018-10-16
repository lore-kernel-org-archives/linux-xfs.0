Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from 1.mo301.mail-out.ovh.net ([137.74.110.64]:58138 "EHLO
        1.mo301.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeJPWAI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Oct 2018 18:00:08 -0400
From: Romain Le Disez <romain.le-disez@corp.ovh.com>
Subject: Re: [QUESTION] multiple fsync() vs single sync()
Date: Tue, 16 Oct 2018 14:09:27 +0000
Message-ID: <2C57B701-747D-4603-9DA7-F4D766858C36@corp.ovh.com>
References: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com>
 <20181016125712.5k5xt4lzhi76qaj6@odin.usersys.redhat.com>
 <CAAxjCEyUL4nJ_Ds+ATragxGtUCyHjkZ9howsMHjc5H7VEe3xUg@mail.gmail.com>
In-Reply-To: <CAAxjCEyUL4nJ_Ds+ATragxGtUCyHjkZ9howsMHjc5H7VEe3xUg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1AA6376AF0C2F4B977648BE5B6DBDB8@corp.ovh.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

DQo+IExlIDE2IG9jdC4gMjAxOCDDoCAxNTo1MywgU3RlZmFuIFJpbmcgPHN0ZWZhbnJpbkBnbWFp
bC5jb20+IGEgw6ljcml0IDoNCj4gDQo+IEJ1dCBpbiB3aGF0IG9yZGVyPyBJZiBJIHVuZGVyc3Rv
b2QgY29ycmVjdGx5LCB3aXRoIHRoZSBzaW5nbGUgc3luYygpDQo+IGNhbGwsIGhlIG1pZ2h0IGVu
ZCB1cCB3aXRoIGEgZGlyZWN0b3J5IGVudHJ5IHJlZmVyZW5jaW5nIGFuIGluY29tcGxldGUNCj4g
ZmlsZS4gV2hpY2ggc2hvdWxkIG5vdCBiZSBwb3NzaWJsZSBpbiB0aGUgY2FzZSB3aXRoIHRoZSB0
d28gZnN5bmNzLg0KDQpJbiB3aGF0IG9yZGVyLCB0aGlzIGlzIGV4YWN0bHkgbXkgcXVlc3Rpb24g
OikNCg0KV2UgYXJlIGNyZWF0aW5nIGh1bmRyZWRzIG9yIHRob3VzYW5kcyBvZiBmaWxlcyBpbiBh
IHJvdy4gQ29udmVydGluZyB0aG91c2FuZHMgb2YgZnN5bmMoKSB0byBvbmUgc3luYygpIHdvdWxk
IGJlIGEgZ3JlYXQgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQsIGJ1dCBJIHdhbnQgdG8gYmUgc3Vy
ZSB3ZSBhcmUgbm90IHRha2luZyBhbnkgcmlzayB3aXRoIGRhdGEgY29uc2lzdGVuY3kuDQoNCi0t
IA0KUm9tYWluDQoNCg==
