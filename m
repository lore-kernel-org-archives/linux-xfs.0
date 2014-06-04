Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 159557F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 12:33:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4F248F8049
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 10:33:53 -0700 (PDT)
Received: from mail-qg0-f47.google.com (mail-qg0-f47.google.com
	[209.85.192.47]) by cuda.sgi.com with ESMTP id qvOjmmIXN9hysBHt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Jun 2014 10:33:53 -0700 (PDT)
Received: by mail-qg0-f47.google.com with SMTP id j107so16140906qga.34
	for <xfs@oss.sgi.com>; Wed, 04 Jun 2014 10:33:52 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 4 Jun 2014 23:03:52 +0530
Message-ID: <CAMqKDv6Ki0vxBkbAJFyZ19C0SqBihSc6kii8cjagtOFF7ECi5A@mail.gmail.com>
Subject: Why xfs is not permitted on bootable partitions in RHEL 7?
From: Dhiraj Bhor <dhirajbhor21@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5111534196603927452=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5111534196603927452==
Content-Type: multipart/alternative; boundary=001a11c119e230697704fb06088e

--001a11c119e230697704fb06088e
Content-Type: text/plain; charset=ISO-8859-1

Hi all,
I am new to this mailing list. I came across a issue with xfs while
installing RHEL 7.
When I created "custom layout" and created /boot partition with xfs file
system it shown me error as "/boot filesystem cannot be of type xfs".
Why xfs is not allowed on /boot partition?
Help me resolving this issue.
Thanks,
Dhiraj

--001a11c119e230697704fb06088e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi all,</div><div>I am new to this mailing list. I ca=
me across a issue with xfs while installing RHEL 7.</div><div>When I create=
d=A0&quot;custom layout&quot; and created /boot partition=A0with xfs file s=
ystem it shown me error as &quot;/boot filesystem cannot be of type xfs&quo=
t;.</div>
<div>Why xfs is not allowed on /boot partition?</div><div>Help me resolving=
 this issue.</div><div>Thanks,</div><div>Dhiraj</div></div>

--001a11c119e230697704fb06088e--


--===============5111534196603927452==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5111534196603927452==--
