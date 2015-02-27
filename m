Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 430507F54
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 02:08:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 318E430406B
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 00:08:04 -0800 (PST)
Received: from mail-pd0-f169.google.com (mail-pd0-f169.google.com
	[209.85.192.169]) by cuda.sgi.com with ESMTP id
	PoTJAJflM0LSfBRl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Feb 2015 00:08:02 -0800 (PST)
Received: by pdjp10 with SMTP id p10so19426131pdj.3
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 00:08:01 -0800 (PST)
Date: Fri, 27 Feb 2015 00:08:00 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: Documenting MS_LAZYTIME
Message-ID: <20150227080800.GA20442@mew>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
	<54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org>
	<54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org>
	<54EF2161.90607@gmail.com> <20150227000409.GC17174@thunk.org>
	<54F02446.2050008@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F02446.2050008@gmail.com>
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

T24gRnJpLCBGZWIgMjcsIDIwMTUgYXQgMDk6MDE6MTBBTSArMDEwMCwgTWljaGFlbCBLZXJyaXNr
IChtYW4tcGFnZXMpIHdyb3RlOgo+IE9uIDAyLzI3LzIwMTUgMDE6MDQgQU0sIFRoZW9kb3JlIFRz
J28gd3JvdGU6Cj4gPiBPbiBUaHUsIEZlYiAyNiwgMjAxNSBhdCAwMjozNjozM1BNICswMTAwLCBN
aWNoYWVsIEtlcnJpc2sgKG1hbi1wYWdlcykgd3JvdGU6Cj4gPj4KPiA+PiAgICAgVGhlIGRpc2Fk
dmFudGFnZSBvZiBNU19TVFJJQ1RBVElNRSB8IE1TX0xBWllUSU1FIGlzIHRoYXQKPiA+PiAgICAg
aW4gdGhlIGNhc2Ugb2YgYSBzeXN0ZW0gY3Jhc2gsIHRoZSBhdGltZSBhbmQgbXRpbWUgZmllbGRz
Cj4gPj4gICAgIG9uIGRpc2sgbWlnaHQgYmUgb3V0IG9mIGRhdGUgYnkgYXQgbW9zdCAyNCBob3Vy
cy4KPiA+IAo+ID4gSSdkIGNoYW5nZSB0byAiVGhlIGRpc2FkdmFudGFnZSBvZiBNU19MQVpZVElN
RSBpcyB0aGF0Li4uIiAgYW5kCj4gPiBwZXJoYXBzIG1vdmUgdGhhdCBzbyBpdCdzIGNsZWFyIGl0
IGFwcGxpZXMgdG8gYW55IHVzZSBvZiBNU19MQVpZVElNRQo+ID4gaGFzIHRoaXMgYXMgYSBkb3du
c2lkZS4KPiA+IAo+ID4gRG9lcyB0aGF0IG1ha2Ugc2Vuc2U/Cj4gCj4gVGhhbmtzLCBUZWQuIEdv
dCBpdC4gU28sIG5vdyB3ZSBoYXZlOgo+IAo+ICAgICAgICBNU19MQVpZVElNRSAoc2luY2UgTGlu
dXggMy4yMCkKPiAgICAgICAgICAgICAgIFJlZHVjZSAgb24tZGlzayAgdXBkYXRlcyAgb2YgIGlu
b2RlICB0aW1lc3RhbXBzICAoYXRpbWUsCj4gICAgICAgICAgICAgICBtdGltZSwgY3RpbWUpIGJ5
IG1haW50YWluaW5nIHRoZXNlIGNoYW5nZXMgb25seSBpbiAgbWVt4oCQCj4gICAgICAgICAgICAg
ICBvcnkuICBUaGUgb24tZGlzayB0aW1lc3RhbXBzIGFyZSB1cGRhdGVkIG9ubHkgd2hlbjoKPiAK
PiAgICAgICAgICAgICAgIChhKSAgdGhlIGlub2RlIG5lZWRzIHRvIGJlIHVwZGF0ZWQgZm9yIHNv
bWUgY2hhbmdlIHVucmXigJAKPiAgICAgICAgICAgICAgICAgICAgbGF0ZWQgdG8gZmlsZSB0aW1l
c3RhbXBzOwo+IAo+ICAgICAgICAgICAgICAgKGIpICB0aGUgYXBwbGljYXRpb24gIGVtcGxveXMg
IGZzeW5jKDIpLCAgc3luY2ZzKDIpLCAgb3IKPiAgICAgICAgICAgICAgICAgICAgc3luYygyKTsK
PiAKPiAgICAgICAgICAgICAgIChjKSAgYW4gdW5kZWxldGVkIGlub2RlIGlzIGV2aWN0ZWQgZnJv
bSBtZW1vcnk7IG9yCj4gCj4gICAgICAgICAgICAgICAoZCkgIG1vcmUgIHRoYW4gMjQgaG91cnMg
aGF2ZSBwYXNzZWQgc2luY2UgdGhlIGlub2RlIHdhcwo+ICAgICAgICAgICAgICAgICAgICB3cml0
dGVuIHRvIGRpc2suCj4gCj4gICAgICAgICAgICAgICBUaGlzIG1vdW50IHNpZ25pZmljYW50bHkg
cmVkdWNlcyB3cml0ZXMgbmVlZGVkIHRvIHVwZGF0ZQoiVGhpcyBtb3VudCBvcHRpb24iPwoKPiAg
ICAgICAgICAgICAgIHRoZSAgaW5vZGUncyAgdGltZXN0YW1wcywgIGVzcGVjaWFsbHkgIG10aW1l
ICBhbmQgYXRpbWUuCj4gICAgICAgICAgICAgICBIb3dldmVyLCBpbiB0aGUgZXZlbnQgb2YgYSBz
eXN0ZW0gY3Jhc2gsIHRoZSAgYXRpbWUgIGFuZAo+ICAgICAgICAgICAgICAgbXRpbWUgIGZpZWxk
cyAgb24gIGRpc2sgbWlnaHQgYmUgb3V0IG9mIGRhdGUgYnkgdXAgdG8gMjQKPiAgICAgICAgICAg
ICAgIGhvdXJzLgo+IAo+ICAgICAgICAgICAgICAgRXhhbXBsZXMgb2Ygd29ya2xvYWRzIHdoZXJl
IHRoaXMgb3B0aW9uIGNvdWxkIGJlIG9mIHNpZ+KAkAo+ICAgICAgICAgICAgICAgbmlmaWNhbnQg
IGJlbmVmaXQgaW5jbHVkZSBmcmVxdWVudCByYW5kb20gd3JpdGVzIHRvIHByZeKAkAo+ICAgICAg
ICAgICAgICAgYWxsb2NhdGVkIGZpbGVzLCBhcyB3ZWxsIGFzIGNhc2VzIHdoZXJlIHRoZSAgTVNf
U1RSSUNUQeKAkAo+ICAgICAgICAgICAgICAgVElNRSAgbW91bnQgIG9wdGlvbiAgaXMgYWxzbyBl
bmFibGVkLiAgKFRoZSBhZHZhbnRhZ2Ugb2YKPiAgICAgICAgICAgICAgIChNU19TVFJJQ1RBVElN
RSB8ICBNU19MQVpZVElNRSkgIGlzICB0aGF0ICBzdGF0KDIpICB3aWxsCj4gICAgICAgICAgICAg
ICByZXR1cm4gIHRoZSAgY29ycmVjdGx5ICB1cGRhdGVkICBhdGltZSwgIGJ1dCAgdGhlICBhdGlt
ZQo+ICAgICAgICAgICAgICAgdXBkYXRlcyB3aWxsIGJlIGZsdXNoZWQgdG8gZGlzayBvbmx5IHdo
ZW4gKDEpIHRoZSAgaW5vZGUKPiAgICAgICAgICAgICAgIG5lZWRzICB0byAgYmUgIHVwZGF0ZWQg
Zm9yIGZpbGVzeXN0ZW0gLyBkYXRhIGNvbnNpc3RlbmN5Cj4gICAgICAgICAgICAgICByZWFzb25z
IG9yICgyKSB0aGUgaW5vZGUgaXMgcHVzaGVkIG91dCBvZiBtZW1vcnksIG9yICgzKQo+ICAgICAg
ICAgICAgICAgdGhlIGZpbGVzeXN0ZW0gaXMgdW5tb3VudGVkLikKSXMgaXQgbmVjZXNzYXJ5IHRv
IHJlcGVhdCB0aGUgcmVhc29ucyBmb3IgZmx1c2hpbmcsIHdoaWNoIGFyZSBzdGF0ZWQKYWJvdmU/
Cgo+IAo+IENoZWVycywKPiAKPiBNaWNoYWVsCj4gCj4gCj4gLS0gCj4gTWljaGFlbCBLZXJyaXNr
Cj4gTGludXggbWFuLXBhZ2VzIG1haW50YWluZXI7IGh0dHA6Ly93d3cua2VybmVsLm9yZy9kb2Mv
bWFuLXBhZ2VzLwo+IExpbnV4L1VOSVggU3lzdGVtIFByb2dyYW1taW5nIFRyYWluaW5nOiBodHRw
Oi8vbWFuNy5vcmcvdHJhaW5pbmcvCj4gCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KPiB4ZnMgbWFpbGluZyBsaXN0Cj4geGZzQG9zcy5zZ2kuY29tCj4g
aHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCgpUaGFua3MhCi0tIApPbWFy
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
