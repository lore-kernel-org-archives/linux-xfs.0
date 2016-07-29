Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C32C87CA0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 09:29:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1EEBAC006
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 07:29:21 -0700 (PDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id iA7HNaC4hc5yvDwm
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2016 07:29:18 -0700 (PDT)
Received: by mail-wm0-f53.google.com with SMTP id o80so154788297wme.1
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 07:29:18 -0700 (PDT)
Message-ID: <9301714F76AF46609DB9C6636A31EB39@dinulap>
From: "Lista Unx" <lista.unx@gmail.com>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
	<alpine.LSU.2.20.1607291240530.18210@zvanf-gvevgu.inyvabe>
Subject: Re: partition 100% full No space left on device. looks like xfs
	iscorrupted or a bug
Date: Fri, 29 Jul 2016 17:27:44 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <robin.listas@telefonica.net>, XFS mailing list <xfs@oss.sgi.com>

IyBtb3VudHxncmVwIF4vCi9kZXYvbWFwcGVyL2NlbnRvcy1yb290IG9uIC8gdHlwZSB4ZnMgCihy
dyxyZWxhdGltZSxhdHRyMixpbm9kZTY0LGxvZ2JzaXplPTI1Nmssc3VuaXQ9NTEyLHN3aWR0aD01
MTIsbm9xdW90YSkKL2Rldi9zZGExIG9uIC9ib290IHR5cGUgeGZzIAoocncscmVsYXRpbWUsYXR0
cjIsaW5vZGU2NCxsb2dic2l6ZT0yNTZrLHN1bml0PTUxMixzd2lkdGg9NTEyLG5vcXVvdGEpCi9k
ZXYvbWFwcGVyL2NlbnRvcy1ob21lIG9uIC9ob21lIHR5cGUgeGZzIAoocncscmVsYXRpbWUsYXR0
cjIsaW5vZGU2NCxsb2dic2l6ZT0yNTZrLHN1bml0PTUxMixzd2lkdGg9NTEyLG5vcXVvdGEpCiMK
CmFsc28gY2hlY2tlZCB4ZnNfaW5mbyAvIGFuZCBvdXRwdXQgaXMgdGhlIHNhbWUgZm9yIGJvb3Ro
IChzaWNrIGluIGhlYWx0aHkpIApzZXJ2ZXJzLgoKLS0tLS0gT3JpZ2luYWwgTWVzc2FnZSAtLS0t
LSAKRnJvbTogIkNhcmxvcyBFLiBSLiIgPHJvYmluLmxpc3Rhc0B0ZWxlZm9uaWNhLm5ldD4KVG86
ICJYRlMgbWFpbGluZyBsaXN0IiA8eGZzQG9zcy5zZ2kuY29tPgpTZW50OiBGcmlkYXksIEp1bHkg
MjksIDIwMTYgMTo0OCBQTQpTdWJqZWN0OiBSZTogcGFydGl0aW9uIDEwMCUgZnVsbCBObyBzcGFj
ZSBsZWZ0IG9uIGRldmljZS4gbG9va3MgbGlrZSB4ZnMgCmlzY29ycnVwdGVkIG9yIGEgYnVnCgoK
PiAtLS0tLUJFR0lOIFBHUCBTSUdORUQgTUVTU0FHRS0tLS0tCj4gSGFzaDogU0hBMjU2Cj4KPgo+
Cj4gRWwgMjAxNi0wNy0yOSBhIGxhcyAxMjowMSArMDMwMCwgTGlzdGEgVW54IGVzY3JpYmnDszoK
Pgo+PkhlbGxvIHhmcyBleHBlcnRzLAo+Pgo+PkkgYW0gY3Jhd2xpbmcgaW4gdGhlIGRhcmsgZnJv
bSBmZXcgZGF5cyBhbmQgSSBoYXZlIG5vIGlkZWEgaG93IHRvIGZpeCB0aGUgCj4+Zm9sbG93aW5n
IHByb2JsZW0uIE9uIGEgY2VudG9zIDcgc3lzdGVtOgo+Cj4gSSdtIG5vdCBhbiBleHBlcnQsIGZh
ciBmcm9tIGl0LCBidXQuLi4gbWF5IEkgc3VnZ2VzdCB5b3UgYWRkIHRoZSBvdXRwdXQKPiBvZiBh
IHBsYWluICJtb3VudCIgY29tbWFuZD8gVG8gc2hvdyB0aGUgcGFydGl0aW9ucy4gT3IgcGVyaGFw
czoKPgo+IGxzYmxrIC0tb3V0cHV0IE5BTUUsVFlQRSxGU1RZUEUsU0laRSxUWVBFLE1PVU5UUE9J
TlQKPgo+Cj4gLSAtLSAKPiBDaGVlcnMKPiAgICAgICAgQ2FybG9zIEUuIFIuCj4KPiAgICAgICAg
KGZyb20gMTMuMSB4ODZfNjQgIkJvdHRsZSIgKE1pbmFzIFRpcml0aCkpCj4gLS0tLS1CRUdJTiBQ
R1AgU0lHTkFUVVJFLS0tLS0KPiBWZXJzaW9uOiBHbnVQRyB2Mi4wLjIyIChHTlUvTGludXgpCj4K
PiBpRjRFQVJFSUFBWUZBbGViTkdRQUNna1FqYThVYmNVV00xeTlXZ0VBaElDSHkrVGQrbmY1U0Zr
SVhzaFRMMGhpCj4gOUtRaW5JYmxsc3R2SUNPQVBoVUJBSWNQMWdjYytMbWZPNmI0ZjRnc2dVSDZM
M2R3ZW1Rb2VXNk9ZcmRQdlYvUQo+ID1OeWhXCj4gLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0t
CgoKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCgo+IF9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCj4geGZzIG1haWxpbmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNv
bQo+IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo+IAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
