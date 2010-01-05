Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o056Nnl9182029 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 00:23:49 -0600
Received: from mgw-mx03.nokia.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D705D13EBF6
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 22:24:36 -0800 (PST)
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230]) by
	cuda.sgi.com with ESMTP id MKtFEZkwyjBfa34c for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2010 22:24:36 -0800 (PST)
Subject: Re: [PATCH] sort: Introduce generic list_sort function
From: Artem Bityutskiy <dedekind@infradead.org>
In-Reply-To: <1262649295-28427-1-git-send-email-david@fromorbit.com>
References: <1262649295-28427-1-git-send-email-david@fromorbit.com>
Date: Tue, 05 Jan 2010 08:23:58 +0200
Message-Id: <1262672638.4512.48.camel@localhost>
Mime-Version: 1.0
Reply-To: dedekind@infradead.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Airlie <airlied@redhat.com>, Adrian Hunter <adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

T24gVHVlLCAyMDEwLTAxLTA1IGF0IDEwOjU0ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
VGhlcmUgYXJlIHR3byBjb3BpZXMgb2YgbGlzdF9zb3J0KCkgaW4gdGhlIHRyZWUgYWxyZWFkeSwg
b25lIGluIHRoZSBEUk0gY29kZSwKPiBhbm90aGVyIGluIHViaWZzLiBOb3cgWEZTIG5lZWRzIHRo
aXMgYXMgd2VsbC4gQ3JlYXRlIGEgZ2VuZXJpYyBsaXN0X3NvcnQoKQo+IGZ1bmN0aW9uIGZyb20g
dGhlIHViaWZzIHZlcnNpb24gYW5kIGNvbnZlcnQgZXhpc3RpbmcgdXNlcnMgdG8gaXQgc28gd2UK
PiBkb24ndCBlbmQgdXAgd2l0aCB5ZXQgYW5vdGhlciBjb3B5IGluIHRoZSB0cmVlLgo+IAo+IEND
OiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgo+IENDOiBBcnRlbSBCaXR5dXRza2l5
IDxkZWRla2luZEBpbmZyYWRlYWQub3JnPgo+IENDOiBBZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVu
dGVyQG5va2lhLmNvbT4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+CgpBY2tlZC1ieTogQXJ0ZW0gQml0eXV0c2tpeSA8ZGVkZWtpbmRAaW5mcmFk
ZWFkLm9yZz4KClRoYW5rcywgdGhpcyBoYXMgYmVlbiBpbiBteSBUT0RPIGxpc3QgZm9yIGxvbmcg
dGltZSBhcyB3ZWxsIDotKQoKLS0gCkJlc3QgUmVnYXJkcywKQXJ0ZW0gQml0eXV0c2tpeSAo0JDR
gNGC0ZHQvCDQkdC40YLRjtGG0LrQuNC5KQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
