Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C8B6229DF8
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 09:44:34 -0600 (CST)
Date: Fri, 20 Dec 2013 09:44:30 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: XFS segfaulting on xfs_repair
Message-ID: <20131220154430.GY1935@sgi.com>
References: <5C03211A-BF4B-485A-97F1-9CE00DACF09D@libeo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5C03211A-BF4B-485A-97F1-9CE00DACF09D@libeo.com>
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
To: Marc Boivin <marc.boivin@libeo.com>
Cc: xfs@oss.sgi.com

SGkgTWFyYywKCk9uIEZyaSwgRGVjIDIwLCAyMDEzIGF0IDA5OjI2OjI2QU0gLTA1MDAsIE1hcmMg
Qm9pdmluIHdyb3RlOgo+ICAgICBXZeKAmXZlIGJlZW4gaGF2aW5nIGEgaGFyZCB0aW1lIHdpdGgg
b3VyIGlmcyBwYXJ0aXRpb24gYnV0IG1hbmFnZWQgdG8gZ2V0Cj4gICAgIGl0IGFsbW9zdCBiYWNr
IHRvIHdvcmtpbmcgY29uZGl0aW9ucy4gVG8gZ2l2ZSB5b3UgYSBiaXQgb2YgY29udGV4dCB3ZQo+
ICAgICBoYXZlIGEgTFZNIHNpdHRpbmcgb24gdG9wIG9mIDMgUkFJRCA1LiBUaGUgcGFydGl0aW9u
IGlzIGVuY3J5cHRlZC4gV2UgaGFkCj4gICAgIGlzc3VlcyB3aXRoIFJBSUQgZGVncmFkYXRpb24g
YnV0IG5vdyB0aGUgUkFJRHMgYXJlIGhlYWx0aHkuIAo+IAo+IFdlIHJhbiB4ZnNfcmVwYWlyIHF1
aXRlIGEgZmV3IHRpbWVzICg1IGlmIEnigJltIG5vdCBtaXN0YWtlbikuIFdlIGFyZSBzdHVjawo+
IHdpdGggYW4gZXJyb3I6IAo+IAo+ICoqKiBnbGliYyBkZXRlY3RlZCAqKiogeGZzX3JlcGFpcjog
bWFsbG9jKCk6IHNtYWxsYmluIGRvdWJsZSBsaW5rZWQgbGlzdCBjb3JydXB0ZWQ6IDB4MDAwMDdm
NWRjNzY0MjU3MCAqKioKPiA9PT09PT09IEJhY2t0cmFjZTogPT09PT09PT09Cj4gL2xpYi94ODZf
NjQtbGludXgtZ251L2xpYmMuc28uNigrMHg3NmQ3NilbMHg3ZjYxNDlmOTZkNzZdCj4gL2xpYi94
ODZfNjQtbGludXgtZ251L2xpYmMuc28uNigrMHg3YTY1OClbMHg3ZjYxNDlmOWE2NThdCj4gL2xp
Yi94ODZfNjQtbGludXgtZ251L2xpYmMuc28uNihfX2xpYmNfbWFsbG9jKzB4NzApWzB4N2Y2MTQ5
ZjliYjkwXQo+IHhmc19yZXBhaXJbMHg0MmRhODNdCj4geGZzX3JlcGFpclsweDQyZGIxNl0KPiB4
ZnNfcmVwYWlyWzB4NDJkZDYyXQo+IHhmc19yZXBhaXJbMHg0MzBiNzRdCj4geGZzX3JlcGFpclsw
eDQ0OTJkZV0KPiB4ZnNfcmVwYWlyWzB4NDRlNjM0XQo+IHhmc19yZXBhaXJbMHg0NTE5NzZdCj4g
eGZzX3JlcGFpclsweDQ0YzRiYV0KPiB4ZnNfcmVwYWlyWzB4NDFmMTI2XQo+IHhmc19yZXBhaXJb
MHg0MjFlNTVdCj4geGZzX3JlcGFpclsweDQwMzlkOF0KPiAvbGliL3g4Nl82NC1saW51eC1nbnUv
bGliYy5zby42KF9fbGliY19zdGFydF9tYWluKzB4ZmQpWzB4N2Y2MTQ5ZjNlZWFkXQo+IHhmc19y
ZXBhaXJbMHg0MDNmZjldCgpJIHRoaW5rIGlmIHlvdSBpbnN0YWxsIHRoZSB4ZnNwcm9ncyBkZWJ1
Z2luZm8gcGFja2FnZSB0aGlzIGJhY2t0cmFjZSB3aWxsCmluY2x1ZGUgZnVuY3Rpb24gbmFtZXMu
ICBEbyB5b3UgaGF2ZSBhIGNvcmUgZmlsZT8gIFdoYXQgdmVyc2lvbiBvZiB4ZnNfcmVwYWlyPwoK
VGhhbmtzLAoJQmVuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20v
bWFpbG1hbi9saXN0aW5mby94ZnMK
