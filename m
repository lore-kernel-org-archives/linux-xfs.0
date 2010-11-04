Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA4AM1OM141407 for <xfs@oss.sgi.com>; Thu, 4 Nov 2010 05:22:01 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1053B152E37
	for <xfs@oss.sgi.com>; Thu,  4 Nov 2010 03:23:24 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 84GCWeCTJ6nqa3YD
	for <xfs@oss.sgi.com>; Thu, 04 Nov 2010 03:23:24 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 08D6D6C0D8
	for <xfs@oss.sgi.com>; Thu,  4 Nov 2010 05:23:23 -0500 (CDT)
Message-ID: <4CD2899B.5040101@hardwarefreak.com>
Date: Thu, 04 Nov 2010 05:23:23 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS mounting fails on MIPS
References: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
In-Reply-To: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
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

Ajeet Yadav put forth on 11/4/2010 12:57 AM:

> Filesystem "sda2": Corruption of in-memory data detected.

That would lead me to believe you have a hardware problem.  Could be a
bad DIMM, a bad board, defective PSU with too much voltage swing, etc,
etc.  I'd start by replacing the DIMM(s) and go from there with process
of elimination.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
