Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CCA087F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:50:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA8718F8059
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:50:33 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id VoB4hxGMGPciXPeB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 12:50:32 -0800 (PST)
Date: Thu, 27 Feb 2014 21:50:29 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfstests with NFS
Message-ID: <20140227205029.GA29741@lst.de>
References: <27AB99CF-CEF3-4AC5-AFBD-6648F3B3BED2@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <27AB99CF-CEF3-4AC5-AFBD-6648F3B3BED2@oracle.com>
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
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>, xfs@oss.sgi.com

T24gVGh1LCBGZWIgMjcsIDIwMTQgYXQgMTA6MzI6NTFBTSAtMDgwMCwgQ2h1Y2sgTGV2ZXIgd3Jv
dGU6Cj4gCj4gSeKAmW0gcnVubmluZyB4ZnN0ZXN0cyB0byB2YWxpZGF0ZSBmdW5jdGlvbmFsaXR5
IG9mIGEgcGFydGljdWxhcgo+IE5GUyBjbGllbnQvdHJhbnNwb3J0L3NlcnZlciBzZXQgdXAuCj4g
Cj4gVGhlcmUgYXJlIGEgY291cGxlIG9mIHRlc3RzIHRoYXQgbWF5IG5vdCBhbHdheXMgYmUgYXBw
cm9wcmlhdGUgZm9yCj4gRlNUWVA9bmZzLiAgV2Ugd2VyZW7igJl0IGFibGUgdG8gaWRlbnRpZnkg
YSBidWd6aWxsYSB3aGVyZSB3ZSBjYW4gcmVwb3J0Cj4gdGhlc2UgaXNzdWVzLgoKSnVzdCBzZW5k
IHRoZSB0byB0aGUgeGZzIGxpc3QuICAoYW5kIGNhcCBsaW5lcyBhZnRlciA3NSBjaGFycyBsaWtl
IGZvciBhbGwKTGludXggbGlzdHMuLikKCj4gZ2VuZXJpYy8xOTIgdGVzdHMgYXRpbWUgY2hhbmdl
cy4gIFRoZSBMaW51eCBORlMgY2xpZW50IChhbmQgcHJvYmFibHkKPiBvdGhlcnMpIHR5cGljYWxs
eSBvcHRpbWl6ZXMgYXdheSBhdGltZSBjaGFuZ2VzLiAgVGh1cyB0aGlzIHRlc3QgZmFpbHMKPiBm
b3IgTkZTIG1vdW50cyBvbiBMaW51eC4gIEnigJltIHdvbmRlcmluZyBpZiB3ZSBjYW4gdHJlYXQg
TkZTIGFzIGFsd2F5cwo+IGEgbm9hdGltZSBmaWxlc3lzdGVtLgoKSSBndWVzcyB0aGVyZSdzIHR3
byBjb21wb25lbnRzIHRvIHRoaXMgaWYgd2Ugd2FudCB0byBkbyBpdCBwcm9wZXJseToKCiAtIG1h
a2Ugc3VyZSBuZnMgYWx3YXlzIHJlcG9ydHMgbm9hdGltZSBpbiAvcHJvYy9zZWxmL21vdW50cyBp
bnN0ZWFkCiAgIG9mIGluY29ycmVjdGx5IGNsYWltaW5nIGl0IHN1cHBvcnRzIHJlbGF0aW1lIGJ5
IGRlZmF1bHQKIC0gX25vdHJ1biAxOTIgaWYgaXQgZGV0ZWN0cyB0aGUgZmlsZXN5c3RlbXMgcmVw
b3J0cyBub2F0aW1lLgoKPiBnZW5lcmljLzIzNyB0cmllcyBzZXRmYWNsLiAgT24gTkZTIG1vdW50
cywgdGhlIG9wZXJhdGlvbiBhbHdheXMgcmV0dXJucwo+IOKAnE9wZXJhdGlvbiBub3Qgc3VwcG9y
dGVkLOKAnSBidXQgdGhlIHRlc3QgaXMgbG9va2luZyBmb3Ig4oCcT3BlcmF0aW9uIG5vdAo+IHBl
cm1pdHRlZC7igJ0gIFRoZSBmb3JtZXIgaXMgYW4gYWNjZXB0YWJsZSBwYXNzLCBJTU8uICBJIGNv
bnNpZGVyZWQKPiBkaXNhYmxpbmcgdGhpcyB0ZXN0IGZvciBORlMsIGJ1dCBJIHdvdWxkIGJldCBz
b21lIE5GUyBjbGllbnQKPiBpbXBsZW1lbnRhdGlvbnMgYWN0dWFsbHkgZG8gc3VwcG9ydCBzZXRm
YWNsKCkuCgpUaGUgTkZTdjMgY2xpZW50IHN1cHBvcnQgQUNMcyBwZXJmZWN0bHksIGl0J3MganVz
dCBORlN2NCB0aGF0J3MgbWVzc2VkIHVwLgoKMjM3IGRvZXMgYSBfcmVxdWlyZV9hY2xzIGJlZm9y
ZSBkaW5nIHRow6YgdGVzdCwgd2hpY2ggY2hlY2tzIGZvcgpFTk9TWVMgb3IgRU9QTk9UU1VQUCwg
d2hpY2ggaW4gdGhlb3J5IHNob3VsZCBjYXRjaCBORlN2NCBpbiB0aGVvcnksIGJ1dAppZiB0aGlz
IGRvZXNuJ3QgaGFwcGVuIHRyeSB0byBkZWJ1ZyBpdCBieSBsb29raW5nIGF0IHRoZSBfcmVxdWly
ZV9hY2xzIHNoZWxsCmZ1bmN0aW9uLCB0aGUgY2hhY2wgaW1wbGVtZW50YXRpb24sIHRoZSBORlN2
NCBBQ0wgc3R1YnMgYW5kIGFueXRoaW5nIGVsc2UKcmVsYXRlZC4KCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5z
Z2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
