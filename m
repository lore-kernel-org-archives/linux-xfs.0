Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4P3HVWF219996 for <xfs@oss.sgi.com>; Mon, 24 May 2010 22:17:32 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13BB9143D6EB
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 20:19:53 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id WfzEQrdcysiMhdRt for
	<xfs@oss.sgi.com>; Mon, 24 May 2010 20:19:53 -0700 (PDT)
Message-ID: <4BFB41D8.3020402@sandeen.net>
Date: Mon, 24 May 2010 22:19:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Is persistant preallocation possible?
References: <1374176788.272721274754374474.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <1374176788.272721274754374474.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nathans@aconex.com>
Cc: Jeff Zheng <Jeff.Zheng@endace.com>, xfs@oss.sgi.com

TmF0aGFuIFNjb3R0IHdyb3RlOgo+IC0tLS0tICJKZWZmIFpoZW5nIiA8SmVmZi5aaGVuZ0BlbmRh
Y2UuY29tPiB3cm90ZToKPiAKPj4gSGksCj4+Cj4+IFdlIGFyZSB0cnlpbmcgdG8gY29udHJvbCB3
aGVyZSB0aGUgZmlsZXMgYXJlIGJlaW5nIGFsbG9jYXRlZCBvbiB0aGUKPj4gZGlza3MsIGFuZCB3
ZSB0cmllZCB4ZnMgcHJlYWxsb2NhdGlvbi4gV2hhdCB3ZSBmb3VuZCBpcyB0aGF0IGVhY2ggdGlt
ZQo+PiB0aGUgZmlsZSBiZWluZyByZW9wZW5lZCB0aGUgbG9jYXRpb24gb2YgdGhlIHByZS1hbGxv
Y2F0ZWQgc3BhY2UgY291bGQKPj4gY2hhbmdlIChub3QgYWxsIHRoZSB0aW1lKS4gSXMgdGhlcmUg
YSB3YXkgdG8gZG8gcGVyc2lzdGVudAo+PiBwcmVhbGxvY2F0aW9uIGluIHhmcywgbGlrZSB0aGUg
c2FtZSBmaWxlIHdpbGwgYWx3YXlzIGJlIG9uIHRoZSBzYW1lCj4+IGxvY2F0aW9uIG9uIHRoZSBk
aXNrIGdpdmVuIHRoYXQgdGhlIHJlcXVlc3RlZCBzaXplIGRvZXNu4oCZdCBjaGFuZ2U/Cj4+Cj4g
Cj4gU291bmRzIGxpa2UgeW91IGFyZSB0cnVuY2F0aW5nIHRoZSBmaWxlIChvbiBvcGVuPyksIGFu
ZCBoZW5jZSBkaXNjYXJkaW5nCj4gdGhlIHByZWFsbG9jYXRpb24uICBYRlMgcHJlYWxsb2NhdGlv
biBpcyBwZXJzaXN0ZW50IGFscmVhZHksIHNvIEkgdGhpbmsKPiBzb21ldGhpbmcgeW91IGFyZSBk
b2luZyBtdXN0IGJlIGRpc2NhcmRpbmcgdGhvc2UgcHJlYWxsb2NhdGVkIGV4dGVudHMuCj4gCj4g
Q291bGQgeW91IHBvc3QgYSB0ZXN0IHByb2dyYW0sIG9yIHNlcXVlbmNlIG9mIHhmc19pbyBjb21t
YW5kcywgdGhhdCB3b3VsZAo+IGRlbW9uc3RyYXRlIHRoZSBwcm9ibGVtPwo+IAo+IGNoZWVycy4K
PiAKCi4uLiBtYXliZSB5b3UgbWVhbiB0aGF0IHRydW5jYXRpbmcgLyBwcmUtYWxsb2NhdGluZyB0
aGUgc2FtZSBzcGFjZSByZXBlYXRlZGx5Cm9uIHRoZSBzYW1lIGZpbGVuYW1lIGVuZHMgdXAgd2l0
aCBibG9ja3MgbWFwcGVkIGluIGRpZmZlcmVudCBsb2NhdGlvbnMuLi4/ClRoYXQncyBlbnRpcmVs
eSBleHBlY3RlZC4uLiBub3RoaW5nIGFib3V0IHRoZSBwcmVhbGxvY2F0aW9uIGludGVyZmFjZSBs
ZXRzCnlvdSAiY29udHJvbCAqd2hlcmUqIGZpbGVzIGFyZSBiZWluZyBhbGxvY2F0ZWQiIGFzIHlv
dSBzYWlkIGFib3ZlLi4uCgotRXJpYwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
