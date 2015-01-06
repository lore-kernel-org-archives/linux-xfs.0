Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 736547F5F
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 12:39:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EFF24AC003
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:39:53 -0800 (PST)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com
	[209.85.213.173]) by cuda.sgi.com with ESMTP id
	ldZA0HFW6DAkXGJd (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 10:39:52 -0800 (PST)
Received: by mail-ig0-f173.google.com with SMTP id r2so4611475igi.0
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 10:39:52 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: a simple and scalable pNFS block layout server
From: Weston Andros Adamson <dros@primarydata.com>
In-Reply-To: <20150106103708.70a06aba@synchrony.poochiereds.net>
Date: Tue, 6 Jan 2015 13:39:50 -0500
Message-Id: <9AFC48B6-B1DC-41CF-9D43-C27DF45A4809@primarydata.com>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<20150106173222.GF12067@fieldses.org>
	<20150106175611.GA16413@lst.de>
	<20150106103708.70a06aba@synchrony.poochiereds.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeffrey Layton <jeff.layton@primarydata.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs list <linux-nfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Cj4gT24gSmFuIDYsIDIwMTUsIGF0IDE6MzcgUE0sIEplZmYgTGF5dG9uIDxqZWZmLmxheXRvbkBw
cmltYXJ5ZGF0YS5jb20+IHdyb3RlOgo+IAo+IE9uIFR1ZSwgNiBKYW4gMjAxNSAxODo1NjoxMSAr
MDEwMAo+IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPiB3cm90ZToKPiAKPj4gT24gVHVl
LCBKYW4gMDYsIDIwMTUgYXQgMTI6MzI6MjJQTSAtMDUwMCwgSi4gQnJ1Y2UgRmllbGRzIHdyb3Rl
Ogo+Pj4gCS0gZG8gd2UgaGF2ZSBldmlkZW5jZSB0aGF0IHRoaXMgaXMgdXNlZnVsIGluIGl0cyBj
dXJyZW50IGZvcm0/Cj4+IAo+PiBXaGF0IGlzIHlvdXIgdGhyZXNob2xkIGZvciB1c2VmdWxuZXNz
PyAgSXQgcGFzc2VzIHhmc3Rlc3RzIGZpbmUsIGFuZAo+PiBzaG93cyBsaW5lYXIgc2NhbGFiaWxp
dHkgd2l0aCBtdWx0aXBsZSBjbGllbnRzIHRoYXQgZWFjaCBoYXZlIDEwR0IKPj4gbGlua3MuIAo+
PiAKPj4+IAktIGFueSBhZHZpY2Ugb24gdGVzdGluZz8gIElzIHRoZXJlIHdhcyBzb21lIHNpbXBs
ZSB2aXJ0dWFsIHNldHVwCj4+PiAJICB0aGF0IHdvdWxkIGFsbG93IGFueSBsb3NlciB3aXRoIG5v
IHNwZWNpYWwgaGFyZHdhcmUgKGUuZy4sIG1lKQo+Pj4gCSAgdG8gY2hlY2sgd2hldGhlciB0aGV5
J3ZlIGJyb2tlbiB0aGUgYmxvY2sgc2VydmVyPwo+PiAKPj4gUnVuIHR3byBrdm0gVk1zIHRoYXQg
c2hhcmUgdGhlIHNhbWUgZGlzay4gIENyZWF0ZSBhbiBYRlMgZmlsZXN5c3RlbQo+PiBvbiB0aGUg
TURTLCBhbmQgZXhwb3J0IGl0LiAgSWYgdGhlIGNsaWVudCBoYXMgYmxrbWFwZCBydW5uaW5nIChv
biBEZWJpYW4KPj4gaXQgbmVlZHMgdG8gYmUgc3RhcnRlZCBtYW51YWxseSkgaXQgd2lsbCB1c2Ug
cE5GUyBmb3IgYWNjZXNzaW5nIHRoZQo+PiBmaWxlc3lzdGVtLiAgVmVyaWZ5IHRoYXQgdXNpbmcg
dGhlIHBlci1vcGVyYXRpb24gY291bnRlcnMgaW4KPj4gL3Byb2Mvc2VsZi9tb3Vuc3RhdHMuICBS
ZXBlYXQgd2l0aCBhZGRpdGlvbmFsIGNsaWVudHMgYXMgbmVzc2VjYXJ5Lgo+PiAKPj4gQWx0ZXJu
YXRpdmVseSBzZXQgdXAgYSBzaW1wbGUgaVNDU0kgdGFyZ2V0IHVzaW5nIHRndCBvciBsaW8gYW5k
Cj4+IGNvbm5lY3QgdG8gaXQgZnJvbSBtdWx0aXBsZSBjbGllbnRzLgo+PiAKPj4+IAktIGFueSBk
ZWJ1Z2dpbmcgYWR2aWNlPyAgRS5nLiwgaGF2ZSB5b3UgY2hlY2tlZCBpZiBjdXJyZW50Cj4+PiAJ
ICB3aXJlc2hhcmsgY2FuIGhhbmRsZSB0aGUgTURTIHRyYWZmaWM/Cj4+IAo+PiBUaGUgd2lyZXNo
YXJlIHZlcnNpb24gSSd2ZSB1c2VkIGRlY29kZWQgdGhlIGdlbmVyaWMgcE5GUyBvcGVyYXRpb25z
Cj4+IGZpbmUsIGJ1dCBqdXN0IGR1bXBzIHRoZSBsYXlvdXQgc3BlY2lmaWNzIGFzIGhleCBkYXRh
Lgo+PiAKPj4gRW5hYmxlIHRoZSB0cmFjZSBwb2ludHMgYWRkZWQgaW4gdGhpcyBzZXJpZXMsIHRo
ZXkgdHJhY2sgYWxsIHN0YXRlaWQKPj4gaW50ZXJhY3Rpb25zIGluIHRoZSBzZXJ2ZXIuICBBZGRp
dNGWb25hbGx5IHRoZSBwbmZzIGRlYnVnIHByaW50a3Mgb24KPj4gY2xpZW50IGFuZCBzZXJ2ZXIg
ZHVtcCBhIGxvdCBvZiBpbmZvcm1hdGlvbi4KPiAKPiBUaGUgd2lyZXNoYXJrIGRlY29kZXIgcmVh
bGx5IG9ubHkgaGFuZGxlcyBmaWxlcyBsYXlvdXRzIHJpZ2h0IG5vdy4gRHJvcwo+IGhhcyBzb21l
IHBhdGNoZXMgdG8gYWRkIGZsZXhmaWxlcyBzdXBwb3J0IHRvbyAob25jZSB0aGUgc3BlYyBpcyBh
IGJpdAo+IG1vcmUgZmluYWxpemVkKSBhbmQgYXQgdGhhdCBwb2ludCBpdCBzaG91bGRuJ3QgYmUg
dG9vIGhhcmQgdG8gZml4IGl0IHRvCj4gaGFuZGxlIGJsb2NrIGxheW91dCBhcyB3ZWxsLgoKSSBz
aG91bGQgYmUgcHVibGlzaGluZyB0aGVzZSBwYXRjaGVzIHNvb24uIFRoZSBvbmx5IGhvbGR1cCBp
cyB3YWl0aW5nCm9uIHRoZSBJQU5BIGxheW91dCB0eXBlIGFzc2lnbm1lbnQuCgotZHJvcwoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
