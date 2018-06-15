Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34070 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753735AbeFOU5C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 16:57:02 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] libxfs: detect zoned disks and prevent their raw use
Date: Fri, 15 Jun 2018 20:56:57 +0000
Message-ID: <7c229a7179312855f0a29a0ae71cf4a03382cd35.camel@wdc.com>
References: <20180615205011.7728-1-mcgrof@kernel.org>
In-Reply-To: <20180615205011.7728-1-mcgrof@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <0015EB15783BDE42ADEC129A2C6DD48E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "sandeen@sandeen.net" <sandeen@sandeen.net>, "mcgrof@kernel.org" <mcgrof@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "mwilck@suse.com" <mwilck@suse.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>

T24gRnJpLCAyMDE4LTA2LTE1IGF0IDEzOjUwIC0wNzAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90
ZToNCj4gK3N0YXRpYyBpbnQNCj4gK2lzX3pvbmVkX2Rpc2soY2hhciAqcGF0aCkNCj4gK3sNCj4g
KwljaGFyIHN0cltQQVRIX01BWF07DQo+ICsJY2hhciAqZGV2bmFtZSA9IGJhc2VuYW1lKHBhdGgp
Ow0KPiArCUZJTEUgKmZpbGU7DQo+ICsJaW50IGxlbjsNCj4gKw0KPiArDQo+ICsJbGVuID0gc25w
cmludGYoc3RyLCBzaXplb2Yoc3RyKSwgIi9zeXMvYmxvY2svJXMvcXVldWUvem9uZWQiLCBkZXZu
YW1lKTsNCg0KSGF2ZSB5b3UgY29uc2lkZXJlZCB0byB1c2UgYXNwcmludGYoKSBpbnN0ZWFkIG9m
IHVzaW5nIHNucHJpbnRmKCkgYW5kIGEgZml4ZWQNCnNpemUgYnVmZmVyPw0KDQo+ICsNCj4gKwkv
KiBJbmRpY2F0ZXMgdHJ1bmNhdGlvbiAqLw0KPiArCWlmIChsZW4gPj0gUEFUSF9NQVgpIHsNCj4g
KwkJZXJybm8gPSBFTkFNRVRPT0xPTkc7DQo+ICsJCXJldHVybiAtMTsNCj4gKwl9DQo+ICsNCj4g
KwlmaWxlID0gZm9wZW4oc3RyLCAiciIpOw0KPiArCWlmICghZmlsZSkNCj4gKwkJcmV0dXJuIDA7
DQo+ICsNCj4gKwlmY2xvc2UoZmlsZSk7DQo+ICsNCj4gKwlyZXR1cm4gMTsNCj4gK30NCg0KSSB0
aGluayB0aGF0IHlvdSBoYXZlIHRvIHJlYWQgdGhlIHN5c2ZzIGZpbGUgYW5kIG9ubHkgcmV0dXJu
IDEgZm9yIGhvc3QtbWFuYWdlZA0KZHJpdmVzLiBDcmVhdGluZyBhIGZpbGVzeXN0ZW0gb24gdG9w
IG9mIGEgaG9zdC1hd2FyZSBkcml2ZSBzaG91bGQgbm90IGJlIGZvcmJpZGRlbi4NClBsZWFzZSBh
bHNvIHJlbmFtZSAiaXNfem9uZWRfZGlzaygpIiBpbnRvICJpc19ob3N0X21hbmFnZWQoKSIgb3Ig
c28uDQoNClRoYW5rcywNCg0KQmFydC4NCg0KDQoNCg0K
