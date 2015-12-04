Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 245887F51
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 07:00:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E56718F8035
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 05:00:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fBLfXp538CiE2JwJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2015 05:00:02 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 9E2EE91353
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 13:00:02 +0000 (UTC)
Date: Fri, 4 Dec 2015 08:00:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Is test xfs/096 correct?
Message-ID: <20151204130000.GA47882@bfoster.bfoster>
References: <CACj3i71kgpqNvg0ru=-4x6gtJ8faOVn-P=y_AM+xwoKbm-55tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i71kgpqNvg0ru=-4x6gtJ8faOVn-P=y_AM+xwoKbm-55tQ@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

T24gRnJpLCBEZWMgMDQsIDIwMTUgYXQgMDE6MjA6MjZQTSArMDEwMCwgSmFuIFR1bGFrIHdyb3Rl
Ogo+IEhpLgo+IAo+IEknbSBsb29raW5nIG9uIHRlc3QgeGZzLzA5NiBhbmQgSSdtIG5vdCBzdXJl
IGlmIEkgZ290IGl0IHJpZ2h0Ogo+IAo+ICJ0ZXN0IG91dCBta2ZzX3hmcyBvdXRwdXQgb24gSVJJ
WC9MaW51eCBhbmQgc29tZSBvZiBpdHMgZXJyb3IgaGFuZGxpbmcsCj4gZW5zdXJlIHB2IzkyMDY3
OSBpcyBhZGRyZXNzZWQiIC0gdGhpcywgYW5kIHRoaW5ncyBsaWtlICIkbWF4X2xyX3NpemUgKwo+
IDQwOTYiIGFsbCBsb29rcyBsaWtlIG1rZnMgc2hvdWxkIGJlIGNhdGNoaW5nIGludmFsaWQgaW5w
dXQuIFlldCB0aGUgLm91dAo+IGZpbGUgaW5zdGVhZCBsb29rcyBsaWtlIGl0IHNob3VsZCBjcmVh
dGUgdGhlIEZTIGNvcnJlY3RseSAoaXQgY29udGFpbnMgdGhlCj4gY3JlYXRlZCBmcyBzdGF0cyBp
bnN0ZWFkIG9mIG1rZnMncyB1c2FnZSBhbmQgc29tZSBlcnJvcikuCj4gCgptYXhfbHJfc2l6ZSBy
ZWZlcnMgdG8gdGhlIG1heGltdW0gbG9nIHJlY29yZCBzaXplICgyNTZrKS4gV2hlbiBhIGxhcmdl
cgpsb2cgc3RyaXBlIHVuaXQgaXMgcGFzc2VkLCBta2ZzIHdhcm5zIGFib3V0IGl0IGFuZCBhZGp1
c3RzIHRvIHRoZQpkZWZhdWx0OgoKJCBta2ZzLnhmcyAtZiAtbCBzdT0yNjYyNDAgLi90bXAKbG9n
IHN0cmlwZSB1bml0ICgyNjYyNDAgYnl0ZXMpIGlzIHRvbyBsYXJnZSAobWF4aW11bSBpcyAyNTZL
aUIpCmxvZyBzdHJpcGUgdW5pdCBhZGp1c3RlZCB0byAzMktpQgptZXRhLWRhdGE9Li90bXAgICAg
ICAgICAgICAgICAgICBpc2l6ZT0yNTYgICAgYWdjb3VudD00LCBhZ3NpemU9NjU1MzYwCmJsa3MK
ICAgICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIGF0dHI9MiwgcHJv
amlkMzJiaXQ9MQogICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBjcmM9MCAgICAgICAg
Zmlub2J0PTAKZGF0YSAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgYnNpemU9NDA5NiAgIGJs
b2Nrcz0yNjIxNDQwLCBpbWF4cGN0PTI1CiAgICAgICAgID0gICAgICAgICAgICAgICAgICAgICAg
IHN1bml0PTAgICAgICBzd2lkdGg9MCBibGtzCm5hbWluZyAgID12ZXJzaW9uIDIgICAgICAgICAg
ICAgIGJzaXplPTQwOTYgICBhc2NpaS1jaT0wIGZ0eXBlPTAKbG9nICAgICAgPWludGVybmFsIGxv
ZyAgICAgICAgICAgYnNpemU9NDA5NiAgIGJsb2Nrcz0yNTYwLCB2ZXJzaW9uPTIKICAgICAgICAg
PSAgICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIHN1bml0PTggYmxrcywgbGF6eS1j
b3VudD0xCnJlYWx0aW1lID1ub25lICAgICAgICAgICAgICAgICAgIGV4dHN6PTQwOTYgICBibG9j
a3M9MCwgcnRleHRlbnRzPTAKClRoZSBta2ZzX2ZpbHRlcigpIGZ1bmN0aW9uIGluIHhmcy8wOTYg
ZmlsdGVycyBvdXQgdGhlIHdhcm5pbmcgbWVzc2FnZXMKKGlpcmMsIHRoZSB3YXJuaW5nIGlzIGEg
cmVsYXRpdmVseSByZWNlbnQgYWRkaXRpb24pLCBzbyB0aGUgdGVzdCBvdXRwdXQKZmlsZSBleHBl
Y3RzIHRoZSB0eXBpY2FsIChmaWx0ZXJlZCkgbWtmcyBvdXRwdXQuCgpCcmlhbgoKPiBTbyBlaXRo
ZXIgSSdtIHJlYWRpbmcgdGhlIHRlc3Qgd3JvbmcsIG9yIHRoZSBwYXRjaCBhcHByb3ZlcyBpbnZh
bGlkCj4gYmVoYXZpb3VyLiBJIGhpdCB0aGlzIHRlc3QgYmVjYXVzZSB3aGVuIEkgYWRkZWQgYSBz
dHJpY3RlciBpbnB1dAo+IHZhbGlkYXRpb24sIHRoaXMgcGF0Y2ggc3RhcnRlZCB0byBmYWlsIGFz
IG1rZnMgaXMgbm93IHJlZnVzaW5nIHRvIGNyZWF0ZQo+IHRoZSBmcyB3aXRoIHRoZXNlIGFyZ3Vt
ZW50cy4KPiAKPiBCVFc6IEkgdHJpZWQgdG8gbG9vayBmb3IgdGhlIG1lbnRpb25lZCBwdiBudW1i
ZXIsIGJ1dCBkaWRuJ3QgZm91bmQgaXQgLQo+IHdoZXJlIHNob3VsZCBJIGxvb2sgZnVydGhlcj8K
PiDigItDaGVlcnMKPiBKYW7igIsKPiAKPiAtLSAKPiBKYW4gVHVsYWsKPiBqdHVsYWtAcmVkaGF0
LmNvbSAvIGphbkB0dWxhay5tZQoKPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwo+IHhmcyBtYWlsaW5nIGxpc3QKPiB4ZnNAb3NzLnNnaS5jb20KPiBodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
