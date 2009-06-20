Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KIH02o130821 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 13:17:01 -0500
Received: from mail-bw0-f226.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0593512A84D7
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 11:17:26 -0700 (PDT)
Received: from mail-bw0-f226.google.com (mail-bw0-f226.google.com
	[209.85.218.226]) by cuda.sgi.com with ESMTP id
	lUM0YcC9IUBmnFa7 for <xfs@oss.sgi.com>;
	Sat, 20 Jun 2009 11:17:26 -0700 (PDT)
Received: by bwz26 with SMTP id 26so2168515bwz.20
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 11:17:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090620180116.GD3984@infradead.org>
References: <941396568.292261245481145500.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<961884583.292281245481464174.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090620180116.GD3984@infradead.org>
Date: Sat, 20 Jun 2009 22:17:25 +0400
Message-ID: <a4423d670906201117w4fd43662j58fdbea89d668941@mail.gmail.com>
Subject: Re: 2.6.30-06725: xfs_fsr: Assertion failed: ip->i_delayed_blks == 0,
	file: fs/xfs/xfs_bmap.c, line: 5991
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, xfs@oss.sgi.com

MjAwOS82LzIwIENocmlzdG9waCBIZWxsd2lnIDxoY2hAaW5mcmFkZWFkLm9yZz46Cj4gT24gU2F0
LCBKdW4gMjAsIDIwMDkgYXQgMDM6MDQ6MjRBTSAtMDQwMCwgTGFjaGxhbiBNY0lscm95IHdyb3Rl
Ogo+PiBIaSBBbGV4YW5kZXIsCj4+Cj4+IEkndmUgc2VlbiB0aGlzIGFzc2VydGlvbiBiZWZvcmUg
YW5kIGlmIGl0J3MgdGhlIHByb2JsZW0gSSB0aGluayBpdAo+PiBpcyB0aGVuIGl0IHNob3VsZCBi
ZSBmaXhlZCB3aXRoIHRoaXMgcGF0Y2g6Cj4+Cj4+IGh0dHA6Ly9vc3Muc2dpLmNvbS9hcmNoaXZl
cy94ZnMvMjAwOS0wMi9tc2cwMDE3Ni5odG1sCj4+Cj4+IEl0IHNob3VsZG4ndCBiZSBkaWZmaWN1
bHQgdG8gdGVzdCB0aGlzIHRvbyAtIElmIHlvdSBydW4gYWJvdXQgMTAyNAo+PiBkZCB3cml0ZXJz
IHRvIHNlcGFyYXRlIDEwME1CIGZpbGVzIGFuZCB0aGVuIHJ1biB4ZnNfYm1hcCBvbiBlYWNoCj4+
IGZpbGUgYWZ0ZXJ3YXJkcyBpdCBzaG91bGQgYXNzZXJ0Lgo+Cj4gVGhhcyBpcyBpbiBhIGZpbGVz
eXN0ZW0gbm90IGJpZyBlbm91Z2ggdG8gYWN0dWFsbHkgZml0IHRob3NlIGZpbGVzLAo+IHJpZ2h0
PyDCoE1pZ2h0IGJlIHdvcnRoIGFkZGluZyBhIHRlc3RjYXNlIGxpa2UgdGhpcy4uCj4KPiBBbGV4
LCBjYW4geW91IGdpdmUgdGhhdCBwYXRjaCBhIHRyeT8KClllcywgSSBoYXZlIGFwcGxpZWQgYW5k
IHRlc3RpbmcgaXQgbm93LgpJIHdpbGwgbGV0IHlvdSBrbm93LgpUaGFua3MuCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
