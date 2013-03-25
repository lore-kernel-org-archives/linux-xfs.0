Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8EBD97F52
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 12:01:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5AC7330406A
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 10:00:57 -0700 (PDT)
Received: from mail-ve0-f180.google.com (mail-ve0-f180.google.com
	[209.85.128.180]) by cuda.sgi.com with ESMTP id
	c9poYi2mQ5RdwnkM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Mar 2013 10:00:56 -0700 (PDT)
Received: by mail-ve0-f180.google.com with SMTP id c13so3088172vea.39
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 10:00:55 -0700 (PDT)
Message-ID: <515082C3.2000006@binghamton.edu>
Date: Mon, 25 Mar 2013 13:00:51 -0400
From: Dave Hall <kdhall@binghamton.edu>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard>
In-Reply-To: <20130316072126.GG6369@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)


On 03/16/2013 03:21 AM, Dave Chinner wrote:
> Using perf to profile the kernel while the cp -al workload is
> running will tell use exactly where the CPU is being burnt. That
> will confirm the analysis, or point us at some other issue that is
> causing excessive CPU burn...
>
Dave,  which perf command(s) would you like me to run.  (I'm familiar 
with the concept behind this kind of tool, but I haven't worked with 
this one before).

Also, what would you like me to do with the xfs_db freesp output for 26 
agroups?

-Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
