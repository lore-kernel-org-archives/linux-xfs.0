Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B746D7CA0
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 14:33:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3AFA0AC004
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 12:33:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id f50kaPUjmdfhobhd for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2016 12:33:11 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E7285142F
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 14:33:10 -0500 (CDT)
Subject: Re: about the xfs performance
References: <CAG=-QKovDGUdLXv9AekeK1o4Dd_bwWNfTTTEcq3VoszBgbmXeQ@mail.gmail.com>
	<20160411181001.2760439b@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <570BFBF6.8020403@sandeen.net>
Date: Mon, 11 Apr 2016 14:33:10 -0500
MIME-Version: 1.0
In-Reply-To: <20160411181001.2760439b@harpe.intellique.com>
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
To: xfs@oss.sgi.com

CgpPbiA0LzExLzE2IDExOjEwIEFNLCBFbW1hbnVlbCBGbG9yYWMgd3JvdGU6Cj4gTGUgTW9uLCAx
MSBBcHIgMjAxNiAyMjoxNDowNiArMDgwMAo+IFNvbmdibyBXYW5nIDxoYWNrLmNvb0BnbWFpbC5j
b20+IMOpY3JpdmFpdDoKPiAKPj4gICAgICBta2ZzOiBta2ZzLnhmcyAvZGV2L2hpb2EyIC1mIC1u
IHNpemU9NjRrIC1pIHNpemU9NTEyIC1kCj4+IGFnY291bnQ9NDAgLWwgc2l6ZT0xMDI0bS4KPj4g
ICAgICBtb3VudDogbW91bnQgL2Rldi9oaW9hMiAvbW50LyAgLXQgeGZzIC1vCj4+IHJ3LG5vZXhl
Yyxub2Rldixub2F0aW1lLG5vZGlyYXRpbWUsbm9iYXJyaWVyLGRpc2NhcmQsaW5vZGU2NCxsb2di
c2l6ZT0yNTZrLGRlbGF5bG9nCj4+IEkgdXNlIHRoZSBmb2xsb3dpbmcgY29tbWFuZCB0byB0ZXN0
IGlvcHM6IGZpbyAtaW9lbmdpbmU9bGliYWlvIC1icz00awo+PiAtZGlyZWN0PTEgLXRocmVhZCAt
cnc9cmFuZHdyaXRlIC1zaXplPTUwRyAtZmlsZW5hbWU9L21udC90ZXN0Cj4+IC1uYW1lPSJFQlMg
NEtCIHJhbmR3cml0ZSB0ZXN0IiAtaW9kZXB0aD02NCAtcnVudGltZT02MAo+PiBUaGUgcmVzdWx0
cyBpcyBub3JtYWwgYXQgdGhlIGJlZ2lubmluZyB3aGljaCBpcyBhYm91dCAyMTBrwrHvvIxidXQg
c29tZQo+PiBzZWNvbmRzIGxhdGVyLCB0aGUgcmVzdWx0cyBkb3duIHRvIDE5a8KxLgo+IAo+IFlv
dSBzaG91bGQgZmlyc3QgdHJ5IGRlZmF1bHQgbWtmcyBzZXR0aW5ncywgd2l0aCBkZWZhdWx0IG1v
dW50IG9wdGlvbnMuCgpBZ3JlZWQuICBXaGVyZSBkaWQgdGhhdCBzZXQgb2Ygb3B0aW9ucyBjb21l
IGZyb20sIGluIGFueSBjYXNlPwoKLUVyaWMKCj4gTm9ybWFsbHkgbWtmcy54ZnMgc2hvdWxkIGlu
aXRpYXRlIGEgVFJJTSBvbiB0aGUgU1NELCB0aGVyZWZvcmUKPiBwZXJmb3JtYW5jZSBzaG91bGQg
cmVtYWluIHByZWRpY3RhYmxlLgo+IAo+IFdoYXQgbW9kZWwgb2YgU1NEIGNhcmQgYXJlIHlvdSB1
c2luZz8gV2l0aCBhbiBIR1NUIE5WTWUgU04xeDAgSSd2ZSBnb3QKPiB2ZXJ5IGNvbnNpc3RlbnQg
cmVzdWx0cyAobm8gZGVncmFkYXRpb24gd2l0aCB0aW1lKS4KPiAKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5z
Z2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
