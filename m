Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 22D1F7F54
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:54:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0CA03304053
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:54:59 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id z6psu6xeGyQzpsgj for
	<xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:54:56 -0700 (PDT)
Date: Tue, 12 Mar 2013 11:54:42 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS filesystem corruption
Message-ID: <20130312115442.1918d592@galadriel.home>
In-Reply-To: <CAPcwv6yb4F1b4hUiBmt3HNs-uTet812TVUN_-_y+JibAXkTQsw@mail.gmail.com>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	<5139D792.4090304@redhat.com> <513A350A.508@hardwarefreak.com>
	<20130309091152.GH23616@dastard>
	<513B84AD.2000603@hardwarefreak.com>
	<20130310224536.GK23616@dastard>
	<513D1D51.7010905@hardwarefreak.com>
	<CAPcwv6yb4F1b4hUiBmt3HNs-uTet812TVUN_-_y+JibAXkTQsw@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Julien FERRERO <jferrero06@gmail.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, stan@hardwarefreak.com, xfs@oss.sgi.com

TGUgTW9uLCAxMSBNYXIgMjAxMyAxMDoyNToxMyArMDEwMCB2b3VzIMOpY3JpdmllejoKCj4gVGhh
dCBpcyB0aGUgbWFpbiByZWFzb24gSSBhc2tlZC4gSSBnb29nbGUgZm9yIHJlZ3Jlc3Npb24gLyBp
c3N1ZSB3aXRoCj4gWEZTIGluIDIuNi4zNSBidXQgSSBkaWRuJ3QgZmluZCBhbnl0aGluZy4gTXkg
aG9wZSB3YXMgdGhhdCBzb21lb25lCj4gZnJvbSB0aGlzIG1haWxpbmcgbGlzdCB3b3VsZCByZW1l
bWJlciBpdCAoaWYgc3VjaCBhIHJlZ3Jlc3Npb24gZGlkCj4gZXhpc3Qgb2YgY291cnNlKS4KCkkg
ZG9uJ3QsIGJ1dCBJIGhhZCBhdCBsYXN0IG9uZSBzZXJpb3VzIGNvcnJ1cHRpb24gdW5kZXIgMi42
LjM1LjEzCih0aG91Z2ggaXQgd2FzIHJlbGF0ZWQgdG8gaGFyZCBkcml2ZSB3b2VzKS4KCi0tIAot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1
ZQogICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAg
fAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEg
NzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
