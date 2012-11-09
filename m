Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA96xGaT082864 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 00:59:16 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZQ9oiUIN5gVZoCLB for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 23:01:14 -0800 (PST)
Date: Fri, 9 Nov 2012 18:01:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_quota -x -c 'report -u /dev/sde5' shows the duplicate result.
Message-ID: <20121109070112.GB6434@dastard>
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com> <509C5885.5060300@eisoo.com>
	<20121109012405.GX6434@dastard> <509C7825.1080401@eisoo.com>
	<20121109053931.GA6434@dastard> <509CA82F.7030103@eisoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509CA82F.7030103@eisoo.com>
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
To: "yyq@eisoo.com" <yyq@eisoo.com>
Cc: xfs@oss.sgi.com

T24gRnJpLCBOb3YgMDksIDIwMTIgYXQgMDI6NTI6MzFQTSArMDgwMCwgeXlxQGVpc29vLmNvbSB3
cm90ZToKPiDkuo4gMjAxMi0xMS05IDEzOjM5LCBEYXZlIENoaW5uZXIg5YaZ6YGTOgo+ID5PbiBG
cmksIE5vdiAwOSwgMjAxMiBhdCAxMToyNzozM0FNICswODAwLCB5eXFAZWlzb28uY29tIHdyb3Rl
Ogo+ID4+5LqOIDIwMTItMTEtOSA5OjI0LCBEYXZlIENoaW5uZXIg5YaZ6YGTOgo+ID4+Pk9uIEZy
aSwgTm92IDA5LCAyMDEyIGF0IDA5OjEyOjM3QU0gKzA4MDAsIHl5cUBlaXNvby5jb20gd3JvdGU6
Cj4gPj4+PkhpLAo+ID4+Pj4KPiA+Pj4+ICAgICBXaGVuIEkgdXNlICJ4ZnNfcXVvdGEgLXggLWMg
J3JlcG9ydCAtdSAvZGV2L3NkZTUnIiB0byBzaG93Cj4gPj4+Pi9kZXYvc2RlNSdzIHF1b3Rhcywg
YW5kIHRoZSByZXN1bHQgaGF2ZSB0d28gc2FtZSBibG9jayBhcyBiZWxvdzoKPiA+Pj5XaGF0IHZl
cnNpb24gb2YgeGZzX3F1b3RhIGFyZSB5b3UgdXNpbmc/IFdoYXQgaXMgdGhlIG91dHB1dCBvZgo+
ID4+Pi9wcm9jL21vdW50cyBhbmQgL2V0Yy9tdGFiIHNheT8KPiA+Pnhmc19xdW90YSdzIHZlcnNp
b24gaXMgMy4xLjEgYW5kIG91dHB1dCBvZiAvcHJvYy9tb3VudHMgbGlrZSB0aGlzOgouLi4uCj4g
PkNhbiB5b3UgYXR0YWNoIHRoZSBzdHJhY2Ugb3V0cHV0IG9mIHRoZSBjb21tYW5kPwoKVGhhbmtz
LiBUaGUgcGF0Y2ggYmVsb3cgc2hvdWxkIGZpeCBpdC4gQ2FuIHlvdSB0cnkgaXQ/CgpDaGVlcnMs
CgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCnhmc19xdW90YTog
Zml4IHJlcG9ydCBjb21tYW5kIHBhcnNpbmcKCkZyb206IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJA
cmVkaGF0LmNvbT4KClRoZSByZXBvcnQgY29tbWFuZCBsaW5lIG5lZWRzIHRvIGJlIHBhcnNlZCBh
cyBhIHdob2xlIG5vdCBhcwppbmRpdmlkdWFsIGVsZW1lbnRzIC0gcmVwb3J0X2YoKSBpcyBzZXQg
dXAgdG8gZG8gdGhpcyBjb3JyZWN0bHkuCldoZW4gdHJlYXRlZCBhcyBub24tZ2xvYmFsIGNvbW1h
bmQgbGluZSwgdGhlIHJlcG9ydCBmdW5jdGlvbiBpcwpjYWxsZWQgb25jZSBmb3IgZWFjaCBjb21t
YW5kIGxpbmUgYXJnLCByZXN1bHRpbmcgaW4gcmVwb3J0cyBiZWluZwppc3N1ZWQgbXVsdGlwbGUg
dGltZXMuCgpTZXQgdGhlIGNvbW1hbmQgdG8gYmUgYSBnbG9iYWwgY29tbWFuZCBzbyB0aGF0IGl0
IGlzIG9ubHkgY2FsbGVkCm9uY2UuCgpTaWduZWQtb2ZmLWJ5OiBEYXZlIENoaW5uZXIgPGRjaGlu
bmVyQHJlZGhhdC5jb20+Ci0tLQogcXVvdGEvcmVwb3J0LmMgfCAgICAxICsKIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL3F1b3RhL3JlcG9ydC5jIGIvcXVvdGEv
cmVwb3J0LmMKaW5kZXggYTFlMTY1Yi4uNzA4OTRhMiAxMDA2NDQKLS0tIGEvcXVvdGEvcmVwb3J0
LmMKKysrIGIvcXVvdGEvcmVwb3J0LmMKQEAgLTY1Myw2ICs2NTMsNyBAQCByZXBvcnRfaW5pdCh2
b2lkKQogCXJlcG9ydF9jbWQuY2Z1bmMgPSByZXBvcnRfZjsKIAlyZXBvcnRfY21kLmFyZ21pbiA9
IDA7CiAJcmVwb3J0X2NtZC5hcmdtYXggPSAtMTsKKwlyZXBvcnRfY21kLmZsYWdzID0gQ01EX0ZM
QUdfR0xPQkFMOwogCXJlcG9ydF9jbWQuYXJncyA9IF8oIlstYmlyXSBbLWdwdV0gWy1haG50XSBb
LWYgZmlsZV0iKTsKIAlyZXBvcnRfY21kLm9uZWxpbmUgPSBfKCJyZXBvcnQgZmlsZXN5c3RlbSBx
dW90YSBpbmZvcm1hdGlvbiIpOwogCXJlcG9ydF9jbWQuaGVscCA9IHJlcG9ydF9oZWxwOwoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
