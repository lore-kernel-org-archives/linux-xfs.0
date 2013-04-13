Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C6167CBF
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 19:32:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2CC22304043
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 17:32:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zZUXdQJaGw08E56p for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 17:32:26 -0700 (PDT)
Date: Sat, 13 Apr 2013 10:32:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: make install support common/ and tests/ dirs
Message-ID: <20130413003222.GG30622@dastard>
References: <51678D0D.1070002@gmail.com> <20130412074034.GC30622@dastard>
	<5168396C.6020801@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5168396C.6020801@gmail.com>
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
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>, Rich Johnston <rjohnston@sgi.com>, Dave Chinner <dchinner@redhat.com>

T24gU2F0LCBBcHIgMTMsIDIwMTMgYXQgMTI6NDI6MjBBTSArMDgwMCwgV2FuZyBTaGVuZy1IdWkg
d3JvdGU6Cj4gT24gMjAxM+W5tDA05pyIMTLml6UgMTU6NDAsIERhdmUgQ2hpbm5lciB3cm90ZToK
PiA+T24gRnJpLCBBcHIgMTIsIDIwMTMgYXQgMTI6MjY6NTNQTSArMDgwMCwgV2FuZyBTaGVuZy1I
dWkgd3JvdGU6Cj4gPj4rIwo+ID4+Kwo+ID4+K1RPUERJUiA9IC4uCj4gPj4raW5jbHVkZSAkKFRP
UERJUikvaW5jbHVkZS9idWlsZGRlZnMKPiA+PisKPiA+PitURVNUU19TVUJESVJTID0gJChzaGVs
bCBmaW5kIC4gLW1heGRlcHRoIDEgLXR5cGUgZCB8IHNlZCAtbiAtZSAncy9cLlwvLy9ncCcpCj4g
Pgo+ID5UaGlzIGlzIG11Y2ggbmVhdGVyOgo+ID4KPiA+VEVTVFNfU1VCRElSUyA9ICQoc29ydCAk
KGRpciAkKHdpbGRjYXJkICAkKFBXRCkvKi8pKSkKPiAKPiBIaSBEYXZlLAo+IAo+IEkgaW50cm9k
dWNlcyBNYWtlZmlsZSB1bmRlciB0ZXN0cy8sIHdoaWNoIHdvdWxkIHJldHVybiB0byBURVNUU19T
VUJESVJTIHdpdGggdGhlCj4gJChkaXIgZnVuY3Rpb24uIEJ5IHJ1bm5pbmcgZmluZCBpbiAkKHNo
ZWxsLCBURVNUX1NVQkRJUlMgd2lsbCBvbmx5IGdldCB0aGUgZGlyIG5hbWVzLAo+IGFuZCBubyBN
YWtlZmlsZS4KCkkgdGhpbmsgeW91IG1pc3VuZGVyc3RhbmQuIFRoZSB3aWxkY2FyZCBhYm92ZSBv
bmx5IHJldHVybnMKZGlyZWN0b3JpZXM6CgokIHB3ZAogMCAgfi9zcmMveGZzdGVzdHMtZGV2L3Rl
c3RzCiQgY2F0IH4vdG1wL01ha2VmaWxlIApmb289JChzb3J0ICQoZGlyICQod2lsZGNhcmQgICQo
UFdEKS8qLykpKQoKZGVmYXVsdDoKICAgICAgICBAZWNobyAkKGZvbykKJCBtYWtlIC1mIH4vdG1w
L01ha2VmaWxlIAovaG9tZS9kYXZlL3NyYy94ZnN0ZXN0cy1kZXYvdGVzdHMvYnRyZnMvIC9ob21l
L2RhdmUvc3JjL3hmc3Rlc3RzLWRldi90ZXN0cy9leHQ0LyAvaG9tZS9kYXZlL3NyYy94ZnN0ZXN0
cy1kZXYvdGVzdHMvZ2VuZXJpYy8gL2hvbWUvZGF2ZS9zcmMveGZzdGVzdHMtZGV2L3Rlc3RzL3No
YXJlZC8gL2hvbWUvZGF2ZS9zcmMveGZzdGVzdHMtZGV2L3Rlc3RzL3VkZi8gL2hvbWUvZGF2ZS9z
cmMveGZzdGVzdHMtZGV2L3Rlc3RzL3hmcy8KJAoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hp
bm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
