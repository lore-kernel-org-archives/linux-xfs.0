Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 379AA7F50
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 02:01:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9AC8AC006
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 00:01:25 -0800 (PST)
Received: from mail-we0-f179.google.com (mail-we0-f179.google.com
	[74.125.82.179]) by cuda.sgi.com with ESMTP id N7U5wHXUvyAMqjAc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Feb 2015 00:01:20 -0800 (PST)
Received: by wevl61 with SMTP id l61so18130070wev.2
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 00:01:19 -0800 (PST)
Message-ID: <54F02446.2050008@gmail.com>
Date: Fri, 27 Feb 2015 09:01:10 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
	<54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org>
	<54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org>
	<54EF2161.90607@gmail.com> <20150227000409.GC17174@thunk.org>
In-Reply-To: <20150227000409.GC17174@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, mtk.manpages@gmail.com, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

T24gMDIvMjcvMjAxNSAwMTowNCBBTSwgVGhlb2RvcmUgVHMnbyB3cm90ZToKPiBPbiBUaHUsIEZl
YiAyNiwgMjAxNSBhdCAwMjozNjozM1BNICswMTAwLCBNaWNoYWVsIEtlcnJpc2sgKG1hbi1wYWdl
cykgd3JvdGU6Cj4+Cj4+ICAgICBUaGUgZGlzYWR2YW50YWdlIG9mIE1TX1NUUklDVEFUSU1FIHwg
TVNfTEFaWVRJTUUgaXMgdGhhdAo+PiAgICAgaW4gdGhlIGNhc2Ugb2YgYSBzeXN0ZW0gY3Jhc2gs
IHRoZSBhdGltZSBhbmQgbXRpbWUgZmllbGRzCj4+ICAgICBvbiBkaXNrIG1pZ2h0IGJlIG91dCBv
ZiBkYXRlIGJ5IGF0IG1vc3QgMjQgaG91cnMuCj4gCj4gSSdkIGNoYW5nZSB0byAiVGhlIGRpc2Fk
dmFudGFnZSBvZiBNU19MQVpZVElNRSBpcyB0aGF0Li4uIiAgYW5kCj4gcGVyaGFwcyBtb3ZlIHRo
YXQgc28gaXQncyBjbGVhciBpdCBhcHBsaWVzIHRvIGFueSB1c2Ugb2YgTVNfTEFaWVRJTUUKPiBo
YXMgdGhpcyBhcyBhIGRvd25zaWRlLgo+IAo+IERvZXMgdGhhdCBtYWtlIHNlbnNlPwoKVGhhbmtz
LCBUZWQuIEdvdCBpdC4gU28sIG5vdyB3ZSBoYXZlOgoKICAgICAgIE1TX0xBWllUSU1FIChzaW5j
ZSBMaW51eCAzLjIwKQogICAgICAgICAgICAgIFJlZHVjZSAgb24tZGlzayAgdXBkYXRlcyAgb2Yg
IGlub2RlICB0aW1lc3RhbXBzICAoYXRpbWUsCiAgICAgICAgICAgICAgbXRpbWUsIGN0aW1lKSBi
eSBtYWludGFpbmluZyB0aGVzZSBjaGFuZ2VzIG9ubHkgaW4gIG1lbeKAkAogICAgICAgICAgICAg
IG9yeS4gIFRoZSBvbi1kaXNrIHRpbWVzdGFtcHMgYXJlIHVwZGF0ZWQgb25seSB3aGVuOgoKICAg
ICAgICAgICAgICAoYSkgIHRoZSBpbm9kZSBuZWVkcyB0byBiZSB1cGRhdGVkIGZvciBzb21lIGNo
YW5nZSB1bnJl4oCQCiAgICAgICAgICAgICAgICAgICBsYXRlZCB0byBmaWxlIHRpbWVzdGFtcHM7
CgogICAgICAgICAgICAgIChiKSAgdGhlIGFwcGxpY2F0aW9uICBlbXBsb3lzICBmc3luYygyKSwg
IHN5bmNmcygyKSwgIG9yCiAgICAgICAgICAgICAgICAgICBzeW5jKDIpOwoKICAgICAgICAgICAg
ICAoYykgIGFuIHVuZGVsZXRlZCBpbm9kZSBpcyBldmljdGVkIGZyb20gbWVtb3J5OyBvcgoKICAg
ICAgICAgICAgICAoZCkgIG1vcmUgIHRoYW4gMjQgaG91cnMgaGF2ZSBwYXNzZWQgc2luY2UgdGhl
IGlub2RlIHdhcwogICAgICAgICAgICAgICAgICAgd3JpdHRlbiB0byBkaXNrLgoKICAgICAgICAg
ICAgICBUaGlzIG1vdW50IHNpZ25pZmljYW50bHkgcmVkdWNlcyB3cml0ZXMgbmVlZGVkIHRvIHVw
ZGF0ZQogICAgICAgICAgICAgIHRoZSAgaW5vZGUncyAgdGltZXN0YW1wcywgIGVzcGVjaWFsbHkg
IG10aW1lICBhbmQgYXRpbWUuCiAgICAgICAgICAgICAgSG93ZXZlciwgaW4gdGhlIGV2ZW50IG9m
IGEgc3lzdGVtIGNyYXNoLCB0aGUgIGF0aW1lICBhbmQKICAgICAgICAgICAgICBtdGltZSAgZmll
bGRzICBvbiAgZGlzayBtaWdodCBiZSBvdXQgb2YgZGF0ZSBieSB1cCB0byAyNAogICAgICAgICAg
ICAgIGhvdXJzLgoKICAgICAgICAgICAgICBFeGFtcGxlcyBvZiB3b3JrbG9hZHMgd2hlcmUgdGhp
cyBvcHRpb24gY291bGQgYmUgb2Ygc2ln4oCQCiAgICAgICAgICAgICAgbmlmaWNhbnQgIGJlbmVm
aXQgaW5jbHVkZSBmcmVxdWVudCByYW5kb20gd3JpdGVzIHRvIHByZeKAkAogICAgICAgICAgICAg
IGFsbG9jYXRlZCBmaWxlcywgYXMgd2VsbCBhcyBjYXNlcyB3aGVyZSB0aGUgIE1TX1NUUklDVEHi
gJAKICAgICAgICAgICAgICBUSU1FICBtb3VudCAgb3B0aW9uICBpcyBhbHNvIGVuYWJsZWQuICAo
VGhlIGFkdmFudGFnZSBvZgogICAgICAgICAgICAgIChNU19TVFJJQ1RBVElNRSB8ICBNU19MQVpZ
VElNRSkgIGlzICB0aGF0ICBzdGF0KDIpICB3aWxsCiAgICAgICAgICAgICAgcmV0dXJuICB0aGUg
IGNvcnJlY3RseSAgdXBkYXRlZCAgYXRpbWUsICBidXQgIHRoZSAgYXRpbWUKICAgICAgICAgICAg
ICB1cGRhdGVzIHdpbGwgYmUgZmx1c2hlZCB0byBkaXNrIG9ubHkgd2hlbiAoMSkgdGhlICBpbm9k
ZQogICAgICAgICAgICAgIG5lZWRzICB0byAgYmUgIHVwZGF0ZWQgZm9yIGZpbGVzeXN0ZW0gLyBk
YXRhIGNvbnNpc3RlbmN5CiAgICAgICAgICAgICAgcmVhc29ucyBvciAoMikgdGhlIGlub2RlIGlz
IHB1c2hlZCBvdXQgb2YgbWVtb3J5LCBvciAoMykKICAgICAgICAgICAgICB0aGUgZmlsZXN5c3Rl
bSBpcyB1bm1vdW50ZWQuKQoKQ2hlZXJzLAoKTWljaGFlbAoKCi0tIApNaWNoYWVsIEtlcnJpc2sK
TGludXggbWFuLXBhZ2VzIG1haW50YWluZXI7IGh0dHA6Ly93d3cua2VybmVsLm9yZy9kb2MvbWFu
LXBhZ2VzLwpMaW51eC9VTklYIFN5c3RlbSBQcm9ncmFtbWluZyBUcmFpbmluZzogaHR0cDovL21h
bjcub3JnL3RyYWluaW5nLwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
