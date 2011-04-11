Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3B2eCEk063012 for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 21:40:13 -0500
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?=
	<panweiping3@gmail.com>
Subject: [PATCH 2/2] xfs:remove a warning in xfs_buf_readahead()
Date: Mon, 11 Apr 2011 10:44:53 +0800
Message-Id: <1302489893-31676-1-git-send-email-panweiping3@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com, xfs-masters@oss.sgi.com, dchinner@redhat.com, hch@lst.de, jaxboe@fusionio.com, tj@kernel.org, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, "=?UTF-8?q?Weiping=20Pan ?= (=E6=BD=98=E5=8D=AB=E5=B9=B3)" <panweiping3@gmail.com>

L2hvbWUvcHdwL215c3ZuL2xpbnV4L2xpbnV4LTIuNi9mcy94ZnMvbGludXgtMi42L3hmc19idWYu
YzogSW4gZnVuY3Rpb24K4oCYeGZzX2J1Zl9yZWFkYWhlYWTigJk6Ci9ob21lL3B3cC9teXN2bi9s
aW51eC9saW51eC0yLjYvZnMveGZzL2xpbnV4LTIuNi94ZnNfYnVmLmM6NjYwOjI3OiB3YXJuaW5n
Ogp1bnVzZWQgdmFyaWFibGUg4oCYYmRp4oCZCgpTaWduZWQtb2ZmLWJ5OiBXZWlwaW5nIFBhbijm
vZjljavlubMpIDxwYW53ZWlwaW5nM0BnbWFpbC5jb20+Ci0tLQogZnMveGZzL2xpbnV4LTIuNi94
ZnNfYnVmLmMgfCAgICAyIC0tCiAxIGZpbGVzIGNoYW5nZWQsIDAgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy94ZnMvbGludXgtMi42L3hmc19idWYuYyBiL2Zz
L3hmcy9saW51eC0yLjYveGZzX2J1Zi5jCmluZGV4IDVlYTQwMjAuLmExMjViMzIgMTAwNjQ0Ci0t
LSBhL2ZzL3hmcy9saW51eC0yLjYveGZzX2J1Zi5jCisrKyBiL2ZzL3hmcy9saW51eC0yLjYveGZz
X2J1Zi5jCkBAIC02NTcsOCArNjU3LDYgQEAgeGZzX2J1Zl9yZWFkYWhlYWQoCiAJeGZzX29mZl90
CQlpb2ZmLAogCXNpemVfdAkJCWlzaXplKQogewotCXN0cnVjdCBiYWNraW5nX2Rldl9pbmZvICpi
ZGk7Ci0KIAlpZiAoYmRpX3JlYWRfY29uZ2VzdGVkKHRhcmdldC0+YnRfYmRpKSkKIAkJcmV0dXJu
OwogCi0tIAoxLjcuNAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
