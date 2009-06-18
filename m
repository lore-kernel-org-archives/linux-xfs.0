Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5IM4IsG030208 for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 17:04:19 -0500
Received: from mail-fx0-f207.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6820F94B0A3
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 15:12:38 -0700 (PDT)
Received: from mail-fx0-f207.google.com (mail-fx0-f207.google.com
	[209.85.220.207]) by cuda.sgi.com with ESMTP id
	xJJ4FDWzEzwSV3Ho for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2009 15:12:38 -0700 (PDT)
Received: by fxm3 with SMTP id 3so1319809fxm.20
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 15:04:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090618205102.GA5805@infradead.org>
References: <a4423d670906181231r7388df5am394bc55508272b3@mail.gmail.com>
	<20090618205102.GA5805@infradead.org>
Date: Fri, 19 Jun 2009 02:04:41 +0400
Message-ID: <a4423d670906181504s7a36a4f6n9d910931a1ca478a@mail.gmail.com>
Subject: Re: 2.6.30-06725: xfs_fsr: Assertion failed: ip->i_delayed_blks == 0,
	file: fs/xfs/xfs_bmap.c, line: 5991
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

MjAwOS82LzE5IENocmlzdG9waCBIZWxsd2lnIDxoY2hAaW5mcmFkZWFkLm9yZz46Cj4gRGlkIHRo
aXMgaGFwcGVucyBvbmNlIG9yIG11bHRpcGxlIHRpbWVzPyDCoEl0IHNlZW1zIHRoYXQgZm9yIHNv
bWUKT25jZS4gQnV0IEkgd2FzIGFibGUgdG8gcmVwcm9kdWNlIGl0IChub3Qgc28gZWFzeSkuClRo
ZSBwYXRjaCBkb2VzIG5vdCB3b3JrLgoKPiByZWFzb24geGZzX2ZsdXNoX3BhZ2VzIGRpZG4ndCBm
bHVzaCBhbGwgZGVsYWxsb2Mgc3BhY2UgYW5kIHRoZW4KPiB3ZSByaWdodGZ1bGx5IGhpdCB0aGlz
IGFzc2VydGF0aW9uLgo+Cj4gSSByZWFsbHkgaGF0ZSB0aGUgY29kZSBpbiB4ZnNfZmx1c2hfcGFn
ZXMgd2l0aCB0aGUgb3B0aW1pemF0aW9ucyBpdAo+IHRyaWVzIHRvIGFwcGx5LiDCoENhbiB5b3Ug
Z2l2ZSB0aGUgcGF0Y2ggYmVsb3cgd2hpY2ggcmVtb3ZlcyB0aGUKPiBvcHRpbWl6YXRpb25zIGFu
ZCB1c2VzIHNvbWUgbW9yZSBjb3JlIFZNIGNvZGUgaW5zdGVhZCBvZiBkb2luZyBvdXIKPiBvd24g
dGhpbmc/CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
