Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C4707F86
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 01:39:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89437304051
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 23:39:58 -0800 (PST)
Received: from mail.stepping-stone.ch (mail.stepping-stone.ch
	[194.176.109.206]) by cuda.sgi.com with ESMTP id
	X5XqCVYUCNi2bAj5 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Nov 2013 23:39:53 -0800 (PST)
Message-ID: <1384069188.245087.68.camel@storm>
Subject: Setting project quotas on special files
From: Tiziano =?ISO-8859-1?Q?M=FCller?= <tiziano.mueller@stepping-stone.ch>
Date: Sun, 10 Nov 2013 08:39:48 +0100
Mime-Version: 1.0
Reply-To: tiziano.mueller@stepping-stone.ch
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
To: xfs@oss.sgi.com

SGkgZXZlcnlvbmUKCkl0IHN0YXJ0ZWQgd2l0aCB0aGUgZm9sbG93aW5nIGVycm9yOgoKICAgZGV2
ICMgY3AgLWFsIGR2ZCBkdmQyCiAgIGNwOiBjYW5ub3QgY3JlYXRlIGhhcmQgbGluayDigJhkdmQy
4oCZIHRvIOKAmGR2ZOKAmTogSW52YWxpZCBjcm9zcy1kZXZpY2UgbGluawoKImR2ZCIgaXMgaW4g
dGhpcyBjYXNlIGEgc3ltbGluayAoYnV0IEkgYWxzbyBkaWQgdGhlIHRlc3Qgd2l0aCBzcGVjaWFs
CmRldmljZXMpLgoKV2hhdCBJIGRpZCB3YXM6IGNvcHkgdGhhdCBzeW1saW5rIGZyb20gc29tZXdo
ZXJlIGVsc2UsIHRyeWluZyB0byB0dXJuIG9uCnByb2plY3QgcXVvdGFzIG9uIGEgcGFyZW50IGRp
cmVjdG95IG9mIHRoYXQgImRldiIgZGlyZWN0b3J5IHdoaWNoIGdpdmVzCm1lOgoKICB4ZnNfcXVv
dGE6IHNraXBwaW5nIHNwZWNpYWwgZmlsZSAvdmFyL2Zvby9kZXYvZHZkCgpXaGVuIEkgZXhhbWlu
ZSB0aGUgaW5vZGUgdXNpbmcgeGZzX2RiIEkgZ2V0IGZvciBteSAiZHZkIiBzeW1saW5rOgoKICBj
b3JlLnByb2ppZF9sbyA9IDAKICBjb3JlLnByb2ppZF9oaSA9IDAKCldoZW4gSSBjcmVhdGUgYSBu
ZXcgc3ltbGluayAiZm9vIiAod2l0aCB0aGUgc2FtZSB1aWQrZ2lkIGFzICJkdmQiKSBhbmQKZXhh
bWluZSBpdCdzIGlub2RlIHVzaW5nIHhmc19kYjoKCiAgY29yZS5wcm9qaWRfbG8gPSAyMzk4CiAg
Y29yZS5wcm9qaWRfaGkgPSA2MQoKV2hhdCBJIHRoZXJlZm9yZSBzZWVtIHRvIGVuY291bnRlciBp
cyB0aGUgcHJvYmxlbSBtZW50aW9uZWQgaW4geGZzX3F1b3RhCmZvciB0aGUgcHJvamVjdCBzdWJj
b21tYW5kOgoKICBBbiBhdHRlbXB0IHRvIGNyZWF0ZSBhIGhhcmQgbGluayB0byBhIGZpbGUgaW4g
dGhlIHRyZWUgd2lsbCBvbmx5IHN1Y2NlZWQgaWYgdGhlIHByb2plY3QgaWRlbnRp4oCQCiAgICAg
ICBmaWVyIG1hdGNoZXMgdGhlIHByb2plY3QgaWRlbnRpZmllciBmb3IgdGhlIHRyZWUuCgpJIGNv
dWxkIG5vdyB1c2UgeGZzX2lvIHRvIGZpeCBhbGwgc3BlY2lhbCBmaWxlcyBvbmNlIChzaW5jZSBu
ZXdseQpjcmVhdGVkIG9uZXMgd2lsbCBjYXJyeSB0aGUgcHJvamVjdCBpZCBkaXJlY3RseSksIGJ1
dCB3aHkgZG9lcwoieGZzX3F1b3RhIC14IC1jICdwcm9qZWN0IC1zIHRlc3QxJyAvdmFyIiBza2lw
IHNwZWNpYWwgZmlsZXMgaWYgaXQgaXMKY2xlYXJseSBwb3NzaWJsZSBhbmQgcmVxdWlyZWQgdG8g
c2V0IHRoZSBwcm9qZWN0IGlkIG9uIHRoZW0gdG8gaGF2ZQpoYXJkbGlua3Mgd29ya2luZyBhZ2Fp
biB3aXRoaW4gdGhlIHByb2plY3QgZGlyPwoKVGhhbmtzIGluIGFkdmFuY2UsCmJlc3QgcmVnYXJk
cywKVGl6aWFubwoKLS0gCnN0ZXBwaW5nIHN0b25lIEdtYkgKTmV1ZmVsZHN0cmFzc2UgOQpDSC0z
MDEyIEJlcm4KVGVsZWZvbjogKzQxIDMxIDMzMiA1MyA2Mwp3d3cuc3RlcHBpbmctc3RvbmUuY2gK
dGl6aWFuby5tdWVsbGVyQHN0ZXBwaW5nLXN0b25lLmNoCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
