Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6HM54ZK115879 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 17:05:04 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id zZVKP7AmHqc6KPWe for
	<xfs@oss.sgi.com>; Tue, 17 Jul 2012 15:05:02 -0700 (PDT)
Date: Wed, 18 Jul 2012 00:04:45 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs/md filesystem hang on drive pull under IO with 2.6.35.13
Message-ID: <20120718000445.62135e1d@galadriel.home>
In-Reply-To: <5005D661.8030200@dolby.com>
References: <5005D661.8030200@dolby.com>
Mime-Version: 1.0
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
To: Benedict Singer <bzsing@dolby.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

TGUgVHVlLCAxNyBKdWwgMjAxMiAxNDoxNzoyMSAtMDcwMCB2b3VzIMOpY3JpdmllejoKCj4gSXMg
dGhpcyBhIGJ1ZyAoc2VlbXMgbGlrZSBhIHJhY2UgY29uZGl0aW9uIGxlYWRpbmcgdG8gYSBkZWFk
bG9jaz8pLCAKPiBhbmQvb3IgaXMgdGhlcmUgc29tZXRoaW5nIHRvIGNoYW5nZSBpbiB0aGUgd2F5
IHRoZSBzeXN0ZW0gaXMgc2V0IHVwCj4gdG8gbWl0aWdhdGUgb3Igd29ya2Fyb3VuZCB0aGlzPwoK
SXQgZG9lc24ndCByZWFsbHkgaGVscCwgYnV0IGl0IGxvb2tzIHF1aXRlIHNpbWlsYXIgdG8gbXkg
b3duIHByb2JsZW07CnRoZSBmaWxlc3lzdGVtIHRoYXQgYnJva2UgdW5kZXIgbG9hZCAoc2VlIG15
IGxhc3QgbWVzc2FnZXMpIHdhcyBydW5uaW5nCnVuZGVyIDIuNi4zNS4xMyB3aGVuIHRoZSBwcm9i
bGVtIG9jY3VyZWQgYW5kIHdhcyBwcm9iYWJseSB1bmRlcgpzaWduaWZpY2FudCBsb2FkIGF0IHRo
ZSB0aW1lIG9mIHRoZSBjcmFzaC4KClNvIGZhciBpdCBtYXkgYmUgYSBnb29kIGlkZWEgdG8gdXBn
cmFkZSB0byBzb21ldGhpbmcgYmV0dGVyIHRoYW4KMi42LjM1LjEzLgoKLS0gCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQpFbW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAg
ICAgICAgICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFj
QGludGVsbGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAw
MgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
