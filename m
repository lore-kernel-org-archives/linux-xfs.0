Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6H3Xh7X040680 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 22:33:44 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id kj2o37NfiUEINENA
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Jul 2012 20:33:42 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so85967pbb.26
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 20:33:42 -0700 (PDT)
Subject: Re: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
Mime-Version: 1.0 (Apple Message framework v1084)
From: Chen Baozi <baozich@gmail.com>
In-Reply-To: <20120716151038.GI29979@sgi.com>
Date: Tue, 17 Jul 2012 11:33:33 +0800
Message-Id: <5292013E-6FF3-47F6-BE9F-FD7BA2BB2AA9@gmail.com>
References: <1342208293-3405-1-git-send-email-baozich@gmail.com>
	<20120716151038.GI29979@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

SGkgQmVuLApPbiBKdWwgMTYsIDIwMTIsIGF0IDExOjEwIFBNLCBCZW4gTXllcnMgd3JvdGU6Cgo+
IEhleSBDaGVuLAo+IAo+IE9uIFNhdCwgSnVsIDE0LCAyMDEyIGF0IDAzOjM4OjEzQU0gKzA4MDAs
IENoZW4gQmFvemkgd3JvdGU6Cj4+IEZpeCB0cml2aWFsIHR5cG8gZXJyb3IgdGhhdCBoYXMgd3Jp
dHRlbiAiSXQiIHRvICJJcyIuCj4+IAo+PiBTaWduZWQtb2ZmLWJ5OiBDaGVuIEJhb3ppIDxiYW96
aWNoQGdtYWlsLmNvbT4KPiAKPiBSZXZpZXdlZC1ieTogQmVuIE15ZXJzIDxicG1Ac2dpLmNvbT4K
PiAKPiBUaGFua3MgZm9yIHRoZSBwYXRjaCEgIEknbSBoYXBweSB5b3UncmUgd29ya2luZyBvbiBY
RlMuICBEbyB5b3UgaGF2ZSBhbnkKPiB0aW1lL2ludGVyZXN0IGluIHRha2luZyBvbiBhIHdvcmsg
aXRlbSBvciB0d28/ICBJIGhhdmUgYSBmZXcgd291bGQtYmUtbmljZXMKPiB3aGljaCBJJ3ZlIG1h
ZGUgbm90ZXMgb2YsIGFuZCBJJ20gc3VyZSB0aGF0IERhdmUgb3IgQ2hyaXN0b3BoIGNvdWxkIGFs
c28gdGhpbmsKPiBvZiBhIGZldyBpZiB5b3UncmUgaW50ZXJlc3RlZC4KSSdkIHJlYWxseSBsb3Zl
IHRvLiBSaWdodCBub3csIEkgYW0gd29ya2luZyBvbiBzeXNsaW51eCB0byBzdXBwb3J0IGJvb3Rp
bmcgb24geGZzIHBhcnRpdGlvbiAodW5kZXIgcGNhY2pyJ3MgbWVudG9yaW5nKe+8jCB3aGljaCBJ
IHRob3VnaHQgd291bGQgYmUgYSBuaWNlIHN0YXJ0IHRvIGdldCBmYW1pbGlhciB3aXRoIHhmcyAo
YW5kIEkgZGlkIGxlYXJuIGEgbG90IGZyb20gaXQpLiBTbyBJIHRoaW5rIHRoZXJlIHdvdWxkIGJl
IG1vcmUgdGltZSAoYW5kIGV4cGVyaWVuY2Ugb24geGZzKSBhZnRlciBJIGZpbmlzaCB0aGUgeGZz
IHN1cHBvcnQgb24gc3lzbGludXguIEFuZCBJJ20gcmVhbGx5IGxvb2tpbmcgZm9yd2FyZCB0byB5
b3VyIGlkZWFzLiBTbyBkbyBwbGVhc2UgdGVsbCBtZSB3aGF0IEkgY2FuIGhlbHAsIEknbGwgdHJ5
IG15IGJlc3QgdG8gZG8gaXQuIAoKVGhhbmtzIGEgbG90LgoKQmFvemkKPiAKPiBUaGFua3MgYWdh
aW4sCj4gLUJlbgo+IAo+PiAtLS0KPj4gZnMveGZzL3hmc19kYV9idHJlZS5oIHwgICAgMiArLQo+
PiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKPj4gCj4+
IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2RhX2J0cmVlLmggYi9mcy94ZnMveGZzX2RhX2J0cmVl
LmgKPj4gaW5kZXggZGJmN2MwNy4uYmUzMGJkNCAxMDA2NDQKPj4gLS0tIGEvZnMveGZzL3hmc19k
YV9idHJlZS5oCj4+ICsrKyBiL2ZzL3hmcy94ZnNfZGFfYnRyZWUuaAo+PiBAQCAtMzIsNyArMzIs
NyBAQCBzdHJ1Y3Qgem9uZTsKPj4gLyoKPj4gICogVGhpcyBzdHJ1Y3R1cmUgaXMgY29tbW9uIHRv
IGJvdGggbGVhZiBub2RlcyBhbmQgbm9uLWxlYWYgbm9kZXMgaW4gdGhlIEJ0cmVlLgo+PiAgKgo+
PiAtICogSXMgaXMgdXNlZCB0byBtYW5hZ2UgYSBkb3VibHkgbGlua2VkIGxpc3Qgb2YgYWxsIGJs
b2NrcyBhdCB0aGUgc2FtZQo+PiArICogSXQgaXMgdXNlZCB0byBtYW5hZ2UgYSBkb3VibHkgbGlu
a2VkIGxpc3Qgb2YgYWxsIGJsb2NrcyBhdCB0aGUgc2FtZQo+PiAgKiBsZXZlbCBpbiB0aGUgQnRy
ZWUsIGFuZCB0byBpZGVudGlmeSB3aGljaCB0eXBlIG9mIGJsb2NrIHRoaXMgaXMuCj4+ICAqLwo+
PiAjZGVmaW5lIFhGU19EQV9OT0RFX01BR0lDCTB4ZmViZQkvKiBtYWdpYyBudW1iZXI6IG5vbi1s
ZWFmIGJsb2NrcyAqLwo+PiAtLSAKPj4gMS43LjEKPj4gCj4+IF9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCj4+IHhmcyBtYWlsaW5nIGxpc3QKPj4geGZzQG9z
cy5zZ2kuY29tCj4+IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
