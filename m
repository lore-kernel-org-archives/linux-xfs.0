Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27D9F29DF8
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 19:54:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4BA58F8040
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 17:54:37 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0Dx1iyp5B5AFhjKe for <xfs@oss.sgi.com>;
	Tue, 14 Jan 2014 17:54:36 -0800 (PST)
Date: Wed, 15 Jan 2014 12:53:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Message-ID: <20140115015350.GR3469@dastard>
References: <52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
	<20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
	<20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
	<20140114022414.GM3469@dastard>
	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
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
To: Zachary Kotlarek <zach@kotlarek.com>
Cc: xfs@oss.sgi.com

T24gTW9uLCBKYW4gMTMsIDIwMTQgYXQgMDc6MTI6MDdQTSAtMDgwMCwgWmFjaGFyeSBLb3RsYXJl
ayB3cm90ZToKPiAKPiBPbiBKYW4gMTMsIDIwMTQsIGF0IDY6MjQgUE0sIERhdmUgQ2hpbm5lciA8
ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gCj4gPj4gR290IG9uZS4gYnVbOV0gaXMgdGhl
IGZpbGUgdGhhdCBkb2VzbuKAmXQgd29yazoKPiA+IC4uLi4uCj4gPj4gYnVbOV0uaW51bWJlciA9
IDY4NzE5NDc4ODE0Cj4gPj4gYnVbOV0ubmFtZWxlbiA9IDI2Cj4gPj4gYnVbOV0ubmFtZSA9ICIw
NyAtIFNlXDMwM1wyNjFvciBNYWNobyBTb2xvLm00diIKPiA+PiBidVs5XS50YWcgPSAweDEzMAo+
ID4gCj4gPiBUaGF0IGxvb2tzIGNvbXBsZXRlbHkgdmFsaWQuIEl0J3MgYSB1dGYtOCBlbmNvZGVk
IGRpcmVjdG9yeSBlbnRyeS4KPiA+IEl0IGRvZXNuJ3QgbG9vayBsaWtlIHRoZXJlJ3MgYW55IGNv
cnJ1cHRpb24gb24gZGlzayBoZXJlLgo+ID4gCj4gPiBUaGUgbHMgLWwgb3V0cHV0IGZ1bGwgb2Yg
Pz8/PyB1c3VhbGx5IG1lYW5zIHRoZSBzdGF0IG9mIHRoZSBpbm9kZQo+ID4gdGhlIGRpcmVudCBw
b2ludGVkIHRvLCBzbyB0aGF0IGltcGxpZXMgdGhhdCB0aGUgc3RhdCBoYXMgZmFpbGVkLgo+ID4g
U28sIHdoYXQgZG9lcyBhbmQgc3RyYWNlIG9mIHRoZSAnbHMgLWwnIG9mIHRoYXQgZGlyZWN0b3J5
IHRlbGwgeW91Cj4gPiBhYm91dCB0aGUgZGlyZWN0b3J5IGVudHJ5IHRoYXQgaXMgcmV0dXJuZWQg
dG8gdXNlcnNwYWNlPwo+IAo+IEl0IGp1c3QgcmV0dXJucyBFTk9FTlQ6Cj4gc3RhdCgiL21udC9t
ZWRpYS9UVi8zMCBSb2NrL1NlYXNvbiAzLzA3IC0gU2XDsW9yIE1hY2hvIFNvbG8ubTR2IiwgMHgx
NTk5MGYwKSA9IC0xIEVOT0VOVCAoTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeSkKPiBsc3RhdCgi
L21udC9tZWRpYS9UVi8zMCBSb2NrL1NlYXNvbiAzLzA3IC0gU2XDsW9yIE1hY2hvIFNvbG8ubTR2
IiwgMHgxNTk5MGYwKSA9IC0xIEVOT0VOVCAoTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeSkKCk9r
LCBzbyBpdCdzIGEgbG9va3VwIGZhaWx1cmUuCgo+ID4+IGJsZWFmWzVdLmhhc2h2YWwgPSAweDE2
ZDA3MDc0Cj4gPj4gYmxlYWZbNV0uYWRkcmVzcyA9IDB4MjYKPiA+IAo+ID4gVGhhdCdzIHRoZSBo
YXNoIGVudHJ5IGluIHRoZSBkaXJlY3RvcnkgZm9yIHRoZSBuYW1lLiBUaGF0IG1heSBiZQo+ID4g
d3JvbmcsIEkgZ3Vlc3MuIGNhbiB5b3UgY3JlYXRlIGFub3RoZXIgZmlsZSB3aXRoIHRoZSBzYW1l
IG5hbWUKPiA+IGluIGEgZGlmZmVyZW50IGRpcmVjdG9yeSBzbyB3ZSBjYW4gY2hlY2sgdGhhdCB0
aGUgaGFzaCBpcyBjb3JyZWN0Pwo+IAo+IGJ1WzE2XS5pbnVtYmVyID0gOTI1NTcxNjg4OAo+IGJ1
WzE2XS5uYW1lbGVuID0gMjYKPiBidVsxNl0ubmFtZSA9ICIwNyAtIFNlXDMwM1wyNjFvciBNYWNo
byBTb2xvLm00diIKPiBidVsxNl0udGFnID0gMHgxZDgKPiAKPiBJIGRvbuKAmXQgdW5kZXJzdGFu
ZCBob3cgdG8gZmluZCB0aGUgcmlnaHQgYmxlYWYsIGJ1dCAweDE2ZDA3MDc0IGRvZXNu4oCZdCBh
cHBlYXIgaW4gYW55IG9mIHRoZSBoYXNodmFscyBmb3IgdGhhdCBkaXJlY3Rvcnk6CgpQcmV0dHkg
c2ltcGxlIC0gdGhlIGxlYWZbXS5hZGRyZXNzIGlzIHNpbXBseSBhIGNvbXByZXNzZWQgb2Zmc2V0
CmludG8gdGhlIGxlYWYuIGFsbCBkaXJlbnRzIGFyZSA4IGJ5dGUgYWxpZ25lZCwgYW5kIHRoZSB0
YWcgaXMgdGhlCmJ5dGUgb2Zmc2V0IGludG8gdGhlIGxlYWYgZGlyZW50IHNwYWNlLiBIZW5jZToK
CglsZWFmW10uYWRkcmVzcyA9IGJ1WzE2XS50YWcgPj4gMwoJCQk9IDB4MWQ4ID4+IDMKCQkJPSAw
eDNiCgkJCT0gYmxlYWZbM10uYWRkcmVzcwoKPiBibGVhZlszXS5oYXNodmFsID0gMHgxNmQwNzA3
Ywo+IGJsZWFmWzNdLmFkZHJlc3MgPSAweDNiCgpBbmQgdGhlcmUgd2VyZSBhcmUgLSB0aGVyZSdz
IGEgc2luZ2xlIGJpdCBkaXNjcmVwYW5jeSBpbiB0aGUgbG93ZXIKYnl0ZSBvZiB0aGUgaGFzaC4g
VGhhdCB0ZW5kcyB0byBpbXBseSB3ZSBoYXZlIGEgYnVnIGluIHhmc19yZXBhaXIuCgpXaGF0IHZl
cnNpb24gb2YgeGZzX3JlcGFpciBkaWQgeW91IHVzZT8gKHhmc19yZXBhaXIgLVYpCgpDaGVlcnMs
CgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
