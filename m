Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92C0F7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 19:42:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55FB2304039
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 17:42:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tEGkOd4MMIhQQaIW for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 17:42:00 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EC292481A
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 19:41:58 -0500 (CDT)
Subject: Re: [PATCH 18/19] mkfs: unit conversions are case insensitive
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-19-git-send-email-jtulak@redhat.com>
	<57057B2A.3000100@sandeen.net>
	<CACj3i736w-nnDzBDOiBf39cJ3AUHqeVL9_Y8EbUgaMa9S7PToA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706FE56.7060308@sandeen.net>
Date: Thu, 7 Apr 2016 19:41:58 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i736w-nnDzBDOiBf39cJ3AUHqeVL9_Y8EbUgaMa9S7PToA@mail.gmail.com>
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

CgpPbiA0LzcvMTYgNTo1MCBBTSwgSmFuIFR1bGFrIHdyb3RlOgo+IE9uIFdlZCwgQXByIDYsIDIw
MTYgYXQgMTE6MTAgUE0sIEVyaWMgU2FuZGVlbiA8c2FuZGVlbkBzYW5kZWVuLm5ldCA8bWFpbHRv
OnNhbmRlZW5Ac2FuZGVlbi5uZXQ+Pndyb3RlOgo+IAo+ICAgICBPbiAzLzI0LzE2IDY6MTUgQU0s
IGp0dWxha0ByZWRoYXQuY29tIDxtYWlsdG86anR1bGFrQHJlZGhhdC5jb20+IHdyb3RlOgo+ICAg
ICA+IEZyb206IEphbiBUdWxhayA8anR1bGFrQHJlZGhhdC5jb20gPG1haWx0bzpqdHVsYWtAcmVk
aGF0LmNvbT4+Cj4gICAgID4KPiAgICAgPiBTb2x2ZXMgdGhlIHF1ZXN0aW9uICJTaG91bGQgSSB1
c2UgMTBnIG9yIDEwRz8iCj4gCj4gICAgIE1pZ2h0IGJlIG5pY2VyIHRvIGRvIGl0IGxpa2UgdGhl
IGN2dG51bSBpbiBsaWJ4Y21kOgo+IAo+ICAgICAgICAgICAgIGMgPSB0b2xvd2VyKCpzcCk7Cj4g
ICAgICAgICAgICAgc3dpdGNoIChjKSB7Cj4gICAgICAgICAgICAgY2FzZSAnYic6Cj4gICAgICAg
ICAgICAgICAgICAgICByZXR1cm4gaSAqIGJsb2Nrc2l6ZTsKPiAgICAgLi4uCj4gCj4g4oCLWWVh
aCwgY2hhbmdlZC4KPiDigIsKPiAgCj4gCj4gCj4gICAgIChobSwgd2h5IGRvIHdlIGhhdmUgMyBj
b3BpZXMgb2YgY3Z0bnVtPykKPiAKPiAKPiDigItXaGVyZT8g4oCLCj4gIOKAiwo+IAo+IOKAiyQg
cHdkCj4g4oCLL3NvbWUvcGF0aC94ZnNwcm9ncy1kZXYKPiAKPiAkIGdyZXAgLXIgImN2dG51bShz
aXplX3QiIC4gfGdyZXAgLXYgIl5CaW5hcnkiCj4g4oCLLi9pbmNsdWRlL2lucHV0Lmg6ZXh0ZXJu
IGxvbmcgbG9uZyBjdnRudW0oc2l6ZV90IGJsb2Nrc2l6ZSwgc2l6ZV90IHNlY3RvcnNpemUsIGNo
YXIgKnMpOwo+IC4vaW8vaW5pdC5oOmV4dGVybiB2b2lkIGluaXRfY3Z0bnVtKHNpemVfdCAqYmxv
Y2tzaXplLCBzaXplX3QgKnNlY3RzaXplKTsKCiAgRmlsZSAgICAgICAgICAgICAgCUxpbmUKMCBl
c3RpbWF0ZS94ZnNfZXN0aW1hdGUuYyAgIDI5IGN2dG51bShjaGFyICpzKQoxIGxpYnhjbWQvaW5w
dXQuYyAgICAgICAgICAxNDcgY3Z0bnVtKAoyIG1rZnMveGZzX21rZnMuYyAgICAgICAgIDM2MTgg
Y3Z0bnVtKAoKLUVyaWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
