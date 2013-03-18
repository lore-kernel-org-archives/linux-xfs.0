Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CDFFF7F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 15:58:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ADB898F804B
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:58:33 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id xlJrlbk06U8GHjFQ for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:58:32 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Xfs_repair and journalling
Date: Mon, 18 Mar 2013 21:58:30 +0100
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
	<20130318182202.GD22182@sgi.com>
	(sfid-20130318_205600_822442_7E5CA7C2)
In-Reply-To: <20130318182202.GD22182@sgi.com>
MIME-Version: 1.0
Message-Id: <201303182158.31100.Martin@lichtvoll.de>
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
Cc: Ben Myers <bpm@sgi.com>, stan@hardwarefreak.com, Subranshu Patel <spatel.ml@gmail.com>

QW0gTW9udGFnLCAxOC4gTcOkcnogMjAxMyBzY2hyaWViIEJlbiBNeWVyczoKPiBIaSBTdWJyYW5z
aHUsClvigKZdCj4gPiBJbiBjYXNlIG9mIEVYVDQsIGpvdXJuYWwgd2lsbCBub3QgYmUgcmVwbGF5
ZWQgb24gcGVyZm9ybWluZyBtb3VudC4gT25lCj4gPiBuZWVkIHRvIGludm9rZSBmc2NrIHdoaWNo
IHBlcmZvcm1zIGpvdXJuYWwgcGxheWJhY2sgYW5kIHRoZW4gb3RoZXIKPiA+IGNvcnJ1cHRpb24g
Y2hlY2tzL3JlY292ZXJ5Lgo+IAo+IEkgY2FuJ3Qgc3BlYWsgZm9yIGV4dDQuICBJIGRvIHRoaW5r
IHRoYXQgeW91ciBleHBlY3RhdGlvbiB0aGF0Cj4gZnNjay9yZXBhaXIgYmUgYWJsZSB0byByZXBs
YXkgYSBqb3VybmFsIGlzIHByZXR0eSByZWFzb25hYmxlLiAgVGhhdCdzCj4ganVzdCBub3QgaG93
IGl0IGlzIGltcGxlbWVudGVkIGhlcmUuICBJbiB4ZnMsIGxvZyByZWNvdmVyeSBpcyBpbiB0aGUK
PiBrZXJuZWwgYW5kIHhmc19yZXBhaXIga25vd3MganVzdCBlbm91Z2ggYWJvdXQgdGhlIGxvZyB0
byBhdm9pZAo+IGNsb2JiZXJpbmcgeW91ciBwcmVjaW91cyBtZXRhZGF0YSB3aGVuIGl0IG5lZWRz
IHRvIGJlIHJlY292ZXJlZC4gIFRoZXJlCj4gd2FzIHNvbWUgZGlzY3Vzc2lvbiBpbiB0aGUgcGFz
dCBhYm91dCBtYWtpbmcgeGZzX3JlcGFpciBhYmxlIHRvIHJlY292ZXIKPiB0aGUgbG9nIGJ1dCBJ
IHdvdWxkbid0IGV4cGVjdCB0aGF0IGFueSB0aW1lIHNvb24uCgpZZXMsIGZzY2suZXh0NCBpcyBh
YmxlIHRvIHJlcGxheSB0aGUgam91cm5hbCwgYW5kIGFsc28gYWJsZSB0byAqanVzdCogcmVwbGF5
IAp0aGUgam91cm5hbCBhbmQgZG8gbm90aGluZyBlbHNlLiBJIGp1c3QgY2hlY2tlZCBpdHMgbWFu
cGFnZS4KClRoYW5rcyBmb3Igbm90IHNwZWFraW5nIGZvciBFeHQ0IHVubGVzcyB5b3UgcmVhbGx5
IHRoaW5rIHlvdSBrbm93IGl0LgoKQmVpbmcgYWJsZSB0byByZXBsYXkgaW4gdXNlcnNwYWNlIG1p
Z2h0IGhlbHAgd2hlbiB0aGUgZmlsZXN5c3RlbSBjYW5ub3QgYmUgCm1vdW50ZWQgY29ycmVjdGx5
IGR1ZSB0byByZWFzb25zIGxheWluZyBvdXRzaWRlIHRoZSBqb3VybmFsLiBDYXVzZSB0aGVuIG9u
ZSAKY2FuIGF0dGVtcHQgdG8gcmVwbGF5IHRoZSBqb3VybmFsIGluIHVzZXJzcGFjZSBhbmQgcnVu
IGEgcmVwYWlyIG9uIHRoZSAKZmlsZXN5c3RlbSB0aGVuLgoKLS0gCk1hcnRpbiAnSGVsaW9zJyBT
dGVpZ2Vyd2FsZCAtIGh0dHA6Ly93d3cuTGljaHR2b2xsLmRlCkdQRzogMDNCMCAwRDZDIDAwNDAg
MDcxMCA0QUZBICBCODJGIDk5MUIgRUFBQyBBNTk5IDg0QzcKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
