Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C41D97CA3
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 10:58:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37CC2AC007
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:58:22 -0700 (PDT)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id VZ2sYOJMU3j3TUIi
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2016 08:58:19 -0700 (PDT)
Received: by mail-lf0-f53.google.com with SMTP id q132so77396658lfe.3
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:58:19 -0700 (PDT)
MIME-Version: 1.0
From: Danny Shavit <danny@zadarastorage.com>
Date: Wed, 22 Jun 2016 18:58:16 +0300
Message-ID: <CAC=x_0jDYb17Vh97Led7XXDiUMcUTJbpJ2Dw45gn=D0_w0K5VQ@mail.gmail.com>
Subject: xfs metadata overhead
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8742443453129545177=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8742443453129545177==
Content-Type: multipart/alternative; boundary=001a113ca6068203c20535e00154

--001a113ca6068203c20535e00154
Content-Type: text/plain; charset=UTF-8

Hi,

We are looking for a method to estimate the size of metadata overhead for a
given file system.
We would like to use this value as indicator for the amount of cache memory
a system for faster operation.
Are there any counters that are maintained in the on-disk data
structures like free space for examples?

-- 
Thank you,
Danny Shavit
Zadarastorage

--001a113ca6068203c20535e00154
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>We are looking for a method to esti=
mate the size of metadata overhead for a given file system.</div><div>We wo=
uld like to use this value as indicator for the amount of cache memory a sy=
stem for faster operation.</div><div>Are there any counters that are mainta=
ined in the on-disk data structures=C2=A0like free space for examples?</div=
><div><br></div><div>-- <br><div class=3D"gmail_signature" data-smartmail=
=3D"gmail_signature"><div dir=3D"ltr"><div>Thank you,<br></div>Danny Shavit=
<br></div><div>Zadarastorage</div></div>
</div></div>

--001a113ca6068203c20535e00154--


--===============8742443453129545177==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8742443453129545177==--
