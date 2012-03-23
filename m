Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NDvpUH188740 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 08:57:51 -0500
Received: from mail.vlasiu.net (mail.vlasiu.net [213.157.175.46]) by
	cuda.sgi.com with ESMTP id 6iHlXW0gAy7kvhDi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Mar 2012 06:57:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id 3D5E97E06D
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 15:57:46 +0200 (EET)
Received: from mail.vlasiu.net ([127.0.0.1])
	by localhost (mail.vlasiu.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id JPi1CdYahZeM for <xfs@oss.sgi.com>;
	Fri, 23 Mar 2012 15:57:44 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id E04267E06D
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 15:57:43 +0200 (EET)
Date: Fri, 23 Mar 2012 15:57:37 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: xfs_fsr XFS_IOC_SWAPEXT failed
Message-ID: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Can somebody explain the reason for this error:

# xfs_fsr -vvv \{aed7ec6a-7659-494a-8837-cabce9e6f506\}.vdi                                                            
{aed7ec6a-7659-494a-8837-cabce9e6f506}.vdi
XFS_IOC_SWAPEXT failed: {aed7ec6a-7659-494a-8837-cabce9e6f506}.vdi: Invalid argument

I can copy this file and there are no errors reported by virtualbox.
The kernel version is 3.3.0.

Thank you.


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 0xE684206E
// OpenGPG-Fingerprint: 0C3D 9F8B 725D E243 CB3C 8428 796A DB1F E684 206E
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9sgVEACgkQeWrbH+aEIG4yJwCdEQ+7j+dEO83ThG6LqRXujyZ8
VBcAn2EjjzhaUqDcvVAOXuhiic91DEJg
=ZAR0
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
