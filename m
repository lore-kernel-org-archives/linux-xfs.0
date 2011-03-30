Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2U3Nxvo005812 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 22:23:59 -0500
From: Pan Weiping <panweiping3@gmail.com>
Subject: [PATCH] delete a warning in function xfs_buf_readahead
Date: Wed, 30 Mar 2011 11:28:06 +0800
Message-Id: <1301455686-21517-1-git-send-email-panweiping3@gmail.com>
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
To: aelder@sgi.com, xfs-masters@oss.sgi.com, dchinner@redhat.com, hch@lst.de, tj@kernel.org, jaxboe@fusionio.com
Cc: Pan Weiping <panweiping3@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

L2hvbWUvcHdwL215c3ZuL2xpbnV4L2xpbnV4LTIuNi9mcy94ZnMvbGludXgtMi42L3hmc19idWYu
YzogSW4gZnVuY3Rpb24K4oCYeGZzX2J1Zl9yZWFkYWhlYWTigJk6Ci9ob21lL3B3cC9teXN2bi9s
aW51eC9saW51eC0yLjYvZnMveGZzL2xpbnV4LTIuNi94ZnNfYnVmLmM6NjYwOjI3OiB3YXJuaW5n
Ogp1bnVzZWQgdmFyaWFibGUg4oCYYmRp4oCZClNpZ25lZC1vZmYtYnk6IFBhbiBXZWlwaW5nIDxw
YW53ZWlwaW5nM0BnbWFpbC5jb20+Ci0tLQogZnMveGZzL2xpbnV4LTIuNi94ZnNfYnVmLmMgfCAg
ICAyIC0tCiAxIGZpbGVzIGNoYW5nZWQsIDAgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9mcy94ZnMvbGludXgtMi42L3hmc19idWYuYyBiL2ZzL3hmcy9saW51eC0y
LjYveGZzX2J1Zi5jCmluZGV4IDU5NmJiMmMuLmQ5MTcxNDYgMTAwNjQ0Ci0tLSBhL2ZzL3hmcy9s
aW51eC0yLjYveGZzX2J1Zi5jCisrKyBiL2ZzL3hmcy9saW51eC0yLjYveGZzX2J1Zi5jCkBAIC02
NTcsOCArNjU3LDYgQEAgeGZzX2J1Zl9yZWFkYWhlYWQoCiAJeGZzX29mZl90CQlpb2ZmLAogCXNp
emVfdAkJCWlzaXplKQogewotCXN0cnVjdCBiYWNraW5nX2Rldl9pbmZvICpiZGk7Ci0KIAlpZiAo
YmRpX3JlYWRfY29uZ2VzdGVkKHRhcmdldC0+YnRfYmRpKSkKIAkJcmV0dXJuOwogCi0tIAoxLjcu
NAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
