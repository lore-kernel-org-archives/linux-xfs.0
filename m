Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 594FE7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 11:13:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 461A9304043
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 09:13:12 -0700 (PDT)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	O7GM1kQVcdvVxD7S (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 09:13:11 -0700 (PDT)
Received: by mail-ie0-f170.google.com with SMTP id at1so6862832iec.1
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 09:13:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131025164255.46d2829c@harpe.intellique.com>
References: <CAD+1EGPG1G9Q8kwaSUjxVjvx73UByLb3G0rmUbgJr+zD-CnjEw@mail.gmail.com>
	<20131025164255.46d2829c@harpe.intellique.com>
Date: Sat, 26 Oct 2013 00:13:10 +0800
Message-ID: <CAD+1EGNJ1MsCqsHX2wezMoeBiWFPReRquibsZTgYkjcOtsVQdA@mail.gmail.com>
Subject: Re: Questions about XFS
From: harryxiyou <harryxiyou@gmail.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

T24gRnJpLCBPY3QgMjUsIDIwMTMgYXQgMTA6NDIgUE0sIEVtbWFudWVsIEZsb3JhYwo8ZWZsb3Jh
Y0BpbnRlbGxpcXVlLmNvbT4gd3JvdGU6Cj4gTGUgRnJpLCAyNSBPY3QgMjAxMyAyMjoyODoxMCAr
MDgwMAo+IGhhcnJ5eGl5b3UgPGhhcnJ5eGl5b3VAZ21haWwuY29tPiDDqWNyaXZhaXQ6Cj4KPj4g
MSwgSG93IHRvIGluc3RhbGwgWEZTIG9uIExpbnV4IE9TLCBJIHNob3VsZCBkbyBsaWtlIGJlbG93
LCByaWdodD8KPj4gICAgYSwgRG93bmxvYWQgbGF0ZXN0IExpbnV4IEtlcm5lbCBTb3VyY2UgQ29k
ZXMuCj4+ICAgIGIsIENvbXBpbGUgdGhlIExpbnV4IEtlcm5lbCBhbmQgc2VsZWN0IFhGUyBmZWF0
dXJlIHdoZW4gSSBkbyB0aGUKPj4gY29uZmlndXJhdGlvbiAobWFrZSBtZW51Y29uZmlnKS4KPgo+
IE5vLCBYRlMgaXMgc3VwcG9ydGVkIGJ5IGFsbCBMaW51eCBkaXN0cmlidXRpb25zIG91dCBvZiB0
aGUgYm94LiBUbyB1c2UKPiBYRlMsIHlvdSBtYXkgZXZlbnR1YWxseSBuZWVkIHRvIGluc3RhbGwg
dGhlIHhmcy1wcm9ncyBwYWNrYWdlLgoKWWVhaCwgSSBoYXZlIHNlZW4gaXQuIEFmdGVyIEkgaW5z
dGFsbCB4ZnMtcHJvZ3MsIEkgY291bGQgcnVuIG1rZnMueGZzIHRvCmZvcm1hdCBhIGRldmljZSB0
byBydW4gWEZTLgoKPgo+Cj4+IDIsIERvZXMgWEZTIHN1cHBvcnQgcmVhbC10aW1lIGZlYXR1cmUg
YWZ0ZXIgSSBpbnN0YWxsIGl0IG9uIExpbnV4Cj4+IEtlcm5lbD8gQW5kIGhvdyB0byB1c2UgcmVh
bC10aW1lIGZlYXR1cmUgb24gTGludXggS2VybmVsLgo+Pgo+Cj4gWWVzLiBXaGF0IGRvIHlvdSB3
YW50IHRvIGRvIHdpdGggcmVhbHRpbWUgWEZTPwo+CgpJIGp1c3Qgd29uZGVyIGhvdyB0byByZWFs
aXplIHRoZSByZWFsLXRpbWUgdXBvbiBjb21tb24gTGludXggS2VybmVsCmFuZCBjb21tb24gcGh5
c2ljYWwgaGFyZHdhcmUuIEl0J3MgaW50ZXJlc3RpbmcsIGlzbid0PyA7LSkKClRoYW5rcyBmb3Ig
eW91ciByZXBseS4KCgoKLS0gClRoYW5rcwpXZWl3ZWkgIEppYSAoSGFycnkgV2VpKQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
