Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6N9GXUN192545 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 04:16:33 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F1D946B7BF
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 02:19:35 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id qNOyCMl2SEXbOQik
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 02:19:35 -0700 (PDT)
Received: by fxm19 with SMTP id 19so5792630fxm.26
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 02:19:34 -0700 (PDT)
From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: 4k sector drives
Date: Fri, 23 Jul 2010 12:19:21 +0300
MIME-Version: 1.0
Message-Id: <201007231219.21880.eye.of.the.8eholder@gmail.com>
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

> Thanks, I did this, and it even worked for my other WDC 
> WD2002FYPS-01U1B0, which was on 12 seconds (the EARS were on 8s as you 
> said), and now all three drives have a 120s delay before parking. That 

I am glad it worked.

>should be sufficient. It didn't work for the VelociRaptor in my PC, just 
> to mention.

Disks from the Green series support some features that help the
enviroment. Among them is having lower rpm (usually 5400) and
the intellipark feature that you set to 120s.

If i am not mistaken, VelociRaptor is the low latency 10K rpm
drive, so it's not surprising that it doesn't support this. Only
drives from the Green series do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
