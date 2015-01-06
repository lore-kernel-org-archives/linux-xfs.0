Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52E7E7F5F
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 12:37:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 242F9304059
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:37:14 -0800 (PST)
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id 2EERH9CXh9IG9IDf
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2015 10:37:12 -0800 (PST)
Received: by mail-pa0-f53.google.com with SMTP id kq14so31594206pab.40
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 10:37:12 -0800 (PST)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Tue, 6 Jan 2015 10:37:08 -0800
Subject: Re: a simple and scalable pNFS block layout server
Message-ID: <20150106103708.70a06aba@synchrony.poochiereds.net>
In-Reply-To: <20150106175611.GA16413@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<20150106173222.GF12067@fieldses.org>
	<20150106175611.GA16413@lst.de>
MIME-Version: 1.0
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Weston Andros Adamson <dros@primarydata.com>, xfs@oss.sgi.com

T24gVHVlLCA2IEphbiAyMDE1IDE4OjU2OjExICswMTAwCkNocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPiB3cm90ZToKCj4gT24gVHVlLCBKYW4gMDYsIDIwMTUgYXQgMTI6MzI6MjJQTSAtMDUw
MCwgSi4gQnJ1Y2UgRmllbGRzIHdyb3RlOgo+ID4gCS0gZG8gd2UgaGF2ZSBldmlkZW5jZSB0aGF0
IHRoaXMgaXMgdXNlZnVsIGluIGl0cyBjdXJyZW50IGZvcm0/Cj4gCj4gV2hhdCBpcyB5b3VyIHRo
cmVzaG9sZCBmb3IgdXNlZnVsbmVzcz8gIEl0IHBhc3NlcyB4ZnN0ZXN0cyBmaW5lLCBhbmQKPiBz
aG93cyBsaW5lYXIgc2NhbGFiaWxpdHkgd2l0aCBtdWx0aXBsZSBjbGllbnRzIHRoYXQgZWFjaCBo
YXZlIDEwR0IKPiBsaW5rcy4gCj4gCj4gPiAJLSBhbnkgYWR2aWNlIG9uIHRlc3Rpbmc/ICBJcyB0
aGVyZSB3YXMgc29tZSBzaW1wbGUgdmlydHVhbCBzZXR1cAo+ID4gCSAgdGhhdCB3b3VsZCBhbGxv
dyBhbnkgbG9zZXIgd2l0aCBubyBzcGVjaWFsIGhhcmR3YXJlIChlLmcuLCBtZSkKPiA+IAkgIHRv
IGNoZWNrIHdoZXRoZXIgdGhleSd2ZSBicm9rZW4gdGhlIGJsb2NrIHNlcnZlcj8KPiAKPiBSdW4g
dHdvIGt2bSBWTXMgdGhhdCBzaGFyZSB0aGUgc2FtZSBkaXNrLiAgQ3JlYXRlIGFuIFhGUyBmaWxl
c3lzdGVtCj4gb24gdGhlIE1EUywgYW5kIGV4cG9ydCBpdC4gIElmIHRoZSBjbGllbnQgaGFzIGJs
a21hcGQgcnVubmluZyAob24gRGViaWFuCj4gaXQgbmVlZHMgdG8gYmUgc3RhcnRlZCBtYW51YWxs
eSkgaXQgd2lsbCB1c2UgcE5GUyBmb3IgYWNjZXNzaW5nIHRoZQo+IGZpbGVzeXN0ZW0uICBWZXJp
ZnkgdGhhdCB1c2luZyB0aGUgcGVyLW9wZXJhdGlvbiBjb3VudGVycyBpbgo+IC9wcm9jL3NlbGYv
bW91bnN0YXRzLiAgUmVwZWF0IHdpdGggYWRkaXRpb25hbCBjbGllbnRzIGFzIG5lc3NlY2FyeS4K
PiAKPiBBbHRlcm5hdGl2ZWx5IHNldCB1cCBhIHNpbXBsZSBpU0NTSSB0YXJnZXQgdXNpbmcgdGd0
IG9yIGxpbyBhbmQKPiBjb25uZWN0IHRvIGl0IGZyb20gbXVsdGlwbGUgY2xpZW50cy4KPiAKPiA+
IAktIGFueSBkZWJ1Z2dpbmcgYWR2aWNlPyAgRS5nLiwgaGF2ZSB5b3UgY2hlY2tlZCBpZiBjdXJy
ZW50Cj4gPiAJICB3aXJlc2hhcmsgY2FuIGhhbmRsZSB0aGUgTURTIHRyYWZmaWM/Cj4gCj4gVGhl
IHdpcmVzaGFyZSB2ZXJzaW9uIEkndmUgdXNlZCBkZWNvZGVkIHRoZSBnZW5lcmljIHBORlMgb3Bl
cmF0aW9ucwo+IGZpbmUsIGJ1dCBqdXN0IGR1bXBzIHRoZSBsYXlvdXQgc3BlY2lmaWNzIGFzIGhl
eCBkYXRhLgo+IAo+IEVuYWJsZSB0aGUgdHJhY2UgcG9pbnRzIGFkZGVkIGluIHRoaXMgc2VyaWVz
LCB0aGV5IHRyYWNrIGFsbCBzdGF0ZWlkCj4gaW50ZXJhY3Rpb25zIGluIHRoZSBzZXJ2ZXIuICBB
ZGRpdNGWb25hbGx5IHRoZSBwbmZzIGRlYnVnIHByaW50a3Mgb24KPiBjbGllbnQgYW5kIHNlcnZl
ciBkdW1wIGEgbG90IG9mIGluZm9ybWF0aW9uLgoKVGhlIHdpcmVzaGFyayBkZWNvZGVyIHJlYWxs
eSBvbmx5IGhhbmRsZXMgZmlsZXMgbGF5b3V0cyByaWdodCBub3cuIERyb3MKaGFzIHNvbWUgcGF0
Y2hlcyB0byBhZGQgZmxleGZpbGVzIHN1cHBvcnQgdG9vIChvbmNlIHRoZSBzcGVjIGlzIGEgYml0
Cm1vcmUgZmluYWxpemVkKSBhbmQgYXQgdGhhdCBwb2ludCBpdCBzaG91bGRuJ3QgYmUgdG9vIGhh
cmQgdG8gZml4IGl0IHRvCmhhbmRsZSBibG9jayBsYXlvdXQgYXMgd2VsbC4KCi0tIApKZWZmIExh
eXRvbiA8amxheXRvbkBwcmltYXJ5ZGF0YS5jb20+CgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
