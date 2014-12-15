Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 478347F4E
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 06:25:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26825304032
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 04:25:00 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id l2KkKHmT0SDdMCAw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2014 04:24:58 -0800 (PST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 22F22D480BB
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 13:23:20 +0100 (CET)
Date: Mon, 15 Dec 2014 13:25:00 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141215132500.13210fdb@harpe.intellique.com>
In-Reply-To: <20141215130715.4dfaaa8e@harpe.intellique.com>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
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
To: xfs@oss.sgi.com

TGUgTW9uLCAxNSBEZWMgMjAxNCAxMzowNzoxNSArMDEwMApFbW1hbnVlbCBGbG9yYWMgPGVmbG9y
YWNAaW50ZWxsaXF1ZS5jb20+IMOpY3JpdmFpdDoKCj4gRGVjIDEyIDAwOjQwOjE4IFRFU1QtQURB
UFRFQyBrZXJuZWw6IFhGUyAoZG0tMCk6Cj4geGZzX2RvX2ZvcmNlX3NodXRkb3duKDB4MSkgY2Fs
bGVkIGZyb20gbGluZSAzODMgb2YgZmlsZQo+IGZzL3hmcy94ZnNfdHJhbnNfYnVmLmMuICBSZXR1
cm4gYWRkcmVzcyA9IDB4ZmZmZmZmZmY4MTI1Y2M5MAo+IERlYyAxMiAwMDo0MDozMSBURVNULUFE
QVBURUMga2VybmVsOiBYRlMgKGRtLTApOiB4ZnNfbG9nX2ZvcmNlOiBlcnJvcgo+IDUgcmV0dXJu
ZWQuCj4gRGVjIDEyIDAwOjQxOjAyIFRFU1QtQURBUFRFQyBrZXJuZWw6IFhGUyAoZG0tMCk6IHhm
c19sb2dfZm9yY2U6IGVycm9yCj4gNSByZXR1cm5lZC4KPiAKClJlYWRpbmcgdGhlIHNvdXJjZSBJ
IHNlZSB0aGF0IHRoZSBlcnJvciBvY2N1cmVkIGluIHhmc19idWZfcmVhZF9tYXAsIEkKc3VwcG9z
ZSBpdCdzIHdoZW4geGZzYnVmZCB0cmllcyB0byBzY2FuIGRpcnR5IG1ldGFkYXRhPyBUaGlzIGlz
IGEgcmVhZAplcnJvciwgc28gaXQgY291bGQgdmVyeSB3ZWxsIGJlIGEgc2ltcGxlIElPIHN0YXJ2
YXRpb24gYXQgdGhlIGNvbnRyb2xsZXIKbGV2ZWwgKGFzIHRoZSBjb250cm9sbGVyIHByb2JhYmx5
IGdpdmVzIHByaW9yaXR5IHRvIHdoYXRldmVyIHdyaXRlcyBhcmUKcGVuZGluZyBvdmVyIHJlYWRz
KS4KCk1heWJlIHNldHRpbmcgeGZzYnVmZF9jZW50aXNlY3MgdG8gdGhlIG1heCBjb3VsZCBoZWxw
IGhlcmU/IFRyeWluZwpyaWdodCBhd2F5Li4uIEFueSBhZHZpY2Ugd2VsY29tZS4KCi0tIAotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQog
ICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8
ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzgg
OTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
