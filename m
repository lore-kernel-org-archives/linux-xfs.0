Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o47A5XAN158090 for <xfs@oss.sgi.com>; Fri, 7 May 2010 05:05:33 -0500
Received: from v007470.home.net.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D2163967BB6
	for <xfs@oss.sgi.com>; Fri,  7 May 2010 03:07:44 -0700 (PDT)
Received: from v007470.home.net.pl (v007470.home.net.pl [212.85.125.104]) by
	cuda.sgi.com with SMTP id EOv2AF69pA5D327A for
	<xfs@oss.sgi.com>; Fri, 07 May 2010 03:07:44 -0700 (PDT)
From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: posix_fallocate
Date: Fri, 7 May 2010 12:07:07 +0200
References: <201005071022.37863.kb@sysmikro.com.pl>
	<4BE3DC2D.3000607@hardwarefreak.com>
In-Reply-To: <4BE3DC2D.3000607@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201005071207.07745.kb@sysmikro.com.pl>
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
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

SGVsbG8gU3RhbiwKCkl0IHNlZW1zIHRoYXQgeW91ciBtYWlsIHNlcnZlciBibG9ja3MgdHJhZmZp
YyBmcm9tICIucGwiIGRvbWFpbnMgc28gZG9uJ3QgYmUgCm9mZmVuZGVkIGlmIHlvdSB3aWxsIG5v
dCBzZWUgbXkgcmVwbHkgc2VudCB0byB5b3VyIGFkZHJlc3MuCgooUmVtb3RlIGhvc3Qgc2FpZDog
NTUwIDUuNy4xIDx2MDA3NDcwLmhvbWUubmV0LnBsWzIxMi44NS4xMjUuMTA0XT46IENsaWVudCAK
aG9zdCByZWplY3RlZDogV2UgZG8gbm90IGFjY2VwdCBtYWlsIGZyb20gLnBsIGRvbWFpbnMpCgpL
cnp5c3p0b2YKCk9uIEZyaWRheSAwNyBNYXkgMjAxMCAxMToyMywgU3RhbiBIb2VwcG5lciB3cm90
ZToKPiBLcnp5c3p0b2YgQsWCYXN6a293c2tpIHB1dCBmb3J0aCBvbiA1LzcvMjAxMCAzOjIyIEFN
Ogo+ID4gSGVsbG8sCj4gPgo+ID4gSSB1c2UgdGhpcyB0byBwcmVhbGxvY2F0ZSBsYXJnZSBzcGFj
ZSBidXQgZm91bmQgYW4gaXNzdWUuIFBvc2l4X2ZhbGxvY2F0ZQo+ID4gd29ya3MgcmlnaHQgd2l0
aCBzaXplcyBsaWtlIDEwMEcsIDFUIGFuZCBldmVuIDEwVCBvbiBzb21lIGJveGVzIChvbiBzb21l
Cj4gPiBvdGhlciBjYW4gZmFpbCBhZnRlciBlLmcuIDdUIHRocmVzaG9sZCkgYnV0IGlmIGkgdHJp
ZWQgZS5nLiAxNlQgdGhlIHVzZXIKPiA+IHNwYWNlIHByb2Nlc3Mgd291bGQgYmUgIlIidW5uaW5n
IGZvcmV2ZXIgYW5kIGl0IGlzIG5vdCBpbnRlcnJ1cHRpYmxlLgo+ID4gRnVydGhlcm1vcmUgc29t
ZSBvdGhlciBub3QgcmVsYXRlZCBwcm9jZXNzZXMgbGlrZSBzc2hkLCBiYXNoIGVudGVyIEQKPiA+
IHN0YXRlLiBUaGVyZSBpcyBub3RoaW5nIGluIGtlcm5lbCBsb2cuCj4gPgo+ID4gSSBtYWRlIHNv
IGZhciBhIGZldyBsb2dzIHdpdGggZnRyYWNlIGZhY2lsaXR5IGZvciAxRywgMTAwRywgMVQgYW5k
IDEwVAo+ID4gc2l6ZXMuIEkgbm90aWNlZCB0aGF0IGZvciAxc3QgdGhyZWUgc2l6ZXMgdGhlIGxv
ZyBpcyBhcyBsb25nIGFzIGFidCAxLjVNCj4gPiAoMk0gcGVhaykgd2hpbGUgMTBUIGdlbmVyYXRl
cyA5NE0gbG9uZyBsb2cuIEkgY291bGRuJ3QgcmV0cmlldmUgYSBsb2cgZm9yCj4gPiAxN1QgY2Fz
ZSBiZWNhdXNlICJjYXQgL3N5cyAuLi4gL3RyYWNlIiBlbnRlcnMgRC4KPiA+Cj4gPiBJIHdvdWxk
IGFwcHJlY2lhdGUgYW55IGhlbHAgYmVjYXVzZSBpIGdhdmUgdXAgd2l0aCBmdHJhY2UgbG9ncyBh
bmFseXNpcy4KPiA+IFRoZSB4ZnNfdm5fZmFsbG9jYXRlIGlzIGNvdmVyZWQgaW4gYWJ0IDExayBs
aW5lcyBmb3IgYSAxLjVNIGxvZyBjYXNlCj4gPiB3aGlsZSB0aGVyZSBhcmUgYWJ0IDE2M2sgbGlu
ZXMgaW4gOTRNIGxvZy4gQW5kIGFsbCBpIGNvdWxkIHNlZSBpcyBwb3NzCj4gPiBzb21lIHJlbGF0
aW9uc2hpcCBiZXR3ZWVuIHRpbWUgc3BlbnQgaW4geGZzX3ZuX2ZhbGxvY2F0ZSBzdWJmdW5jdGlv
bnMgdnMKPiA+IHJlcXVlc3RlZCBzcGFjZS4KPiA+Cj4gPiBCb3ggZGV0YWlsczoKPiA+IDE2IEhp
dGFjaGkgMlRCIGRyaXZlcyAoYmFja3BsYW5lIGNvbm5lY3RlZCksIGRtLCAxIGx2bSBsdW4gb2Yg
MjVUIHNpemUsCj4gPiBrZXJuZWwgMi42LjMxLjUsIG1vcmUgcmVjZW50IGtlcm5lbHMgbmVpdGhl
ciB4ZnMgd2VyZSBub3QgdGVzdGVkLgo+Cj4gMzIgb3IgNjQgYml0IGtlcm5lbD8gIFdoYXQgaXMg
dGhlIHNpemUgb2YgdGhlIFhGUyBmaWxlc3lzdGVtIG9uIHRoZSAyNVRCCj4gTFZNIExVTiBhZ2Fp
bnN0IHdoaWNoIHlvdSdyZSBydW5uaW5nIHBvc2l4X2ZhbGxvY2F0ZT8gIFRoZSByZWFzb24gSSBh
c2sgaXMKPiB0aGF0IFhGUyBoYXMgYSAxNlRCIHBlciBmaWxlc3lzdGVtIGxpbWl0YXRpb24gb24g
MzIgYml0IGtlcm5lbHMuICBJIGNhbgo+IG9ubHkgYXNzdW1lIHRoYXQgeW91ciBYRlMgZmlsZXN5
c3RlbSBpcyBsYXJnZXIgdGhhbiAxNlRCIHNpbmNlIHlvdSdyZQo+IGF0dGVtcHRpbmcgdG8gcG9z
aXhfZmFsbG9jYXRlIDE2VEIuICBCdXQsIGl0J3MgYmVzdCB0byBhc2sgZm9yIGNvbmZpcm1hdGlv
bgo+IHJhdGhlciB0aGFuIGFzc3VtZSwgZXNwZWNpYWxseSBnaXZlbiB0aGF0IHlvdXIgcHJvYmxl
bSBpcyBhcHBlYXJpbmcgbmVhcgo+IHRoYXQgbWFnaWNhbCAxNlRCIGJvdW5kYXJ5LgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
