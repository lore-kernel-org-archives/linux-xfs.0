Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o887hGlZ020329 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 02:43:17 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65E0C56A3A
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 00:44:00 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	AcmrFQxtQcTWTzVL for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 00:44:00 -0700 (PDT)
Date: Wed, 8 Sep 2010 17:43:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs on armv5 still with erroneous log in kernel 2.6.35.4
Message-ID: <20100908074357.GS705@dastard>
References: <4C835A34.9080008@googlemail.com> <20100906005230.GX7362@dastard>
	<4C845EDE.3010806@sandeen.net> <4C8534D0.3050003@googlemail.com>
	<20100907060331.GK705@dastard> <4C86B4E3.5090202@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C86B4E3.5090202@googlemail.com>
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
To: Marcus Osdoba <marcus.osdoba@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

T24gVHVlLCBTZXAgMDcsIDIwMTAgYXQgMTE6NTU6NDdQTSArMDIwMCwgTWFyY3VzIE9zZG9iYSB3
cm90ZToKPiAgQW0gMDcuMDkuMjAxMCAwODowMywgc2NocmllYiBEYXZlIENoaW5uZXI6Cj4gPk9u
IE1vbiwgU2VwIDA2LCAyMDEwIGF0IDA4OjM3OjA0UE0gKzAyMDAsIE1hcmN1cyBPc2RvYmEgd3Jv
dGU6Cj4gPj5JJ20gdXNpbmcgdGhlIGxhdGVzdCBzdGFibGUga2VybmVsIDIuNi4zNS40LiBUaGUg
ZmlsZXN5c3RlbSB3YXMKPiA+PmNyZWF0ZWQgb24gdGhlIHRhcmdldCBkZXZpY2Ugd2l0aCBhIGNy
b3NzIGNvbXBpbGVkIHhmc3Byb2dzIDMuMS4zLgo+ID4+VGhlIHN5c3RlbXMgcnVucyBvbiBhbiBh
cm12NXRlIGFyY2hpdGVjdHVyZSAoc2hlZXZhcGx1ZyBkZXJpdmF0aXZlKS4KPiA+PkFmdGVyIGNy
ZWF0aW5nLCBtb3VudGluZyBhbmQgd3JpdGluZyBzb21lIGRhdGEgb24gaXQsIHJlLW1vdW50aW5n
Cj4gPj53YXMgbm90IHBvc3NpYmxlIHdpdGggdGhlIGFib3ZlIG1lbnRpb25lZCBlcnJvci4gSSd2
ZSBmb3VuZCB0aGlzCj4gPj5tZXNzYWdlIGluIHRoZSBtYWlsaW5nbGlzdGFyY2hpdmUgYW5kIHRo
b3VnaHQgdGhlIHBhdGNoZXMgd2VyZQo+ID4+aW50ZWdyYXRlZCBpbnRvIG1haW5saW5lLgo+ID4+
Cj4gPj5Ib3cgY2FuIEkgaGVscD8gV2hhdCBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIGRvIHlvdSBu
ZWVkPwouLi4uCgo+IElzIHN5bmMnaW5nIGVub3VnaCBmb3Igc29sdmluZyB0aGlzIGlzc3VlPyAt
PiBSZXByb2R1Y2U6Cj4gPm1vdW50IC9kZXYvc2RhMSAvZGF0YQo+ID5jcCBzb21ldGhpbmcgbW9y
ZSBvbiBpdAo+ID5zeW5jCj4gPnVtb3VudCAvZGF0YQo+ID5kZXZpY2Ugb3IgcmVzb3VyY2UgYnVz
eQoKV2hhdCBpcyB0aGlzIGVycm9yPyBBbnl0aGluZyBpbiBkbWVzZz8gRG9lcyB0aGlzIGFsd2F5
cyBvY2N1cgpiZWZvcmUgdGhlIGxvZyByZWNvdmVyeSBlcnJvciBvbiBuZXh0IG1vdW50PwoKRldJ
VywgcGxlYXNlIGNvcHkgdGhlIGV4YWN0IGNvbW1hbmRzIGFuZCBlcnJvcnMgZnJvbSB5b3VyIHRl
cm1pbmFsIC0KcGFyYXBocmFzaW5nIHRoZW0gbGlrZSB0aGlzIGRvZXMgbm90IGhlbHAgbWUgdW5k
ZXLRlXRhbmQgZXhhY3RseSB3aGF0CmlzIGhhcHBlbmluZy4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0g
CkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
