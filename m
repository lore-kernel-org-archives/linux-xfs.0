Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A8987F37
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 05:16:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4021B304032
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 03:16:56 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id 4DZsuDAbsuqkCM0A (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 May 2015 03:16:53 -0700 (PDT)
Date: Fri, 15 May 2015 12:16:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair fails
Message-ID: <20150515121654.602d74af@harpe.intellique.com>
In-Reply-To: <D42CEF46A796364580AFE375880EF73F01AD63D1ED@SRVMSXMBDEN2.ad.twtelecom.com>
References: <D42CEF46A796364580AFE375880EF73F01AD63BE36@SRVMSXMBDEN2.ad.twtelecom.com>
	<20150514104341.GA15457@bfoster.bfoster>
	<D42CEF46A796364580AFE375880EF73F01AD63D1ED@SRVMSXMBDEN2.ad.twtelecom.com>
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
To: "Rhorer, Leslie" <Leslie.Rhorer@Level3.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

TGUgRnJpLCAxNSBNYXkgMjAxNSAwMzowODowNSArMDAwMAoiUmhvcmVyLCBMZXNsaWUiIDxMZXNs
aWUuUmhvcmVyQExldmVsMy5jb20+IMOpY3JpdmFpdDoKCj4gUkFJRC1TZXJ2ZXI6L3Zhci9sb2cj
IHhmc19yZXBhaXIgLXYgL2Rldi9tZDAKPiBQaGFzZSAxIC0gZmluZCBhbmQgdmVyaWZ5IHN1cGVy
YmxvY2suLi4KPiAgICAgICAgIC0gcmVwb3J0aW5nIHByb2dyZXNzIGluIGludGVydmFscyBvZiAx
NSBtaW51dGVzCj4gICAgICAgICAtIGJsb2NrIGNhY2hlIHNpemUgc2V0IHRvIDM5NTAzMiBlbnRy
aWVzCj4gUGhhc2UgMiAtIHVzaW5nIGludGVybmFsIGxvZwo+ICAgICAgICAgLSB6ZXJvIGxvZy4u
Lgo+IHplcm9fbG9nOiBoZWFkIGJsb2NrIDggdGFpbCBibG9jayA4Cj4gLi4uIDxhZnRlciBhIGZl
dyBtaW51dGVzPgo+ICAgICAgICAgLSBzY2FuIGZpbGVzeXN0ZW0gZnJlZXNwYWNlIGFuZCBpbm9k
ZSBtYXBzLi4uCj4gYWdpIHVubGlua2VkIGJ1Y2tldCAzOCBpcyAxNjMwMDAzNTggaW4gYWcgMzEg
KGlub2RlPTEzMzMwNjk4NjUzNCkKPiB6ZXJvaW5nIHVudXNlZCBwb3J0aW9uIG9mIHNlY29uZGFy
eSBzdXBlcmJsb2NrIChBRyAjNSkKPiBTZWdtZW50YXRpb24gZmF1bHQKPiAKClRyeSB3aXRoIHRo
ZSBsYXRlc3QgdmVyc2lvbiBvZiB4ZnNfcmVwYWlyIChhdCBsZWFzdCAzLjIuMiBpZiBwb3NzaWJs
ZSkuCkhlcmUncyBhIDMuMi4yIHZlcnNpb24ganVzdCBpbiBjYXNlOgoKaHR0cDovL3VwZGF0ZS5p
bnRlbGxpcXVlLmNvbS9wdWIveGZzX3JlcGFpci0zLjIuMi5negoKbWQ1IGNoZWNrc3VtIDoKOGQy
ZjljNjZlNmVhMDE1Y2Y3ZDFiOTVlZjgwNDY4YzQgIHhmc19yZXBhaXItMy4yLjIuZ3oKCldoYXQn
cyB0aGUgb3V0cHV0IGZyb20gZG1lc2cgb3IgL3Zhci9sb2cvbWVzc2FnZXMgZnJvbSB0aGUgbW91
bnQKYXR0ZW1wdD8gSWYgdGhlIGZpbGVzeXN0ZW0gaXMgImhhbGYtbW91bnRlZCIgaXQgbWF5IGJl
IGJldHRlciB0byBib290CndpdGggdGhlIGZpbGVzeXN0ZW0gZGlzYWJsZWQgaW4gL2V0Yy9mc3Rh
YiBiZWZvcmUgYXR0ZW1wdGluZyByZXBhaXIuCgotLSAKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkVtbWFudWVs
IEZsb3JhYyAgICAgfCAgIERpcmVjdGlvbiB0ZWNobmlxdWUKICAgICAgICAgICAgICAgICAgICB8
ICAgSW50ZWxsaXF1ZQogICAgICAgICAgICAgICAgICAgIHwJPGVmbG9yYWNAaW50ZWxsaXF1ZS5j
b20+CiAgICAgICAgICAgICAgICAgICAgfCAgICszMyAxIDc4IDk0IDg0IDAyCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
