Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4FDA800C
	for <linux-xfs@oss.sgi.com>; Fri, 19 Jul 2013 03:52:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A5D6C8F8033
	for <linux-xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:52:53 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id hETRPCOAy7Kn7FQm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:52:52 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	r6J8qnuY078817
	for <linux-xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:52:51 -0700
Message-ID: <51E8FE5F.8030107@tlinx.org>
Date: Fri, 19 Jul 2013 01:52:47 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: choice of 'namespace' for ACL's 
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
To: Linux-Xfs <linux-xfs@oss.sgi.com>

CgoKSSB3YXMgbG9va2luZyBhdCB0aGUgYXR0ciBhbmQgaXQgbGVmdCBtZSBhIGJpdCBwdXp6bGVk
LgoKKDEpIE9mIG1pbm9yIGNvbnNpZGVyYXRpb24sIHdhcyB0aGUgc3RhdGVtZW50IGFib3V0ICd2
YWx1ZXMgY2FuIGJlIHVwCnRvIDY0S0InLi4uICBCdXQgdGhlcmUgaXMgbm8gbWVudGlvbiBvZiBo
b3cgbWFueSBuYW1lcyBjYW4gYmUgcHJlc2VudApvciBpZiB0aGVyZSBpcyBhIGN1bXVsYXRpdmUg
bWF4aW11bSBvbiB0aGUgbmFtZXMgb3Igb24gdGhlIGRhdGEuICBJIHRob3VnaHQKSSByZW1lbWJl
cmVkIHRoZXJlIHdhcywgYnV0IGFsbCBJIGZvdW5kIHdhcyBsaW1pdHMgb24gc2luZ2xlIGRhdHVt
cy4KCigyKSBBIG1vcmUgY29uZnVzaW5nIGlzc3VlIHdhcyB0aGUgYml0IGRlc2NyaWJpbmcgWEZT
IGFzIGhhdmluZyAyCmRpc2pvaW50IGF0dHJpYgpuYW1lc3BhY2VzLCBidXQgbGF0ZXIgdGhlIHNl
bGVjdG9ycyBmb3IgdGhlIG5hbWVzIHNwYWNlcyBhcmUgZ2l2ZW4gYXMKW25vbmVdID0gdXNlciwg
W1JdID0gcm9vdCwgYW5kIFtTXSA9IFNlY3VyaXR5IC0tIG1ha2luZyBpdCBzb3VuZCBsaWtlIDMK
ZGlzam9pbnQKbmFtZXNwYWNlcy4gIFNvLCBob3cgbWFueSBhdHRyaWIgbmFtZXNwYWNlcyBhcmUg
dGhlaXIsIDIgb3IgMz8KCigzKSBBZGRpbmcgYSBiaXQgbW9yZSB0byBwaXF1ZSBteSBjdXJpb3Np
dHksIEkgbm90aWNlZCB0aGF0CmZpbGUgQUNMJ3Mgd2VyZSBpbiB0aGUgcm9vdC1uYW1lc3BhY2Us
IG5vdCB0aGUgc2VjdXJpdHkgYXR0cmlidXRlIG5hbWVzcGFjZS4KV291bGRuJ3QgaXQgbWFrZSBt
b3JlIHNlbnNlIGlmIGFjY2VzcyBjb250cm9sIHdhcyBjb25zaWRlcmVkIGEgc2VjdXJpdHkKYXR0
cmliPwoKCkFub3RoZXIgcG9pbnQgb2YgY29uZnVzaW9uIHdhcyBvbiB0aGUgYXR0cmliIG1hbnBh
Z2Ugd2hlcmUgaXQgc2F5czoKQ0FWRUFUUwogICAgICAgVGhlIGxpc3Qgb3B0aW9uIHByZXNlbnQg
aW4gdGhlIElSSVggdmVyc2lvbiBvZiB0aGlzIGNvbW1hbmQgaXMKbm90IHN1cOKAkAogICAgICAg
cG9ydGVkLiAgZ2V0ZmF0dHIgcHJvdmlkZXMgYSBtZWNoYW5pc20gdG8gcmV0cmlldmUgYWxsIG9m
IHRoZQphdHRyaWJ1dGUKICAgICAgIG5hbWVzLgoKKDQpIFdoYXQgZG9lcyB0aGF0IG1lYW4/ICBp
LmUuOgoKd2hlbiBJIHVzZSBhdHRyIC1sOgoKPiBhdHRyIC1sIG9wZW5zc2gtNi4xcDEtaHBuMTN2
MTQuZGlmZi5negpBdHRyaWJ1dGUgIkRPU0FUVFJJQiIgaGFzIGEgNTYgYnl0ZSB2YWx1ZSBmb3Ig
b3BlbnNzaC02LjFwMS1ocG4xM3YxNC5kaWZmLmd6CkF0dHJpYnV0ZSAiU0FNQkFfUEFJIiBoYXMg
YSAyNSBieXRlIHZhbHVlIGZvciBvcGVuc3NoLTYuMXAxLWhwbjEzdjE0LmRpZmYuZ3oKCm9yIGFk
ZGludCB0aGUgLXEgc3dpdGNoIHdpdGggLWw6Cgo+IGF0dHIgLXFsIG9wZW5zc2gtNi4xcDEtaHBu
MTN2MTQuZGlmZi5negpET1NBVFRSSUIKU0FNQkFfUEFJCi0tLQpEb2VzICJub3Qgc3VwcG9ydGVk
IiBtZWFuIHRoYXQgaXQgaXMgd29ya2luZyBieSBhY2NpZGVudCBhbmQgbWF5IGJlCnJlbW92ZWQg
ICAuLi4gYmVjYXVzZS4uLi5bX19fX19fX19fPz8/X19fX19fXT8gCgpnZXRmYXR0ciBpcyBzdWdn
ZXN0ZWQgYXMgYSByZXBsYWNlbWVudCwgYnV0Cig1KSBob3cgY2FuIGl0IGJlIHVzZWQgdG8gbGlz
dCB0aGUgbGVuZ3Rocz8gIGFuZAooNikgaG93IGNhbiBpdCBiZSB1c2VkIHRvIGxpc3QgdGhlIFNl
Y3VyaXR5IG9yIFJvb3QgbmFtZXNwYWNlcz8KClNvcnJ5IGZvciBhbGwgdGhlIFEncywgYnV0IGl0
IHNlZW1lZCBsaWtlIHRoZXJlIHdlcmUgc29tZSBtaXNzaW5nIHBpZWNlcy4uLgoKCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
