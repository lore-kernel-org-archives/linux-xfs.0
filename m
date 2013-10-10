Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 266AB7F4E
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 18:56:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD221AC001
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 16:56:20 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 4QSibWe6NNmyIQ1J for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 16:56:19 -0700 (PDT)
Received: from zmail20.collab.prod.int.phx2.redhat.com
	(zmail20.collab.prod.int.phx2.redhat.com [10.5.83.23])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r9ANuJ0T027558
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 19:56:19 -0400
Date: Thu, 10 Oct 2013 19:56:19 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1803090820.5630526.1381449379093.JavaMail.root@redhat.com>
In-Reply-To: <408976477.5626180.1381447471755.JavaMail.root@redhat.com>
References: <20131010133811.GK32337@riva.ucam.org>
	<408976477.5626180.1381447471755.JavaMail.root@redhat.com>
Subject: Re: Bug#725971: xfsprogs: config.guess/config.sub out of date for
	arm64
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_5630524_334529076.1381449379089"
Reply-To: Nathan Scott <nathans@debian.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS <xfs@oss.sgi.com>

------=_Part_5630524_334529076.1381449379089
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


----- Original Message -----
> ...
> Have tested this out here & works just fine - please merge.
> 

Also, the attached fixes a warning in the deb build for me,
plus some trivial cleanup in the release script.

cheers.

--
Nathan

------=_Part_5630524_334529076.1381449379089
Content-Type: text/x-patch; name=xfsprogs-patchlet
Content-Disposition: attachment; filename=xfsprogs-patchlet
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RlYmlhbi9jaGFuZ2Vsb2cgYi9kZWJpYW4vY2hhbmdlbG9nCmluZGV4IDEy
NTQ3MWQuLjA5MzVlMDcgMTAwNjQ0Ci0tLSBhL2RlYmlhbi9jaGFuZ2Vsb2cKKysrIGIvZGViaWFu
L2NoYW5nZWxvZwpAQCAtMiw3ICsyLDcgQEAgeGZzcHJvZ3MgKDMuMS4xMSkgdW5zdGFibGU7IHVy
Z2VuY3k9bG93CiAKICAgKiBOZXcgdXBzdHJlYW0gcmVsZWFzZQogCi0gLS0gTmF0aGFuIFNjb3R0
IDxuYXRoYW5zQGRlYmlhbi5vcmc+IFdlZCwgMDggTWF5IDIwMTMgMTI6NTk6NTYgLTA1MDAKKyAt
LSBOYXRoYW4gU2NvdHQgPG5hdGhhbnNAZGViaWFuLm9yZz4gIFdlZCwgMDggTWF5IDIwMTMgMTI6
NTk6NTYgLTA1MDAKIAogeGZzcHJvZ3MgKDMuMS45KSB1bnN0YWJsZTsgdXJnZW5jeT1sb3cKIApk
aWZmIC0tZ2l0IGEvcmVsZWFzZS5zaCBiL3JlbGVhc2Uuc2gKaW5kZXggZGI1Y2M3NC4uZTIwOTU3
NCAxMDA3NTUKLS0tIGEvcmVsZWFzZS5zaAorKysgYi9yZWxlYXNlLnNoCkBAIC0xLDYgKzEsNiBA
QAotIyEvYmluL2Jhc2gKKyMhL2Jpbi9zaAogIwotIyBBdXRvbWF0ZSBnZW5lcmF0aW9uIGEgbmV3
IHJlbGVhc2UKKyMgQXV0b21hdGUgZ2VuZXJhdGlvbiBvZiBhIG5ldyByZWxlYXNlCiAjCiAKIC4g
Li9WRVJTSU9OCg==
------=_Part_5630524_334529076.1381449379089
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_5630524_334529076.1381449379089--
