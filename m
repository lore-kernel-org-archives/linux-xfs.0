Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B63017F4E
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 11:19:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35BD6AC005
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 09:19:08 -0700 (PDT)
Received: from mail-qc0-f193.google.com (mail-qc0-f193.google.com
	[209.85.216.193]) by cuda.sgi.com with ESMTP id
	lTiZk0OVILucQ9lg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 09:19:06 -0700 (PDT)
Received: by mail-qc0-f193.google.com with SMTP id c9so689622qcz.4
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 09:19:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+o=1OUEJimqFngui01JvvS3YjwCOimpWTu+A2MPkYBmq0xgiQ@mail.gmail.com>
References: <CA+o=1OVY0pV18XMKz98dT5LGwE500DQQb5B1wh=HaGTAGuP+oQ@mail.gmail.com>
	<20140809005404.GG26465@dastard>
	<CA+o=1OX+Qq4Scq=su1MDDknRXJGL8F=7WV8P0PCeDjYep7rLnA@mail.gmail.com>
	<CA+o=1OXmM+WsFh-ipS4d8hn6RKvOuv3Zga+66PF4DBehuH-5-A@mail.gmail.com>
	<20140811043219.GJ26465@dastard>
	<CA+o=1OUEJimqFngui01JvvS3YjwCOimpWTu+A2MPkYBmq0xgiQ@mail.gmail.com>
Date: Mon, 11 Aug 2014 18:19:06 +0200
Message-ID: <CA+o=1OWRJEttORNm+=tUd-aFwKbkU5J0Uf9k+cZn_6h8h_XZmg@mail.gmail.com>
Subject: Re: Verifier fixes backported to stable kernels?
From: Fanael Linithien <fanael4@gmail.com>
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
Cc: xfs@oss.sgi.com

PiAyMDE0LTA4LTExIDY6MzIgR01UKzAyOjAwIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0
LmNvbT46Cj4gT2ssIGJ1dCBwbGVhc2UgdXNlIHRoZSAib25lLWxpbmUgZm9ybWF0IiB3aGVuIHF1
b3RpbmcgY29tbWl0cy4KPgo+IEkuZS4gdGhpczoKPgo+ICQgZ2l0IGxvZyAtLW9uZWxpbmUgLW4g
NCBhZDM3MTRiCj4gW+KApl0KPgo+IGlzIG11Y2ggbW9yZSBpbmZvcm1hdGl2ZSB0byB0aGUgcmVh
ZGVyIHdpdGhvdXQgYSBnaXQgdHJlZSB0byBsb29rIHVwCj4gY29tbWl0cy4KCk9rYXksIEknbGwg
dHJ5IHRvIHJlbWVtYmVyLgoKPiBBcyBpdCBpcywgdGhvc2UgY29tbWl0cyBoYXZlIG5vdCB5ZXQg
YmVlbiBzZW50IHRvIExpbnVzLCBoZW5jZSB0aGV5Cj4gd29uJ3QgeWV0IGJlIGFjY2VwdGVkIGJ5
IHRoZSBzdGFibGUga2VybmVsIGZvbGsuIEFuZCBiZWNhdXNlIHRoZXkKPiBoYXZlbid0IGJlZW4g
c2VudCB0byBMaW51cyB5ZXQsIEkgY2FuIHJlZG8gdGhlIGNvbW1pdHMgaW4gdGhhdCB0b3BpYwo+
IGJyYW5jaCB3aXRoIHRoZSBuZWVkZWQgc3RhYmxlIHRhZ3MuIEkndmUgZ290IHRvIGFkZCBhIGNv
dXBsZSBtb3JlCj4gZml4ZXMgdGhhdCBuZWVkIHRvIGdvIHRvIHN0YWJsZSwgdG9vLCBzbyBhIHB1
bGwgcmVxIHdvbid0IGhhcHBlbiBmb3IKPiBhIGNvdXBsZSBvZiBkYXlzIHlldC4uLi4KCk9rYXks
IHNvIEkgcmVhbGx5IG5lZWQgdG8gcGF0Y2ggaXQgbWFudWFsbHkuCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
