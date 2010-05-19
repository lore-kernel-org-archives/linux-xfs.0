Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4J4G8qT098701 for <xfs@oss.sgi.com>; Tue, 18 May 2010 23:16:08 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A71E3358DA2
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 21:18:26 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id SIDRAOmWZucoWcuZ
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 21:18:26 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C2E1A6C2B0
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 23:18:25 -0500 (CDT)
Message-ID: <4BF366C9.9050300@hardwarefreak.com>
Date: Tue, 18 May 2010 23:19:21 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
References: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>	<4BF1EC44.7070803@hardwarefreak.com>	<AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>	<4BF219A6.4010900@hardwarefreak.com>	<AANLkTim93-4YueMBizXKLGRFka2vwqzJzDx5_P5gs0bl@mail.gmail.com>	<AANLkTim17eZcbW3gCOdziY3-Vsyd-XjBkmWV875yOWIC@mail.gmail.com>	<1274201857.17233.144.camel@montana.filmlight.ltd.uk>
	<AANLkTimZnSIrjAsboL5AgZPRPl3qzCz0DyfE8cEp6KmO@mail.gmail.com>
In-Reply-To: <AANLkTimZnSIrjAsboL5AgZPRPl3qzCz0DyfE8cEp6KmO@mail.gmail.com>
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

big beer put forth on 5/18/2010 5:43 PM:

> Strangely enough I was told by Hitachi that they licensed XFS from
> SGI, so they don't have any GPL code to give back.

IIRC (and IANAL) any version of XFS, with the exception of CXFS, running on
Linux is GPL'd code.  There is no such beast as non GPL XFS on Linux.

For that SGI licensing statement to be true, they've have to be running XFS
on IRIX, which means they'd need an IRIX license as well.  Not to mention
that IRIX only runs on MIPS hardware, and only SGI MIPS hardware.  This HDS
storage blade is x86.

It seems whoever told you that is misinformed or is being disingenuous in
order to avoid assisting you.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
