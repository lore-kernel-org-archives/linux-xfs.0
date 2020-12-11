Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FABC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 17:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B0122257
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 17:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437636AbgLKQTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 11:19:53 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:42659 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394735AbgLKQT1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 11:19:27 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-21-k-MMa7B5NWytXTlCKpJtiw-1; Fri, 11 Dec 2020 16:17:48 +0000
X-MC-Unique: k-MMa7B5NWytXTlCKpJtiw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 11 Dec 2020 16:17:48 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 11 Dec 2020 16:17:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Sandeen' <sandeen@sandeen.net>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] fs/xfs: convert comma to semicolon
Thread-Topic: [PATCH -next] fs/xfs: convert comma to semicolon
Thread-Index: AQHWz9X+JwW+21or/kigRtAUH3yamanyElFg
Date:   Fri, 11 Dec 2020 16:17:47 +0000
Message-ID: <5f4ee9cf48a445cea25ba01bc9ffdf13@AcuMS.aculab.com>
References: <20201211084112.1931-1-zhengyongjun3@huawei.com>
 <fd372b27-983d-00ff-5218-4082fe2f08df@sandeen.net>
In-Reply-To: <fd372b27-983d-00ff-5218-4082fe2f08df@sandeen.net>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

RnJvbTogRXJpYyBTYW5kZWVuDQo+IFNlbnQ6IDExIERlY2VtYmVyIDIwMjAgMTU6NTENCj4gDQo+
IE9uIDEyLzExLzIwIDI6NDEgQU0sIFpoZW5nIFlvbmdqdW4gd3JvdGU6DQo+ID4gUmVwbGFjZSBh
IGNvbW1hIGJldHdlZW4gZXhwcmVzc2lvbiBzdGF0ZW1lbnRzIGJ5IGEgc2VtaWNvbG9uLg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWku
Y29tPg0KPiANCj4gaGFoLCB0aGF0J3MgYW4gb2xkIG9uZS4gIEhhcm1sZXNzIHRob3VnaCwgQUZB
SUNULg0KPiANCj4gdGhpcyBmaXhlcyA5MWNjYTVkZjliYzggKCJbWEZTXSBpbXBsZW1lbnQgZ2Vu
ZXJpYyB4ZnNfYnRyZWVfZGVsZXRlL2RlbHJlYyIpDQo+IGlmIHdlIGRhcmUgYWRkIHRoYXQgdGFn
IDspDQoNCkl0IGRvZXNuJ3QgJ2ZpeCcgYW55dGhpbmcsIGl0IGlzIGp1c3Qgc3R5bGlzdGljLg0K
Q29tcGxldGVseSBoYXJtbGVzcyBpbiBldmVyeSBzZW5zZS4NCg0KCURhdmlkDQoNCj4gDQo+IFJl
dmlld2VkLWJ5OiBFcmljIFNhbmRlZW4gPHNhbmRlZW5AcmVkaGF0LmNvbT4NCj4gDQo+ID4gLS0t
DQo+ID4gIGZzL3hmcy9saWJ4ZnMveGZzX2J0cmVlLmMgfCAyICstDQo+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2ZzL3hmcy9saWJ4ZnMveGZzX2J0cmVlLmMgYi9mcy94ZnMvbGlieGZzL3hmc19idHJlZS5jDQo+
ID4gaW5kZXggMmQyNWJhYjY4NzY0Li41MWRiZmY5YjA5MDggMTAwNjQ0DQo+ID4gLS0tIGEvZnMv
eGZzL2xpYnhmcy94ZnNfYnRyZWUuYw0KPiA+ICsrKyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2J0cmVl
LmMNCj4gPiBAQCAtNDA3MCw3ICs0MDcwLDcgQEAgeGZzX2J0cmVlX2RlbHJlYygNCj4gPiAgCSAq
IHN1cnZpdmluZyBibG9jaywgYW5kIGxvZyBpdC4NCj4gPiAgCSAqLw0KPiA+ICAJeGZzX2J0cmVl
X3NldF9udW1yZWNzKGxlZnQsIGxyZWNzICsgcnJlY3MpOw0KPiA+IC0JeGZzX2J0cmVlX2dldF9z
aWJsaW5nKGN1ciwgcmlnaHQsICZjcHRyLCBYRlNfQkJfUklHSFRTSUIpLA0KPiA+ICsJeGZzX2J0
cmVlX2dldF9zaWJsaW5nKGN1ciwgcmlnaHQsICZjcHRyLCBYRlNfQkJfUklHSFRTSUIpOw0KPiA+
ICAJeGZzX2J0cmVlX3NldF9zaWJsaW5nKGN1ciwgbGVmdCwgJmNwdHIsIFhGU19CQl9SSUdIVFNJ
Qik7DQo+ID4gIAl4ZnNfYnRyZWVfbG9nX2Jsb2NrKGN1ciwgbGJwLCBYRlNfQkJfTlVNUkVDUyB8
IFhGU19CQl9SSUdIVFNJQik7DQo+ID4NCj4gPg0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFr
ZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwg
VUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

