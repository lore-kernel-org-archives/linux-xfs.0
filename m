Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15676 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdJCUNa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:13:30 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Date: Tue, 3 Oct 2017 20:13:26 +0000
Message-ID: <1507061605.2567.13.camel@wdc.com>
References: <20171003185313.1017-1-mcgrof@kernel.org>
         <20171003185313.1017-6-mcgrof@kernel.org>
In-Reply-To: <20171003185313.1017-6-mcgrof@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCBE2C891CB2F44BB4FA0C8A21B6438E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>
Cc: "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "jgross@suse.com" <jgross@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "jack@suse.cz" <jack@suse.cz>

T24gVHVlLCAyMDE3LTEwLTAzIGF0IDExOjUzIC0wNzAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90
ZToNCj4gTm93IHRoYXQgYWxsIGZpbGVzeXN0ZW1zIHdoaWNoIHVzZWQgdG8gcmVseSBvbiBrdGhy
ZWFkDQo+IGZyZWV6aW5nIGhhdmUgYmVlbiBjb252ZXJ0ZWQgdG8gZmlsZXN5c3RlbSBmcmVlemUv
dGhhd2luZw0KPiB3ZSBjYW4gcmVtb3ZlIHRoZSBrZXJuZWwga3RocmVhZCBmcmVlemVyLg0KDQpN
YW55IHN1YnN5c3RlbXMgdXNlIHN5c3RlbV9mcmVlemFibGVfd3EgYW5kL29yDQpzeXN0ZW1fZnJl
ZXphYmxlX3Bvd2VyX2VmZmljaWVudF93cSB0byBxdWV1ZSB3b3JrIHRoYXQgc2hvdWxkIG5vdCBy
dW4gd2hpbGUNCnByb2Nlc3NlcyBhcmUgZnJvemVuLiBTaG91bGQgaXQgYmUgbWVudGlvbmVkIGlu
IHRoZSBwYXRjaCBkZXNjcmlwdGlvbiB0aGF0DQp0aGlzIHBhdGNoIGRvZXMgbm90IGFmZmVjdCB3
b3JrcXVldWVzIGZvciB3aGljaCBXUV9GUkVFWkFCTEUgaGFzIGJlZW4gc2V0Pw0KDQpXaGF0IGFi
b3V0IHRoZSBtYW55IGRyaXZlcnMgb3V0c2lkZSBmaWxlc3lzdGVtcyB0aGF0IHVzZSB0aGUgc2V0
X2ZyZWV6YWJsZSgpIC8NCnRyeV90b19mcmVlemUoKSAvIHdhaXRfZXZlbnRfZnJlZXphYmxlKCkg
QVBJPw0KDQpUaGFua3MsDQoNCkJhcnQu
