Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7D9ojcD045275 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 04:50:46 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F143314CF29B
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 03:00:01 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 7yqBhmDMyoh3pn36
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 03:00:01 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 363CC6C3E2
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 04:51:09 -0500 (CDT)
Message-ID: <4C6516CA.2010602@hardwarefreak.com>
Date: Fri, 13 Aug 2010 04:56:26 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: observed significant performance improvement using "delaylog" in
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>	<201008122105.35787@zmi.at>
	<i41q43$6td$1@dough.gmane.org>
In-Reply-To: <i41q43$6td$1@dough.gmane.org>
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

Peter Niemayer put forth on 8/12/2010 4:46 PM:

> To me, as of today, XFS' big strength is performing good to
> excellent (while not always better than all other file-systems)
> in many use-cases - without worries about instability or immaturity.

+1  But don't forget the excellent tool set which I think is a little better
than those of the other filesystems.  XFS has the only functional/reliable
online defrag tool AFAIK.  The only 'missing' feature compared to the other
FSes is filesystem shrink ability, but for the majority of XFS users, I'm
guessing this isn't an issue as data sets are always growing.

Some benchmark results maybe worth a look:
http://btrfs.boxacle.net/repository/raid/2.6.35-rc5/2.6.35-rc5/

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
