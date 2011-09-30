Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8U88HpG248927
	for <linux-xfs@oss.sgi.com>; Fri, 30 Sep 2011 03:08:17 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF81219D243
	for <linux-xfs@oss.sgi.com>; Fri, 30 Sep 2011 01:08:15 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id D9VPknqYW9Qvzdhn
	for <linux-xfs@oss.sgi.com>; Fri, 30 Sep 2011 01:08:15 -0700 (PDT)
Received: by fxh2 with SMTP id 2so2827798fxh.26
	for <linux-xfs@oss.sgi.com>; Fri, 30 Sep 2011 01:08:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 Sep 2011 13:38:15 +0530
Message-ID: <CAAjPY7YmTQu_z_9Gz89hh7S9stQKhFzon69X0Uxad2St8PrHLg@mail.gmail.com>
Subject: Need Assistance on using xattr
From: Parag Amritkar <paragamritkar@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9036954020369574116=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

--===============9036954020369574116==
Content-Type: multipart/alternative; boundary=00151747b378932fda04ae242087

--00151747b378932fda04ae242087
Content-Type: text/plain; charset=ISO-8859-1

i,We r working on inherent encryption decryption in kernel,nw we r stucked
upon where to store key of encryption. Can we store it in xattr of that file
? Will it be secure? Please reply as early as possible. This is our Project
Abstract->

Abstract:

In today's world securing file data is very important. The proposed Secure
File System (SecFS), we will be providing file data security using
cryptographic techniques in a transparent and convenient way. The proposed
SecFS pushes encryption services into the Linux kernel space, mounting it
between the virtual file system layer and underlying file system. After
SecFS is integrated with the Linux operating system (OS), it enables OS to
provide file data security as its inherent functionality. SecFS requires
that the user creates a directory and name it with the prefix 'ecrypt' to
store the encrypted file data, such as ecryptdir. Any directory on the
system with the prefix 'ecrypt' will basically tells the system that the
newly created directory will contain encrypted data. All files destined to
be saved on this directory will be transparently encrypted on the fly
without any user intervention. SecFS will be fully compatible with all
underlying storage file systems.

Please reply soon.

   Yours Sincerely
  Parag S. Amritkar

--00151747b378932fda04ae242087
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

i,We
 r working on inherent encryption decryption in kernel,nw we r stucked=20
upon where to store key of encryption. Can we store it in xattr of that=20
file ? Will it be secure? Please reply as early as possible. This is our
 Project=20
Abstract-&gt;<br><div>
<br> Abstract:<br> <br> In today&#39;s world securing file data is very=20
important. The proposed Secure File System (SecFS), we will be providing
 file data security using cryptographic techniques in a transparent and=20
convenient way. The proposed SecFS pushes encryption services into the=20
Linux kernel space, mounting it between the virtual file system layer=20
and underlying file system. After SecFS is integrated with the Linux=20
operating system (OS), it enables OS to provide file data security as=20
its inherent functionality. SecFS requires that the user creates a=20
directory and name it with the prefix &#39;ecrypt&#39; to store the encrypt=
ed=20
file data, such as ecryptdir. Any directory on the system with the=20
prefix &#39;ecrypt&#39; will basically tells the system that the newly crea=
ted=20
directory will contain encrypted data. All files destined to be saved on
 this directory will be transparently encrypted on the fly without any=20
user intervention. SecFS will be fully compatible with all underlying=20
storage file systems.</div>
<div>=A0</div><div>Please reply soon.</div><div>=A0</div><div>=A0=A0 Yours =
Sincerely</div><div>=A0 Parag S. Amritkar</div>

--00151747b378932fda04ae242087--


--===============9036954020369574116==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9036954020369574116==--
