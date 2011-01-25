Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PNUT9o102731 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 17:30:29 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50BD7291AA6
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 15:32:53 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id zob5aGBIQ3l8N664
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 15:32:53 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 948D06C0A8
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 17:32:52 -0600 (CST)
Message-ID: <4D3F5DA4.3070809@hardwarefreak.com>
Date: Tue, 25 Jan 2011 17:32:52 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: version dependency question
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

Is the delaylog fstab mount option dependent on anything external to the kernel,
such as the mount command, or xfsprogs?  Do these need to be updated to take
advantage of '-o delaylog'?

I'm currently running vanilla 2.6.34.1 underneath Debian Lenny, whose mount and
xfsprogs (and everything for that matter) are quite old.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
