Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q43Kg0tK199827 for <xfs@oss.sgi.com>; Thu, 3 May 2012 15:42:00 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id ekUE48ZybBkJdfSC for
	<xfs@oss.sgi.com>; Thu, 03 May 2012 13:41:58 -0700 (PDT)
Date: Thu, 3 May 2012 21:41:57 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Storage server, hung tasks and tracebacks
Message-ID: <20120503204157.GC4387@nsrc.org>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA27EF8.6040002@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

T24gVGh1LCBNYXkgMDMsIDIwMTIgYXQgMDc6NTA6MDBBTSAtMDUwMCwgU3RhbiBIb2VwcG5lciB3
cm90ZToKPiA+IEFueSBvdGhlciBzdWdnZXN0aW9ucyAoYW5kIG9mIGNvdXJzZSBpbnRlcnByZXRh
dGlvbiBvZiB0aGUga2VybmVsIGNhbGwKPiA+IHRyYWNlYmFja3MpIHdvdWxkIGJlIG11Y2ggYXBw
cmVjaWF0ZWQuCj4gCj4gV2hpY2ggbWFpbmJvYXJkcyBhcmUgdGhlc2UgQnJpYW4/ICBNYWtlL21v
ZGVsPwoKVHlhbiBTNTUxMCwgd2l0aCBJbnRlbCBYZW9uIENQVSBFMzEyMjUgQCAzLjEwR0h6CgpV
cGdyYWRlZCB0byBCSU9TIDEuMDVhIGFuZCBpS1ZNIDMuMDAKCj4gTWFrZS9tb2RlbC9jb3VudCBv
ZiBhbGwgYWRkIGluIGNhcmRzPwoKMSB4IExTSSBTQVM5MjAx4oCTMTZpCjEgeCBMU0kgU0FTOTIx
MTjigJM4aQoxIHggSW50ZWwgWDUyMC1EQTIgZHVhbCAxMEcgTklDCgphbHRob3VnaCB0aGUgMTBH
IGxpbmsgd2Fzbid0IGJlaW5nIHVzZWQgZm9yIHRoZSBtb3N0IHJlY2VudCB0ZXN0cy4KCj4gTWFr
ZS9tb2RlbCBvZiBQU1U/CgpXaWxsIGhhdmUgdG8gY2hlY2ssIEkgdGhpbmsgaXQgbWF5IGJlIHRo
aXMgb25lOgpodHRwOi8vd3d3LnhjYXNlLmNvLnVrL1hDQVNFLVBvd2VyLVN1cHBseS1wL3BzdS1k
b2xwaGluLTkwMC4uaHRtCgo+IE1ha2UgbW9kZWwgb2YgY2hhc3Npcz8KCmh0dHA6Ly93d3cueGNh
c2UuY28udWsvMjQtYmF5LUhvdHN3YXAtcmFja21vdW50LWNoYXNzaXMtbm9yY28tUlBDLTQyMjQt
cC9jYXNlLXhjYXNlLXJtNDI0Lmh0bQoKVGhlIGRyaXZlcyBhcmUgMjQgeCBTVDMwMDBETTAwMSAo
SSB3YXMgaG9waW5nIHRvIGdldCBsb3ctcG93ZXIgSGl0YWNoaQpkcml2ZXMgYnV0IHRoZXkgd2Vy
ZW4ndCBhdmFpbGFibGUgYXQgdGhlIHRpbWUpCgo+IEknbGwgc2xldXRoIGFyb3VuZCBhbmQgc2Vl
IHdoYXQgSSBjYW4gZmluZC4gIENvdWxkIGJlIHNvbWUgb2JzY3VyZQo+IGV4cGFuc2lvbiBjYXJk
IGludGVyYWN0aW9uLiAgQ291bGQgYmUgdW5kZXJzaXplZCBQU1VzIG9yIGxhY2sgb2YKPiBiYWNr
cGxhbmVzIHNwcmVhZCBldmVubHkgYWNyb3NzIHRoZSAxMnYgcmFpbHMgb2YgYSBtdWx0aS1yYWls
IFBTVSwgZXRjLCBldGMuCgpNdWNoIGFwcHJlY2lhdGVkLgoKSG93ZXZlciwgbGFzdCBuaWdodCBJ
IHJlYm9vdGVkIG9uZSBib3ggKHRoZSBvbmUgd2hpY2ggd291bGRuJ3QgbGV0IG1lIHNzaAppbikg
dGhlbiB1cGdyYWRlZCBpdCB0byB1YnVudHUgMTIuMDQuICBJdCBoYXMgYmVlbiBydW5uaW5nIGEg
Y291cGxlIG9mCmNvbmN1cnJlbnQgYm9ubmllKysgaW5zdGFuY2VzIGZvciBvdmVyIDI0IGhvdXJz
IHdpdGhvdXQgYSBoaXRjaC4KClNvIG1heWJlIGl0J3MgdGhlIG1wdDJzYXMgZHJpdmVyIHdoaWNo
IGlzIHRoZSBkaWZmZXJlbmNlOgoKW2RtZXNnIGZyb20gVWJ1bnR1IDExLjEwXQogICAgbXB0MnNh
cyB2ZXJzaW9uIDA4LjEwMC4wMC4wMgoKW2RtZXNnIGZyb20gVWJ1bnR1IDEyLjA0XQogICAgbXB0
MnNhcyB2ZXJzaW9uIDEwLjEwMC4wMC4wMAoKUmVnYXJkcywKCkJyaWFuLgoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNA
b3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
