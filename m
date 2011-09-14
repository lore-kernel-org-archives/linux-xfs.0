Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EFA8sH146989 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 10:10:08 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C35A213E9EF0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 08:14:51 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id LdVF7AI30miE8bY8
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 08:14:51 -0700 (PDT)
Received: by fxh2 with SMTP id 2so1741749fxh.26
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 08:10:05 -0700 (PDT)
Message-ID: <4E70C3CA.7010103@nasza-klasa.pl>
Date: Wed, 14 Sep 2011 17:10:02 +0200
From: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaut in stage 6
References: <4E69D1B9.8070201@nasza-klasa.pl> <201109091401.31422@zmi.at>
	<4E6A2B73.50503@nasza-klasa.pl>
	<20110912161215.GA17798@infradead.org>
	<4E707624.9030703@nasza-klasa.pl>
	<20110914142430.GA28049@infradead.org>
	<4E70C0C5.1080100@sandeen.net>
In-Reply-To: <4E70C0C5.1080100@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

VyBkbml1IDE0LjA5LjIwMTEgMTY6NTcsIEVyaWMgU2FuZGVlbiBwaXN6ZToKPiBJZiBpdCB3b3Jr
ZWQgZm9yIENocmlzdG9waCBhbmQgbm90IGZvciBCYXJ0b3N6IC4uLi4KPiAKPiBJcyB0aGUgLURE
RUJVRyAvIC1ETkRFQlVHIHR5cGUgc2V0dGluZyB0aGUgc2FtZSBpbiBib3RoIGNhc2VzPwo+IE1h
eWJlIEZlZG9yYSBpcyB0aGUgb25seSBvbmUgZG9pbmcgLUROREVCVUcgOiggYnV0IG1heWJlIHdv
cnRoCj4gY2hlY2tpbmcuCgpUZXN0ZWQgYm90aC4gSSB3YXMgd29kZXJpbmcgd2h5IEkgZ290ICd2
YWx1ZSBvcHRpbWl6ZWQgb3V0JyBpbiBnZGIsIHNvCmNvbXBpbGVkIHdpdGggREVCVUc9LUROREJF
VUcgYW5kIERFQlVHPS1EREVCVUcuIEJvdGggY3Jhc2hlZCwgYm90aCBoYWQKJ29wdGltaXplZCBv
dXQnIHZhbHVlcyBpbiBnZGIgYmFja3RyYWNlLgoKSSBmb3VuZCB0d28gcGxhY2VkIHdoZXJlIERF
QlVHIG1heSBiZSBvdmVyd3JpdHRlbjoKCmhkLXNsYXZlNSB+L2RldmVsL3hmc3Byb2dzICMgYWNr
LWdyZXAgTkRFQlVHCmxpYnhmcy9NYWtlZmlsZQozOTpERUJVRyA9IC1ETkRFQlVHCgpsaWJ4bG9n
L01ha2VmaWxlCjE2OkRFQlVHID0gLUROREVCVUcKCldoZW4gSSBjaGFuZ2VkIC1ETkRFQlVHIHRv
IC1EREVCVUcvIGNvbXBpbGF0aW9uIGZhaWxlZC4KCnhmc19pYWxsb2MuYzogSW4gZnVuY3Rpb24g
4oCYeGZzX2ltYXDigJk6Cnhmc19pYWxsb2MuYzoxMTIyOiB3YXJuaW5nOiBpbXBsaWNpdCBkZWNs
YXJhdGlvbiBvZiBmdW5jdGlvbgrigJh4ZnNfc3RhY2tfdHJhY2XigJkKICAgIFtDQ10gICAgIHhm
c19pbm9kZS5sbwp4ZnNfaW5vZGUuYzogSW4gZnVuY3Rpb24g4oCYeGZzX3ZhbGlkYXRlX2V4dGVu
dHPigJk6Cnhmc19pbm9kZS5jOjQ1OiB3YXJuaW5nOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBm
dW5jdGlvbiDigJhnZXRfdW5hbGlnbmVk4oCZCnhmc19pbm9kZS5jOiBJbiBmdW5jdGlvbiDigJh4
ZnNfaW1hcF90b19icOKAmToKeGZzX2lub2RlLmM6MTQ5OiB3YXJuaW5nOiBpbXBsaWNpdCBkZWNs
YXJhdGlvbiBvZiBmdW5jdGlvbgrigJhYRlNfQlVGVEFSR19OQU1F4oCZCnhmc19pbm9kZS5jOiBJ
biBmdW5jdGlvbiDigJh4ZnNfaWV4dGVudHNfY29weeKAmToKeGZzX2lub2RlLmM6MTAxMjogd2Fy
bmluZzogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24g4oCYeGZzX2lzaWxvY2tlZOKA
mQp4ZnNfaW5vZGUuYzoxMDEyOiBlcnJvcjog4oCYWEZTX0lMT0NLX1NIQVJFROKAmSB1bmRlY2xh
cmVkIChmaXJzdCB1c2UgaW4KdGhpcyBmdW5jdGlvbikKeGZzX2lub2RlLmM6MTAxMjogZXJyb3I6
IChFYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBpcyByZXBvcnRlZCBvbmx5IG9uY2UKeGZzX2lu
b2RlLmM6MTAxMjogZXJyb3I6IGZvciBlYWNoIGZ1bmN0aW9uIGl0IGFwcGVhcnMgaW4uKQotLSAK
QmFydG9zeiBDaXNlawpBZG1pbgoKZW1haWw6IGJhcnRvc3ouY2lzZWtAbmFzemEta2xhc2EucGwK
dGVsOiArNDggNTE5IDMwMCAxMjIKCk5hc3phIEtsYXNhIFNwLiB6IG8uby4sCnVsLiBHZW4uIEou
IEJlbWEgMiwgNTAtMjY1IFdyb2PFgmF3CgpTxIVkIFJlam9ub3d5IGRsYSBXcm9jxYJhd2lhIC0g
RmFicnljem5laiB3ZSBXcm9jxYJhd2l1LApWSSBXeWR6aWHFgiBHb3Nwb2RhcmN6eSBLcmFqb3dl
Z28gUmVqZXN0cnUgU8SFZG93ZWdvLApuciBLUlM6MDAwMDI4OTYyOSwgTklQOjg5OC0yMS0yMi0x
MDQgUkVHT046MDIwNTg2MDIwLApLYXBpdGHFgiB6YWvFgmFkb3d5OiA2NyA4NTAsMDAgUExOCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGlu
ZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5m
by94ZnMK
