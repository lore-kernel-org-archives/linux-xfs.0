Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB43F7F37
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 02:51:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 664E7AC002
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 00:51:15 -0800 (PST)
Received: from mail-ob0-f179.google.com (mail-ob0-f179.google.com
	[209.85.214.179]) by cuda.sgi.com with ESMTP id
	u1dnxCokB6YsfZBa (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 00:51:10 -0800 (PST)
Received: by mail-ob0-f179.google.com with SMTP id wp4so22875899obc.10
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 00:51:10 -0800 (PST)
MIME-Version: 1.0
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Fri, 20 Feb 2015 09:50:50 +0100
Message-ID: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Subject: Documenting MS_LAZYTIME
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

SGVsbG8gVGVkLAoKQmFzZWQgb24geW91ciBjb21taXQgbWVzc2FnZSAwYWU0NWY2M2Q0ZSwgSSBJ
IHdyb3RlIHRoZSBkb2N1bWVudGF0aW9uCmJlbG93IGZvciBNU19MQVpZVElNRSwgdG8gZ28gaW50
byB0aGUgbW91bnQoMikgbWFuIHBhZ2UuIENvdWxkIHlvdQpwbGVhc2UgY2hlY2sgaXQgb3ZlciBh
bmQgbGV0IG1lIGtub3cgaWYgaXQncyBhY2N1cmF0ZS4gSW4gcGFydGljdWxhciwKSSBhZGRlZCBw
aWVjZXMgbWFya2VkIHdpdGggIioiIGJlbG93IHRoYXQgd2VyZSBub3QgcGFydCBvZiB0aGUgY29t
bWl0Cm1lc3NhZ2UgYW5kIEknZCBsaWtlIGNvbmZpcm1hdGlvbiB0aGF0IHRoZXkncmUgYWNjdXJh
dGUuCgpUaGFua3MsCgpNaWNoYWVsCgpbWwogICAgICAgTVNfTEFaWVRJTUUgKHNpbmNlIExpbnV4
IDMuMjApCiAgICAgICAgICAgICAgT25seSAgdXBkYXRlICBmaWxldGltZXMgKGF0aW1lLCBtdGlt
ZSwgY3RpbWUpIG9uIHRoZSBpbi0KICAgICAgICAgICAgICBtZW1vcnkgdmVyc2lvbiBvZiB0aGUg
ZmlsZSAgaW5vZGUuICAgVGhlICBvbi1kaXNrICB0aW1l4oCQCiAgICAgICAgICAgICAgc3RhbXBz
IGFyZSB1cGRhdGVkIG9ubHkgd2hlbjoKCiAgICAgICAgICAgICAgKGEpICB0aGUgaW5vZGUgbmVl
ZHMgdG8gYmUgdXBkYXRlZCBmb3Igc29tZSBjaGFuZ2UgdW5yZeKAkAogICAgICAgICAgICAgICAg
ICAgbGF0ZWQgdG8gZmlsZSB0aW1lc3RhbXBzOwoKICAgICAgICAgICAgICAoYikgIHRoZSBhcHBs
aWNhdGlvbiAgZW1wbG95cyAgZnN5bmMoMiksICBzeW5jZnMoMiksICBvcgogICAgICAgICAgICAg
ICAgICAgc3luYygyKTsKCiAgICAgICAgICAgICAgKGMpICBhbiB1bmRlbGV0ZWQgaW5vZGUgaXMg
ZXZpY3RlZCBmcm9tIG1lbW9yeTsgb3IKCiogICAgICAgICAgICAgKGQpICBtb3JlIHRoYW4gMjQg
aG91cnMgaGF2ZSBwYXNzZWQgc2luY2UgdGhlIGktbm9kZSB3YXMKKiAgICAgICAgICAgICAgICAg
IHdyaXR0ZW4gdG8gZGlzay4KCiAgICAgICAgICAgICAgVGhpcyBtb3VudCBvcHRpb24gc2lnbmlm
aWNhbnRseSByZWR1Y2VzICB3cml0ZXMgIHRvICB0aGUKICAgICAgICAgICAgICBpbm9kZSAgdGFi
bGUgIGZvciB3b3JrbG9hZHMgdGhhdCBwZXJmb3JtIGZyZXF1ZW50IHJhbmRvbQogICAgICAgICAg
ICAgIHdyaXRlcyB0byBwcmVhbGxvY2F0ZWQgZmlsZXMuCgoqICAgICAgICAgICAgIEFzIGF0IExp
bnV4IDMuMjAsIHRoaXMgb3B0aW9uIGlzIHN1cHBvcnRlZCBvbmx5IG9uIGV4dDQuCl1dCgotLSAK
TWljaGFlbCBLZXJyaXNrIExpbnV4IG1hbi1wYWdlcyBtYWludGFpbmVyOwpodHRwOi8vd3d3Lmtl
cm5lbC5vcmcvZG9jL21hbi1wYWdlcy8KQXV0aG9yIG9mICJUaGUgTGludXggUHJvZ3JhbW1pbmcg
SW50ZXJmYWNlIiwgaHR0cDovL2Jsb2cubWFuNy5vcmcvCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
