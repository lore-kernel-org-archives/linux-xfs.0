Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04D727F37
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 16:19:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77D83AC001
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 14:19:26 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	t0GdWLaqcWg7lv3R for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2015 14:19:23 -0800 (PST)
Date: Wed, 16 Dec 2015 09:19:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fixing XFS RAID - does XFS ever issue non-aligned discards?
Message-ID: <20151215221910.GP26718@dastard>
References: <20151215141605.5b60d336@sauron>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151215141605.5b60d336@sauron>
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
To: =?utf-8?Q?Micha=C5=82?= Pecio <michal.pecio@gmail.com>
Cc: xfs@oss.sgi.com

T24gVHVlLCBEZWMgMTUsIDIwMTUgYXQgMDI6MTY6MDVQTSArMDEwMCwgTWljaGHFgiBQZWNpbyB3
cm90ZToKPiBIaSwKPiAKPiBJJ20gdXNpbmcgWEZTIHdpdGggYnNpemU9NDA5NiBvbiBSQUlEMCBv
ZiB0d28gSW50ZWwgMzIwIFNTRHMgdW5kZXIKPiBMaW51eCAzLjE4IExUUy4gSSdtIHdvbmRlcmlu
ZyBpZiBpdCdzIGNvcnJlY3QgdG8gYXNzdW1lIHRoYXQgZGlzY2FyZHMKPiBpc3N1ZWQgYnkgWEZT
IHdpbGwgYWx3YXlzIGJlIG11bHRpcGxlcyBvZiA0ayBhbmQgNGstYWxpZ25lZD8KClllcy4gRGlz
Y2FyZHMgYXJlIG9ubHkgZG9uZSBvbiBmaWxlc3lzdGVtIGJsb2Nrcywgc28gd2lsbCBoYXZlCmZp
bGVzeXN0ZW0gYmxvY2sgZ3JhbnVsYXJpdHkvYWxpZ25tZW50LgoKQ2hlZXJzLAoKRGF2ZS4KLS0g
CkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
