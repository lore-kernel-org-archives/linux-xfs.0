Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB48DB4B004362 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 02:13:12 -0600
Received: from main.carme.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06D8D1691381
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 00:13:09 -0800 (PST)
Received: from main.carme.maven.pl (main.carme.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id JjC3I8rFan4MQ5fL for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 00:13:09 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: 2.6.27.7 vanilla,
	project quota enabled and process stuck in D state (repeatable every
	time)
Date: Thu, 4 Dec 2008 09:13:06 +0100
References: <200812021949.55463.arekm@maven.pl>
	<200812032242.29326.arekm@maven.pl>
	<20081203220934.GA32301@disturbed>
In-Reply-To: <20081203220934.GA32301@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812040913.06733.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

T24gV2VkbmVzZGF5IDAzIG9mIERlY2VtYmVyIDIwMDgsIERhdmUgQ2hpbm5lciB3cm90ZToKPiBP
biBXZWQsIERlYyAwMywgMjAwOCBhdCAxMDo0MjoyOVBNICswMTAwLCBBcmthZGl1c3ogTWlza2ll
d2ljeiB3cm90ZToKPiA+IE9uIFdlZG5lc2RheSAwMyBvZiBEZWNlbWJlciAyMDA4LCBEYXZlIENo
aW5uZXIgd3JvdGU6Cgo+ID4gW2FyZWttQGZhcm0gcnBtXSQgdG91Y2ggL2hvbWUvdXNlcnMvYXJl
a20vdG1wL2FhCj4gPiBbYXJla21AZmFybSBycG1dJCAuL2Eub3V0Cj4gPiByZXQ9LTEgSW52YWxp
ZCBjcm9zcy1kZXZpY2UgbGluawo+Cj4gV2VsbCwgdGhhdCdzIHdoYXQgd2UgbmVlZGVkIHRvIGtu
b3cuIFRoZSBidWc6Cj4KPiAxOTkgICAgICAgICAvKgo+IDIwMCAgICAgICAgICAqIExvY2sgYWxs
IHRoZSBwYXJ0aWNpcGF0aW5nIGlub2Rlcy4gRGVwZW5kaW5nIHVwb24gd2hldGhlcgo+IDIwMSAg
ICAgICAgICAqIHRoZSB0YXJnZXRfbmFtZSBleGlzdHMgaW4gdGhlIHRhcmdldCBkaXJlY3Rvcnks
IGFuZAo+IDIwMiAgICAgICAgICAqIHdoZXRoZXIgdGhlIHRhcmdldCBkaXJlY3RvcnkgaXMgdGhl
IHNhbWUgYXMgdGhlIHNvdXJjZQo+IDIwMyAgICAgICAgICAqIGRpcmVjdG9yeSwgd2UgY2FuIGxv
Y2sgZnJvbSAyIHRvIDQgaW5vZGVzLgo+IDIwNCAgICAgICAgICAqLwo+IDIwNSAgPj4+Pj4gIHhm
c19sb2NrX2lub2Rlcyhpbm9kZXMsIG51bV9pbm9kZXMsIFhGU19JTE9DS19FWENMKTsKPiAyMDYK
PiAyMDcgICAgICAgICAvKgo+IDIwOCAgICAgICAgICAqIElmIHdlIGFyZSB1c2luZyBwcm9qZWN0
IGluaGVyaXRhbmNlLCB3ZSBvbmx5IGFsbG93IHJlbmFtZXMKPiAyMDkgICAgICAgICAgKiBpbnRv
IG91ciB0cmVlIHdoZW4gdGhlIHByb2plY3QgSURzIGFyZSB0aGUgc2FtZTsgZWxzZSB0aGUKPiAy
MTAgICAgICAgICAgKiB0cmVlIHF1b3RhIG1lY2hhbmlzbSB3b3VsZCBiZSBjaXJjdW12ZW50ZWQu
Cj4gMjExICAgICAgICAgICovCj4gMjEyICAgICAgICAgaWYgKHVubGlrZWx5KCh0YXJnZXRfZHAt
PmlfZC5kaV9mbGFncyAmIFhGU19ESUZMQUdfUFJPSklOSEVSSVQpCj4gJiYgMjEzICAgICAgICAg
ICAgICAgICAgICAgICh0YXJnZXRfZHAtPmlfZC5kaV9wcm9qaWQgIT0KPiBzcmNfaXAtPmlfZC5k
aV9wcm9qaWQpKSkgeyAyMTQgICAgICAgICAgICAgICAgIGVycm9yID0gWEZTX0VSUk9SKEVYREVW
KTsKPiAyMTUgID4+Pj4+Pj4gICAgICAgIHhmc19yZW5hbWVfdW5sb2NrNChpbm9kZXMsIFhGU19J
TE9DS19TSEFSRUQpOwo+IDIxNiAgICAgICAgICAgICAgICAgeGZzX3RyYW5zX2NhbmNlbCh0cCwg
Y2FuY2VsX2ZsYWdzKTsKPiAyMTcgICAgICAgICAgICAgICAgIGdvdG8gc3RkX3JldHVybjsKPiAy
MTggICAgICAgICB9Cj4KPiBJcyB0aGF0IHRoZSB1bmxvY2sgb2YgdGhlIGlub2RlcyBpcyB1c2lu
ZyB0aGUgaW5jb3JyZWN0IGxvY2sKPiB0eXBlIGZvciB0aGUgdW5sb2NrLCAoaW5vZGVzIGxvY2sg
WEZTX0lMT0NLX0VYQ0wsIHVubG9ja2VkCj4gWEZTX0lMT0NLX1NIQVJFRCkgd2hpY2ggbWVhbnMg
dGhleSBkb24ndCBnZXQgdW5sb2NrZWQgYW5kIHRoZSBuZXh0IGF0dGVtcHQKPiB0byBkbyBhbnl0
aGluZyB3aXRoIHRob3NlIGlub2RlcyB3aWxsIGhhbmcuCj4KPiBDb21waWxlLXRlc3RlZC1vbmx5
IHBhdGNoIGJlbG93IHRoYXQgc2hvdWxkIGZpeCB0aGUgcHJvYmxlbS4KCkl0IGZpeGVzIHRoZSBw
cm9ibGVtIGZvciBtZS4gVGhhbmtzISBJIGhvcGUgdGhhdCBpdCB3aWxsIHJlYWNoIHN0YWJsZUAg
dGVhbSAKZm9yIDIuNi4yNy45LgoKPiBDaGVlcnMsCj4KPiBEYXZlLgoKCgotLSAKQXJrYWRpdXN6
IE1pxZtraWV3aWN6ICAgICAgICBQTEQvTGludXggVGVhbQphcmVrbSAvIG1hdmVuLnBsICAgICAg
ICAgICAgaHR0cDovL2Z0cC5wbGQtbGludXgub3JnLwoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20K
aHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
