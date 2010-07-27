Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R6dSVg170341 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:39:28 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E40A474E95
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 23:42:32 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id JjacbmuIIdwddfet
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 23:42:32 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id B5B686C309
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:42:31 -0500 (CDT)
Message-ID: <4C4E8151.8060403@hardwarefreak.com>
Date: Tue, 27 Jul 2010 01:48:49 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: filesystem shrinks after using xfs_repair
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>	<20100712134743.624249b2@harpe.intellique.com>	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>	<20100724005426.GN32635@dastard>	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>	<20100724023922.GP32635@dastard>	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>	<20100726034545.GE655@dastard>	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>	<20100726060604.GF7362@dastard>	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>	<20100726114940.7a97f29e@harpe.intellique.com>	<AE59CF1C-6E28-4468-892A-394AE324EEF0@ucsc.edu>	<20100726230653.5da272c1@galadriel.home>
	<89B1ECDD-E9F4-4044-953A-76987AAF8EFE@ucsc.edu>
In-Reply-To: <89B1ECDD-E9F4-4044-953A-76987AAF8EFE@ucsc.edu>
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

Eli Morris put forth on 7/27/2010 12:02 AM:
> Hi,
> 
> Thanks. I tried a Knoppix live DVD (latest version) today and it does seem to have xfs-progs, but I can't get it to recognize the lvm volume that the filesystem is on. LVM2 programs are available, but 'vgscan  --mknodes' turns up nothing. I'll continue to look into it, but if anyone has any ideas, please let me know.

www.sysresccd.org

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
