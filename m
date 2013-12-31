Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C3DB7F3F
	for <xfs@oss.sgi.com>; Tue, 31 Dec 2013 03:51:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C9A9304053
	for <xfs@oss.sgi.com>; Tue, 31 Dec 2013 01:51:43 -0800 (PST)
Message-ID: <52C293A5.1000606@oracle.com>
Date: Tue, 31 Dec 2013 17:51:33 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/10] xfs: xfs_bulkstat_single consolidation
References: <52BEB3E7.2080706@oracle.com> <52C1BCE5.1070707@sgi.com>
In-Reply-To: <52C1BCE5.1070707@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gMjAxM+W5tDEy5pyIMzHml6UgMDI6MzUsIE1hcmsgVGluZ3VlbHkgd3JvdGU6Cj4gT24gMTIv
MjgvMTMgMDU6MjAsIEplZmYgTGl1IHdyb3RlOgo+PiBGcm9tOiBKaWUgTGl1PGplZmYubGl1QG9y
YWNsZS5jb20+Cj4+Cj4+IEluIHhmc19idWxrc3RhdF9zaW5nbGUoKSwgeGZzX2J1bGtzdGF0X29u
ZSgpIGFuZCB4ZnNfYnVsa3N0YXQoKSBtaWdodAo+PiByZXR1cm4gZGlmZmVyZW50IGVycm9yIGlm
IGVpdGhlciBjYWxsIGZhaWxlZCwgd2UnZCBiZXR0ZXIgcmV0dXJuIHRoZQo+PiBwcm9wZXIgZXJy
b3IgaW4gdGhpcyBjYXNlLiAgTW9yZW92ZXIsIHRoZSBmdW5jdGlvbiBhcmd1bWVudCBkb25lIGlz
Cj4+IHVzZWxlc3MgaW4gdGVybXMgb2YgeGZzX2lvY19idWxrc3RhdCgpLCBoZW5jZSB3ZSBjYW4g
Z2V0IHJpZCBvZiBpdC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogSmllIExpdTxqZWZmLmxpdUBvcmFj
bGUuY29tPgo+PiAtLS0KPiAKPiBZZXMsIEkga25vdyBkbWFwaSBpcyBub3QgbG92ZWQgaGVyZSBi
dXQgU0dJIHN0aWxsIHVzZXMgaXQgYW5kIGl0IHdhbnRzCj4gdGhlIGRvbmUgZmxhZyBzdGlsbC4u
Ck15IG1pc3Rha2UuICBBdCB0aGF0IHRpbWUsIEkgbm90aWNlZCB0aGF0IHRoZXJlIGhhcyBjb21t
ZW50cyBhYm91dCB0aGlzCmluIHhmc19pb2NfYnVsa3N0YXQoKSwgaS5lLAoKIC8qIGRvbmUgPSAx
IGlmIHRoZXJlIGFyZSBtb3JlIHN0YXRzIHRvIGdldCBhbmQgaWYgYnVsa3N0YXQgKi8KIC8qIHNo
b3VsZCBiZSBjYWxsZWQgYWdhaW4gKHVudXNlZCBoZXJlLCBidXQgdXNlZCBpbiBkbWFwaSkgKi8K
Ckhvd2V2ZXIsIEkgZmFpbGVkIHRvIGZpbmQgb3V0IHdoeSBpdCB3b3VsZCBiZSBjYWxsZWQgYnkg
Z29pbmcgdGhyb3VnaAp0aGUgZG1hcGkgc291cmNlIGNvZGUuLi4KCkknbGwga2VlcCB0aGlzIGFy
Z3VtZW50IGluIG5leHQgcm91bmQgb2YgcG9zdC4KClRoYW5rcywKLUplZmYKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
