Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B56B27F85
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 19:16:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9685C304043
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 17:16:04 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id Z2eECuuSJz3KB9Dp
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 02 Feb 2014 17:16:03 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Extended attributes limit in Linux
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
Date: Sun, 2 Feb 2014 18:15:59 -0700
Message-Id: <83F9F221-9387-47D5-B67C-E9252056E408@colorremedies.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>
	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>
	<1391172723.4275.11.camel@ubuntu>	<52EBA783.1080801@oracle.com>
	<1391178074.4275.19.camel@ubuntu> <52EBB431.50301@oracle.com>
	<6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>
	<1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>
	<14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sun_Blood <sblood@gmail.com>
Cc: xfs@oss.sgi.com


On Feb 2, 2014, at 7:33 AM, Sun_Blood <sblood@gmail.com> wrote:
> I will make a bug report for rsync also that it should not try to copy files with EA bigger then the destination can handle. But it would be great if XFS could handle this files and be fully compatible with OS X backups.

What application(s) are creating such files on OS X? Or how are they coming to have such large extended attributes?


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
