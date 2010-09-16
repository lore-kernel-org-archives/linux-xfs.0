Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GLqISV018652 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 16:52:18 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3A0F1D8A736
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 14:53:08 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id EmT84ETV5Rlwd4sD
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 14:53:08 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C3E1F6C0B8
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 16:53:07 -0500 (CDT)
Message-ID: <4C9291C3.7000709@hardwarefreak.com>
Date: Thu, 16 Sep 2010 16:53:07 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: LWN.net article: creating 1 billion files -> Tests we did
References: <201008191312.49346@zmi.at>
	<20100916121350.3ab30ca5@harpe.intellique.com>
In-Reply-To: <20100916121350.3ab30ca5@harpe.intellique.com>
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

Emmanuel Florac put forth on 9/16/2010 5:13 AM:

> Test run on a dual Opteron quad core, 16 GB RAM, kernel 2.6.32.11
> x86_64...

This is a test of storage system performance, and you left out the
storage array specs?  By doing so it seems you're stating the underlying
storage is not relevant to the results.

So, are you saying I should be able to duplicate your results with that
dual Opty system, but using an md RAID0 stripe over 8x2TB SATA disks
connected to two $60 4 port SiI 3124 PCIe x1 cards?

-- 
Stan



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
