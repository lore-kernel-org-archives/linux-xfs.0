Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:41852 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751514AbdJCUWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:22:04 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Date: Tue, 3 Oct 2017 20:21:42 +0000
Message-ID: <1507062101.2567.16.camel@wdc.com>
References: <20171003185313.1017-1-mcgrof@kernel.org>
         <20171003185313.1017-6-mcgrof@kernel.org>
         <1507061605.2567.13.camel@wdc.com>
         <nycvar.YFH.7.76.1710032215140.17517@jbgna.fhfr.qr>
In-Reply-To: <nycvar.YFH.7.76.1710032215140.17517@jbgna.fhfr.qr>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <51FF403CC54C1741870215A58DB50BC3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "jikos@kernel.org" <jikos@kernel.org>
Cc: "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "jgross@suse.com" <jgross@suse.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>

T24gVHVlLCAyMDE3LTEwLTAzIGF0IDIyOjE3ICswMjAwLCBKaXJpIEtvc2luYSB3cm90ZToNCj4g
T24gVHVlLCAzIE9jdCAyMDE3LCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gV2hhdCBhYm91
dCB0aGUgbWFueSBkcml2ZXJzIG91dHNpZGUgZmlsZXN5c3RlbXMgdGhhdCB1c2UgdGhlIA0KPiA+
IHNldF9mcmVlemFibGUoKSAvIHRyeV90b19mcmVlemUoKSAvIHdhaXRfZXZlbnRfZnJlZXphYmxl
KCkgQVBJPw0KPiANCj4gTWFueS9tb3N0IG9mIHRoZW0gYXJlIGp1c3QgY29tcGxldGVseSBib2d1
cyBhbmQgcG9pbnRsZXNzLiBJJ3ZlIGtpbGxlZCBhIA0KPiBsb3Qgb2YgdGhvc2UgaW4gdGhlIHBh
c3QsIGJ1dCB0aGUgY29weS9wYXN0ZSBwcm9ncmFtbWluZyBpcyBqdXN0IHRvbyANCj4gc3Ryb25n
IGVuZW15IHRvIGZpZ2h0IGFnYWluc3QuDQoNCklmIGp1c3QgYSBzaW5nbGUgZHJpdmVyIHdvdWxk
IHVzZSB0aGF0IEFQSSB0byBwcmV2ZW50IHRoYXQgSS9PIG9jY3VycyB3aGlsZQ0KcHJvY2Vzc2Vz
IGFyZSBmcm96ZW4gdGhlbiB0aGlzIHBhdGNoIHdpbGwgYnJlYWsgdGhhdCBkcml2ZXIuIEkgd291
bGQgbGlrZSB0bw0Ka25vdyB5b3VyIG9waW5pb24gYWJvdXQgdGhlIGZvbGxvd2luZyBwYXRjaCBp
biBwYXJ0aWN1bGFyOiAiW1BBVENIIHY0IDEvN10gbWQ6DQpNYWtlIG1kIHJlc3luYyBhbmQgcmVz
aGFwZSB0aHJlYWRzIGZyZWV6YWJsZSINCihodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9s
aW51eC1ibG9jay9tc2cxNzg1NC5odG1sKS4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
