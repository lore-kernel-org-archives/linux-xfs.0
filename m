Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GAmFMr242957 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 05:48:16 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CB7C148729C
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:50:10 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id Q21Cn5ChbC0pgF7M
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:50:10 -0700 (PDT)
Received: from cl-840.mbx-01.si.sixxs.net ([2001:15c0:65ff:347::2])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.71)
	(envelope-from <mw@dermichi.com>) id 1O2j7g-0005JH-99
	for xfs@oss.sgi.com; Fri, 16 Apr 2010 12:50:08 +0200
Message-ID: <4BC840DF.2000501@dermichi.com>
Date: Fri, 16 Apr 2010 12:50:07 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8F871C.60802@dermichi.com> <201004161010.14607@zmi.at>
In-Reply-To: <201004161010.14607@zmi.at>
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

Hi Michael!
> 
> I've had crashes once with xfs_fsr, only to find that my filesystem was 
> a bit broken (which lead to an improved xfs_repair, btw).
> 
> Michael, did you try to xfs_repair once to check if you got errors?
> 
Yes, as already said before i ran xfs_repair (version 3.1.1) on the fs
and it reported no errors. For the moment i had to disable xfs_fsr on
that server since it is a production machine.

with kind regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
