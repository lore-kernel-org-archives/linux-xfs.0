Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39BdR3b107261 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 06:39:27 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 4sNQD5mxS9VqvnoU for
	<xfs@oss.sgi.com>; Mon, 09 Apr 2012 04:39:24 -0700 (PDT)
Date: Mon, 9 Apr 2012 13:39:13 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120409133913.2fb9d94b@galadriel.home>
In-Reply-To: <20120409001943.GI18323@dastard>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
	<20120409001943.GI18323@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Stefan Ring <stefanrin@gmail.com>, stan@hardwarefreak.com, Linux fs XFS <xfs@oss.sgi.com>

TGUgTW9uLCA5IEFwciAyMDEyIDEwOjE5OjQzICsxMDAwIHZvdXMgw6ljcml2aWV6OgoKPiBBIGRl
Y2VudCBSQUlEIGNvbnRyb2xsZXIgd2l0aCBhIEJCV0MgYW5kIGEgc2luZ2xlIExVTiBiZW5lZml0
cyBmcm9tCj4gcGFyYWxsZWxpc20ganVzdCBhcyBtdWNoIGFzIGEgbGFyZ2UgZGlzayBhcnJheXMg
ZG8gYmVjYXVzZSB0aGUgQkJXQwo+IG1pbmltaXNlcyB0aGUgd3JpdGUgSU8gbGF0ZW5jeSBhbmQg
dGhlIGNvbnRyb2xsZXIgdG8gZG8gYSBiZXR0ZXIgam9iCj4gb2Ygc2NoZWR1bGluZyBpdHMgSU8u
CgpCVFcgcmVjZW50bHkgSSd2ZSBmb3VuZCB0aGF0IGZvciBzdG9yYWdlIHNlcnZlcnMsIG5vb3Ag
aW8gc2NoZWR1bGVyCm9mdGVuIGlzIHRoZSBiZXN0IGNob2ljZSwgSSBzdXBwb3NlIHByZWNpc2Vs
eSBiZWNhdXNlIGl0IGRvZXNuJ3QgdHJ5IHRvCm91dHNtYXJ0IHRoZSBSQUlEIGNvbnRyb2xsZXIg
bG9naWMuLi4KCi0tIAotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGly
ZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAg
ICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAgICAg
ICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
