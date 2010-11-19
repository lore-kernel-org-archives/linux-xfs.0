Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAJ12wos252872 for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 19:02:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F3F413C4C38
	for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 17:04:30 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	HzDJ2ED0uUwl5OiX for <xfs@oss.sgi.com>;
	Thu, 18 Nov 2010 17:04:30 -0800 (PST)
Date: Fri, 19 Nov 2010 12:04:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs 2.x vs 3.x logsize changed
Message-ID: <20101119010421.GZ13830@dastard>
References: <201011171549.04806.lukasz.oles@open-e.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201011171549.04806.lukasz.oles@open-e.com>
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
To: =?utf-8?B?xYF1a2FzeiBPbGXFmw==?= <lukasz.oles@open-e.com>
Cc: Artur Piechocki <artur.piechocki@open-e.com>, xfs@oss.sgi.com

T24gV2VkLCBOb3YgMTcsIDIwMTAgYXQgMDM6NDk6MDRQTSArMDEwMCwgxYF1a2FzeiBPbGXFmyB3
cm90ZToKPiBIaSwKPiAKPiBJJ20gdXBncmFkaW5nIHhmc3Byb2dzIGZyb20gMi4xMC4xIHRvIHRo
ZSBsYXRlc3QgMy4xLjQgdmVyc2lvbi4gSSBub3RpY2VkIHRoYXQgCj4gd2hlbiBJJ20gY3JlYXRp
bmcgbGFyZ2UgbHZtIHZvbHVtZSAoMlQpIHRoZSBsb2cgc2l6ZSBpcyBhbG1vc3QgMUcgaW4gdGhl
IG9sZCAKPiB2ZXJzaW9uIGl0IHdhcyAxMjhNLiAgCj4gSSBrbm93IEkgY2FuIG1hbmlwdWxhdGUg
dGhpcyB2YWx1ZSB3aXRoIC1sc2l6ZSBvcHRpb24sIGJ1dCBJJ20gd29uZGVyaW5nIHdoeSAKPiB0
aGlzIGRpZmZlcmVuY2UgaXMgc28gaHVnZT8gCgpNYW55IHdvcmtsb2FkcyB3ZXJlIGRlbW9uc3Ry
YXRlZCB0byBoYXZlIHN1YnN0YW50aWFsbHkgYmV0dGVyCnBlcmZvcm1hbmNlIHdpdGggbGFyZ2Vy
IGxvZ3MsIGV2ZW4gb24gc21hbGwgZmlsZXN5c3RlbXMuIEF0IDRUQiwKbW9zdCBwZW9wbGUgYXJl
IHVzaW5nIFJBSUQgb2Ygc29tZSBraW5kLCBzbyBsYXJnZXIgbG9ncyBhcmUgcXVpdGUKYmVuZWZp
Y2lhbCBoZXJlLgoKPiBPbiB0aGlzIHZvbHVtZSBJIGhhdmUgb25lIHNwYXJzZSBmaWxlIHdoaWNo
IGlzIGV4cG9ydGVkIGJ5IGlTQ1NJIFRhcmdldC4gIEkgCj4gaGF2ZSBzY3JpcHQgd2hpY2ggY2Fs
Y3VsYXRlcyAgZm9yIG1lICJzZWVrIiB2YWx1ZSBmb3IgZGQgY29tbWFuZCBhbmQgbm93IGl0IAo+
IHJldHVybnMgbWUgd3JvbmcgdmFsdWVzLgo+IENhbiBJIHN0YXkgd2l0aCB0aGUgb2xkIGxvZyBz
aXplIG9yIG1heWJlIHRoZXJlIGFyZSBzb21lIGdvb2QgcmVhc29ucyB0byB1c2UgCj4gbmV3IHZh
bHVlcz8KClN0YXlpbmcgd2l0aCB0aGUgb2xkIGxvZyBzaXplIGlzIGp1c3QgZmluZSAtIGl0J2xs
IGJlaGF2ZSBleGFjdGx5CnRoZSBzYW1lIGFzIGl0IGRvZXMgbm93LiBUaGVyZSBhcmUgdHdvIG1h
aW4gdGhpbmdzIGhhdCBtYWtlIGEgbGFyZ2VyCmxvZyBzaXplIGF0dHJhY3RpdmU6CgoJMS4gbG9n
IHNpemUgZGV0ZXJtaW5lcyBtYXhpbXVtIHRyYW5zYWN0aW9uIHBhcmFsbGVsaXNtLCBzbwoJICAg
c28gc21hbGxlciBsb2dzIG1heSBsaW1pdCBvcGVyYXRpb25hbCBjb25jdXJyZW5jeS4gQQoJICAg
MTI4TUIgbG9nIHR5cGljYWxseSBhbGxvd3MgfjI1MCBjb25jdXJyZW50IHRyYW5zYWN0aW9ucwoJ
ICAgb24gYSAxVEIsIDRrIGJsb2NrIHNpemUgZmlsZXN5c3RlbS4KCTIuIGxhcmdlciBsb2dzIGFs
bG93IHRoZSBmaWxlc3lzdGVtIHRvIHNvYWsgdXAgbGFyZ2VyIGJ1cnN0CgkgICBvZiBtZXRhZGF0
YSBtb2RpZmljYXRpb25zIHdpdGhvdXQgbmVlZGluZyB0byB3cml0ZSBiYWNrCgkgICBkaXJ0eSBt
ZXRhZGF0YS4KClRoZSBkb3duc2lkZSBvdCBhIGxhcmdlciBsb2cgaXMgdGhhdCByZWNvdmVyeSBj
YW4gdGFrZSBsb25nZXIgYWZ0ZXIKYSBjcmFzaC4KCkFueXdheSwgaWYgeW91IGFyZSBoYXZpbmcg
bm8gcHJvYmxlbXMgYXQgMTI4TUIsIHRoZW4ganVzdCB1c2UKdGhhdC4uLgoKQ2hlZXJzLAoKRGF2
ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
