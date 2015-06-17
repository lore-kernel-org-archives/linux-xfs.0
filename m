Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E6C07F8E
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 06:34:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3258F8F8070
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 04:34:31 -0700 (PDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
	[209.85.212.176]) by cuda.sgi.com with ESMTP id
	zQxozkZ71JKHWHVS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 04:34:29 -0700 (PDT)
Received: by wiga1 with SMTP id a1so136456738wig.0
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 04:34:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150612154353.1c0df8b6@harpe.intellique.com>
References: <CAG_XuNWrbyb97h3moqgYJLdvMr3J1OPGb2VknDTpcO0-8upMnw@mail.gmail.com>
	<20150612122750.21c2a8e4@harpe.intellique.com>
	<CAG_XuNUxBCYZtPJixcA8sJqN7nzb85Eg+vJyvAoNB73wryPcTw@mail.gmail.com>
	<20150612154353.1c0df8b6@harpe.intellique.com>
From: Lampa <lampacz@gmail.com>
Date: Wed, 17 Jun 2015 13:33:48 +0200
Message-ID: <CAG_XuNWJhCGrSB7jOi54wzdjxXVec+i=s6szkWea=8sx7SD50g@mail.gmail.com>
Subject: Re: xfs_repair use all memory
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

SGVsbG8sCgp1bmFibGUgdG8gcmVwYWlyIC0gcnVubmluZyB3aXRob3V0IC1uIHBhcmFtZXRlciBy
ZXF1aXJlcyBtb3JlIG1lbW9yeS4KQWx3YXlzIGtpbGxlZCBieSBrZXJuZWwKCjIwMTUtMDYtMTIg
MTU6NDMgR01UKzAyOjAwIEVtbWFudWVsIEZsb3JhYyA8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT46
Cj4gTGUgRnJpLCAxMiBKdW4gMjAxNSAxMjozNjo1OCArMDIwMAo+IExhbXBhIDxsYW1wYWN6QGdt
YWlsLmNvbT4gw6ljcml2YWl0Ogo+Cj4+IFJldHVybiBhZGRyZXNzID0gMHhmZmZmZmZmZmEwMzEy
Njc3Cj4+IFsgIDE1MC4zMjcyNjJdIFhGUyAoZG0tMCk6IENvcnJ1cHRpb24gb2YgaW4tbWVtb3J5
IGRhdGEgZGV0ZWN0ZWQuCj4+IFNodXR0aW5nIGRvd24gZmlsZXN5c3RlbQo+PiBbICAxNTAuMzI3
MjY0XSBYRlMgKGRtLTApOiBQbGVhc2UgdW1vdW50IHRoZSBmaWxlc3lzdGVtIGFuZCByZWN0aWZ5
Cj4+IHRoZSBwcm9ibGVtKHMpCj4+IFsgIDE1OS4zMDQyODddIFhGUyAoZG0tMCk6IHhmc19sb2df
Zm9yY2U6IGVycm9yIDUgcmV0dXJuZWQuCj4+Cj4+Cj4+IGkgd2lsbCB0cnkgeW91ciB4ZnNwcm9n
cyB2ZXJzaW9uCj4+Cj4KPiBZZXMsIGFuZCB0cnkgdG8gbW91bnQvdW5tb3VudCB0aGUgZmlsZXN5
c3RlbSBmaXJzdCB0byBjbGVhciB0aGUgbG9nIGlmCj4gcG9zc2libGUsIGJlZm9yZSBydW5uaW5n
IHhmc19yZXBhaXIuCj4KPgo+IC0tCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gRW1tYW51ZWwgRmxvcmFj
ICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQo+ICAgICAgICAgICAgICAgICAgICAgfCAgIElu
dGVsbGlxdWUKPiAgICAgICAgICAgICAgICAgICAgIHwgICA8ZWZsb3JhY0BpbnRlbGxpcXVlLmNv
bT4KPiAgICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgo+IC0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQoKCgotLSAKTGFtcGEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
