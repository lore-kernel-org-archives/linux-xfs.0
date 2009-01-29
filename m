Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0TF86JK212817 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 09:08:07 -0600
Received: from nschwmtas02p.mx.bigpond.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50F9BC936E
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 07:07:24 -0800 (PST)
Received: from nschwmtas02p.mx.bigpond.com (nschwmtas02p.mx.bigpond.com
	[61.9.189.140]) by cuda.sgi.com with ESMTP id NovziaBRdHx7b2TG
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 07:07:24 -0800 (PST)
Message-ID: <4981C62A.6020503@bigpond.net.au>
Date: Fri, 30 Jan 2009 02:07:22 +1100
From: Donald Douwsma <ddouwsma@bigpond.net.au>
MIME-Version: 1.0
Subject: Re: [PATCH] [LIBXCMD]: Move error messages to appropriate places.
References: <1233167051-14711-1-git-send-email-arekm@maven.pl>	<4981BD32.2090405@bigpond.net.au>
	<200901291543.07441.arekm@maven.pl>
In-Reply-To: <200901291543.07441.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

QXJrYWRpdXN6IE1pc2tpZXdpY3ogd3JvdGU6Cj4gT24gVGh1cnNkYXkgMjkgb2YgSmFudWFyeSAy
MDA5LCBEb25hbGQgRG91d3NtYSB3cm90ZToKPj4gQXJrYWRpdXN6IE1pxZtraWV3aWN6IHdyb3Rl
Ogo+Pj4gUmVwbGFjZSByYXcgcGVycm9yKCkgd2l0aCBwcm9wZXIgbWVzc2FnZSBpbgo+Pj4gZnNf
dGFibGVfaW5pdGlhbGlzZV9tb3VudHMoKS4KPj4+Cj4+PiBSZXBsYWNlIHJhdyBwZXJyb3IoKSB3
aXRoIHByb3BlciBtZXNzYWdlIGFuZCBtb3ZlIGl0IGZyb20KPj4+IGZzX21vdW50X3BvaW50X2Zy
b21fcGF0aCgpIHRvIGZzX3RhYmxlX2luaXRpYWxpc2VfcHJvamVjdHMoKSB3aGVyZSB0aGlzCj4+
PiBtZXNzYWdlIGhhcyBtZWFuaW5nLgo+PiBJIGxpa2UgeW91ciBjaGFuZ2UsIGl0IG1ha2VzIHRo
aW5ncyBjbGVhcmVyLgo+Pgo+PiBCdXQgZG9lcyB0aGlzIHBhcnRpY3VsYXIgZXJyb3IgYWN0dWFs
bHkgaGVscCBwZW9wbGU/IEkndmUgc2VlbiBpdCBhIGZldwo+PiB0aW1lcyB3aGVuIHRlc3Rpbmcg
cXVvdGEgY29kZSBpbiB0aGUgcGFzdC4gSXQncyBvbmx5IHVzZWQgd2hlbiByZWFkaW5nIGluCj4+
IHByb2plY3RzLCBhbmQgY2F1c2VzIGVycm9ycyB0byBiZSBkaXNwbGF5ZWQgZXZlbiB3aGVuIGlz
c3Vpbmcgbm9uIHByb2plY3QKPj4gY29tbWFuZHMuCj4+Cj4+ICQgc3VkbyBiYXNoIC1jICJlY2hv
IDEwOi92YXIvbm9uZXhpc3RhbnRkaXIgPj4gL2V0Yy9wcm9qZWN0cwo+PiAkIHhmc19xdW90YSAt
YyBwcmludAo+PiAvdmFyL25vbmV4aXN0YW50ZGlyOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5
Cj4+IEZpbGVzeXN0ZW0gICAgICAgICAgUGF0aG5hbWUKPj4gL2hvbWUgICAgICAgICAgICAgICAv
ZGV2L3NkYTgKPiAKPiBOb3cgaXQgd2lsbCBiZToKPiB4ZnNfcXVvdGE6IGNhbm5vdCBmaW5kIG1v
dW50IHBvaW50IGZvciBwYXRoIGAvdmFyL25vbmV4aXN0YW50ZGlyJzogTm8gc3VjaCAKPiBmaWxl
IG9yIGRpcmVjdG9yeQo+IAo+PiBJJ2QgYmUgdGVtcHRlZCB0byByZW1vdmUgdGhpcyBlcnJvciwg
YW5kIGFkZCBlcnJvciBjaGVja2luZyBjb2RlIHRvIHRoZQo+PiBwcm9qZWN0IHNwZWNpZmljIGNv
bW1hbmRzIHRoYXQgd2FsayB0cmVlJ3MuCj4gCj4gVGhlIHBhdGggd29uJ3QgYmUgYWRkZWQgdG8g
d2FsayBpdGVyYXRvciBhbmQgdGhlcmUgd2lsbCBiZSBubyBlcnJvciBhdCB3YWxrIAo+IHRpbWUu
IAoKR29vZCBwb2ludCwgaWYgd2UgZG9udCBnaXZlIHRoZSBlcnJvciBhdCB0aGF0IHBvaW50IHRo
ZXJlIGlzIG5vIHdheSBmb3IgdGhlIHVzZXIgdG8KZmluZCBvdXQgd2hhdCBoYXBwZW5lZCwgbm90
IGdvb2QuCgo+IAo+IFRoZSBmaXggd291bGQgYmUgcHJvYmFibHkgdG8gbm90IGFkZCBwcm9qZWN0
IHRvIHRoZSBpdGVyYXRpbmcgZW5naW5lIHdoZW4gCj4gYXNraW5nIGZvciBub24tcHJvamVjdCB0
aGluZ3MgZXRjLiAKClRoYXQgd291bGQgYmUgbmljZSwgaW4gdGhlIG1lYW50aW1lIEkgdGhpbmsg
eW91ciBjaGFuZ2UgaXMgYSBnb29kIGlkZWEuCgpEb24KCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
