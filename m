Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANKbdJG004273 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 14:37:39 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35EBD1E8F54E
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 12:39:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	MILEFVBtor1Ah0Rq for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 12:39:15 -0800 (PST)
Date: Wed, 24 Nov 2010 07:39:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Improving XFS file system inode performance
Message-ID: <20101123203906.GV22876@dastard>
References: <4CEAE7D7.6050401@ssec.wisc.edu> <20101122234419.GK13830@dastard>
	<4CEBD47F.1040004@ssec.wisc.edu> <201011232127.37796@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201011232127.37796@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Jesse Stroik <jstroik@ssec.wisc.edu>, xfs@oss.sgi.com

T24gVHVlLCBOb3YgMjMsIDIwMTAgYXQgMDk6Mjc6MzZQTSArMDEwMCwgTWljaGFlbCBNb25uZXJp
ZSB3cm90ZToKPiBPbiBEaWVuc3RhZywgMjMuIE5vdmVtYmVyIDIwMTAgSmVzc2UgU3Ryb2lrIHdy
b3RlOgo+ID4gQXMgdGhpcyBmaWxlIHN5c3RlbSBpcyBsaWtlbHkgdG8gY29udGludWUgdG8gaW5j
cmVhc2UgaW4gbnVtYmVyIG9mCj4gPiBmaWxlcyAgYXQgYSBmYWlybHkgcmFwaWQgcmF0ZSwgd2Un
cmUgZ29pbmcgdG8gbmVlZCBhIGxvbmcgdGVybQo+ID4gc3RyYXRlZ3kuICBJIHN1c3BlY3QgaXQg
bWF5IGJlIG5lY2Vzc2FyeSBpbiB0aGUgbmVhciBmdXR1cmUgdG8KPiA+IGRvdWJsZSBvciBxdWFk
cnVwbGUgdGhlIG1lbW9yeSB0byAzMkdCIG9yIDY0R0IsIGJ1dCB0aGUgdW5jZXJ0YWludHkKPiA+
IGluIHRoZSBmb3JtdWxhIG1ha2VzIG1lIG5lcnZvdXMuCj4gCj4gVXNpbmcgdG9vbHMgbGlrZSAi
bXVuaW4iIGhlbHBzIHlvdSBzZWUgdGhlIHByb2JsZW0gaW4gZ3JhcGhzLCBzbyB5b3UgY2FuIAo+
IGVhc2lseSBjaGVjayB3aGF0J3MgZ29pbmcgb24uIE11bmluIGRyYXdzIGdyYXBocyBmcm9tIGEg
bG90IG9mIAo+IHBhcmFtZXRlcnMgb2YgYSBzeXN0ZW0sIGFuZCBoZWxwZWQgbWUgZmluZCBwcm9i
bGVtcyB0aGF0IHlvdSBjb3VsZG4ndCAKPiBmaW5kIG90aGVyd2lzZS4KCkZvciBYRlMgc3BlY2lm
aWMgc3RhdHMsIFBDUCBpcyB5b3VyIGZyaWVuZC4gSXQga25vd3MgYWxsIGFib3V0IHRoZQpzdGF0
cyBpbiAvcHJvYy9mcy94ZnMvc3RhdHMgYXMgd2VsbCBhcyBtb3N0IHN5c3RlbSBsZXZlbCBzdGF0
cyB0aGF0Cm90aGVyIHRvb2zRlSBhbHNvIGNvbGxlY3QgYW5kIGRpc3BsYXkuLi4KCkNoZWVycywK
CkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNA
b3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
