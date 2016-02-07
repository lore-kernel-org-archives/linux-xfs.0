Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEDCA29DF5
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 12:16:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D865AC003
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 10:16:47 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id QB6EfDL5GkbUIfcK for
	<xfs@oss.sgi.com>; Sun, 07 Feb 2016 10:16:41 -0800 (PST)
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: getrichacl(1) man page review comments
Date: Sun, 07 Feb 2016 19:16:40 +0100
Message-ID: <1505883.O2zQ69A2Zb@merkaba>
In-Reply-To: <56B77139.4080209@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77139.4080209@gmail.com>
MIME-Version: 1.0
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

QW0gU29ubnRhZywgNy4gRmVicnVhciAyMDE2LCAxNzozMDo0OSBDRVQgc2NocmllYiBNaWNoYWVs
IEtlcnJpc2sgKG1hbi1wYWdlcyk6Cj4gSGVsbG8gQW5kcmVhcywKPiAKPiBIZXJlLCBzb21lIGNv
bW1lbnRzIG9uIHRoZSBnZXRyaWNoYWNsKDEpIHBhZ2UuCgpJIGtub3cgdGhhdCB0aGUgY29tbWFu
ZCBuYW1lcyBhcmUgYmFzZWQgb24gc2V0ZmFjbCBhbmQgZ2V0ZmFjbC4gQnV0IHNvbWV0aW1lcyAK
SSBzdGlsbCB3b25kZXIgYWJvdXQgdGhlc2UgbmFtZXMuIFRoZXkganVzdCBkb27CtHQgZml0LgoK
SXRzIGNoc29tZXRoaW5nIGZvciBjaGFuZ2luZyB0aGluZ3MgaW4gVW5peCB0cmFkaXRpb25hbGx5
IOKAkyBjaG93biwgY2htb2QsIApjaGF0dHIsIGNoYWdlIGNoc2gsIHlvdSBuYW1lIGl0IOKAkywg
YnV0IHRoZXJlIGlzIG5vdGhpbmcgZm9yIHF1ZXJ5aW5nIHRoaW5ncy4gClNvIEkgZ2V0IHdoZXJl
IHRoaXMgaXMgY29taW5nIGZyb20sIHlldCBJIGFsd2F5cyBmb3VuZCBzZXRmYWNsIGFuZCBnZXRm
YWNsIApjb21tYW5kIG5hbWVzIGN1bWJlcnNvbWUuCgpTb3JyeSwgZm9yIHBvc3RpbmcgaGVyZSBp
bnN0ZWFkIG9mIGEgcHJldmlvdXMgcmljaGFjbCBpbXBsZW1lbnRhdGlvbiBwYXRjaHNldC4gCkkg
ZnVsbHkgYXBwcmVjaWF0ZSB0aGF0IGl0IG1heSBiZSB0b28gbGF0ZSB0byBjaGFuZ2UgYW55dGhp
bmcgcmVnYXJkaW5nIApjb21tYW5kIG5hbWVzLiBBbHNvIGNvbnNpZGVyaW5nIHVzZXJtb2QgYW5k
IGdyb3VwbW9kIHRoZSBjb21tYW5kIG5hbWluZyBpbiAKVW5peCAvIExpbnV4IGFwcGVhcnMgdG8g
YmUgYSBiaWcgbWVzcyBhbnl3YXkuCgpUaGFua3MsCi0tIApNYXJ0aW4KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9z
cy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
