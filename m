Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5321WcJ236669 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 21:01:32 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FE9C1239851
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 19:01:30 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	73AGp0iCnYD18DOT for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 19:01:30 -0700 (PDT)
Date: Fri, 3 Jun 2011 12:01:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Message-ID: <20110603020127.GY561@dastard>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
	<4DE7A557.9040608@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DE7A557.9040608@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, "Amir G." <amir73il@users.sourceforge.net>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

T24gVGh1LCBKdW4gMDIsIDIwMTEgYXQgMDk6NTk6MzVBTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9uIDYvMi8xMSAyOjE2IEFNLCBBbWlyIEcuIHdyb3RlOgo+IAo+ID4gT0ssIGFmdGVy
IHVwZ3JhZGluZyB0byBuZXdlciB1dGlsLWxpbnV4IGFuZCBidWlsZGluZyBpdCBmcm9tCj4gPiBn
aXQsIHdoaWNoIGFsc28gZGlkbid0IGhlbHAsIEkgZmluYWxseSBmb3VuZCB3aG8gdG8gYmxhbWUg
LSBtZS4KPiA+IEkgaGFkIGFuIG9sZCAobm9hdXRvKSBlbnRyeSBpbiAvZXRjL2ZzdGFiIHdoaWNo
IGNsYWltZWQgdGhhdAo+ID4gL2Rldi9zZGE1IGlzIGV4dDQuICBmc2NrIHdhcyBwaWNraW5nIHVw
IHRoYXQgZW50cnkgYW5kIGluc2lzdGluZwo+ID4gdGhhdCAvZGV2L3NkYTUgaXMgZXh0NCAocmVn
YXJkbGVzcyBvZiB3aGF0IGl0IHJlYWxseSBpcykgYmxraWQKPiA+IGlzbid0IGRvaW5nIHRoYXQg
c2lsbHkgdGhpbmcuCj4gPiAKPiA+IEFtaXIKPiAKPiBTbyB3aGVyZSBhcmUgd2UgYXQgd2l0aCBh
bGwgdGhpcz8KPiAKPiBJIGRvbid0IHJlYWxseSBtaW5kIGFkZGluZyBleHQ0ZGV2IHRvIEZTVFlQ
IGNhc2Ugc3RhdGVtZW50cywgaXQKPiAtaXMtIHNvbWV0aGluZyB3aGljaCBibGtpZCBjb3VsZCwg
aW4gdGhlb3J5LCBzdGlsbCByZXR1cm4sIGFuZAo+IG1ha2luZyB4ZnN0ZXN0cyBjb3BlIHdpdGgg
dGhhdCBhbmQgdHJ5IHRvIGludm9rZSBmc2NrIC10IGV4dDRkZXYKPiBkb2Vzbid0IGJvdGhlciBt
ZSB0b28gbXVjaC4gIEl0IGlzIHNhZGx5IGFuIGZzIHR5cGUgZW1iZWRkZWQgaW50bwo+IGEgZmV3
IHRvb2xzLgo+IAo+IEJ1dCBvdGhlciB0aGFuIHRoYXQsIEkgZG9uJ3QgdGhpbmsgd2Ugc2hvdWxk
IGJlIG1ha2luZyBjaGFuZ2VzIHRvCj4gdXBzdHJlYW0gcHJvamVjdHMgYmFzZWQgb24geW91ciBj
dXJyZW50IGRldmVsb3BtZW50IGhhY2tzIChJIGRvbid0Cj4gbWVhbiBoYWNrIGluIGEgYmFkIHdh
eSwganVzdCB0aGF0IHJ1bm5pbmcgc2VkIGFjcm9zcyBleHQ0IHRvCj4gY3JlYXRlIHlvdXIgY3Vz
dG9tIGZpbGVzeXN0ZW0gZm9yIHRlc3Rpbmcgc2hvdWxkIG5vdCByZXF1aXJlCj4gdXBzdHJlYW0g
cHJvamVjdHMgdG8gY2hhbmdlLi4uKQo+IAo+IFNvIEknbSBvayB3aXRoIHNwcmlua2xpbmcgImV4
dDR8ZXh0NGRldiIgYXJvdW5kIGlmIG5lY2Vzc2FyeS4KPiBBbnlvbmUgZWxzZSBkaXNhZ3JlZT8K
CtCGZiBpdCBpcyBleHQ0IGNvbW11bml0eSBkZWNpZGVzIHRoYXQgZXh0NGRldiBpcyBub3QgZGVw
cmVjYXRlZCB0aGVuCkkgZG9uJ3QgaGF2ZSBhbnkgb2JqZWN0aW9uLiBJdCB3b24ndCBjYXVzZSBt
ZSBhbnkgUEVCS0FDIHByb2JsZW1zLgo7KQoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5l
cgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3Nz
LnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
