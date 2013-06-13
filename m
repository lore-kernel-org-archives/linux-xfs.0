Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D93F27F7E
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 21:53:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 64FD1AC001
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 19:53:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EtmqGGYrOs7JPzPt for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 19:53:53 -0700 (PDT)
Date: Thu, 13 Jun 2013 12:53:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: print missing utility name
Message-ID: <20130613025350.GJ29338@dastard>
References: <alpine.LFD.2.00.1306121558030.14273@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306121558030.14273@localhost.localdomain>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

T24gV2VkLCBKdW4gMTIsIDIwMTMgYXQgMDQ6MDI6MTlQTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IEN1cnJlbnRseSB3aGVuIHRoZSB1dGlsaXR5IHN1Y2ggYXMgZmlvIG9yIGRtc2V0
dXAgaXMgbWlzc2luZyB1c2VyIGRvZXMKPiBub3QgZ2V0IHRoZSBpbmZvcm1hdGlvbiBhYm91dCB0
aGUgdXRpbGl0eSBuYW1lIHdoaWNoIGlzIGFjdHVhbGx5Cj4gbWlzc2luZy4gRml4IGl0IGJ5IHBy
b3ZpZGluZyBzZWNvbmQgYXJndW1lbnQgdG8gdGhlIF9yZXF1aXJlX2NvbW1hbmQoKS4KPiAKPiBT
aWduZWQtb2ZmLWJ5OiBMdWthcyBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPgo+IC0tLQo+
ICBjb21tb24vcmMgfCA1ICsrKy0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2NvbW1vbi9yYyBiL2NvbW1vbi9yYwo+
IGluZGV4IGZlNmJiZmMuLjk4NGNlZjEgMTAwNjQ0Cj4gLS0tIGEvY29tbW9uL3JjCj4gKysrIGIv
Y29tbW9uL3JjCj4gQEAgLTEwNTQsNiArMTA1NCw3IEBAIF9yZXF1aXJlX3JlYWx0aW1lKCkKPiAg
X3JlcXVpcmVfY29tbWFuZCgpCj4gIHsKPiAgICAgIFsgLW4gIiQxIiBdICYmIF9jbWQ9IiQxIiB8
fCBfY21kPSIkMiIKPiArICAgIFsgLXogJF9jbWQgXSAmJiBfY21kPSI8ZmlsbCB1dGlsaXR5IG5h
bWU+IgoKClRoZSBwcm9ibGVtIGhlcmUgaXMgdGhhdCB0aGUgY29tbWFuZCB3aWxsIGJlIGVtcHR5
IGlmIGl0IGRvZXNuJ3QKZXhpc3QsIHNvIGl0J3MgZGlmZmljdWx0IHRvIHRlbGwgaWYgb25lIG9y
IHR3byBwYXJhbWV0ZXJzIGlzIHZhbGlkLgoKU28sIEknZCBzdWdnZXN0IHRoYXQgX3JlcXVpcmVf
Y29tbWFuZCBzaG91bGQgYmUgY2hhbmdlZCB0bzoKCl9yZXF1aXJlX2NvbW1hbmQoKQp7CglfbmFt
ZT0kMQoJX2NtZD0kMgoKCVsgJCMgLWdlIDEgXSB8fCBfZmF0YWwgIkJyYWluZmFydCEgV2hhdCBj
b21tYW5kIGlzIHJlcXVpcmVkPyIKCVsgLW4gJF9jbWQgLWEgLXggJF9jbWQgXSB8fCBfbm90cnVu
ICIkX25hbWUgbm90IGZvdW5kLCBza2lwcGluZyB0ZXN0LiIKfQoKQW5kIGFsbCB0aGUgY2FsbGVy
cyBoYXZlIHRoZWlyIHBhcmFtZXRlcnMgc3dhcHBlZCB0byBhdm9pZCB0aGlzCmNvbmZ1c2lvbiBh
Ym91dCB3aGF0IGV4aXN0cyBhbmQgd2hhdCBkb2Vzbid0Li4uLgoKQ2hlZXJzLAoKRGF2ZS4KCi0t
IApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
