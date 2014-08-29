Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DC2B7F9F
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 06:27:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2A77AC001
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 04:27:07 -0700 (PDT)
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id QKCLR2E3DTp7VxL7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Aug 2014 04:27:06 -0700 (PDT)
Received: by mail-qa0-f46.google.com with SMTP id w8so1974503qac.33
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 04:27:06 -0700 (PDT)
In-Reply-To: <20140829083738.GD20518@dastard>
References: <3dc9caf6f9b415f6e4c0ebac1f1626d3@zbfmail.de>
	<20140827230732.GN20518@dastard>
	<CAAxjCEy9UyjDVrTZ4GdRyDy330wUqLGWurzrLAE6-7Q0KdYzvA@mail.gmail.com>
	<20140829083738.GD20518@dastard>
MIME-Version: 1.0
Subject: Re: mount options question
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 29 Aug 2014 07:26:59 -0400
Message-ID: <6306cfa5-457d-4794-8fc0-1768f7f1deec@email.android.com>
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
To: Dave Chinner <david@fromorbit.com>, Stefan Ring <stefanrin@gmail.com>
Cc: weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

CgpPbiBBdWd1c3QgMjksIDIwMTQgNDozNzozOCBBTSBFRFQsIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj5PbiBGcmksIEF1ZyAyOSwgMjAxNCBhdCAwODozMTo0M0FN
ICswMjAwLCBTdGVmYW4gUmluZyB3cm90ZToKPj4gT24gVGh1LCBBdWcgMjgsIDIwMTQgYXQgMTow
NyBBTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPgo+d3JvdGU6Cj4+ID4gT24g
V2VkLCBBdWcgMjcsIDIwMTQgYXQgMTI6MTQ6MjFQTSArMDIwMCwgTWFya28gV2ViZXJ8ODAwMCB3
cm90ZToKPj4gPj4KPj4gPj4gc29ycnkgZGF2ZSBhbmQgYWxsIG90aGVyLAo+PiA+Pgo+PiA+PiBj
YW4geW91IGd1eXMgcmVjb21tZW5kIG1lIHRoZSBtb3N0IHN0YWJsZSAvIGJlc3QgbW91bnQgb3B0
aW9ucyBmb3IKPj4gPj4gbXkgbmV3IHNlcnZlciB3aXRoIHNzZMK0cyBhbmQgWEZTIGZpbGVzeXN0
ZW0/Cj4+ID4+Cj4+ID4+IGF0IG1vbWVudCBpIHdvdWxkIHNldDogCj5kZWZhdWx0cyxub2JhcnJp
ZXIsZGlzY2FyZCxsb2dic2l6ZT0yNTZrLG5vaWtlZXAKPj4gPj4gb3IgaXMganVzdCAiZGVmYXVs
dCIgdGhlIGJlc3Qgc29sdXRpb24gYW5kIHhmcyBkZXRlY3QgaXRzZWxmIHdoYXRzCj5iZXN0Lgo+
PiA+Pgo+PiA+PiBjYW4geW91IGd1aWRlIG1lIGEgYml0Pwo+PiA+Pgo+PiA+PiBhcyBlbGVhdnRv
ciBpIHNldCBlbGV2YXRvcj1ub29wCj4+ID4+Cj4+ID4+IGkgc2V0dXAgZGlza3Mgd2l0aCBsaW51
eCBzb2Z0cmFpZCByYWlkMS4gT24gdG9wIG9mIHRoZSByYWlkIGlzIExWTQo+PiA+PiAoZm9yIHNv
bWUgZGF0YSBwYXJ0YXRpb25zKS4KPj4gPj4KPj4gPj4KPj4gPj4gd291bGQgYmUgbmljZSB0byBo
ZWFyIHNvbWUgdGlwcHMgZnJvbSB5b3UKPj4gPgo+PiA+IFVubGVzcyB5b3UgaGF2ZSBzcGVjaWZp
YyByZXF1aXJlbWVudHMgb3IgaGF2ZSB0aGUga25vd2xlZGdlIHRvCj4+ID4gdW5kZXJzdGFuZCBo
b3cgdGhlIGRpZmZlcmVudCBvcHRpb25zIGFmZmVjdCBiZWhhdmlvdXIsIHRoZW4ganVzdAo+dXNl
Cj4+ID4gdGhlIGRlZmF1bHRzLgo+PiAKPj4gTW9zdGx5IGFncmVlZCwgYnV0IHVzaW5nICJkaXNj
YXJkIiB3b3VsZCBiZSBhIG5vLWJyYWluZXIgZm9yIG1lLiBJCj4+IHN1cHBvc2UgWEZTIGRvZXMg
bm90IGF1dG9tYXRpY2FsbHkgc3dpdGNoIGl0IG9uIGZvciBub24tcm90YXRpb25hbAo+PiBzdG9y
YWdlLgo+Cj5ZdXAsIHlvdSdyZSBub3QgdXNpbmcgeW91ciBicmFpbi4gOlAKPgo+bW91bnQgLW8g
ZGlzY2FyZCAqc3Vja3MqIG9uIHNvIG1hbnkgbGV2ZWxzIGl0IGlzIG5vdCBmdW5ueS4gSSBkb24n
dAo+cmVjb21tZW5kIHRoYXQgYW55Ym9keSAqZXZlciogdXNlIGl0LCBvbiBYRlMsIGV4dDQgb3Ig
YnRyZnMuICBKdXN0Cj51c2UgZnN0cmltIGlmIHlvdSBldmVyIG5lZWQgdG8gY2xlYW4gdXAgYSBT
U0QuCgpJbiBwYXJ0aWN1bGFyIHRyaW0gaXMgYSBzeW5jaHJvbm91cyBjb21tYW5kIGluIG1hbnkg
U1NEcywgSSBkb24ndCBrbm93IGFib3V0IHRoZSBpbXBhY3Qgb24gdGhlIGtlcm5lbCBibG9jayBz
dGFjay4gRm9yIHRoZSBTU0QgaXRzZWxmIHRoYXQgbWVhbnMgdGhlIFNTRHMgYmFzaWNhbGx5IGZs
dXNoIHRoZWlyIHdyaXRlIGNhY2hlIG9uIGV2ZXJ5IHRyaW0gY2FsbC4KCkkgb2Z0ZW4gdGVsbCBw
ZW9wbGUgdG8gZG8gcGVyZm9ybWFuY2UgdGVzdGluZyB3aXRoIGFuZCB3aXRob3V0IGl0IGFuZCBy
ZXBvcnQgYmFjayB0byBtZSBpZiB0aGV5IHNlZSBubyBkZWdyYWRhdGlvbiBjYXVzZWQgYnkgLW8g
ZGlzY2FyZC4gIFRvIGRhdGUgbm8gb25lIGhhcyBldmVyIHJlcG9ydGVkIGJhY2suICBJIHRoaW5r
IC1vIGRpc2NhcmQgc2hvdWxkIGhhdmUgbmV2ZXIgYmVlbiBpbnRyb2R1Y2VkIGFuZCBjZXJ0YWlu
bHkgbm90IDUgeWVhcnMgYWdvLiAgSW4gdGhlb3J5LCBTU0RzIHRoYXQgaGFuZGxlIHRyaW0gYXMg
YSBhc3luY2hyb25vdXMgY29tbWFuZCBhcmUgbm93IGF2YWlsYWJsZSwgYnV0IEkgZG9uJ3Qga25v
dyBhbnkgc3BlY2lmaWNzLgoKSW4gYW55IGNhc2UsIGZzdHJpbSB3b3JrcyBmb3IgYWxtb3N0IGFs
bCB3b3JrbG9hZHMgYW5kIGRvZXNuJ3QgaGF2ZSB0aGUgcG90ZW50aWFsIGNvbnRpbnVvdXMgbmVn
YXRpdmUgaW1wYWN0IG9mIC1vIGRpc2NhcmQuCgpHcmVnCi0tIApTZW50IGZyb20gbXkgQW5kcm9p
ZCBwaG9uZSB3aXRoIEstOSBNYWlsLiBQbGVhc2UgZXhjdXNlIG15IGJyZXZpdHkuCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
