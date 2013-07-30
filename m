Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF92C7CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 15:26:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE7A38F8033
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 13:26:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7wI2NIRHnWUUtwn3 for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 13:26:40 -0700 (PDT)
Date: Tue, 30 Jul 2013 16:26:28 -0400
From: Dave Jones <davej@redhat.com>
Subject: XFS undeletable files. (3.11rc3)
Message-ID: <20130730202628.GA16356@redhat.com>
References: <20130712023930.GA6473@redhat.com> <20130725041538.GH13468@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130725041538.GH13468@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

T24gVGh1LCBKdWwgMjUsIDIwMTMgYXQgMDI6MTU6MzhQTSArMTAwMCwgRGF2ZSBDaGlubmVyIHdy
b3RlOgogPiBPbiBUaHUsIEp1bCAxMSwgMjAxMyBhdCAxMDozOTozMFBNIC0wNDAwLCBEYXZlIEpv
bmVzIHdyb3RlOgogPiA+IEp1c3Qgc2F3IHRoaXMgZHVyaW5nIGJvb3QgYWZ0ZXIgYW4gdW5jbGVh
biBzaHV0ZG93bi4gSXQgaHVuZyBhZnRlcndhcmRzLgogPiA+IAogPiA+IFsgICA5Ny4xNjI2NjVd
IFhGUzogQXNzZXJ0aW9uIGZhaWxlZDogeGZzX2RpcjJfc2ZfbG9va3VwKGFyZ3MpID09IEVOT0VO
VCwgZmlsZTogZnMveGZzL3hmc19kaXIyX3NmLmMsIGxpbmU6IDM1OAogPiA+IFsgICA5Ny4xNjQ2
NDZdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQogPiAKID4gSSBqdXN0IHJl
cHJvZHVjZWQgdGhpcyBieSBjaGFuY2UuIEkga25vdyBleGFjdGx5IHdoYXQgSSB3YXMgZG9pbmcK
ID4gd2hlbiBpdCB3ZW50IGJhbmcsIHNvIEkgbWlnaHQgYmUgYWJsZSB0byByZWR1Y2UgaXQgZnJv
bSBzY2F0dGVyZ3VuCiA+IGJsYXN0IHRlc3RpbmcgdG8gYmUgYWJsZSB0byByZXByb2R1Y2UgaXQg
b24gZGVtYW5kLgoKSSB4ZnNfcmVwYWlyJ2QgdGhhdCBkaXNrIGEgd2VlayBvciBzbyBiYWNrLCBh
bmQgaGF2ZSBiZWVuIGZpbmUgdW50aWwgdG9kYXkgd2hlbi4uCgooMTY6MjI6NTc6cm9vdEB6ZXJv
c3VtOnRtcC42KSMgbGwKbHM6IGNhbm5vdCBhY2Nlc3MgOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0
b3J5CnRvdGFsIDAKPz8/Pz8/Pz8/PyA/ID8gPyA/ICAgICAgICAgICAgPyA/CigxNjoyMjo1ODpy
b290QHplcm9zdW06dG1wLjYpIyBjZCAuLgooMTY6MjM6MDY6cm9vdEB6ZXJvc3VtOnRtcCkjIHJt
IC1yZiB0bXAuNgpybTogY2Fubm90IHJlbW92ZSDigJh0bXAuNuKAmTogRGlyZWN0b3J5IG5vdCBl
bXB0eQooMTY6MjM6MTQ6cm9vdEB6ZXJvc3VtOnRtcCkjIGNkIC0KL2hvbWUvZGF2ZWovc3JjL3Ry
aW5pdHkvdG1wL3RtcC42CigxNjoyMzoyMzpyb290QHplcm9zdW06dG1wLjYpIyBzdGF0ICoKc3Rh
dDogY2Fubm90IHN0YXQg4oCYXDAyMOKAmTogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQoKSSBk
b24ndCBrbm93IGlmIHRoaXMgaXMgcmVzaWR1YWwgY3JhcCBmcm9tIHRoYXQgZmlyc3QgcHJvYmxl
bSB0aGF0IG5ldmVyIGdvdCBmaXhlZCB1cCwKb3Igc29tZXRoaW5nIG5ldy4KCkFueSBpZGVhcyA/
CgoJRGF2ZQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
eGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxt
YW4vbGlzdGluZm8veGZzCg==
