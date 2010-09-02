Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o827ogFZ192642 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 02:50:42 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83AA81BF8884
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 00:51:22 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id OKTfGbLjQHXtld8h
	for <xfs@oss.sgi.com>; Thu, 02 Sep 2010 00:51:22 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id DD2896C004
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 02:51:21 -0500 (CDT)
Message-ID: <4C7F5779.30201@hardwarefreak.com>
Date: Thu, 02 Sep 2010 02:51:21 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
References: <201009010130.41500@zmi.at>
	<4C7DC21B.1040705@hardwarefreak.com>	<20100901034156.GQ705@dastard>
	<201009010945.59204@zmi.at> <20100902011744.GS705@dastard>
In-Reply-To: <20100902011744.GS705@dastard>
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

Dave Chinner put forth on 9/1/2010 8:17 PM:

> You'd need an entire ASIC, not an instruction ;)

More like an FPGA.  As we see on list, daily, the XFS code changes far
too rapidly for implementation in an ASIC.  ;)

Hay, there's a sales opportunity for SGI:  XFS on Virtex 7 FPGA on a
PCIe accelerator board. :)  Oh, wait, what about RASC?  Just put in on
there. :P

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
