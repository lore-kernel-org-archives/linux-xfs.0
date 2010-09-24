Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ODmNTC184737 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:48:23 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BFD89A831
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:49:17 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	rHOa5Cz0uq6irnaC for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 06:49:17 -0700 (PDT)
Message-ID: <4C9CAC56.2020601@open-e.com>
Date: Fri, 24 Sep 2010 15:49:10 +0200
From: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>
MIME-Version: 1.0
Subject: Re: Problem with file system on iSCSI FileIO
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<20100924151846.1208611c@harpe.intellique.com>
In-Reply-To: <20100924151846.1208611c@harpe.intellique.com>
Reply-To: slawomir.nowakowski@open-e.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>, Christoph Hellwig <hch@infradead.org>
Cc: Artur Piechocki <artur.piechocki@open-e.com>, =?UTF-8?B?xYF1a2FzeiBXaXR0aWc=?= <lukasz.wittig@open-e.com>, 'Ryszard Stawiarski' <ryszard.stawiarski@open-e.com>, xfs@oss.sgi.com

RGVhciBTaXJzLAo+IExlIEZyaSwgMjQgU2VwIDIwMTAgMDM6NTU6MDUgLTA0MDAKPiBDaHJpc3Rv
cGggSGVsbHdpZzxoY2hAaW5mcmFkZWFkLm9yZz4gIMOpY3JpdmFpdDoKPgo+ICAgIAo+PiBUaGFu
a3MsIEkga25vdyBJU0NTSSB2ZXJ5IHdlbGwuICBCdXQgd2hhdCBpcyAiaVNDU0kgRmlsZUlPIiA/
ICBUaGUKPj4gYWJvdmUgc291bmRzIGxpa2UgaXQncyBhbiBpc2NzaSB0YXJnZXQsIGlzIHRoYXQg
Y29ycmVjdD8KPj4gICAgICAKPiBJdCdzIGFuIElPIE1vZGUgdGhhdCBnb2VzIHRocm91Z2ggdGhl
IGtlcm5lbCBWRlMgY2FjaGUsIGFzIG9wcG9zZWQgdG8KPiBibG9ja0lPIHRoYXQgZG9lcyBkaXJl
Y3QgSU8uCj4KPiAgICAKPj4gSSBzdGlsbCBjYW4ndCBtYWtlIGFueSBzZW5zZSBvZiB0aGUgYWN0
dWFsIHNldHVwcy4KPj4KPj4gVGhlIGFib3ZlIHNlZW1zIHRvIGJlIHRoZSBiYWNrZW5kIHN0b3Jh
Z2UuICBUaGVuIHRoZXJlJ3MgU0NTVAo+PiBzb21ld2hlcmUgaW4gd2hpY2ggaXMgaW4gYSBvdXQg
b2YgdHJlZSBrZXJuZWwgbW9kdWxlLiAgQW5kIHRoZW4geW91Cj4+IHVzZSBYRlMgc29tZXdoZXJl
LiAgUGxlYXNlIHByb3ZpZGUgYSBmdWxsIGRlc2NyaXB0aW9uIG9mIHRoZSBzZXR1cC4KPj4gICAg
ICAKPiBJZiB0aGUgaVNDU0kgdGFyZ2V0cyBhcmUgYWN0dWFsbHkgYmxvY2sgZGV2aWNlcyAobHZt
IGx2cywgZGlzawo+IHBhcnRpdGlvbnMsIGV0YyksIHRoYW4gdXNpbmcgRmlsZUlPIGlzIGEgbWlz
dGFrZSwgaXQgbWF5IGJyaW5nIHVwIGFsbAo+IGtpbmQgb2Ygd2VpcmQgYmVoYXZpb3VycywgdGhv
dWdoIG5vcm1hbGx5IG5vIHJlYWwgZXJyb3JzIC0gdGhvdWdoIEkKPiBkb24ndCByZWFsbHkga25v
dyBob3cgc2NzdCBmYXJlcyBpbiB0aGlzIHJlZ2FyZC4KPgo+IE15IHVuZGVyc3RhbmRpbmcgOiBo
ZSBwbGFubmVkIHRvIGNyZWF0ZSBhIGZpbGUgb24gdGhlIG1vdW50ZWQgWEZTCj4gdm9sdW1lIHdp
dGggZGQgYnV0IGluc3RlYWQgaGUgZGQnZWQgdGhlIGx2IGl0c2VsZiwgd2hpY2ggb2J2aW91c2x5
Cj4gZGVzdHJveWVkIHRoZSBmaWxlc3lzdGVtLiBPciBzb21ldGhpbmcgZWxzZSwgSSBkb24ndCBy
ZWFsbHkga25vdyA6KQo+Cj4gU2xhd29taXIsIHBsZWFzZSBzaG93IHVzIHRoZSBzY3N0IGNvbmZp
ZyBmaWxlLiBEaWQgeW91IHVzZSBta2ZzCj4gYW5kIGRkIG9uIHRoZSB0YXJnZXQgb3IgdGhlIGlu
aXRpYXRvcj8gVGhpcyBpc24ndCBjbGVhci4KPgo+ICAgIApJdCdzIG15IG1pc3Rha2UgaW4gZGQg
Y29tbWFuZCwgc29ycnkgZm9yIHRoYXQuCgpGaXJzdCB3ZSBtb3VudCB0aGUgTFY6Cgptb3VudApb
Li4uXQovZGV2L3ZnK3ZnMDAvbHYraStsdjAwMDAgb24gL21udC9wb2ludCB0eXBlIHhmcyAKKHJ3
LG5vdXVpZCxhdHRyMixub2JhcnJpZXIsbm9xdW90YSkKWy4uLl0KCnRoZW4gd2UgcnVuIGRkIHRv
IGZpbGUKCmRkIGlmPS9kZXYvemVybyBvZj0vbW50L3BvaW50L2x1biBicz0xTSBjb252PW5vdHJ1
bmMgY291bnQ9JHNpemUKCiRzaXplIGlzIGNvdW50ZWQgdG8gbGVhdmUgc29tZSBmcmVlIHNwYWNl
IG9uIHRoZSBkZXZpY2UKCkFzIHRoZSBpU0NTSSB0YXJnZXQgd2UgdXNlIFNDU1QgMS4wLjEuMi4g
VGhlIHNjc3QuY29uZiBsb29rcyBsaWtlcyBsaWtlIAp0aGlzOgoKW0hBTkRMRVIgdmRpc2tdCkRF
VklDRSAwUVNQMTk5V0pJMXlLT1BqLC9tbnQvcG9pbnQvbHVuLFdULDUxMiwwUVNQMTk5V0pJMXlL
T1BqCgpbR1JPVVAgRGVmYXVsdF9pcW4uMjAxMC0wMzpzbjEudGFyZ2V0MF0KW0dST1VQIERlZmF1
bHRdCgpbQVNTSUdOTUVOVCBEZWZhdWx0X2lxbi4yMDEwLTAzOnNuMS50YXJnZXQwXQpERVZJQ0Ug
MFFTUDE5OVdKSTF5S09QaiwwCltBU1NJR05NRU5UIERlZmF1bHRdCgpbVEFSR0VUUyBlbmFibGVd
CgpbVEFSR0VUUyBkaXNhYmxlXQoKVGhlIHByb2JsZW0gaXMgdGhhdCB3ZSB3ZXJlIGFibGUgdG8g
dXNlIHRoaXMgTFVOIGluIHRoZSB0YXJnZXQsIGJ1dCAKc3VkZGVubHkgYWZ0ZXIgYSByZWJvb3Qg
d2UgYXJlIG5vdC4KCkNoZWVycwpTbGF3ZWsKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6
Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
