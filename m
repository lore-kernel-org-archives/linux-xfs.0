Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E5507FB1
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 13:17:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D0EF8F8035
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:17:36 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id KlcHNdvfv7Zm106S (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 11:17:34 -0800 (PST)
Date: Tue, 6 Jan 2015 14:17:32 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: a simple and scalable pNFS block layout server
Message-ID: <20150106191731.GC28003@fieldses.org>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<20150106173222.GF12067@fieldses.org>
	<20150106175611.GA16413@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106175611.GA16413@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

T24gVHVlLCBKYW4gMDYsIDIwMTUgYXQgMDY6NTY6MTFQTSArMDEwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gT24gVHVlLCBKYW4gMDYsIDIwMTUgYXQgMTI6MzI6MjJQTSAtMDUwMCwgSi4g
QnJ1Y2UgRmllbGRzIHdyb3RlOgo+ID4gCS0gZG8gd2UgaGF2ZSBldmlkZW5jZSB0aGF0IHRoaXMg
aXMgdXNlZnVsIGluIGl0cyBjdXJyZW50IGZvcm0/Cj4gCj4gV2hhdCBpcyB5b3VyIHRocmVzaG9s
ZCBmb3IgdXNlZnVsbmVzcz8gIEl0IHBhc3NlcyB4ZnN0ZXN0cyBmaW5lLCBhbmQKPiBzaG93cyBs
aW5lYXIgc2NhbGFiaWxpdHkgd2l0aCBtdWx0aXBsZSBjbGllbnRzIHRoYXQgZWFjaCBoYXZlIDEw
R0IKPiBsaW5rcy4gCgpTb3VuZHMgZ29vZC4gIEl0J2QgYmUgaW50ZXJlc3RpbmcgdG8gc2VlIGRl
dGFpbHMgaWYgdGhleSBjYW4gYmUgcG9zdGVkLgoKLS1iLgoKPiA+IAktIGFueSBhZHZpY2Ugb24g
dGVzdGluZz8gIElzIHRoZXJlIHdhcyBzb21lIHNpbXBsZSB2aXJ0dWFsIHNldHVwCj4gPiAJICB0
aGF0IHdvdWxkIGFsbG93IGFueSBsb3NlciB3aXRoIG5vIHNwZWNpYWwgaGFyZHdhcmUgKGUuZy4s
IG1lKQo+ID4gCSAgdG8gY2hlY2sgd2hldGhlciB0aGV5J3ZlIGJyb2tlbiB0aGUgYmxvY2sgc2Vy
dmVyPwo+IAo+IFJ1biB0d28ga3ZtIFZNcyB0aGF0IHNoYXJlIHRoZSBzYW1lIGRpc2suICBDcmVh
dGUgYW4gWEZTIGZpbGVzeXN0ZW0KPiBvbiB0aGUgTURTLCBhbmQgZXhwb3J0IGl0LiAgSWYgdGhl
IGNsaWVudCBoYXMgYmxrbWFwZCBydW5uaW5nIChvbiBEZWJpYW4KPiBpdCBuZWVkcyB0byBiZSBz
dGFydGVkIG1hbnVhbGx5KSBpdCB3aWxsIHVzZSBwTkZTIGZvciBhY2Nlc3NpbmcgdGhlCj4gZmls
ZXN5c3RlbS4gIFZlcmlmeSB0aGF0IHVzaW5nIHRoZSBwZXItb3BlcmF0aW9uIGNvdW50ZXJzIGlu
Cj4gL3Byb2Mvc2VsZi9tb3Vuc3RhdHMuICBSZXBlYXQgd2l0aCBhZGRpdGlvbmFsIGNsaWVudHMg
YXMgbmVzc2VjYXJ5Lgo+IAo+IEFsdGVybmF0aXZlbHkgc2V0IHVwIGEgc2ltcGxlIGlTQ1NJIHRh
cmdldCB1c2luZyB0Z3Qgb3IgbGlvIGFuZAo+IGNvbm5lY3QgdG8gaXQgZnJvbSBtdWx0aXBsZSBj
bGllbnRzLgo+IAo+ID4gCS0gYW55IGRlYnVnZ2luZyBhZHZpY2U/ICBFLmcuLCBoYXZlIHlvdSBj
aGVja2VkIGlmIGN1cnJlbnQKPiA+IAkgIHdpcmVzaGFyayBjYW4gaGFuZGxlIHRoZSBNRFMgdHJh
ZmZpYz8KPiAKPiBUaGUgd2lyZXNoYXJlIHZlcnNpb24gSSd2ZSB1c2VkIGRlY29kZWQgdGhlIGdl
bmVyaWMgcE5GUyBvcGVyYXRpb25zCj4gZmluZSwgYnV0IGp1c3QgZHVtcHMgdGhlIGxheW91dCBz
cGVjaWZpY3MgYXMgaGV4IGRhdGEuCj4gCj4gRW5hYmxlIHRoZSB0cmFjZSBwb2ludHMgYWRkZWQg
aW4gdGhpcyBzZXJpZXMsIHRoZXkgdHJhY2sgYWxsIHN0YXRlaWQKPiBpbnRlcmFjdGlvbnMgaW4g
dGhlIHNlcnZlci4gIEFkZGl00ZZvbmFsbHkgdGhlIHBuZnMgZGVidWcgcHJpbnRrcyBvbgo+IGNs
aWVudCBhbmQgc2VydmVyIGR1bXAgYSBsb3Qgb2YgaW5mb3JtYXRpb24uCj4gLS0KPiBUbyB1bnN1
YnNjcmliZSBmcm9tIHRoaXMgbGlzdDogc2VuZCB0aGUgbGluZSAidW5zdWJzY3JpYmUgbGludXgt
bmZzIiBpbgo+IHRoZSBib2R5IG9mIGEgbWVzc2FnZSB0byBtYWpvcmRvbW9Admdlci5rZXJuZWwu
b3JnCj4gTW9yZSBtYWpvcmRvbW8gaW5mbyBhdCAgaHR0cDovL3ZnZXIua2VybmVsLm9yZy9tYWpv
cmRvbW8taW5mby5odG1sCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
