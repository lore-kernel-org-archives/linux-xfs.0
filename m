Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD8DA7F55
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 05:17:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 521B5AC004
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 03:17:11 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FGpGHwQqCh93slOk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 Nov 2013 03:17:07 -0800 (PST)
MIME-Version: 1.0
Message-ID: <527F63FC.1050005@oracle.com>
Date: Sun, 10 Nov 2013 02:46:20 -0800 (PST)
From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: Setting project quotas on special files
References: <1384069188.245087.68.camel@storm>
In-Reply-To: <1384069188.245087.68.camel@storm>
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
To: tiziano.mueller@stepping-stone.ch, xfs@oss.sgi.com

Ck9uIDExLzEwIDIwMTMgMTU6MzkgUE0sIFRpemlhbm8gTcO8bGxlciB3cm90ZToKPiBIaSBldmVy
eW9uZQo+Cj4gSXQgc3RhcnRlZCB3aXRoIHRoZSBmb2xsb3dpbmcgZXJyb3I6Cj4KPiAgICBkZXYg
IyBjcCAtYWwgZHZkIGR2ZDIKPiAgICBjcDogY2Fubm90IGNyZWF0ZSBoYXJkIGxpbmsg4oCYZHZk
MuKAmSB0byDigJhkdmTigJk6IEludmFsaWQgY3Jvc3MtZGV2aWNlIGxpbmsKPgo+ICJkdmQiIGlz
IGluIHRoaXMgY2FzZSBhIHN5bWxpbmsgKGJ1dCBJIGFsc28gZGlkIHRoZSB0ZXN0IHdpdGggc3Bl
Y2lhbAo+IGRldmljZXMpLgpUaGlzIGRlZmluaXRlbHkgd291bGQgZmFpbCBpZiB5b3UgdHJ5aW5n
IHRvIGNyZWF0ZSBoYXJkIGxpbmtzIGFjcm9zcwp2b2x1bWVzLgo+Cj4gV2hhdCBJIGRpZCB3YXM6
IGNvcHkgdGhhdCBzeW1saW5rIGZyb20gc29tZXdoZXJlIGVsc2UsIHRyeWluZyB0byB0dXJuIG9u
Cj4gcHJvamVjdCBxdW90YXMgb24gYSBwYXJlbnQgZGlyZWN0b3kgb2YgdGhhdCAiZGV2IiBkaXJl
Y3Rvcnkgd2hpY2ggZ2l2ZXMKPiBtZToKPgo+ICAgeGZzX3F1b3RhOiBza2lwcGluZyBzcGVjaWFs
IGZpbGUgL3Zhci9mb28vZGV2L2R2ZApzeW1saW5rIGZpbGVzIHdpbGwgYmUgc2tpcHBlZCBhbmQg
eGZzX3F1b3RhIGNvbnNpZGVyIGl0IGFzIHNwZWNpYWwgZmlsZQpqdXN0IGxpa2UgZmlmbywgc29j
aywgZXRjLi4uCgpJZiB4ZnNfcXVvdGEgZG8gY2hlY2sgd2l0aCBmb2xsb3cgc3ltbGlua3MsIHRo
ZW4gdGhlIHByb2plY3QgaWQgaXMgcG90ZW50aWFsbHkKYXBwbGllZCB0byBmaWxlcyBvbiBhbm90
aGVyIGZpbGVzeXN0ZW0uIAoKPgo+IFdoZW4gSSBleGFtaW5lIHRoZSBpbm9kZSB1c2luZyB4ZnNf
ZGIgSSBnZXQgZm9yIG15ICJkdmQiIHN5bWxpbms6Cj4KPiAgIGNvcmUucHJvamlkX2xvID0gMAo+
ICAgY29yZS5wcm9qaWRfaGkgPSAwCj4KPiBXaGVuIEkgY3JlYXRlIGEgbmV3IHN5bWxpbmsgImZv
byIgKHdpdGggdGhlIHNhbWUgdWlkK2dpZCBhcyAiZHZkIikgYW5kCj4gZXhhbWluZSBpdCdzIGlu
b2RlIHVzaW5nIHhmc19kYjoKPgo+ICAgY29yZS5wcm9qaWRfbG8gPSAyMzk4Cj4gICBjb3JlLnBy
b2ppZF9oaSA9IDYxCj4KPiBXaGF0IEkgdGhlcmVmb3JlIHNlZW0gdG8gZW5jb3VudGVyIGlzIHRo
ZSBwcm9ibGVtIG1lbnRpb25lZCBpbiB4ZnNfcXVvdGEKPiBmb3IgdGhlIHByb2plY3Qgc3ViY29t
bWFuZDoKPgo+ICAgQW4gYXR0ZW1wdCB0byBjcmVhdGUgYSBoYXJkIGxpbmsgdG8gYSBmaWxlIGlu
IHRoZSB0cmVlIHdpbGwgb25seSBzdWNjZWVkIGlmIHRoZSBwcm9qZWN0IGlkZW50aeKAkAo+ICAg
ICAgICBmaWVyIG1hdGNoZXMgdGhlIHByb2plY3QgaWRlbnRpZmllciBmb3IgdGhlIHRyZWUuCj4K
PiBJIGNvdWxkIG5vdyB1c2UgeGZzX2lvIHRvIGZpeCBhbGwgc3BlY2lhbCBmaWxlcyBvbmNlIChz
aW5jZSBuZXdseQo+IGNyZWF0ZWQgb25lcyB3aWxsIGNhcnJ5IHRoZSBwcm9qZWN0IGlkIGRpcmVj
dGx5KSwgYnV0IHdoeSBkb2VzCj4gInhmc19xdW90YSAteCAtYyAncHJvamVjdCAtcyB0ZXN0MScg
L3ZhciIgc2tpcCBzcGVjaWFsIGZpbGVzIGlmIGl0IGlzCj4gY2xlYXJseSBwb3NzaWJsZSBhbmQg
cmVxdWlyZWQgdG8gc2V0IHRoZSBwcm9qZWN0IGlkIG9uIHRoZW0gdG8gaGF2ZQo+IGhhcmRsaW5r
cyB3b3JraW5nIGFnYWluIHdpdGhpbiB0aGUgcHJvamVjdCBkaXI/ClNvcnJ5IGlmIEkgbWlzdW5k
ZXJzdG9vZCB5b3VyIHF1ZXN0aW9uLCBidXQgdGhlIGV4aXN0aW5nIGhhcmQgbGluayBmaWxlcwp3
b3VsZApub3RiZSBza2lwcGVkIElNTy4gIEZvciB0aGUgcHJvamVjdCBzdWJjb21tYW5kLCBpdCBt
ZWFucyB3ZSBjb3VsZCBub3QgY3JlYXRlCmhhcmRsaW5rcyBjcm9zcyBkaWZmZXJlbnQgcHJvamVj
dCB0cmVlcy4KClRoYW5rcywKLUplZmYKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9v
c3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
