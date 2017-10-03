Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48737 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdJCUC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:02:27 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC 2/5] fs: freeze on suspend and thaw on resume
Date: Tue, 3 Oct 2017 20:02:22 +0000
Message-ID: <1507060941.2567.6.camel@wdc.com>
References: <20171003185313.1017-1-mcgrof@kernel.org>
         <20171003185313.1017-3-mcgrof@kernel.org>
In-Reply-To: <20171003185313.1017-3-mcgrof@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E9A27AD0F70F64C983B9FEC98B8D12F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>
Cc: "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "jgross@suse.com" <jgross@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "jack@suse.cz" <jack@suse.cz>

T24gVHVlLCAyMDE3LTEwLTAzIGF0IDExOjUzIC0wNzAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90
ZToNCj4gK3N0YXRpYyBib29sIHN1cGVyX2FsbG93c19mcmVlemUoc3RydWN0IHN1cGVyX2Jsb2Nr
ICpzYikNCj4gK3sNCj4gKwlyZXR1cm4gISEoc2ItPnNfdHlwZS0+ZnNfZmxhZ3MgJiBGU19GUkVF
WkVfT05fU1VTUEVORCk7DQo+ICt9DQoNCkEgbWlub3IgY29tbWVudDogaWYgIiEhIiB3b3VsZCBi
ZSBsZWZ0IG91dCB0aGUgY29tcGlsZXIgd2lsbCBwZXJmb3JtIHRoZQ0KY29udmVyc2lvbiBmcm9t
IGludCB0byBib29sIGltcGxpY2l0bHkgc28gSSBwcm9wb3NlIHRvIGxlYXZlIG91dCB0aGUgIiEh
Ig0KYW5kIHBhcmVudGhlc2VzLiBBbnl3YXksIEkgYWdyZWUgd2l0aCB0aGUgYXBwcm9hY2ggb2Yg
dGhpcyBwYXRjaCBhbmQgSSB0aGluaw0KdGhhdCBmcmVlemluZyBmaWxlc3lzdGVtcyBiZWZvcmUg
cHJvY2Vzc2VzIGFyZSBmcm96ZW4gd291bGQgYmUgYSBiaWcgc3RlcA0KZm9yd2FyZC4NCg0KQmFy
dC4=
