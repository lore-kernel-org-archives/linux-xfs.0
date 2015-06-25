Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 911D67F59
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 11:41:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71D2A8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 09:41:29 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id O0wY6EM9EhVg4pbr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 09:41:27 -0700 (PDT)
Date: Thu, 25 Jun 2015 18:41:32 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Message-ID: <20150625184132.773a5ecd@harpe.intellique.com>
In-Reply-To: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
MIME-Version: 1.0
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
To: Rasmus Borup Hansen <rbh@intomics.com>
Cc: xfs@oss.sgi.com

TGUgV2VkLCAyNCBKdW4gMjAxNSAwOTozOTo0NSArMDIwMApSYXNtdXMgQm9ydXAgSGFuc2VuIDxy
YmhAaW50b21pY3MuY29tPiDDqWNyaXZhaXQ6Cgo+IE9ubHkgdGhlIGZpcnN0IDIwIGxpbmVzIGFy
ZSBpbmNsdWRlZC4gVGhlcmUgYXJlIGN1cnJlbnRseSAyNTAwMDArCj4gbW9yZSBsaW5lcyB3aXRo
ICJkaXJlY3RvcnkgZmxhZ3Mgc2V0IG9uIG5vbi1kaXJlY3RvcnkgaW5vZGUiIGFuZCB0aGUKPiBj
aGVjayBpcyBzdGlsbCBydW5uaW5nICh0aGUgbW9zdGx5IHNtYWxsIGZpbGVzIHRha2UgdXAgYXJv
dW5kIDMwIFRCLAo+IHNvIGl0J2xsIHByb2JhYmx5IHRha2UgYSB3aGlsZSkuCj4gCj4gSSByZWNl
bnRseSBlbmFibGVkIHVzZXIgYW5kIHByb2plY3QgcXVvdGEgYW5kIHVwZGF0ZWQgZnJvbSAzLjEz
LjAtNTMuCj4gVGhlIGZpbGUgc3lzdGVtIGhhcyBiZWVuIGhlYXZpbHkgdXNlZCBmb3IgdGhlIGxh
c3QgbW9udGggb3Igc28uCj4gCj4gRG9lcyBhbnlvbmUgaGF2ZSBhbnkgdGhvdWdodHMgb24gdGhp
cz8gSSdtIHRlbXB0ZWQgdG8gc3RvcCB1c2luZwo+IHF1b3RhcyB3aGVuIHRoZSBmaWxlIHN5c3Rl
bSAoaG9wZWZ1bGx5KSB3b3JrcyBhZ2FpbiwgYXMgaXQncyBteQo+IGltcHJlc3Npb24gdGhhdCBw
cm9qZWN0IHF1b3RhcyBhcmUgbm90IHdpZGVseSB1c2VkLgoKRGlkIHlvdSBmaXJzdCB0cnkgcmVt
b3VudGluZyB0aGVuIHVubW91bnRpbmcgdGhlIHZvbHVtZSB0byBjbGVhciB0aGUKbG9nPyBUaGF0
IGNvdWxkIGNsZWFyIG91dCB4ZnNfcmVwYWlyIG91dHB1dC4KCi0tIAotLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
RW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAg
ICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRl
bGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20v
bWFpbG1hbi9saXN0aW5mby94ZnMK
