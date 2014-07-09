Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F2847F3F
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 08:28:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E0438F804C
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 06:28:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AkXwu5qrvIwD2vJx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Jul 2014 06:28:40 -0700 (PDT)
Date: Wed, 9 Jul 2014 09:28:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: symlink loop for /lib64/libhandle.so
Message-ID: <20140709132836.GA65226@bfoster.bfoster>
References: <1404898212.7231.12.camel@jtulak>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1404898212.7231.12.camel@jtulak>
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
To: Jan =?utf-8?B?xaR1bMOhaw==?= <jan@tulak.me>
Cc: XFS mail list <xfs@oss.sgi.com>

T24gV2VkLCBKdWwgMDksIDIwMTQgYXQgMTE6MzA6MTJBTSArMDIwMCwgSmFuIMWkdWzDoWsgd3Jv
dGU6Cj4gSGksCj4gCj4gd2hlbiBJIGluc3RhbGwgeGZzcHJvZ3MgZnJvbSBHaXQsIEkgZ2V0IGEg
c3ltbGluayBsb29wOgo+ICQgbHMgLWwgL2xpYjY0L2xpYmhhbmRsZS5zbwo+IGxyd3hyd3hyd3gu
IDEgcm9vdCByb290IDE5IEp1bCAgOSAwOTo1NiAvbGliNjQvbGliaGFuZGxlLnNvCj4gLT4gL2xp
YjY0L2xpYmhhbmRsZS5zbwo+IAo+IEkgZ3Vlc3MgaXQgc2hvdWxkIHBvaW50IHRvIGxpYmhhbmRs
ZS5zby4xLgo+IAo+IAo+IEknbSB1c2luZyB0aGlzIHJlcG86IGdpdDovL29zcy5zZ2kuY29tL3hm
cy9jbWRzL3hmc3Byb2dzCj4gQW5kIGp1c3QgdGhlIHVzdWFsICJtYWtlICYmIHN1ZG8gbWFrZSBp
bnN0YWxsIiBjb21tYW5kcy4KPiAKPiBBbHNvLCBJIGhhdmUgbWFkZSBzdXJlIHRoZSBsaWJoYW5k
bGUgbGlicmFyeSB3YXMgbm90IGluc3RhbGxlZCBiZWZvcmUKPiB0aGlzIGluc3RhbGxhdGlvbi4K
PiAKPiAKPiBVc2VkIEhXL1NXOgo+IC0gQSB2aXJ0dWFsIG1hY2hpbmUgaW4gS1ZNLgo+IC0gRmVk
b3JhIDIwIHg4Nl82NAo+IAo+IElmIGl0IG5vdCBhbiBpbnRlbmRlZCBiZWhhdmlvciwgSSBjYW4g
dHJ5IHRvIGZpbmQgdGhlIHNvdXJjZSBvZiB0aGUgYnVnCj4gYW5kIG1ha2UgYSBwYXRjaCAoSSdt
IG5ldyBoZXJlIDotKS4KPiAKCkkgY2FuIHJlcHJvZHVjZSB0aGlzIG9uIGZlZG9yYSByYXdoaWRl
IHZpYSAnbWFrZSBpbnN0YWxsLXFhLicgVGhpcyBpcwpub3QgaW50ZW5kZWQgYmVoYXZpb3IuIEkg
Y291bGRuJ3QgdGVsbCB5b3Ugd2hhdCB0aGUgcHJvYmxlbSBpcywgYnV0CnBhdGNoZXMgYXJlIGNl
cnRhaW5seSB3ZWxjb21lLiA6KQoKQnJpYW4KCj4gVGhhbmtzLAo+IEphbiBUdWxhawo+IAo+IF9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4geGZzIG1haWxp
bmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
