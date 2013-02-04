Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 566417F52
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 03:01:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42CAB304066
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 01:01:18 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id q7Ibhz4fCaGBmaLj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 01:01:17 -0800 (PST)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	r1491ETn017302 for <xfs@oss.sgi.com>; Mon, 4 Feb 2013 01:01:16 -0800
Message-ID: <510F78DA.3080409@tlinx.org>
Date: Mon, 04 Feb 2013 01:01:14 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfsdump  fix tested... level 0's on all partitions: no problems
References: <510DDE61.6060005@tlinx.org> <20130203231706.GJ2667@dastard>
	<510F13AF.1020106@tlinx.org>
In-Reply-To: <510F13AF.1020106@tlinx.org>
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
To: xfs-oss <xfs@oss.sgi.com>

FYI...

reran the level 0's that had problems on Feb01 (~1.3T total)
no errors/no kernel panics...

(same kernel/no reboot)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
