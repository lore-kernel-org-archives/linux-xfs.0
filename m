Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A3MgNX128757 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 22:22:43 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AC5F17C93F2
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 20:23:28 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id aEDxVQ0MwKAiy3K8
	for <xfs@oss.sgi.com>; Thu, 09 Sep 2010 20:23:28 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id CACD26C011
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 22:23:26 -0500 (CDT)
Message-ID: <4C89A4AE.2070904@hardwarefreak.com>
Date: Thu, 09 Sep 2010 22:23:26 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: fragmentation question
References: <C8AEA6E3.6E2E%bchang@greenplum.com>
In-Reply-To: <C8AEA6E3.6E2E%bchang@greenplum.com>
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

Brady Chang put forth on 9/9/2010 4:59 PM:
> thanks guys for the feedback.
> iostat shows balanced io between two filesystems.

Can we please see the "iostat -x" output for the duration of the TPC-H
run _only_?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
